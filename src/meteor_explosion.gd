class_name MeteorExplosion
extends Node2D


func _on_AnimatedSprite_animation_finished() -> void:
    $AnimatedSprite.stop()
    $AnimatedSprite.frame = 44
