tool
class_name Phantom
extends Node2D


const PHANTOM_OPACITY = 0.65

var command: Command


func _ready() -> void:
    modulate = Sc.palette.get_color("command_phantom")
    modulate.a = PHANTOM_OPACITY
