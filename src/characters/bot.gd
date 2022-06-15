tool
class_name Bot
extends SurfacerCharacter


const _LIGHT_TEXTURE := preload(
    "res://addons/scaffolder/assets/images/misc/circle_gradient_modified_1024.png")

const CONSTANT_ENERGY_DRAIN_PERIOD := 0.4
const MOVEMENT_ENERGY_DRAIN_PERIOD := 0.4

const MIN_OPACITY_MULTIPLIER := 0.3
const MAX_OPACITY_MULTIPLIER := 1.0

const POINTER_DISTANCE_SQUARED_OFFSET_FOR_SELECTION_PRIORITY := 30.0 * 30.0

export var wire_attachment_offset := Vector2.ZERO

var status_overlay: StatusOverlay

var held_power_line: DynamicPowerLine

var status := BotStatus.UNKNOWN

var command: Command

var target_station: Station

var light: Light2D

var is_selected := false
var is_new := true
var is_active := false
var is_hovered := false

var reached_command_target := false

var triggers_command_when_landed := false
var triggers_wander_when_landed := false

var is_initial_nav := false

var total_movement_time := 0.0

var viewport_position_outline_alpha_multiplier := 0.0

var entity_command_type := CommandType.UNKNOWN

var _health := 0
var _health_capacity := 0


func _init(entity_command_type: int) -> void:
    self.entity_command_type = entity_command_type
    
    _health_capacity = _get_health_capacity()
    _health = _health_capacity
    
    light = Light2D.new()
    light.texture = _LIGHT_TEXTURE
    light.texture_scale = 0.1
    light.range_layer_min = -100
    light.range_layer_max = 100
    light.range_item_cull_mask = 2
    light.shadow_item_cull_mask = 2
    add_child(light)
    light.owner = self
    _update_status()


func _ready() -> void:
    for light in Sc.utils.get_children_by_type(self, Light2D):
        if light != self.light:
            remove_child(light)
    navigator.connect("navigation_started", self, "_on_navigation_started")
    navigator.connect("navigation_ended", self, "_on_navigation_ended")
    Sc.info_panel.connect("closed", self, "_on_info_panel_closed")
    detects_pointer = true
    pointer_screen_radius = \
        Sc.device.inches_to_pixels(Station.SCREEN_RADIUS_INCHES)
    _set_pointer_distance_squared_offset_for_selection_priority(
        POINTER_DISTANCE_SQUARED_OFFSET_FOR_SELECTION_PRIORITY)
    
    status_overlay = Sc.utils.add_scene(self, Station._STATUS_OVERLAY_SCENE)
    status_overlay.entity = self
    status_overlay.anchor_y = -collider.half_width_height.y
    status_overlay.z_index = 1
    status_overlay.set_up()
    
    _walk_to_side_of_command_center()
    is_initial_nav = true
    is_new = true


func _walk_to_side_of_command_center() -> void:
    var target_point := Vector2(
        Sc.level.command_center.get_bounds().end.x,
        Sc.level.command_center.position.y)
    var surface: Surface = \
        Sc.level.command_center.get_position_along_surface(self).surface
    var destination := PositionAlongSurfaceFactory \
        .create_position_offset_from_target_point(
            target_point, surface, collider, true)
    is_active = true
    _update_status()
    navigate_imperatively(destination)


func _destroy() -> void:
    update_info_panel_visibility(false)
    close_radial_menu()
    ._destroy()


func _physics_process(delta: float) -> void:
    if Engine.editor_hint:
        return
    
    var previous_total_movement_time := total_movement_time
    var current_movement_time := \
        Sc.time.get_scaled_time_step() if \
        surface_state.velocity != Vector2.ZERO else \
        0.0
    total_movement_time += current_movement_time
    
    if int(previous_total_movement_time / MOVEMENT_ENERGY_DRAIN_PERIOD) != \
            int(total_movement_time / MOVEMENT_ENERGY_DRAIN_PERIOD):
        Sc.level.deduct_energy(Cost.BOT_MOVE)
    
    if int(previous_total_time / CONSTANT_ENERGY_DRAIN_PERIOD) != \
            int(total_time / CONSTANT_ENERGY_DRAIN_PERIOD):
        Sc.level.deduct_energy(Cost.BOT_ALIVE)
    
    if did_move_last_frame:
        _update_highlight_for_camera_position()


func _on_level_started() -> void:
    pass


