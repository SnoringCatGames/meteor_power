tool
class_name BarrierBot
extends Bot


const ENTITY_COMMAND_TYPE := CommandType.BOT_BARRIER


func _init().(ENTITY_COMMAND_TYPE) -> void:
    pass


func _get_radial_menu_item_types() -> Array:
    return _get_common_radial_menu_item_types()


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
