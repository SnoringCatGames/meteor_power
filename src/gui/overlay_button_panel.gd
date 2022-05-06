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

# Array<TextureButton>
var buttons := []

var buttons_container: Node2D

var station


func _ready() -> void:
    visible = false
    buttons_container = $Buttons
    
    for button in buttons_container.get_children():
        button.connect(
                "touch_entered", self, "_on_button_touch_entered", [button])
        button.connect(
                "touch_exited", self, "_on_button_touch_exited", [button])
        button.connect("full_pressed", self, "_on_button_pressed", [button])
        button.connect(
                "interaction_mode_changed",
                self,
                "_on_interaction_mode_changed")
        button.scale = _BUTTON_SIZE / button.texture.get_size()
    
    if Engine.editor_hint:
        set_buttons([
            Commands.STATION_RECYCLE,
            Commands.STATION_BATTERY,
            Commands.STATION_SCANNER,
            Commands.STATION_SOLAR,
            Commands.RUN_WIRE,
            Commands.BOT_CONSTRUCTOR,
        ],
        [])


func _destroy() -> void:
    for button in buttons_container.get_children():
        button._destroy()


func set_up_controls(
        station,
        station_area_position: Vector2,
        station_area_size: Vector2) -> void:
    self.station = station


func set_buttons(
        button_types: Array,
        disabled_buttons: Array) -> void:
    var visible_buttons := []
    
    # Set up hover behavior.
    for button in buttons_container.get_children():
        button.alpha_multiplier = _OPACITY_NORMAL
        var button_type := _get_type_for_button(button)
        var is_button_visible := button_types.find(button_type) >= 0
        var is_button_disabled := disabled_buttons.find(button_type) >= 0
        # FIXME: ------------ Handle disabled case, when not enough energy.
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


func set_viewport_opacity_weight(weight: float) -> void:
    self.modulate.a = lerp(
            _MIN_OPACITY_FOR_VIEWPORT_POSITION,
            _MAX_OPACITY_FOR_VIEWPORT_POSITION,
            weight)


func get_is_hovered_or_pressed() -> bool:
    return ($Buttons/RunPowerLine.interaction_mode == \
                LevelControl.InteractionMode.HOVER or \
            $Buttons/RunPowerLine.interaction_mode == \
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
    button.alpha_multiplier = _OPACITY_HOVER


func _on_button_touch_exited(button: SpriteModulationButton) -> void:
#    button.modulate.s = 1.0 + _SATURATION_DELTA_NORMAL
#    button.modulate.v = 1.0 + _VALUE_DELTA_NORMAL
    button.alpha_multiplier = _OPACITY_NORMAL


func _on_interaction_mode_changed(interaction_mode: int) -> void:
    emit_signal("interaction_mode_changed")


func _on_button_pressed(
        level_position: Vector2,
        is_already_handled: bool,
        button: SpriteModulationButton) -> void:
    Sc.utils.give_button_press_feedback()
    var button_type := _get_type_for_button(button)
    Sc.logger.print("OverlayButton pressed: button=%s, station=%s, p=%s" % [
        Commands.get_string(button_type),
        Commands.get_string(station.get_type()),
        station.position,
       ])
    emit_signal("button_pressed", button_type)


func _get_type_for_button(button: SpriteModulationButton) -> int:
    if button == buttons_container.get_node("Destroy"):
        return Commands.STATION_RECYCLE
    elif button == buttons_container.get_node("Battery"):
        return Commands.STATION_BATTERY
    elif button == buttons_container.get_node("Scanner"):
        return Commands.STATION_SCANNER
    elif button == buttons_container.get_node("Solar"):
        return Commands.STATION_SOLAR
    elif button == buttons_container.get_node("RunPowerLine"):
        return Commands.RUN_WIRE
    elif button == buttons_container.get_node("ConstructorBot"):
        return Commands.BOT_CONSTRUCTOR
    else:
        Sc.logger.error("OverlayButtonPanel._get_type_for_button")
        return Commands.UNKNOWN
