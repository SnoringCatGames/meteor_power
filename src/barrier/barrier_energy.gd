class_name BarrierEnergy
extends Node2D


const FRAME_COUNT := 60


func _ready() -> void:
    $AnimatedSprite.frame = min(floor(randf() * FRAME_COUNT), FRAME_COUNT - 1)
