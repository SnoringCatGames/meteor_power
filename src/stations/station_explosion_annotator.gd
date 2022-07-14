class_name StationExplosionAnnotator
extends TransientAnnotator


const STATION_EXPLOSION_SCENE := \
    preload("res://src/stations/station_explosion.tscn")

const DURATION := 1.0

var explosion: StationExplosion


func _init(position: Vector2).(DURATION) -> void:
    explosion = Sc.utils.add_scene(self, STATION_EXPLOSION_SCENE)
    explosion.position = position
    
    _update()
