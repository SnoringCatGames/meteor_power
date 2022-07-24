tool
class_name BarrierPylon
extends StationarySelectable


# FIXME: LEFT OFF HERE: ----------------------------------
# - Add disablement messages:
#   - Too many pylons.
#   - No barrier bots remain.
#   - Too far from other pylon(s).
# - Deduct energy when building pylon.
# - Add logic to decrement energy while pylons are connected.
# - Add pylon-move command logic.
# - Update HUD to display the number of pylons.
# - Impose limit on number of pylons.
#   - Only two?
#   - Or do I need to also add support for targeting which pylon to pair to
#     which?
# - Automatically trigger connection by default?
# - Add logic to prevent starting new barrier-pylon commands when at max
#   capacity (or when current queued commands would put us at max capacity).
# - Add logic to prevent finishing new barrier-pylon commands when at max
#   capacity (or when current queued commands would put us at max capacity).


const ENTITY_COMMAND_TYPE := CommandType.BARRIER_PYLON

const ENERGY_FIELD_SCENE := preload(
    "res://src/barrier/barrier_energy_field.tscn")

var energy_field: BarrierEnergyField


func _init().(ENTITY_COMMAND_TYPE) -> void:
    pass


func _destroy() -> void:
    _set_is_connected(false)
    ._destroy()


func _ready() -> void:
    Sc.slow_motion.set_time_scale_for_node($AnimationPlayer)
    $AnimationPlayer.current_animation = "pylon"
    $AnimationPlayer.seek(
        randf() * $AnimationPlayer.current_animation_length, true)


func _update_outline() -> void:
    $TextureOutlineableSprite.is_outlined = \
        active_outline_alpha_multiplier > 0.0
    $TextureOutlineableSprite.outline_color = outline_color
    $TextureOutlineableSprite.outline_color.a *= \
        active_outline_alpha_multiplier


func _get_meteor_hit_cost() -> int:
    return Cost.BARRIER_PYLON_HIT


func set_is_selected(is_selected: bool) -> void:
    if is_selected == get_is_selected():
        # No change.
        return
    .set_is_selected(is_selected)
    Sc.level._on_station_selection_changed(self, is_selected)
    Sc.level._on_barrier_pylon_selection_changed(self, is_selected)


func get_is_selected() -> bool:
    return Sc.level.selected_barrier_pylon == self


func get_radial_position_in_screen_space() -> Vector2:
    return Sc.utils.get_screen_position_of_node_in_level(self)


func _get_radial_menu_item_types() -> Array:
    # TODO: Update the menu item when is-active changes while the menu is open.
    var connection_toggle := \
        CommandType.BARRIER_DISCONNECT if \
        get_is_active() else \
        CommandType.BARRIER_CONNECT
    return [
        connection_toggle,
        CommandType.BARRIER_MOVE,
        CommandType.BARRIER_RECYCLE,
        CommandType.BARRIER_INFO,
    ]


func get_disabled_message(command_type: int) -> String:
    var message: String = Sc.level.command_enablement[command_type]
    if message != "":
        return message
    # FIXME: ----------------------------
    match command_type:
        CommandType.BARRIER_CONNECT, \
        CommandType.BARRIER_DISCONNECT, \
        CommandType.BARRIER_MOVE, \
        CommandType.BARRIER_RECYCLE, \
        _:
            pass
    return ""


func _on_button_pressed(button_type: int) -> void:
    ._on_button_pressed(button_type)
    
    match button_type:
        CommandType.BARRIER_INFO:
            set_is_selected(true)
            update_info_panel_visibility(true)
        CommandType.BARRIER_CONNECT:
            set_is_selected(false)
            update_info_panel_visibility(false)
            _set_is_connected(true)
        CommandType.BARRIER_DISCONNECT:
            set_is_selected(false)
            update_info_panel_visibility(false)
            _set_is_connected(false)
        CommandType.BARRIER_MOVE:
            set_is_selected(false)
            update_info_panel_visibility(false)
            var destination := _get_closest_position_on_a_surface()
            Sc.level.add_command(
                CommandType.BARRIER_MOVE,
                null,
                null,
                destination,
                self)
            # FIXME: -------------------------------------------
            pass
        CommandType.BARRIER_RECYCLE:
            set_is_selected(false)
            update_info_panel_visibility(false)
            var destination := _get_closest_position_on_a_surface()
            Sc.level.add_command(
                CommandType.BARRIER_RECYCLE,
                null,
                null,
                destination,
                self)
        
        _:
            Sc.logger.error("BarrierPylon._on_button_pressed")


func _on_health_depleted() -> void:
    Sc.level.on_barrier_pylon_health_depleted(self)


func _set_is_connected(value: bool) -> void:
    var other_pylon := get_other_pylon()
    if value:
        if !is_instance_valid(other_pylon) or \
                get_is_active():
            return
        
        var energy_field := \
            Sc.utils.add_scene(Sc.level, ENERGY_FIELD_SCENE)
        energy_field.set_pylons(self, other_pylon)
        _set_energy_field(energy_field)
        other_pylon._set_energy_field(energy_field)
    else:
        if !get_is_active():
            return
        
        self.energy_field.queue_free()
        self._set_energy_field(null)
        if is_instance_valid(other_pylon):
            other_pylon._set_energy_field(null)


func _get_health_capacity() -> int:
    var base_capacity: int = \
        Health.get_default_capacity(CommandType.BARRIER_PYLON)
    
    # FIXME: -------------------------
    # - Modify health-capacity for Upgrade.
    # - Update health-capacity when linking to mothership.
    
    return base_capacity


func _get_closest_position_on_a_surface() -> PositionAlongSurface:
    return SurfaceFinder.find_closest_position_on_a_surface(
        position,
        Sc.level.graph_parser.crash_test_dummies["barrier"],
        SurfaceReachability.ANY)


func get_other_pylon() -> BarrierPylon:
    for pylon in Sc.level.barrier_pylons:
        if is_instance_valid(pylon) and \
                pylon != self:
            return pylon
    return null


func get_is_there_another_pylon() -> bool:
    return !is_instance_valid(get_other_pylon())


func get_is_active() -> bool:
    return is_instance_valid(energy_field)


func _set_energy_field(energy_field: BarrierEnergyField) -> void:
    self.energy_field = energy_field
    # FIXME: ------------------------------
    # - Toggle radial buttons.
    # - ...
