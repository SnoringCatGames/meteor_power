class_name MeteorExplosionAnnotator
extends TransientAnnotator


const METEOR_EXPLOSION_SCENE := \
    preload("res://src/meteor_explosion.tscn")

const DURATION := 0.75


func _init(position: Vector2).(DURATION) -> void:
    var explosion := Sc.utils.add_scene(self, METEOR_EXPLOSION_SCENE)
    explosion.position = position
    
    _update()
