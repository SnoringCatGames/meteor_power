tool
class_name StatusBar, \
"res://addons/scaffolder/assets/images/editor_icons/scaffolder_node.png"
extends Node2D


const RATIO_FULL_THRESHOLD := 0.7
const RATIO_MEDIUM_THRESHOLD := 0.4

export var width := 30.0 setget _set_width
export var height := 3.0 setget _set_height

var current := 0.0
var capacity := 0.0

var background_color := Sc.palette.get_color("black")
var full_color := Sc.palette.get_color("green")
var medium_color := Sc.palette.get_color("yellow")
var empty_color := Sc.palette.get_color("red")

export var icon_texture: Texture setget _set_icon_texture
export var icon_scale := 1.0 setget _set_icon_scale
export var icon_margin := 2.0 setget _set_icon_margin
export var icon_modulate := Color.white setget _set_icon_modulate

var entity


func update() -> void:
    var bar_offset_x := 0.0
    if is_instance_valid(icon_texture):
        $Sprite.visible = true
        $Sprite.modulate = icon_modulate
        $Sprite.texture = icon_texture
        $Sprite.scale = Vector2.ONE * icon_scale
        var icon_size := icon_texture.get_size() * icon_scale
        $Sprite.position.x = icon_size.x / 2.0
        $Sprite.position.y = height / 2.0
        bar_offset_x = icon_size.x + icon_margin
    else:
        $Sprite.visible = false
    
    var bar_width := width - bar_offset_x
    
    $Capacity.rect_position.x = bar_offset_x
    $Capacity.rect_size.x = bar_width
    $Capacity.rect_size.y = height
    $Capacity.color = background_color
    
    var ratio := \
        current / capacity if \
        capacity > 0 else \
        0.0
    
    var color: Color
    if ratio > RATIO_FULL_THRESHOLD:
        color = full_color
    elif ratio > RATIO_MEDIUM_THRESHOLD:
        color = medium_color
    else:
        color = empty_color
    
    $Current.rect_position.x = bar_offset_x
    $Current.rect_size.x = bar_width * ratio
    $Current.rect_size.y = height
    $Current.color = color


func _set_width(value: float) -> void:
    width = value
    update()


func _set_height(value: float) -> void:
    height = value
    update()


func _set_icon_texture(value: Texture) -> void:
    icon_texture = value
    update()


func _set_icon_scale(value: float) -> void:
    icon_scale = value
    update()


func _set_icon_margin(value: float) -> void:
    icon_margin = value
    update()


func _set_icon_modulate(value: Color) -> void:
    icon_modulate = value
    update()


func get_height() -> float:
    if is_instance_valid(icon_texture):
        return max(icon_texture.get_size().y * icon_scale, height)
    else:
        return height