func _on_touch_down(
        level_position: Vector2,
        is_already_handled: bool) -> void:
    ._on_touch_down(level_position, is_already_handled)
    set_is_player_control_active(false)
    
    if is_selected:
        set_is_selected(false)
    else:
        set_is_selected(true)
        
        open_radial_menu()


func _on_touch_up(
        level_position: Vector2,
        is_already_handled: bool) -> void:
    ._on_touch_up(level_position, is_already_handled)
    Sc.level.touch_listener.set_current_touch_as_not_handled()


func _on_interaction_mode_changed(interaction_mode: int) -> void:
    is_hovered = false
    match interaction_mode:
        LevelControl.InteractionMode.HOVER, \
        LevelControl.InteractionMode.PRESSED:
            is_hovered = true
        _:
            pass
    _update_status()


func set_is_player_control_active(
        value: bool,
        should_also_update_level := true) -> void:
    .set_is_player_control_active(value, should_also_update_level)
    if value:
        set_is_selected(true)
        update_info_panel_visibility(false)
    _update_status()


func set_is_selected(is_selected: bool) -> void:
    if self.is_selected == is_selected and \
            !_get_is_player_control_active():
        # No change.
        return
    self.is_selected = is_selected
    Sc.level._on_bot_selection_changed(self, is_selected)
    if !is_selected:
        set_is_player_control_active(false)
    _update_status()


func open_radial_menu() -> void:
    var radial_menu: GameRadialMenu = Sc.gui.hud.open_radial_menu(
            Sc.gui.hud.radial_menu_class,
            _get_radial_menu_items(),
            self.get_position_in_screen_space(),
            self)
    radial_menu.connect(
            "touch_up_item", self, "_on_radial_menu_item_selected")
    radial_menu.connect(
            "touch_up_center", self, "_on_radial_menu_touch_up_center")
    radial_menu.connect(
            "touch_up_outside", self, "_on_radial_menu_touch_up_outside")
    radial_menu.connect(
            "closed", self, "_on_radial_menu_closed")
    var static_behavior := get_behavior(StaticBehavior)
    default_behavior = static_behavior
    behavior.next_behavior = get_behavior(StaticBehavior)
    if !(behavior is PlayerNavigationBehavior) and \
            !(behavior is NavigationOverrideBehavior) and \
            !(behavior is StaticBehavior):
        stop_on_surface(false, false)
        get_behavior(StaticBehavior).is_active = true


func close_radial_menu() -> void:
    if Sc.gui.hud.get_is_radial_menu_open() and \
            Sc.gui.hud._radial_menu.metadata == self:
        Sc.gui.hud.close_radial_menu()


func get_is_own_info_panel_shown() -> bool:
    var data: InfoPanelData = Sc.info_panel.get_current_data()
    return is_instance_valid(data) and data.meta == self


func update_info_panel_contents() -> void:
    if !get_is_own_info_panel_shown():
        return
    var data: InfoPanelData = Sc.info_panel.get_current_data()
    data.contents.update()


func update_info_panel_visibility(is_visible: bool) -> void:
    if is_visible:
        if !get_is_own_info_panel_shown():
            var contents = Game.INFO_PANEL_CONTENTS_SCENE.instance()
            contents.set_up(self)
            Sc.info_panel.show_panel(contents.get_data())
    else:
        if get_is_own_info_panel_shown():
            Sc.info_panel.close_panel()


func _update_status() -> void:
    var previous_status := status
    if _get_is_player_control_active():
        status = BotStatus.PLAYER_CONTROL_ACTIVE
    elif is_hovered:
        status = BotStatus.HOVERED
    elif is_selected:
        status = BotStatus.SELECTED
    elif is_new:
        status = BotStatus.NEW
    elif is_active:
        status = BotStatus.ACTIVE
    else:
        status = BotStatus.IDLE
#    Sc.logger.print("Bot._update_status: %s" % BotStatus.get_string(status))
    if status != previous_status:
        update_highlight()
        _on_command_enablement_changed()


func update_highlight() -> void:
    var outline_alpha_multiplier := \
        viewport_position_outline_alpha_multiplier if \
        (status == BotStatus.ACTIVE || \
            status == BotStatus.IDLE) else \
        1.0
    
    var config: Dictionary = BotStatus.HIGHLIGHT_CONFIGS[status]
    
    light.color = Sc.palette.get_color(config.color)
    light.texture_scale = config.scale
    light.energy = config.energy * outline_alpha_multiplier
    
    if is_instance_valid(animator):
        var outline_color: Color = Sc.palette.get_color(config.color)
        outline_color.a *= \
            config.outline_alpha_multiplier * outline_alpha_multiplier
        animator.outline_color = outline_color
        animator.is_outlined = outline_color.a > 0.0


