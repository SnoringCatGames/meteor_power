tool
class_name Phantom
extends AnimatedSprite


const PHANTOM_OPACITY = 0.8


func _ready() -> void:
    modulate = Sc.palette.get_color("command_phantom")
    modulate.a = PHANTOM_OPACITY
