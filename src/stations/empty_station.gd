tool
class_name EmptyStation
extends Station


const ENTITY_COMMAND_TYPE := Command.STATION_EMPTY
const IS_CONNECTABLE := false


func _init().(ENTITY_COMMAND_TYPE, IS_CONNECTABLE) -> void:
    pass


func _build_station(
        button_type: int,
        bot) -> void:
    match button_type:
        Command.STATION_SOLAR:
            bot.move_to_build_station(self, button_type)
        Command.STATION_SCANNER:
            bot.move_to_build_station(self, button_type)
        Command.STATION_BATTERY:
            bot.move_to_build_station(self, button_type)
        Command.STATION_COMMAND, \
        _:
            Sc.logger.error("EmptyStation._on_station_button_pressed")


func _get_normal_highlight_color() -> Color:
    return ColorConfig.TRANSPARENT


func get_buttons() -> Array:
    return [
#        Command.STATION_SOLAR,
    ]


func _get_radial_menu_item_types() -> Array:
    return [
        Command.STATION_SOLAR,
        Command.STATION_SCANNER,
        Command.STATION_BATTERY,
        Command.STATION_INFO,
    ]


func _on_hit_by_meteor() -> void:
    ._on_hit_by_meteor()
    assert(false, "EmptyStation should not trigger meteor collisions.")


func _update_outline() -> void:
    $ShaderOutlineableSprite.is_outlined = active_outline_alpha_multiplier > 0.0
    $ShaderOutlineableSprite.outline_color = outline_color
    $ShaderOutlineableSprite.outline_color.a *= active_outline_alpha_multiplier
