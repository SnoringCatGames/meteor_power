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

export var rope_attachment_offset := Vector2.ZERO

var status_overlay: StatusOverlay

var held_power_line: DynamicPowerLine

var status := BotStatus.NEW
var command := Commands.UNKNOWN

var target_station: Station
var next_target_station: Station

var light: Light2D

var is_selected := false
var is_new := true
var is_active := false
var is_powered_on := true
var is_stopping := false
var is_hovered := false

var total_movement_time := 0.0

var viewport_position_outline_alpha_multiplier := 0.0

var entity_command_type := Commands.UNKNOWN

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
    status_overlay.set_up()
    
    _update_status()


func _destroy() -> void:
    update_info_panel_visibility(false)
    close_radial_menu()
    ._destroy()


func _physics_process(delta: float) -> void:
    if Engine.editor_hint:
        return
    
    if surface_state.just_left_air and \
            is_stopping:
        _stop_nav()
    
    var previous_total_movement_time := total_movement_time
    var current_movement_time := \
        Sc.time.get_scaled_time_step() if \
        surface_state.velocity != Vector2.ZERO else \
        0.0
    total_movement_time += current_movement_time
    
    if int(previous_total_movement_time / MOVEMENT_ENERGY_DRAIN_PERIOD) != \
            int(total_movement_time / MOVEMENT_ENERGY_DRAIN_PERIOD):
        Sc.level.deduct_energy(Costs.BOT_MOVE)
    
    if int(previous_total_time / CONSTANT_ENERGY_DRAIN_PERIOD) != \
            int(total_time / CONSTANT_ENERGY_DRAIN_PERIOD):
        Sc.level.deduct_energy(Costs.BOT_ALIVE)
    
    if did_move_last_frame:
        _update_highlight_for_camera_position()


func _unhandled_input(event: InputEvent) -> void:
    if Engine.editor_hint:
        return
    
    # Cancel commands with right-click.
    if event is InputEventMouseButton and \
            event.button_index == BUTTON_RIGHT and \
            event.pressed:
        stop()


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
    if self.is_selected == is_selected:
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
            var contents: InfoPanelContents = \
                Game.INFO_PANEL_CONTENTS_SCENE.instance()
            contents.set_up(self)
            Sc.info_panel.show_panel(contents.get_data())
    else:
        if get_is_own_info_panel_shown():
            Sc.info_panel.close_panel()


func _update_status() -> void:
    if _get_is_player_control_active():
        self.status = BotStatus.PLAYER_CONTROL_ACTIVE
    elif is_hovered:
        self.status = BotStatus.HOVERED
    elif is_selected:
        self.status = BotStatus.SELECTED
    elif is_new:
        self.status = BotStatus.NEW
    elif is_active:
        self.status = BotStatus.ACTIVE
    elif !is_powered_on:
        self.status = BotStatus.POWERED_DOWN
    else:
        self.status = BotStatus.IDLE
#    Sc.logger.print("Bot._update_status: %s" % BotStatus.get_string(status))
    update_highlight()


