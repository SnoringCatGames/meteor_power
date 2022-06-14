tool
class_name CommandQueueItem
extends Control


const _ACTIVE_OPACITY = 0.6
const _INACTIVE_OPACITY = 0.3
const _ACTIVE_SATURATION = 0.9
const _INACTIVE_SATURATION = 0.3
const _BUTTON_EXTENTS = Vector2.ONE * 32

var command: Command

var is_active := false


func _ready() -> void:
    $SpriteModulationButton.normal_modulate = \
        ColorFactory.palette("command_queue_item_active_normal")
    $SpriteModulationButton.hover_modulate = \
        ColorFactory.palette("command_queue_item_active_hover")
    $SpriteModulationButton.pressed_modulate = \
        ColorFactory.palette("command_queue_item_active_pressed")
    $SpriteModulationButton.disabled_modulate = \
        ColorFactory.palette("command_queue_item_active_disabled")


func set_up() -> void:
    $SpriteModulationButton.texture = CommandType.TEXTURES[command.type]
    
    if is_active:
        $SpriteModulationButton.alpha_multiplier = _ACTIVE_OPACITY
        $SpriteModulationButton.saturation = _ACTIVE_SATURATION
    else:
        $SpriteModulationButton.alpha_multiplier = _INACTIVE_OPACITY
        $SpriteModulationButton.saturation = _INACTIVE_SATURATION
    
    _on_gui_scale_changed()


func _on_gui_scale_changed() -> bool:
    rect_min_size = _BUTTON_EXTENTS * 2 * Sc.gui.scale
    $SpriteModulationButton.position = _BUTTON_EXTENTS * Sc.gui.scale
    $SpriteModulationButton.shape_rectangle_extents = \
        _BUTTON_EXTENTS * Sc.gui.scale
    return false