func _on_panned() -> void:
    _update_highlight_for_camera_position()


func _on_zoomed() -> void:
    _update_highlight_for_camera_position()


func _update_highlight_for_camera_position() -> void:
    var opacity := Station.get_opacity_for_camera_position(self.global_position)
    opacity = lerp(MIN_OPACITY_MULTIPLIER, MAX_OPACITY_MULTIPLIER, opacity)
    viewport_position_outline_alpha_multiplier = opacity
    status_overlay.modulate.a = viewport_position_outline_alpha_multiplier
    update_highlight()


func start_command(command: Command) -> void:
    assert(!is_instance_valid(self.command))
    self.command = command
    # If on the ground, start the command; otherwise, wait.
    stop_on_surface(true, false)


func _start_command_navigation() -> void:
    call_deferred("_start_command_navigation_deferred")


func _start_command_navigation_deferred() -> void:
    _on_command_started()
    assert(command.target_station != command.next_target_station)
    match command.type:
        CommandType.BOT_MOVE:
            # This is handled by the PlayerNavigationBehavior.
            pass
        CommandType.STATION_REPAIR, \
        CommandType.WIRE_REPAIR:
            # FIXME: ----------------------------
            pass
        CommandType.RUN_WIRE, \
        CommandType.STATION_SOLAR, \
        CommandType.STATION_SCANNER, \
        CommandType.STATION_BATTERY, \
        CommandType.BOT_CONSTRUCTOR, \
        CommandType.BOT_LINE_RUNNER, \
        CommandType.BOT_BARRIER, \
        CommandType.STATION_RECYCLE, \
        CommandType.BOT_RECYCLE:
            _navigate_to_target_station(command.target_station)
        _:
            Sc.logger.error("Bot._start_command_navigation")


func _on_reached_first_station_for_power_line() -> void:
    if !is_instance_valid(command.target_station) or \
            !is_instance_valid(command.next_target_station):
        # One of the stations has been destroyed.
        # FIXME: Play error sound
        Sc.audio.play_sound("nav_select_fail")
        return
    
    call_deferred("_navigate_to_second_station_for_power_line_deferred")


func _navigate_to_second_station_for_power_line_deferred() -> void:
    # FIXME: Play sound and particles
    Sc.audio.play_sound("command_acc")
    Sc.logger.print(
        "Bot._on_reached_first_station_for_power_line: bot=%s, station=%s, p=%s" % [
            self.character_name,
            CommandType.get_string(target_station.entity_command_type),
            target_station.position,
        ])
    assert(is_instance_valid(command.target_station))
    assert(is_instance_valid(command.next_target_station))
    assert(held_power_line == null)
    held_power_line = DynamicPowerLine.new(
        command.target_station,
        command.next_target_station,
        self,
        PowerLine.HELD_BY_BOT)
    Sc.level.add_power_line(held_power_line)
    _navigate_to_target_station(command.next_target_station)
    Sc.level.deduct_energy(Cost.RUN_WIRE)


func _on_reached_second_station_for_power_line() -> void:
    if !is_instance_valid(command.target_station) or \
            !is_instance_valid(command.next_target_station):
        # One of the stations has been destroyed.
        # FIXME: Play error sound
        Sc.audio.play_sound("nav_select_fail")
        drop_power_line()
        return
    
    # FIXME: Play sound and particles
    assert(is_instance_valid(held_power_line))
    if held_power_line.origin_station.station_connections.has(
            held_power_line.destination_station):
        # The stations are already connected.
        # -   This should be uncommon, but can sometimes happen.
        # -   For example, two bots could simultaneously be commanded to run a
        #     wire from A to B, in which case, A and B would not be detected as
        #     connected when triggering the latter command.
        Sc.audio.play_sound("nav_select_fail")
        Sc.logger.print(
            ("STATIONS ALREADY CONNECTED: " +
            "bot=%s, station=%s, p=%s") % [
                character_name,
                CommandType.get_string(target_station.entity_command_type),
                target_station.position,
            ])
        drop_power_line()
    else:
        Sc.audio.play_sound("command_finished")
        Sc.logger.print(
            ("Bot._on_reached_second_station_for_power_line: " +
            "bot=%s, station=%s, p=%s") % [
                character_name,
                CommandType.get_string(target_station.entity_command_type),
                target_station.position,
            ])
        held_power_line._on_connected()
        held_power_line = null
        Sc.level.deduct_energy(Cost.RUN_WIRE)


