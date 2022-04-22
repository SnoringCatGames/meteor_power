tool
class_name CommandCenter
extends Station


func get_buttons() -> Array:
    return [
        OverlayButtonType.RUN_WIRE,
        OverlayButtonType.BUILD_CONSTRUCTOR_BOT,
#        OverlayButtonType.BUILD_LINE_RUNNER_BOT,
#        OverlayButtonType.BUILD_REPAIR_BOT,
#        OverlayButtonType.BUILD_BARRIER_BOT,
    ]


func get_disabled_buttons() -> Array:
    return []


func get_name() -> String:
    return "command"
