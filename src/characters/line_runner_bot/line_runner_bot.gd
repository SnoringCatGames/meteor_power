tool
class_name LineRunnerBot
extends Bot


const ENTITY_COMMAND_TYPE := CommandType.BOT_LINE_RUNNER


func _init().(ENTITY_COMMAND_TYPE) -> void:
    pass


func _get_radial_menu_item_types() -> Array:
    return _get_common_radial_menu_item_types()


func get_can_handle_command(type: int) -> bool:
    match type:
        CommandType.BOT_LINE_RUNNER, \
        CommandType.BOT_BARRIER, \
        CommandType.STATION_COMMAND, \
        CommandType.STATION_SOLAR, \
        CommandType.STATION_SCANNER, \
        CommandType.STATION_BATTERY, \
        CommandType.STATION_LINK_TO_MOTHERSHIP, \
        CommandType.STATION_RECYCLE:
            # Override the default bot behavior.
            return false
        
        _:
            # Use the default bot behavior.
            return .get_can_handle_command(type)
