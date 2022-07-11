class_name MeteorExplosionAnnotator
extends TransientAnnotator


const METEOR_EXPLOSION_SCENE := \
    preload("res://src/meteor_explosion.tscn")

const DURATION := 0.75

var explosion: MeteorExplosion


func _init(position: Vector2).(DURATION) -> void:
    explosion = Sc.utils.add_scene(self, METEOR_EXPLOSION_SCENE)
    explosion.position = position
    
    _update()


func set_is_small(value: bool) -> void:
    explosion.set_is_small(value)
