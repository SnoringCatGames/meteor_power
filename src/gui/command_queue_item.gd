tool
class_name CommandQueueItem
extends Control


const _ACTIVE_OPACITY = 0.6
const _INACTIVE_OPACITY = 0.3
const _ACTIVE_SATURATION = 0.9
const _INACTIVE_SATURATION = 0.3

var command: Command

var is_active := false


func _ready() -> void:
    # FIXME: -------------- Update colors.
    $SpriteModulationButton.normal_modulate = \
        ColorFactory.palette("modulation_button_normal")
    $SpriteModulationButton.hover_modulate = \
        ColorFactory.palette("modulation_button_hover")
    $SpriteModulationButton.pressed_modulate = \
        ColorFactory.palette("modulation_button_pressed")
    $SpriteModulationButton.disabled_modulate = \
        ColorFactory.palette("modulation_button_disabled")


func set_up() -> void:
    $SpriteModulationButton.texture = CommandType.TEXTURES[command.type]
    
    if is_active:
        $SpriteModulationButton.alpha_multiplier = _ACTIVE_OPACITY
        $SpriteModulationButton.saturation = _ACTIVE_SATURATION
    else:
        $SpriteModulationButton.alpha_multiplier = _INACTIVE_OPACITY
        $SpriteModulationButton.saturation = _INACTIVE_SATURATION


func _on_gui_scale_changed() -> bool:
    $SpriteModulationButton.position = Vector2(32, 32)
    return false
