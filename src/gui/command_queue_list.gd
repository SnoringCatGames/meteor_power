tool
class_name CommandQueueList
extends ScaffolderPanelContainer


const _COMMAND_QUEUE_ITEM_SCENE := \
    preload("res://src/gui/command_queue_item.tscn")

const OUTER_PADDING_X := 2.0
const OUTER_PADDING_Y := 32.0
const INTRA_ITEM_PADDING := 8.0

# Dictionary<Command, CommandQueueItem>
var queued_command_to_control := {}
# Dictionary<Command, CommandQueueItem>
var in_progress_command_to_control := {}

var item_in_cancel_mode: CommandQueueItem


func _ready() -> void:
    Sc.gui.add_gui_to_scale(self)
    Sc.level.touch_listener.connect(
        "single_unhandled_touch_down", self, "_on_single_unhandled_touch_down")


func _destroy() -> void:
    Sc.gui.remove_gui_to_scale(self)
    for collection in [
        in_progress_command_to_control,
        queued_command_to_control,
    ]:
        for command in collection:
            collection[command]._destroy()
    if !is_queued_for_deletion():
        queue_free()


func _on_gui_scale_changed() -> bool:
    call_deferred("_deferred_on_gui_scale_changed")
    return false


func _deferred_on_gui_scale_changed() -> bool:
    rect_position.x = \
        Sc.gui.hud.hud_key_value_list.rect_position.x + \
        OUTER_PADDING_X * Sc.gui.scale
    rect_position.y = \
        Sc.gui.hud.hud_key_value_list.get_bottom_coordinate() + \
        OUTER_PADDING_Y * Sc.gui.scale
    $VBoxContainer/InProgressCommands.add_constant_override(
        "separation", INTRA_ITEM_PADDING * Sc.gui.scale)
    $VBoxContainer/QueuedCommands.add_constant_override(
        "separation", INTRA_ITEM_PADDING * Sc.gui.scale)
    $VBoxContainer/Spacer.size.y = 0.0
    return false


func sync_queue() -> void:
    var command_in_cancel_mode: Command
    if is_instance_valid(item_in_cancel_mode):
        command_in_cancel_mode = item_in_cancel_mode.command
    
    in_progress_command_to_control = _sync_queue_helper(
        Sc.level.in_progress_commands,
        in_progress_command_to_control,
        $VBoxContainer/InProgressCommands,
        true)
    queued_command_to_control = _sync_queue_helper(
        Sc.level.command_queue,
        queued_command_to_control,
        $VBoxContainer/QueuedCommands,
        false)
    
    if is_instance_valid(command_in_cancel_mode):
        if in_progress_command_to_control.has(command_in_cancel_mode):
            in_progress_command_to_control[command_in_cancel_mode] \
                .is_in_cancel_mode = true


func _sync_queue_helper(
        collection,
        command_to_control_map: Dictionary,
        parent: VBoxContainer,
        is_active: bool) -> Dictionary:
    var updated_command_map := {}
    
    for command in collection:
        if command_to_control_map.has(command):
            # Preserve continued items.
            updated_command_map[command] = command_to_control_map[command]
            command_to_control_map.erase(command)
        else:
            # Add new items.
            var control: CommandQueueItem = _COMMAND_QUEUE_ITEM_SCENE.instance()
            control.command = command
            control.is_active = is_active
            control.set_up()
            parent.add_child(control)
            updated_command_map[command] = control
    
    # Remove old items.
    for obsolete_command in command_to_control_map:
        command_to_control_map[obsolete_command]._destroy()
    
    return updated_command_map


func _on_single_unhandled_touch_down(
        pointer_screen_position: Vector2,
        pointer_level_position: Vector2) -> void:
    clear_cancel_status()


func clear_cancel_status(exception_command: Command = null) -> void:
    for collection in [
        in_progress_command_to_control,
        queued_command_to_control,
    ]:
        for command in collection:
            if command == exception_command:
                continue
            collection[command].is_in_cancel_mode = false
