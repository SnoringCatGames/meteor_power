tool
class_name BarrierBot
extends Bot


const ENTITY_COMMAND_TYPE := Commands.BOT_BARRIER


func _init().(ENTITY_COMMAND_TYPE) -> void:
    pass


func _get_radial_menu_item_types() -> Array:
    return _get_common_radial_menu_item_types()
