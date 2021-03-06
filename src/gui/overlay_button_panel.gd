tool
class_name OverlayButtonPanel
extends Node2D


signal button_pressed(button_type)
signal mouse_entered()
signal mouse_exited()
signal interaction_mode_changed()

const _MIN_OPACITY_FOR_VIEWPORT_POSITION := 0.0
const _MAX_OPACITY_FOR_VIEWPORT_POSITION := 1.0

const _OPACITY_NORMAL := 0.75
const _OPACITY_HOVER := 0.999

const _VALUE_DELTA_NORMAL := 0.0
const _VALUE_DELTA_HOVER := 0.35

const _SATURATION_DELTA_NORMAL := 0.0
const _SATURATION_DELTA_HOVER := -0.3

const _BUTTON_SIZE := Vector2(30, 30)

const _PANEL_OFFSET := Vector2(0, 8)

const _BUTTON_KEYS := [
    CommandType.STATION_STOP,
    CommandType.STATION_RECYCLE,
    CommandType.STATION_BATTERY,
    CommandType.STATION_SCANNER,
    CommandType.STATION_SOLAR,
    CommandType.RUN_WIRE,
    CommandType.BOT_CONSTRUCTOR,
]

# Array<TextureButton>
var buttons := []

var buttons_container: Node2D

var station

var has_run_power_line_button := false


func _ready() -> void:
    visible = false
    buttons_container = $Buttons
    
    for button in buttons_container.get_children():
        button.connect(
                "touch_entered", self, "_on_button_touch_entered", [button])
        button.connect(
                "touch_exited", self, "_on_button_touch_exited", [button])
        button.connect("touch_down", self, "_on_button_touch_down", [button])
        button.connect(
                "interaction_mode_changed",
                self,
                "_on_interaction_mode_changed")
        button.scale = _BUTTON_SIZE / button.texture.get_size()
    
    if Engine.editor_hint:
        set_buttons(_BUTTON_KEYS)


func _destroy() -> void:
    for button in buttons_container.get_children():
        button._destroy()


func set_up_controls(
        station,
        station_area_position: Vector2,
        station_area_size: Vector2) -> void:
    self.station = station


func set_buttons(button_types: Array) -> void:
    has_run_power_line_button = button_types.has(CommandType.RUN_WIRE)
    
    var visible_buttons := []
    
    # Set up hover behavior.
    for button in buttons_container.get_children():
        button.alpha_multiplier = _OPACITY_NORMAL
        var button_type := _get_type_for_button(button)
        var is_button_visible := button_types.find(button_type) >= 0
        button.visible = is_button_visible
        button.mouse_filter = \
                Control.MOUSE_FILTER_STOP if \
                is_button_visible else \
                Control.MOUSE_FILTER_IGNORE
        if is_button_visible:
            visible_buttons.push_back(button)
    
    # Calculate the button row and column counts.
    var row_count: int
    var button_count := visible_buttons.size()
    if button_count > 6:
        row_count = 3
    elif button_count > 2:
        row_count = 2
    else:
        row_count = 1
    var column_count := int(ceil(button_count / row_count))
    
    var container_size := Vector2(column_count, row_count) * _BUTTON_SIZE
    
    # Assign the individual button positions.
    for row_i in row_count:
        for column_i in column_count:
            var button_i: int = row_i * column_count + column_i
            var button_position := \
                    _BUTTON_SIZE * Vector2(column_i, row_i) + \
                    _BUTTON_SIZE / 2.0 - \
                    Vector2(container_size.x / 2.0, 0.0)
            visible_buttons[button_i].position = button_position
    
    self.position = _PANEL_OFFSET
    
#    _set_shape_rectangle_extents(container_size / 2.0)
#    _set_shape_offset(Vector2(0.0, container_size.y / 2.0))
    
    $Buttons/Stop.position = $Buttons/RunPowerLine.position
    
    _on_command_enablement_changed()


func set_viewport_opacity_weight(weight: float) -> void:
    $Buttons.modulate.a = lerp(
            _MIN_OPACITY_FOR_VIEWPORT_POSITION,
            _MAX_OPACITY_FOR_VIEWPORT_POSITION,
            weight)


func get_is_hovered_or_pressed() -> bool:
    return ($Buttons/RunPowerLine.interaction_mode == \
                LevelControl.InteractionMode.HOVER or \
            $Buttons/RunPowerLine.interaction_mode == \
                LevelControl.InteractionMode.PRESSED) or \
        ($Buttons/Stop.interaction_mode == \
                LevelControl.InteractionMode.HOVER or \
            $Buttons/Stop.interaction_mode == \
                LevelControl.InteractionMode.PRESSED) or \
        ($Buttons/Battery.interaction_mode == \
                LevelControl.InteractionMode.HOVER or \
            $Buttons/Battery.interaction_mode == \
                LevelControl.InteractionMode.PRESSED) or \
        ($Buttons/Scanner.interaction_mode == \
                LevelControl.InteractionMode.HOVER or \
            $Buttons/Scanner.interaction_mode == \
                LevelControl.InteractionMode.PRESSED) or \
        ($Buttons/Solar.interaction_mode == \
                LevelControl.InteractionMode.HOVER or \
            $Buttons/Solar.interaction_mode == \
                LevelControl.InteractionMode.PRESSED) or \
        ($Buttons/ConstructorBot.interaction_mode == \
                LevelControl.InteractionMode.HOVER or \
            $Buttons/ConstructorBot.interaction_mode == \
                LevelControl.InteractionMode.PRESSED) or \
        ($Buttons/Destroy.interaction_mode == \
                LevelControl.InteractionMode.HOVER or \
            $Buttons/Destroy.interaction_mode == \
                LevelControl.InteractionMode.PRESSED)