func _on_reached_station_to_build() -> void:
    # FIXME: Play sound and particles
    Sc.audio.play_sound("command_finished")
    assert(is_instance_valid(target_station))
    Sc.logger.print(
        "Bot._on_reached_station_to_build: bot=%s, station=%s, p=%s" % [
            self.character_name,
            CommandType.get_string(target_station.entity_command_type),
            target_station.position,
        ])
    Sc.level.replace_station(target_station, command.type)
    Sc.level.deduct_energy(CommandType.COSTS[command.type])


func _on_reached_station_to_destroy() -> void:
    if !is_instance_valid(command.target_station):
        # The station has been destroyed.
        # FIXME: Play error sound
        Sc.audio.play_sound("nav_select_fail")
        return
    
    # FIXME: Play sound and particles
    Sc.audio.play_sound("command_finished")
    Sc.logger.print(
        "Bot._on_reached_station_to_destroy: bot=%s, station=%s, p=%s" % [
            self.character_name,
            CommandType.get_string(target_station.entity_command_type),
            target_station.position,
        ])
    assert(is_instance_valid(target_station))
    Sc.level.replace_station(target_station, CommandType.STATION_EMPTY)
    Sc.level.deduct_energy(Cost.STATION_RECYCLE)


func _on_reached_station_to_recycle_self() -> void:
    if !is_instance_valid(command.target_station):
        # The station has been destroyed.
        # FIXME: Play error sound
        Sc.audio.play_sound("nav_select_fail")
        return
    
    # FIXME: Play sound and particles
    Sc.audio.play_sound("command_finished")
    Sc.logger.print(
        ("Bot._on_reached_station_to_recycle_self: " +
        "bot=%s, p=%s") % [
            self.character_name,
            target_station.position,
        ])
    assert(is_instance_valid(target_station))
    Sc.level.deduct_energy(CommandType.COSTS[CommandType.BOT_RECYCLE])
    Sc.level.remove_bot(self)


func _on_reached_station_to_build_bot() -> void:
    if !is_instance_valid(command.target_station):
        # The station has been destroyed.
        # FIXME: Play error sound
        Sc.audio.play_sound("nav_select_fail")
        return
    
    # FIXME: Play sound and particles
    Sc.audio.play_sound("command_finished")
    Sc.logger.print(
        "Bot._on_reached_station_to_build_bot: bot=%s, bot_to_build=%s, p=%s" % [
            self.character_name,
            CommandType.get_string(command.type),
            target_station.position,
        ])
    assert(is_instance_valid(target_station))
    Sc.level.add_bot(command.type)
    Sc.level.deduct_energy(CommandType.COSTS[command.type])


func _navigate_to_target_station(target_station: Station) -> void:
    self.target_station = target_station
    var already_there := \
        _extra_collision_detection_area.overlaps_area(target_station)
    if already_there:
        _on_reached_command_target()
    else:
        navigate_imperatively(target_station.get_position_along_surface(self))


func stop_on_surface(
        triggers_command := false,
        triggers_wander := false) -> void:
    assert(!triggers_command or !triggers_wander)
    _clear_command_state(is_active)
    triggers_command_when_landed = triggers_command
    triggers_wander_when_landed = triggers_wander
    .stop_on_surface()


func _stop_nav_immediately() -> void:
    ._stop_nav_immediately()
    var previous_triggers_command_when_landed := triggers_command_when_landed
    var previous_triggers_wander_when_landed := triggers_wander_when_landed
    _clear_command_state(triggers_command_when_landed)
    if previous_triggers_command_when_landed:
        _start_command_navigation()
    else:
        if previous_triggers_wander_when_landed:
            default_behavior = get_behavior(WanderBehavior)
        if behavior is PlayerNavigationBehavior or \
                behavior is NavigationOverrideBehavior or \
                behavior is StaticBehavior:
            default_behavior.trigger(false)


func drop_power_line() -> void:
    if !is_instance_valid(held_power_line):
        return
    assert(held_power_line.end_attachment == self)
    held_power_line.start_attachment \
        .remove_bot_connection(self, held_power_line)
    held_power_line.start_attachment._on_unplugged_from_bot(self)
    Sc.level.remove_power_line(held_power_line)
    held_power_line = null


