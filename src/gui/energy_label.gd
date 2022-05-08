tool
class_name EnergyLabel
extends HBoxContainer


export var cost := 0 setget _set_cost
export var color: Color setget _set_color
export(String, "Xs", "S", "M", "L", "Xl") var font_size := "S" \
        setget _set_font_size
export var icon_scale := 2.0 setget _set_icon_scale

var _is_ready := false


func _init() -> void:
    color = Sc.palette.get_color("energy")


func _ready() -> void:
    _is_ready = true
    _set_color(color)
    _set_font_size(font_size)
    _set_icon_scale(icon_scale)


func _set_cost(value: int) -> void:
    cost = value
    if !_is_ready:
        return
    $ScaffolderLabel.text = str(value)


func _set_color(value: Color) -> void:
    color = value
    if !_is_ready:
        return
    $ScaffolderLabel.add_color_override("font_color", color)
    $ScaffolderTextureRect.modulate = color


func _set_font_size(value: String) -> void:
    font_size = value
    if !_is_ready:
        return
    $ScaffolderLabel.font_size = font_size


func _set_icon_scale(value: float) -> void:
    icon_scale = value
    if !_is_ready:
        return
    $ScaffolderTextureRect.texture_scale = Vector2(value, value)
