class_name MeteorExplosion
extends Node2D


func _ready() -> void:
    $Node2D/AnimatedSprite.play()


func _on_AnimatedSprite_animation_finished() -> void:
    $Node2D/AnimatedSprite.stop()
    $Node2D/AnimatedSprite.frame = 44


func set_is_small(value: bool) -> void:
    var scale_factor := 1.0 if value else 1.6
    $Node2D.scale = Vector2.ONE * scale_factor
