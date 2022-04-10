tool
class_name EmptyStation
extends Station


func get_are_buttons_shown_for_bot_selection(bot) -> bool:
    return is_instance_valid(bot)


func get_buttons(bot) -> Array:
    return [
        OverlayButtonType.SOLAR_COLLECTOR,
    ]


func get_disabled_buttons(bot) -> Array:
    return []


func get_name() -> String:
    return "empty"
