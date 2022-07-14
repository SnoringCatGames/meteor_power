class_name BotExplosionAnnotator
extends TransientAnnotator


const BOT_EXPLOSION_SCENE := \
    preload("res://src/characters/bot_explosion.tscn")

const DURATION := 1.0

var explosion: BotExplosion


func _init(position: Vector2).(DURATION) -> void:
    explosion = Sc.utils.add_scene(self, BOT_EXPLOSION_SCENE)
    explosion.position = position
    _update()
