tool
class_name EmptyStation
extends Station


const ENTITY_COMMAND_TYPE := CommandType.STATION_EMPTY


func _init().(ENTITY_COMMAND_TYPE) -> void:
    pass


func _build_station(button_type: int) -> void:
    Sc.level.add_command(button_type, self)


func _get_normal_highlight_color() -> Color:
    return ColorConfig.TRANSPARENT


func get_buttons() -> Array:
    return [
#        CommandType.STATION_SOLAR,
    ]


func _get_radial_menu_item_types() -> Array:
    return [
        CommandType.STATION_SOLAR,
        CommandType.STATION_SCANNER,
        CommandType.STATION_BATTERY,
        CommandType.STATION_INFO,
    ]


func _on_hit_by_meteor(meteor) -> void:
    ._on_hit_by_meteor(meteor)
    assert(false, "EmptyStation should not trigger meteor collisions.")


func _update_outline() -> void:
    $ShaderOutlineableSprite.is_outlined = active_outline_alpha_multiplier > 0.0
    $ShaderOutlineableSprite.outline_color = outline_color
    $ShaderOutlineableSprite.outline_color.a *= active_outline_alpha_multiplier
