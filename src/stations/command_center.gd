tool
class_name CommandCenter
extends Station


func get_are_buttons_shown_for_bot_selection(bot) -> bool:
    return is_instance_valid(bot)


func get_buttons(bot) -> Array:
    return [
        OverlayButtonType.RUN_WIRE,
        OverlayButtonType.BUILD_CONSTRUCTOR_BOT,
#        OverlayButtonType.BUILD_LINE_RUNNER_BOT,
#        OverlayButtonType.BUILD_REPAIR_BOT,
#        OverlayButtonType.BUILD_BARRIER_BOT,
    ]


func get_disabled_buttons(bot) -> Array:
    return []


func get_name() -> String:
    return "command"
