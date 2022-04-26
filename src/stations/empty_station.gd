tool
class_name EmptyStation
extends Station


func get_buttons() -> Array:
    return [
        OverlayButtonType.SOLAR_COLLECTOR,
    ]


func get_disabled_buttons() -> Array:
    return []


func get_name() -> String:
    return "empty"


func _update_outline() -> void:
    $ShaderOutlineableSprite.is_outlined = active_outline_alpha_multiplier > 0.0
    $ShaderOutlineableSprite.outline_color = outline_color
    $ShaderOutlineableSprite.outline_color.a *= active_outline_alpha_multiplier
