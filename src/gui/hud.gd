tool
class_name Hud
extends SurfacerHud


const _BOT_KEYS_OVERLAY_SCENE := preload("res://src/gui/bot_keys_overlay.tscn")

var bot_keys_overlay: BotKeysOverlay


func set_up() -> void:
    bot_keys_overlay = Sc.utils.add_scene(self, _BOT_KEYS_OVERLAY_SCENE)


func _destroy() -> void:
    ._destroy()
    if is_instance_valid(bot_keys_overlay):
        bot_keys_overlay._destroy()
