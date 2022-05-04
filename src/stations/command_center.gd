tool
class_name CommandCenter
extends Station


const IS_CONNECTABLE := false


func _init().(IS_CONNECTABLE) -> void:
    pass


func get_buttons() -> Array:
    return [
        Commands.RUN_WIRE,
        Commands.BOT_CONSTRUCTOR,
#        Commands.BOT_LINE_RUNNER,
#        Commands.BOT_REPAIR,
#        Commands.BOT_BARRIER,
    ]


func get_disabled_buttons() -> Array:
    return []


func get_type() -> int:
    return Commands.STATION_COMMAND


func _update_outline() -> void:
    $ShaderOutlineableAnimatedSprite.is_outlined = \
            active_outline_alpha_multiplier > 0.0
    $ShaderOutlineableAnimatedSprite.outline_color = outline_color
    $ShaderOutlineableAnimatedSprite.outline_color.a *= \
            active_outline_alpha_multiplier