func _on_command_started() -> void:
#    Sc.logger.print(
#        "Bot._on_command_started: %s" % \
#        CommandType.get_string(command.type))
    
    Sc.audio.play_sound("command_acc")
    
    var was_active := is_active
    
    is_active = true
    is_new = false
    is_waiting_to_stop_on_surface = false
    reached_command_target = false
    triggers_command_when_landed = false
    triggers_wander_when_landed = false
    is_initial_nav = false
    
    target_station = null
    drop_power_line()
    
    _update_status()
    
    if !was_active:
        Sc.level.on_bot_idleness_changed(self, false)


func _clear_command_state(next_is_active: bool) -> void:
#    Sc.logger.print(
#        "Bot._clear_command_state: %s" % \
#        CommandType.get_string(command.type))
    
    var was_active := is_active
    
    is_new = false
    is_waiting_to_stop_on_surface = false
    triggers_command_when_landed = false
    triggers_wander_when_landed = false
    
    target_station = null
    drop_power_line()
    
    _update_status()
    
    # FIXME: --------------------------------------------
    # - Maybe keep the bot selected?
    # - Maybe don't wander if selected, but then start wander when deselected?
    set_is_selected(false)
    
    var just_became_idle := !next_is_active and was_active
    
    if reached_command_target or \
            just_became_idle:
        if is_instance_valid(command):
            Sc.level.cancel_command(command)
            command = null
    
    if just_became_idle:
        is_active = false
        reached_command_target = false
        Sc.level.on_bot_idleness_changed(self, true)


func _on_info_panel_closed(data: InfoPanelData) -> void:
    set_is_selected(false)


func _on_navigation_started(
        is_retry: bool,
        triggered_by_player: bool) -> void:
#    Sc.logger.print("Bot._on_navigation_started: %s" % \
#            str(navigation_state.triggered_by_player))
    if triggered_by_player:
        _clear_command_state(true)
        if is_instance_valid(command):
            Sc.level.cancel_command(command)
            command = null
        command = Command.new(CommandType.BOT_MOVE, null, null)
        command.is_active = true
        Sc.level.in_progress_commands[command] = true
        Sc.gui.hud.command_queue_list.sync_queue()
        _on_command_started()
        show_exclamation_mark()
    set_is_selected(false)


func _on_navigation_ended(
        did_reach_destination: bool,
        triggered_by_player) -> void:
#    Sc.logger.print("Bot._on_navigation_ended")
    if triggered_by_player:
        reached_command_target = true
        _clear_command_state(false)
    elif is_initial_nav:
        is_initial_nav = false
        is_new = true
        is_active = false
        default_behavior = get_behavior(WanderBehavior)
        default_behavior.trigger(false)
        Sc.level.on_bot_idleness_changed(self, true)


func _on_started_colliding(
        target: Node2D,
        layer_names: Array) -> void:
    call_deferred("_on_started_colliding_deferred", target, layer_names)


func _on_started_colliding_deferred(
        target: Node2D,
        layer_names: Array) -> void:
    match layer_names[0]:
        "bots":
            pass
        "stations":
            if target_station == target:
                _on_reached_command_target()
        "meteors":
            target._on_collided_with_bot(self)
            _on_hit_by_meteor()
        _:
            Sc.logger.error("Bot._on_started_colliding: layer_names=%s" % \
                    str(layer_names))


func _on_hit_by_meteor() -> void:
    Sc.level.session.meteors_collided_count += 1
    Sc.level.deduct_energy(Cost.BOT_HIT)
    var damage := Health.METEOR_DAMAGE
    # FIXME: --------------- Consider modifying damage depending on Upgrade.
    modify_health(-damage)


func _on_reached_command_target() -> void:
    reached_command_target = true
    
    var stops: bool
    match command.type:
        CommandType.RUN_WIRE:
            if is_instance_valid(held_power_line):
                _on_reached_second_station_for_power_line()
                stops = true
            else:
                _on_reached_first_station_for_power_line()
                stops = false
        CommandType.STATION_RECYCLE:
            _on_reached_station_to_destroy()
            stops = true
        CommandType.STATION_REPAIR:
            pass
        CommandType.STATION_SOLAR, \
        CommandType.STATION_SCANNER, \
        CommandType.STATION_BATTERY:
            _on_reached_station_to_build()
            stops = true
        CommandType.BOT_RECYCLE:
            _on_reached_station_to_recycle_self()
            stops = false
        CommandType.BOT_CONSTRUCTOR, \
        CommandType.BOT_LINE_RUNNER, \
        CommandType.BOT_BARRIER:
            _on_reached_station_to_build_bot()
            stops = true
        _:
            Sc.logger.error(
                    "Bot._on_started_colliding: command=%s" % \
                    str(command.type))
    
    if stops:
        stop_on_surface(false, true)
        _clear_command_state(false)


