tool
class_name LineRunnerBot
extends Bot


const ENTITY_COMMAND_TYPE := Command.BOT_LINE_RUNNER


func _init().(ENTITY_COMMAND_TYPE) -> void:
    pass


func _get_radial_menu_item_types() -> Array:
    return _get_common_radial_menu_item_types()
