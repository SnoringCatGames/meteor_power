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


func _update_outline() -> void:
    $ShaderOutlineableAnimatedSprite.is_outlined = \
            active_outline_alpha_multiplier > 0.0
    $ShaderOutlineableAnimatedSprite.outline_color = outline_color
    $ShaderOutlineableAnimatedSprite.outline_color.a *= \
            active_outline_alpha_multiplier