func _on_button_touch_entered(button: SpriteModulationButton) -> void:
#    button.modulate.s = 1.0 + _SATURATION_DELTA_HOVER
#    button.modulate.v = 1.0 + _VALUE_DELTA_HOVER
#    button.alpha_multiplier = _OPACITY_HOVER
    pass


func _on_button_touch_exited(button: SpriteModulationButton) -> void:
#    button.modulate.s = 1.0 + _SATURATION_DELTA_NORMAL
#    button.modulate.v = 1.0 + _VALUE_DELTA_NORMAL
#    button.alpha_multiplier = _OPACITY_NORMAL
    pass


func _on_interaction_mode_changed(interaction_mode: int) -> void:
    emit_signal("interaction_mode_changed")


func _on_button_touch_down(
        level_position: Vector2,
        is_already_handled: bool,
        button: SpriteModulationButton) -> void:
    if button.is_disabled:
        return
    Sc.utils.give_button_press_feedback()
    var button_type := _get_type_for_button(button)
    Sc.logger.print("OverlayButton pressed: button=%s, station=%s, p=%s" % [
        CommandType.get_string(button_type),
        CommandType.get_string(station.entity_command_type),
        station.position,
       ])
    emit_signal("button_pressed", button_type)


func _get_type_for_button(button: SpriteModulationButton) -> int:
    if button == buttons_container.get_node("Stop"):
        return CommandType.STATION_STOP
    elif button == buttons_container.get_node("Destroy"):
        return CommandType.STATION_RECYCLE
    elif button == buttons_container.get_node("Battery"):
        return CommandType.STATION_BATTERY
    elif button == buttons_container.get_node("Scanner"):
        return CommandType.STATION_SCANNER
    elif button == buttons_container.get_node("Solar"):
        return CommandType.STATION_SOLAR
    elif button == buttons_container.get_node("RunPowerLine"):
        return CommandType.RUN_WIRE
    elif button == buttons_container.get_node("ConstructorBot"):
        return CommandType.BOT_CONSTRUCTOR
    else:
        Sc.logger.error("OverlayButtonPanel._get_type_for_button")
        return CommandType.UNKNOWN


func _get_button_for_type(type: int) -> Node:
    match type:
        CommandType.STATION_STOP:
            return $Buttons/Stop
        CommandType.STATION_RECYCLE:
            return $Buttons/Destroy
        CommandType.STATION_BATTERY:
            return $Buttons/Battery
        CommandType.STATION_SCANNER:
            return $Buttons/Scanner
        CommandType.STATION_SOLAR:
            return $Buttons/Solar
        CommandType.RUN_WIRE:
            return $Buttons/RunPowerLine
        CommandType.BOT_CONSTRUCTOR:
            return $Buttons/ConstructorBot
        _:
            Sc.logger.error("OverlayButtonPanel._get_button_for_type")
            return null


func _on_command_enablement_changed() -> void:
    if !has_run_power_line_button:
        return
    
    var disabled: bool = Sc.level.command_enablement[CommandType.RUN_WIRE] != ""
    
    var is_run_wire_button_visible: bool
    if disabled:
        # Always show the run-wire button when disabled.
        is_run_wire_button_visible = true
    elif Sc.level.first_selected_station_for_running_power_line == station:
        # A station cannot be connected to itself.
        is_run_wire_button_visible = false
    elif station.station_connections.has(
            Sc.level.first_selected_station_for_running_power_line):
        # This station is already connected to the selected station.
        is_run_wire_button_visible = false
    else:
        is_run_wire_button_visible = true
        
        # Check whether there is already a command for this run-wire button.
        for collection in \
                [Sc.level.command_queue, Sc.level.in_progress_commands]:
            for command in collection:
                if command.target_station == \
                            Sc.level.first_selected_station_for_running_power_line and \
                        command.next_target_station == station or \
                        command.target_station == station and \
                        command.next_target_station == \
                            Sc.level.first_selected_station_for_running_power_line:
                    is_run_wire_button_visible = false
                    break
    
    var visible_button: SpriteModulationButton
    var hidden_button: SpriteModulationButton
    if is_run_wire_button_visible:
        visible_button = $Buttons/RunPowerLine
        hidden_button = $Buttons/Stop
    else:
        visible_button = $Buttons/Stop
        hidden_button = $Buttons/RunPowerLine
    
    visible_button.visible = true
    visible_button.mouse_filter = Control.MOUSE_FILTER_STOP
    hidden_button.visible = false
    hidden_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
    
    $Buttons/RunPowerLine.is_disabled = disabled
