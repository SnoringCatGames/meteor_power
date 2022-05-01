class_name GameRadialMenu
extends RadialMenu


# FIXME: LEFT OFF HERE: ---------------------


func _on_level_touch_up(
        pointer_screen_position: Vector2,
        pointer_level_position: Vector2,
        has_corresponding_touch_down: bool) -> void:
    ._on_level_touch_up(
            pointer_screen_position,
            pointer_level_position,
            has_corresponding_touch_down)
    metadata.set_is_selected(false)


func _on_center_area_touch_up(touch_position: Vector2) -> void:
    ._on_center_area_touch_up(touch_position)
    metadata.set_is_player_control_active(true)
