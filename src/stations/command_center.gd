tool
class_name CommandCenter
extends Station


const ENTITY_COMMAND_TYPE := Command.STATION_COMMAND
const IS_CONNECTABLE := false


func _init().(ENTITY_COMMAND_TYPE, IS_CONNECTABLE) -> void:
    shield_activated = true


func get_buttons() -> Array:
    return [
        Command.RUN_WIRE,
#        Command.BOT_CONSTRUCTOR,
#        Command.BOT_LINE_RUNNER,
#        Command.BOT_BARRIER,
    ]


func _get_radial_menu_item_types() -> Array:
    return [
        Command.RUN_WIRE,
        Command.BOT_CONSTRUCTOR,
        Command.STATION_LINK_TO_MOTHERSHIP,
        Command.STATION_INFO,
    ]


func _update_outline() -> void:
    $ShaderOutlineableAnimatedSprite.is_outlined = \
            active_outline_alpha_multiplier > 0.0
    $ShaderOutlineableAnimatedSprite.outline_color = outline_color
    $ShaderOutlineableAnimatedSprite.outline_color.a *= \
            active_outline_alpha_multiplier