func _on_radial_menu_item_selected(item: RadialMenuItem) -> void:
    match item.id:
        CommandType.BOT_COMMAND:
            set_is_player_control_active(true)
        CommandType.BOT_STOP:
            set_is_selected(false)
            update_info_panel_visibility(false)
            stop_on_surface(false, true)
        CommandType.BOT_RECYCLE:
            set_is_selected(false)
            update_info_panel_visibility(false)
            Sc.level.add_command(CommandType.BOT_RECYCLE, Sc.level.command_center)
        CommandType.BOT_INFO:
            set_is_selected(true)
            set_is_player_control_active(false)
            update_info_panel_visibility(true)
            if behavior is StaticBehavior:
                get_behavior(WanderBehavior).trigger(false)
        _:
            Sc.logger.error("Bot._on_radial_menu_item_selected")


func _on_radial_menu_touch_up_center() -> void:
#    set_is_player_control_active(true)
    _on_radial_menu_touch_up_outside()


func _on_radial_menu_touch_up_outside() -> void:
    set_is_selected(false)
    if behavior is StaticBehavior:
        get_behavior(WanderBehavior).trigger(false)


func _on_radial_menu_closed() -> void:
    var wander_behavior := get_behavior(WanderBehavior)
    behavior.next_behavior = wander_behavior
    default_behavior = wander_behavior


func _process_sounds() -> void:
    if just_triggered_jump:
        Sc.audio.play_sound("jump")
    
    if surface_state.just_left_air:
        Sc.audio.play_sound("bot_land")
    elif surface_state.just_touched_surface:
            Sc.audio.play_sound("bot_land")


func _get_common_radial_menu_item_types() -> Array:
    return [
        CommandType.BOT_COMMAND,
        CommandType.BOT_STOP,
        CommandType.BOT_RECYCLE,
        CommandType.BOT_INFO,
    ]


func _get_radial_menu_items() -> Array:
    var types := _get_radial_menu_item_types()
    var result := []
    for type in types:
        var command_item := GameRadialMenuItem.new()
        command_item.cost = CommandType.COSTS[type]
        command_item.id = type
        command_item.description = CommandType.COMMAND_LABELS[type]
        command_item.texture = CommandType.TEXTURES[type]
        command_item.disabled_message = get_disabled_message(type)
        result.push_back(command_item)
    return result


func _get_radial_menu_item_types() -> Array:
    Sc.logger.error(
            "Abstract Bot._get_radial_menu_item_types is not implemented")
    return []


func _on_command_enablement_changed() -> void:
    update_info_panel_contents()
    if Sc.gui.hud.get_is_radial_menu_open() and \
            Sc.gui.hud._radial_menu.metadata == self:
        for item in Sc.gui.hud._radial_menu._items:
            item.disabled_message = get_disabled_message(item.id)


func get_disabled_message(command_type: int) -> String:
    var message: String = Sc.level.command_enablement[command_type]
    if message != "":
        return message
    match command_type:
        CommandType.BOT_STOP:
            if !is_active:
                return Description.ALREADY_STOPPED
        _:
            pass
    return ""


func get_power_line_attachment_position(entity_on_other_end) -> Vector2:
    return position + \
            wire_attachment_offset * \
            Vector2(surface_state.horizontal_facing_sign, 1.0)


func get_health() -> int:
    return _health


func get_health_capacity() -> int:
    return _health_capacity


func _get_health_capacity() -> int:
    var base_capacity: int = Health.get_default_capacity(entity_command_type)
    
    # FIXME: -------------------------
    # - Modify health-capacity for Upgrade.
    # - Update health-capacity when linking to mothership.
    
    return base_capacity


func modify_health(diff: int) -> void:
    var previous_health := _health
    _health = clamp(_health + diff, 0, _health_capacity)
    if _health == previous_health:
        return
    update_info_panel_contents()
    status_overlay.update()
    if _health == 0:
        Sc.level.on_bot_health_depleted(self)
