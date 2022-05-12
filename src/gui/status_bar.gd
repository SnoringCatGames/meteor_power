class_name StatusBar, \
"res://addons/scaffolder/assets/images/editor_icons/scaffolder_node.png"
extends Node2D


const RATIO_FULL_THRESHOLD := 0.7
const RATIO_MEDIUM_THRESHOLD := 0.4

var width := 30.0
var height := 3.0

var current := 0.0
var capacity := 0.0

var background_color := Sc.palette.get_color("black")
var full_color := Sc.palette.get_color("green")
var medium_color := Sc.palette.get_color("yellow")
var empty_color := Sc.palette.get_color("red")

var entity


func update() -> void:
    if !is_instance_valid(entity):
        return
    
    $Capacity.rect_size.x = width
    $Capacity.rect_size.y = height
    $Capacity.color = background_color
    
    var ratio := current / capacity
    
    var color: Color
    if ratio > RATIO_FULL_THRESHOLD:
        color = full_color
    elif ratio > RATIO_MEDIUM_THRESHOLD:
        color = medium_color
    else:
        color = empty_color
    
    $Current.rect_size.x = width * ratio
    $Current.rect_size.y = height
    $Current.color = color
