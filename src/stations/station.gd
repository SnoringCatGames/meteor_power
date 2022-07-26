tool
class_name Station
extends StationarySelectable


const _OVERLAY_BUTTON_PANEL_CLASS := preload(
    "res://src/gui/overlay_button_panel.tscn")

const SHIELD_ENERGY_DRAIN_PERIOD := 0.4

export var wire_attachment_offset := Vector2.ZERO

var buttons: OverlayButtonPanel

# Dictionary<Station, PowerLine>
var station_connections := {}

# Dictionary<Bot, PowerLine>
var bot_connections := {}

var is_connected_to_command_center := false

var shield_activated := false

var total_shield_time := INF


func _init(entity_command_type: int).(entity_command_type) -> void:
    self.entity_command_type = entity_command_type


func _set_up() -> void:
    total_shield_time = 0.0
    
    buttons = Sc.utils.add_scene(self, _OVERLAY_BUTTON_PANEL_CLASS)
    buttons.connect("button_pressed", self, "_on_button_pressed")
    buttons.connect(
            "interaction_mode_changed",
            self,
            "_on_button_interaction_mode_changed")
    buttons.station = self
    
    _set_up_desaturatable()
    
    ._set_up()


func _destroy() -> void:
    buttons._destroy()
    #####################################################################
    # FIXME: ------------------------------------- REMOVE. Eventually...
    # - Check whether there are any dangling references...
    for station in Sc.level.stations:
#        assert(!Sc.geometry.are_points_equal_with_epsilon(
#            self.position, station.positon, 10.0))
        for other in station.station_connections:
            assert(!Sc.geometry.are_points_equal_with_epsilon(
                self.position, other.position, 10.0))
            print(other)
    for power_line in Sc.level.power_lines:
        assert(!Sc.geometry.are_points_equal_with_epsilon(
            self.position, power_line.start_attachment.position, 10.0))
        assert(!Sc.geometry.are_points_equal_with_epsilon(
            self.position, power_line.end_attachment.position, 10.0))
        print(power_line)
    #####################################################################
    ._destroy()


func _physics_process(delta: float) -> void:
    if Engine.editor_hint:
        return
    
    var previous_total_shield_time := total_shield_time
    var current_shield_time := \
        Sc.time.get_scaled_time_step() if \
        shield_activated else \
        0.0
    total_shield_time += current_shield_time
    
    if int(previous_total_shield_time / SHIELD_ENERGY_DRAIN_PERIOD) != \
            int(total_shield_time / SHIELD_ENERGY_DRAIN_PERIOD):
        Sc.level.deduct_energy(Cost.STATION_SHIELD)


func _set_up_desaturatable() -> void:
    var sprites: Array = \
        Sc.utils.get_children_by_type(self, OutlineableSprite, true)
    var animated_sprites: Array = \
        Sc.utils.get_children_by_type(self, OutlineableAnimatedSprite, true)
    for collection in [sprites, animated_sprites]:
        for node in collection:
            node.is_desaturatable = true


func _build_station(button_type: int) -> void:
    Sc.logger.error("Abstract Station._build_station is not implemented")


func _on_camera_enter() -> void:
    ._on_camera_enter()
    buttons.visible = true
    # FIXME: --------------------------
    # - Update button visibility and enablement in a different, more direct and
    #   on-demand, way.
    buttons.set_buttons(get_buttons())


func _on_camera_exit() -> void:
    ._on_camera_exit()
    buttons.visible = false


func _on_button_interaction_mode_changed() -> void:
    _update_highlight()


func get_center() -> Vector2:
    return position + $Center.position


func get_power_line_attachment_position(entity_on_other_end) -> Vector2:
    return self.position + self.wire_attachment_offset


func get_buttons() -> Array:
    return []


func get_position_along_surface(
        character: SurfacerCharacter) -> PositionAlongSurface:
    var surface := SurfaceFinder.find_closest_surface_in_direction(
            character.surface_store,
            self.position,
            Vector2.DOWN)
    return PositionAlongSurfaceFactory.create_position_offset_from_target_point(
            self.position,
            surface,
            character.collider,
            true,
            true)


func add_bot_connection(
        bot,
        power_line: PowerLine) -> void:
    assert(!bot_connections.has(bot))
    bot_connections[bot] = power_line


func remove_bot_connection(
        bot,
        power_line: PowerLine) -> void:
    assert(bot_connections[bot] == power_line)
    bot_connections.erase(bot)


func add_station_connection(
        other_station: Station,
        power_line: PowerLine) -> void:
    assert(!station_connections.has(other_station))
    station_connections[other_station] = power_line
    _on_connected_to_station(other_station)
    _check_is_connected_to_command_center()