func update_highlight() -> void:
    var outline_alpha_multiplier := \
        viewport_position_outline_alpha_multiplier if \
        (status == BotStatus.ACTIVE || \
            status == BotStatus.POWERED_DOWN || \
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


func move_to_attach_power_line(
        origin_station: Station,
        destination_station: Station) -> void:
    if origin_station == destination_station:
        return
    _on_command_started(Commands.RUN_WIRE)
    self.target_station = origin_station
    self.next_target_station = destination_station
    _navigate_to_target_station()


func _on_reached_first_station_for_power_line() -> void:
    # FIXME: Play sound and particles
    Sc.audio.play_sound("command_acc")
    Sc.logger.print(
        "Bot._on_reached_first_station_for_power_line: bot=%s, station=%s, p=%s" % [
            self.character_name,
            Commands.get_string(target_station.entity_command_type),
            target_station.position,
        ])
    assert(is_instance_valid(target_station))
    assert(is_instance_valid(next_target_station))
    var origin_station := target_station
    var destination_station := next_target_station
    self.target_station = next_target_station
    self.next_target_station = null
    self.held_power_line = DynamicPowerLine.new(
            origin_station,
            destination_station,
            self,
            PowerLine.HELD_BY_BOT)
    Sc.level.add_power_line(held_power_line)
    _navigate_to_target_station()
    Sc.level.deduct_energy(Costs.RUN_WIRE)


func _on_reached_second_station_for_power_line() -> void:
    # FIXME: Play sound and particles
    Sc.audio.play_sound("command_finished")
    Sc.logger.print(
        "Bot._on_reached_second_station_for_power_line: bot=%s, station=%s, p=%s" % [
            self.character_name,
            Commands.get_string(target_station.entity_command_type),
            target_station.position,
        ])
    assert(is_instance_valid(held_power_line))
    self.held_power_line._on_connected()
    Sc.level.deduct_energy(Costs.RUN_WIRE)
    _on_command_ended()


func get_power_line_attachment_position() -> Vector2:
    return self.position + \
            self.rope_attachment_offset * \
            Vector2(self.surface_state.horizontal_facing_sign, 1.0)


func move_to_build_station(
        station: EmptyStation,
        station_type: int) -> void:
    _on_command_started(station_type)
    self.target_station = station
    _navigate_to_target_station()


func _on_reached_station_to_build() -> void:
    # FIXME: Play sound and particles
    Sc.audio.play_sound("command_finished")
    assert(is_instance_valid(target_station))
    Sc.logger.print(
        "Bot._on_reached_station_to_build: bot=%s, station=%s, p=%s" % [
            self.character_name,
            Commands.get_string(target_station.entity_command_type),
            target_station.position,
        ])
    Sc.level.replace_station(target_station, command)
    Sc.level.deduct_energy(Commands.COSTS[command])
    _on_command_ended()


func move_to_destroy_station(station: Station) -> void:
    _on_command_started(Commands.STATION_RECYCLE)
    self.target_station = station
    _navigate_to_target_station()


func _on_reached_station_to_destroy() -> void:
    # FIXME: Play sound and particles
    Sc.audio.play_sound("command_finished")
    Sc.logger.print(
        "Bot._on_reached_station_to_destroy: bot=%s, station=%s, p=%s" % [
            self.character_name,
            Commands.get_string(target_station.entity_command_type),
            target_station.position,
        ])
    assert(is_instance_valid(target_station))
    Sc.level.replace_station(target_station, Commands.STATION_EMPTY)
    Sc.level.deduct_energy(Costs.STATION_RECYCLE)
    _on_command_ended()


func move_to_recycle_self() -> void:
    _on_command_started(Commands.BOT_RECYCLE)
    self.target_station = Sc.level.command_center
    _navigate_to_target_station()


func _on_reached_station_to_recycle_self() -> void:
    # FIXME: Play sound and particles
    Sc.audio.play_sound("command_finished")
    Sc.logger.print(
        ("Bot._on_reached_station_to_recycle_self: " +
        "bot=%s, p=%s") % [
            self.character_name,
            target_station.position,
        ])
    assert(is_instance_valid(target_station))
    Sc.level.deduct_energy(Commands.COSTS[Commands.BOT_RECYCLE])
    _on_command_ended()
    Sc.level.remove_bot(self)


func move_to_build_bot(
        station: Station,
        bot_type: int) -> void:
    _on_command_started(bot_type)
    self.target_station = station
    _navigate_to_target_station()


func _on_reached_station_to_build_bot() -> void:
    # FIXME: Play sound and particles
    Sc.audio.play_sound("command_finished")
    Sc.logger.print(
        "Bot._on_reached_station_to_build_bot: bot=%s, bot_to_build=%s, p=%s" % [
            self.character_name,
            Commands.get_string(command),
            target_station.position,
        ])
    assert(is_instance_valid(target_station))
    Sc.level.add_bot(command)
    Sc.level.deduct_energy(Commands.COSTS[command])
    _on_command_ended()


func _navigate_to_target_station() -> void:
    if self._extra_collision_detection_area.overlaps_area(target_station):
        _on_reached_target_station()
    else:
        navigator.navigate_to_position(
                target_station.get_position_along_surface(self))


func stop() -> void:
    _on_command_ended()
    is_stopping = true
    if surface_state.is_grabbing_surface:
        _stop_nav()


func _stop_nav() -> void:
    navigator.stop(false)
    _on_command_ended()


func _on_command_started(command: int) -> void:
#    Sc.logger.print(
#            "Bot._on_command_started: %s" % Commands.get_string(command))
    
    Sc.audio.play_sound("command_acc")
    
    self.command = command
    is_active = true
    is_new = false
    is_stopping = false
    
    target_station = null
    next_target_station = null
    if is_instance_valid(held_power_line):
        Sc.level.remove_power_line(held_power_line)
        
    _update_status()


func _on_command_ended() -> void:
#    Sc.logger.print(
#            "Bot._on_command_ended: %s" % Commands.get_string(command))
    
    command = Commands.UNKNOWN
    is_active = false
    is_new = false
    is_stopping = false
    
    target_station = null
    next_target_station = null
    if is_instance_valid(held_power_line):
        Sc.level.remove_power_line(held_power_line)
    held_power_line = null
    
    _update_status()


func _on_powered_on() -> void:
    is_powered_on = true
    _update_status()


func _on_powered_down() -> void:
    _on_command_ended()
    is_powered_on = false
    _update_status()


func _on_info_panel_closed(data: InfoPanelData) -> void:
    set_is_selected(false)


func _on_navigation_started(is_retry: bool) -> void:
#    Sc.logger.print("Bot._on_navigation_started: %s" % \
#            str(navigation_state.is_triggered_by_player_selection))
    if navigation_state.is_triggered_by_player_selection:
        _on_command_started(Commands.BOT_MOVE)
    show_exclamation_mark()
    set_is_selected(false)


func _on_navigation_ended(did_reach_destination: bool) -> void:
#    Sc.logger.print("Bot._on_navigation_ended")
    _on_command_ended()


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
                _on_reached_target_station()
        "meteors":
            target._on_collided_with_bot(self)
            _on_hit_by_meteor()
        _:
            Sc.logger.error("Bot._on_started_colliding: layer_names=%s" % \
                    str(layer_names))


func _on_hit_by_meteor() -> void:
    Sc.level.session.meteors_collided_count += 1
    Sc.level.deduct_energy(Costs.BOT_HIT)
    var damage := Healths.METEOR_DAMAGE
    # FIXME: --------------- Consider modifying damage depending on Upgrades.
    modify_health(-damage)


func _on_reached_target_station() -> void:
    match command:
        Commands.RUN_WIRE:
            if is_instance_valid(held_power_line):
                _on_reached_second_station_for_power_line()
            else:
                _on_reached_first_station_for_power_line()
        Commands.STATION_RECYCLE:
            _on_reached_station_to_destroy()
        Commands.STATION_REPAIR:
            pass
        Commands.STATION_SOLAR, \
        Commands.STATION_SCANNER, \
        Commands.STATION_BATTERY:
            _on_reached_station_to_build()
        Commands.BOT_RECYCLE:
            _on_reached_station_to_recycle_self()
        Commands.BOT_CONSTRUCTOR, \
        Commands.BOT_LINE_RUNNER, \
        Commands.BOT_BARRIER:
            _on_reached_station_to_build_bot()
        _:
            Sc.logger.error(
                    "Bot._on_started_colliding: command=%s" % \
                    str(command))


func _on_radial_menu_item_selected(item: RadialMenuItem) -> void:
    match item.id:
        Commands.BOT_COMMAND:
            set_is_player_control_active(true)
        Commands.BOT_STOP:
            set_is_selected(false)
            update_info_panel_visibility(false)
            stop()
        Commands.BOT_RECYCLE:
            set_is_selected(false)
            update_info_panel_visibility(false)
            move_to_recycle_self()
        Commands.BOT_INFO:
            set_is_selected(true)
            set_is_player_control_active(false)
            update_info_panel_visibility(true)
        _:
            Sc.logger.error("Bot._on_radial_menu_item_selected")


func _on_radial_menu_touch_up_center() -> void:
    set_is_player_control_active(true)


func _on_radial_menu_touch_up_outside() -> void:
    set_is_selected(false)


func _process_sounds() -> void:
    if just_triggered_jump:
        Sc.audio.play_sound("jump")
    
    if surface_state.just_left_air:
        Sc.audio.play_sound("bot_land")
    elif surface_state.just_touched_surface:
            Sc.audio.play_sound("bot_land")


func _get_common_radial_menu_item_types() -> Array:
    return [
        Commands.BOT_COMMAND,
        Commands.BOT_STOP,
        Commands.BOT_RECYCLE,
        Commands.BOT_INFO,
    ]


func _get_radial_menu_items() -> Array:
    var types := _get_radial_menu_item_types()
    var result := []
    for type in types:
        var command_item := GameRadialMenuItem.new()
        command_item.cost = Commands.COSTS[type]
        command_item.id = type
        command_item.description = Commands.COMMAND_LABELS[type]
        command_item.texture = Commands.TEXTURES[type]
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


func get_disabled_message(command: int) -> String:
    var message: String = Sc.level.command_enablement[command]
    if message != "":
        return message
    match command:
        _:
            return ""


func get_health() -> int:
    return _health


func get_health_capacity() -> int:
    return _health_capacity


func _get_health_capacity() -> int:
    var base_capacity: int = Healths.get_default_capacity(entity_command_type)
    
    # FIXME: -------------------------
    # - Modify health-capacity for Upgrades.
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
