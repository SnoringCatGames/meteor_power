tool
class_name BarrierPylon
extends StationarySelectable


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


func _get_radial_menu_item_types() -> Array:
    return [
        CommandType.STATION_INFO,
        CommandType.BARRIER_CONNECT,
        CommandType.BARRIER_DISCONNECT,
        CommandType.BARRIER_MOVE,
    ]


func get_disabled_message(command_type: int) -> String:
    var message: String = Sc.level.command_enablement[command_type]
    if message != "":
        return message
    match command_type:
        # FIXME: -----------------------------
        CommandType.BARRIER_CONNECT:
            pass
        CommandType.BARRIER_DISCONNECT:
            pass
        CommandType.BARRIER_MOVE:
            pass
        _:
            pass
    return ""


func _on_button_pressed(button_type: int) -> void:
    ._on_button_pressed(button_type)
    
    match button_type:
        # FIXME: -------------------------------------------
        CommandType.STATION_INFO:
            pass
        CommandType.BARRIER_CONNECT:
            pass
        CommandType.BARRIER_DISCONNECT:
            pass
        CommandType.BARRIER_MOVE:
            pass
        
        _:
            Sc.logger.error("BarrierPylon._on_button_pressed")


func _get_health_capacity() -> int:
    var base_capacity: int = \
        Health.get_default_capacity(CommandType.BARRIER_PYLON)
    
    # FIXME: -------------------------
    # - Modify health-capacity for Upgrade.
    # - Update health-capacity when linking to mothership.
    
    return base_capacity
