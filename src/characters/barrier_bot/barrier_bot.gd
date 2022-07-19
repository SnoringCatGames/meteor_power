tool
class_name BarrierBot
extends Bot


const ENTITY_COMMAND_TYPE := CommandType.BOT_BARRIER


func _init().(ENTITY_COMMAND_TYPE) -> void:
    pass


func _get_radial_menu_item_types() -> Array:
    return [
        CommandType.BOT_COMMAND,
        CommandType.BARRIER_PYLON,
        CommandType.BOT_STOP,
        CommandType.BOT_RECYCLE,
        CommandType.BOT_INFO,
    ]


func get_can_handle_command(type: int) -> bool:
    match type:
        CommandType.BOT_COMMAND, \
        CommandType.BOT_STOP, \
        CommandType.BOT_MOVE, \
        CommandType.BOT_RECYCLE, \
        CommandType.BARRIER_PYLON:
            return true
        
        _:
            return false


func _on_radial_menu_item_selected(item: RadialMenuItem) -> void:
    if item.id == CommandType.BARRIER_PYLON:
        set_is_player_control_active(true)
        Sc.level.enter_barrier_pylon_placement_mode()
    else:
        ._on_radial_menu_item_selected(item)


func _on_reached_position_to_build_barrier_pylon() -> void:
    # FIXME: ---------------------------------------------------
    pass