func remove_station_connection(other_station: Station) -> void:
    assert(station_connections.has(other_station))
    station_connections.erase(other_station)
    _on_disconnected_from_station(other_station)
    _check_is_connected_to_command_center()


func _check_is_connected_to_command_center() -> void:
    _set_is_connected_to_command_center(
        _check_is_connected_to_command_center_recursive(self, {}))


func _set_is_connected_to_command_center(value: bool) -> void:
    var was_connected_to_command_center := is_connected_to_command_center
    is_connected_to_command_center = value
    if was_connected_to_command_center != is_connected_to_command_center:
        if is_connected_to_command_center:
            _on_transitively_connected_to_command_center()
        else:
            _on_transitively_disconnected_from_command_center()
        _update_all_connections_connected_to_command_center_recursive(
                is_connected_to_command_center, self, {})


func _check_is_connected_to_command_center_recursive(
        station: Station,
        visited_stations: Dictionary) -> bool:
    visited_stations[station] = true
    for other_station in station.station_connections:
        if other_station.entity_command_type == CommandType.STATION_COMMAND:
            return true
        if visited_stations.has(other_station):
            continue
        if _check_is_connected_to_command_center_recursive(
                other_station, visited_stations):
            return true
    return false


func _update_all_connections_connected_to_command_center_recursive(
        is_connected_to_command_center: bool,
        station: Station,
        visited_stations: Dictionary) -> void:
    station._set_is_connected_to_command_center(is_connected_to_command_center)
    visited_stations[station] = true
    for other_station in station.station_connections:
        if visited_stations.has(other_station):
            continue
        _update_all_connections_connected_to_command_center_recursive(
                is_connected_to_command_center, other_station, visited_stations)


func _on_transitively_connected_to_command_center() -> void:
    _update_highlight()
    update_info_panel_contents()


func _on_transitively_disconnected_from_command_center() -> void:
    _update_highlight()
    update_info_panel_contents()


func _on_connected_to_station(other: Station) -> void:
    pass


func _on_disconnected_from_station(other: Station) -> void:
    pass


func _on_plugged_into_bot(bot) -> void:
    pass


func _on_unplugged_from_bot(bot) -> void:
    pass


func _on_replaced_bot_plugin_with_station(
        bot,
        destination_station: Station) -> void:
    pass


func _on_plugged_into_station(origin_station: Station) -> void:
    pass


func _on_hit_by_meteor(meteor) -> void:
    Sc.level.session.meteors_collided_count += 1
    if !shield_activated:
        Sc.level.deduct_energy(_get_meteor_hit_cost())
        var damage := Health.METEOR_DAMAGE
        # FIXME: --------------- Consider modifying damage depending on Upgrade.
        modify_health(-damage)


func _on_health_depleted() -> void:
    Sc.level.on_station_health_depleted(self)


func _on_touch_down(
        level_position: Vector2,
        is_already_handled: bool) -> void:
    set_is_selected(true)
    
    if is_instance_valid(Sc.level.selected_bot):
        Sc.level.selected_bot.set_is_player_control_active(false)
    
    if Sc.level.get_is_first_station_selected_for_running_power_line():
        if Sc.level.first_selected_station_for_running_power_line == self or \
                station_connections.has(Sc.level.first_selected_station_for_running_power_line) or \
                entity_command_type == CommandType.STATION_EMPTY:
            _on_button_pressed(CommandType.STATION_STOP)
        else:
            _on_button_pressed(CommandType.RUN_WIRE)
        return
    
    open_radial_menu()


