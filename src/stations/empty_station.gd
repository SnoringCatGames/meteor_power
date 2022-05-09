tool
class_name EmptyStation
extends Station


const ENTITY_COMMAND_TYPE := Commands.STATION_EMPTY
const IS_CONNECTABLE := false


func _init().(ENTITY_COMMAND_TYPE, IS_CONNECTABLE) -> void:
    pass


func _build_station(
        button_type: int,
        bot) -> void:
    match button_type:
        Commands.STATION_SOLAR:
            bot.move_to_build_station(self, button_type)
        Commands.STATION_SCANNER:
            bot.move_to_build_station(self, button_type)
        Commands.STATION_BATTERY:
            bot.move_to_build_station(self, button_type)
        Commands.STATION_COMMAND, \
        _:
            Sc.logger.error("EmptyStation._on_station_button_pressed")


func _get_normal_highlight_color() -> Color:
    return ColorConfig.TRANSPARENT


func get_buttons() -> Array:
    return [
#        Commands.STATION_SOLAR,
    ]


func get_disabled_buttons() -> Array:
    return []


func _get_radial_menu_item_types() -> Array:
    return [
        Commands.STATION_SOLAR,
        Commands.STATION_SCANNER,
        Commands.STATION_BATTERY,
        Commands.STATION_INFO,
    ]


func get_type() -> int:
    return Commands.STATION_EMPTY


func _update_outline() -> void:
    $ShaderOutlineableSprite.is_outlined = active_outline_alpha_multiplier > 0.0
    $ShaderOutlineableSprite.outline_color = outline_color
    $ShaderOutlineableSprite.outline_color.a *= active_outline_alpha_multiplier
