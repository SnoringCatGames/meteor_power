class_name BotSelector
extends Node2D


const BOT_KEYS := [
    KEY_A,
    KEY_S,
    KEY_D,
    KEY_Q,
    KEY_W,
    KEY_E,
]

var bot_bindings := {}

var is_key_selected := false
var is_bot_selected := false
var selected_key := -1
var selected_bot = null


func _init() -> void:
    for key in BOT_KEYS:
        bot_bindings[key] = null


func _on_bot_created(bot) -> void:
    var was_bot_bound := false
    for key in BOT_KEYS:
        if !is_instance_valid(bot_bindings[key]):
            bot_bindings[key] = bot
            was_bot_bound = true
            break
    assert(was_bot_bound)
    Sc.gui.hud.bot_keys_overlay._on_bot_selection_changed()


func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventKey:
        if event.physical_scancode == KEY_Q or \
                event.physical_scancode == KEY_W or \
                event.physical_scancode == KEY_E or \
                event.physical_scancode == KEY_A or \
                event.physical_scancode == KEY_S or \
                event.physical_scancode == KEY_D:
            if event.pressed:
                if event.physical_scancode == selected_key:
                    # No change.
                    return
                selected_key = event.physical_scancode
                selected_bot = bot_bindings[selected_key]
                is_key_selected = true
                is_bot_selected = is_instance_valid(selected_bot)
            else:
                if event.physical_scancode != selected_key:
                    # Ignore different key.
                    return
                selected_key = -1
                selected_bot = null
                is_key_selected = false
                is_bot_selected = false
            
            Sc.gui.hud.bot_keys_overlay._on_bot_selection_changed()
            Sc.level._on_bot_selection_changed(selected_bot)


func get_is_key_bound(key: int) -> bool:
    return is_instance_valid(bot_bindings[key])