func _on_button_pressed(button_type: int) -> void:
    ._on_button_pressed(button_type)
    
    match button_type:
        CommandType.STATION_LINK_TO_MOTHERSHIP:
            # FIXME: LEFT OFF HERE: ----------------------------------------
            # - Show a fancy energy-field shimmer effect over all bots and
            #   stations to indicate the boost.
            # - Play a success sound.
            # - Animate a fancy beaming-up effect from the command center.
            # - Show a persistent beaming-up ray from the command center?
            Sc.level.did_level_succeed = true
            Sc.level.deduct_energy(Cost.STATION_LINK_TO_MOTHERSHIP)
            set_is_selected(false)
            update_info_panel_visibility(false)
        
        CommandType.STATION_STOP:
            set_is_selected(false)
            update_info_panel_visibility(false)
            Sc.level.clear_station_power_line_selection()
        
        CommandType.STATION_RECYCLE:
            set_is_selected(false)
            update_info_panel_visibility(false)
            Sc.level.add_command(CommandType.STATION_RECYCLE, self)
        
        CommandType.STATION_INFO:
            set_is_selected(true)
            update_info_panel_visibility(true)
        
        CommandType.RUN_WIRE:
            if !Sc.level.get_is_first_station_selected_for_running_power_line():
                set_is_selected(true)
            update_info_panel_visibility(false)
            Sc.level.set_selected_station_for_running_power_line(self)
        
        CommandType.STATION_COMMAND, \
        CommandType.STATION_SOLAR, \
        CommandType.STATION_SCANNER, \
        CommandType.STATION_BATTERY:
            set_is_selected(false)
            update_info_panel_visibility(false)
            _build_station(button_type)
        
        CommandType.BOT_CONSTRUCTOR:
            Sc.audio.play_sound("command_finished")
            Sc.level.add_bot(CommandType.BOT_CONSTRUCTOR)
            Sc.level.deduct_energy(
                CommandType.COSTS[CommandType.BOT_CONSTRUCTOR])
        
        CommandType.BOT_LINE_RUNNER, \
        CommandType.BOT_BARRIER:
            Sc.level.add_command(button_type, self)
        
        _:
            Sc.logger.error("Station._on_button_pressed")
    
    if button_type != CommandType.RUN_WIRE:
        Sc.level.clear_station_power_line_selection()


func _get_common_radial_menu_item_types() -> Array:
    return [
        CommandType.RUN_WIRE,
        CommandType.STATION_RECYCLE,
        CommandType.STATION_INFO,
    ]


func _on_command_enablement_changed() -> void:
    ._on_command_enablement_changed()
    buttons._on_command_enablement_changed()


func _get_meteor_hit_cost() -> int:
    return Cost.STATION_HIT


func set_is_selected(is_selected: bool) -> void:
    if is_selected == get_is_selected():
        # No change.
        return
    .set_is_selected(is_selected)
    Sc.level._on_station_selection_changed(self, is_selected)


func get_is_selected() -> bool:
    return Sc.level.selected_station == self


func get_radial_position_in_screen_space() -> Vector2:
    return Sc.utils.get_screen_position_of_node_in_level($Center)


func _update_highlight() -> void:
    active_outline_alpha_multiplier = \
        _MAX_HIGHLIGHT_OPACITY_FOR_VIEWPORT_POSITION * \
        _MAX_HIGHLIGHT_OPACITY_FOR_VIEWPORT_POSITION
    if interaction_mode == InteractionMode.HOVER or \
            interaction_mode == InteractionMode.PRESSED or \
            buttons.get_is_hovered_or_pressed():
        outline_color = Sc.palette.get_color("station_hovered")
    elif get_is_selected():
        outline_color = Sc.palette.get_color("station_selected")
    elif !is_connected_to_command_center and \
            entity_command_type != CommandType.STATION_COMMAND and \
            entity_command_type != CommandType.STATION_EMPTY:
        outline_color = Sc.palette.get_color("station_disconnected")
    else:
        outline_color = _get_normal_highlight_color()
        active_outline_alpha_multiplier = \
            viewport_position_outline_alpha_multiplier
    _update_outline()
    buttons.set_viewport_opacity_weight(active_outline_alpha_multiplier)


func get_disabled_message(command_type: int) -> String:
    var message: String = Sc.level.command_enablement[command_type]
    if message != "":
        return message
    match command_type:
        CommandType.STATION_REPAIR:
            if _health >= _health_capacity:
                return Description.ALREADY_AT_FULL_HEALTH
        
        CommandType.STATION_LINK_TO_MOTHERSHIP:
            # FIXME: ---------- Remove this case entirely.
            #                   (handled by the default cost-based disablement).
            return Description.NOT_IMPLEMENTED
        CommandType.STATION_BATTERY, \
        CommandType.STATION_SCANNER:
            # FIXME: ---------- Combine these with the other station-type case.
            return Description.NOT_IMPLEMENTED
        CommandType.STATION_COMMAND, \
        CommandType.STATION_SOLAR:
            for collection in [
                    Sc.level.command_queue, 
                    Sc.level.in_progress_commands,
                ]:
                for command in collection:
                    if command.target_station == self and \
                            (command.type == CommandType.STATION_COMMAND or \
                            command.type == CommandType.STATION_BATTERY or \
                            command.type == CommandType.STATION_SCANNER or \
                            command.type == CommandType.STATION_SOLAR):
                        return Description.ALREADY_BUILDING_STATION
        
        _:
            pass
    return ""


func _get_health_capacity() -> int:
    var base_capacity: int = Health.get_default_capacity(entity_command_type)
    
    # FIXME: -------------------------
    # - Modify health-capacity for Upgrade.
    # - Update health-capacity when linking to mothership.
    
    return base_capacity
