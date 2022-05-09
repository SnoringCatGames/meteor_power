tool
class_name CommandCenter
extends Station


const ENTITY_COMMAND_TYPE := Commands.STATION_COMMAND
const IS_CONNECTABLE := false


func _init().(ENTITY_COMMAND_TYPE, IS_CONNECTABLE) -> void:
    pass


func get_buttons() -> Array:
    return [
        Commands.RUN_WIRE,
#        Commands.BOT_CONSTRUCTOR,
#        Commands.BOT_LINE_RUNNER,
#        Commands.BOT_BARRIER,
    ]


func get_disabled_buttons() -> Array:
    return []


func _get_radial_menu_item_types() -> Array:
    return [
        Commands.RUN_WIRE,
        Commands.BOT_CONSTRUCTOR,
        Commands.STATION_RECYCLE,
        Commands.STATION_INFO,
    ]


func get_type() -> int:
    return Commands.STATION_COMMAND


func _update_outline() -> void:
    $ShaderOutlineableAnimatedSprite.is_outlined = \
            active_outline_alpha_multiplier > 0.0
    $ShaderOutlineableAnimatedSprite.outline_color = outline_color
    $ShaderOutlineableAnimatedSprite.outline_color.a *= \
            active_outline_alpha_multiplier
