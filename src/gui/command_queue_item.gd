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

var is_in_cancel_mode := false setget _set_is_in_cancel_mode


func _destroy() -> void:
    if Sc.annotators.command_annotator.command == command:
        Sc.annotators.command_annotator.command = null
    queue_free()


func set_up() -> void:
    $SpriteModulationButton.connect("touch_down", self, "_on_touch_down")
    
    $SpriteModulationButton.texture = CommandType.TEXTURES[command.type]
    
    $SpriteModulationButton.normal_modulate = \
        ColorFactory.palette("command_queue_item_active_normal")
    $SpriteModulationButton.hover_modulate = \
        ColorFactory.palette("command_queue_item_active_hover")
    $SpriteModulationButton.pressed_modulate = \
        ColorFactory.palette("command_queue_item_active_pressed")
    $SpriteModulationButton.disabled_modulate = \
        ColorFactory.palette("command_queue_item_active_disabled")
    
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


func _set_is_in_cancel_mode(value: bool) -> void:
    var was_in_cancel_mode := is_in_cancel_mode
    is_in_cancel_mode = value
    
    if is_in_cancel_mode != was_in_cancel_mode:
        var texture: Texture
        if is_in_cancel_mode:
            texture = CommandType.TEXTURES[CommandType.BOT_STOP]
            $SpriteModulationButton.normal_modulate = \
                ColorFactory.palette("command_queue_item_cancel_normal")
            $SpriteModulationButton.hover_modulate = \
                ColorFactory.palette("command_queue_item_cancel_hover")
            $SpriteModulationButton.pressed_modulate = \
                ColorFactory.palette("command_queue_item_cancel_pressed")
            $SpriteModulationButton.disabled_modulate = \
                ColorFactory.palette("command_queue_item_cancel_disabled")
        else:
            texture = CommandType.TEXTURES[command.type]
            $SpriteModulationButton.normal_modulate = \
                ColorFactory.palette("command_queue_item_active_normal")
            $SpriteModulationButton.hover_modulate = \
                ColorFactory.palette("command_queue_item_active_hover")
            $SpriteModulationButton.pressed_modulate = \
                ColorFactory.palette("command_queue_item_active_pressed")
            $SpriteModulationButton.disabled_modulate = \
                ColorFactory.palette("command_queue_item_active_disabled")
        $SpriteModulationButton.texture = texture
    
    # Update phantom-indicator annotations.
    if Sc.annotators.command_annotator.command == command and \
            !is_in_cancel_mode:
        Sc.annotators.command_annotator.command = null
    elif Sc.annotators.command_annotator.command != command and \
            is_in_cancel_mode:
        Sc.annotators.command_annotator.command = command
    
    if is_in_cancel_mode:
        Sc.gui.hud.command_queue_list.item_in_cancel_mode = self
    elif Sc.gui.hud.command_queue_list.item_in_cancel_mode == self:
        Sc.gui.hud.command_queue_list.item_in_cancel_mode = null


func _on_touch_down(level_position: Vector2, is_already_handled: bool) -> void:
    # Clear the cancel-status from other command-queue items.
    Sc.gui.hud.command_queue_list.clear_cancel_status(command)
    
    if is_in_cancel_mode:
        if is_instance_valid(command.bot):
            command.bot.stop_on_surface(false, true)
        else:
            Sc.level.cancel_command(command)
        visible = false
    else:
        _set_is_in_cancel_mode(true)
