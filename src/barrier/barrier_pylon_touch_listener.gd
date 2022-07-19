class_name BarrierPylonTouchListener
extends PlayerTouchListener


func _init(character).(character) -> void:
    for selection in [
                _player_nav.pre_selection,
                _player_nav.new_selection,
                _player_nav.last_selection,
            ]:
        selection.set_meta(
            "original_surface_to_air_jump_distance_squared_threshold",
            selection._surface_to_air_jump_distance_squared_threshold)
        selection.set_meta(
            "original_pointer_to_surface_distance_squared_threshold",
            selection._pointer_to_surface_distance_squared_threshold)


func _on_is_in_barrier_pylon_placement_mode_changed() -> void:
    # For barrier-pylon placement, update navigation preselection to always use
    # the nearest grabbable position-along-surface, regardless of how far the
    # cursor is.
    for selection in [
                _player_nav.pre_selection,
                _player_nav.new_selection,
                _player_nav.last_selection,
            ]:
        if Sc.level.is_in_barrier_pylon_placement_mode:
            selection._surface_to_air_jump_distance_squared_threshold = \
                10000000.0
            selection._pointer_to_surface_distance_squared_threshold = \
                10000000.0
        else:
            selection._surface_to_air_jump_distance_squared_threshold = \
                selection.get_meta(
                    "original_surface_to_air_jump_distance_squared_threshold")
            selection._pointer_to_surface_distance_squared_threshold = \
                selection.get_meta(
                    "original_pointer_to_surface_distance_squared_threshold")


func _on_pointer_released(
        pointer_screen_position: Vector2,
        pointer_level_position: Vector2,
        has_corresponding_touch_down: bool) -> void:
    ._on_pointer_released(
        pointer_screen_position,
        pointer_level_position,
        has_corresponding_touch_down)
    if Sc.level.is_in_barrier_pylon_placement_mode:
        var destination := \
            PositionAlongSurfaceFactory.create_position_without_surface(
                pointer_level_position)
        Sc.level.add_command(
            CommandType.BARRIER_PYLON,
            null,
            null,
            destination)
