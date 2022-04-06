tool
class_name BotKeysOverlay
extends ScaffolderPanelContainer


var _BOTTOM_PADDING := 16.0
var _BUTTON_SIZE := Vector2(32, 32)
var _TEXTURE_SIZE := Vector2(16, 16)

var _UNBOUND_KEY_MODULATE := Color("77292929")
var _UNBOUND_SELECTED_KEY_MODULATE := Color("ffcc2c16")
var _BOUND_KEY_WITH_BOT_SELECTED_MODULATE := Color("ff1cb0ff")
var _BOUND_KEY_WITHOUT_BOT_SELECTED_MODULATE := Color("cc6abe30")
var _BOUND_KEY_WITH_OTHER_KEY_SELECTED_MODULATE := Color("993d5929")


func _ready() -> void:
    Sc.gui.add_gui_to_scale(self)
    _on_gui_scale_changed()


func _destroy() -> void:
    Sc.gui.remove_gui_to_scale(self)
    if !is_queued_for_deletion():
        queue_free()


func _on_gui_scale_changed() -> bool:
    var texture_scale := _BUTTON_SIZE / _TEXTURE_SIZE
    for key in BotSelector.BOT_KEYS:
        var texture := _get_texture_for_key(key)
        texture.texture_scale = texture_scale
        # This is already triggered when setting texture_scale.
#        Sc.gui.scale_gui_recursively(texture)
    
    var texture_size: Vector2 = $VBoxContainer/HBoxContainer/Q.rect_size
    rect_size = texture_size * Vector2(3.0, 2.0)
    
    rect_position.x = (Sc.device.get_viewport_size().x - rect_size.x) / 2.0
    rect_position.y = \
            Sc.device.get_viewport_size().y - \
            rect_size.y - \
            _BOTTOM_PADDING * Sc.gui.scale
    
    return true


func _on_bot_selection_changed() -> void:
    if Sc.level.bot_selector.is_key_selected:
        for key in BotSelector.BOT_KEYS:
            var texture := _get_texture_for_key(key)
            var is_key_bound: bool = Sc.level.bot_selector.get_is_key_bound(key)
            texture.modulate = \
                    _BOUND_KEY_WITH_OTHER_KEY_SELECTED_MODULATE if \
                    is_key_bound else \
                    _UNBOUND_KEY_MODULATE
        
        var selected_texture := \
                _get_texture_for_key(Sc.level.bot_selector.selected_key)
        var is_bot_selected: bool = Sc.level.bot_selector.is_bot_selected
        selected_texture.modulate = \
                _BOUND_KEY_WITH_BOT_SELECTED_MODULATE if \
                is_bot_selected else \
                _UNBOUND_SELECTED_KEY_MODULATE
        
    else:
        for key in BotSelector.BOT_KEYS:
            var texture := _get_texture_for_key(key)
            var is_key_bound: bool = Sc.level.bot_selector.get_is_key_bound(key)
            texture.modulate = \
                    _BOUND_KEY_WITHOUT_BOT_SELECTED_MODULATE if \
                    is_key_bound else \
                    _UNBOUND_KEY_MODULATE


func _get_texture_for_key(key: int) -> ScaffolderTextureRect:
    var texture_rect: ScaffolderTextureRect
    if key == KEY_Q:
        texture_rect = $VBoxContainer/HBoxContainer/Q
    elif key == KEY_W:
        texture_rect = $VBoxContainer/HBoxContainer/W
    elif key == KEY_E:
        texture_rect = $VBoxContainer/HBoxContainer/E
    elif key == KEY_A:
        texture_rect = $VBoxContainer/HBoxContainer2/A
    elif key == KEY_S:
        texture_rect = $VBoxContainer/HBoxContainer2/S
    elif key == KEY_D:
        texture_rect = $VBoxContainer/HBoxContainer2/D
    else:
        Sc.logger.error("_get_texture_for_key")
    return texture_rect


