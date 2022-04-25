tool
class_name OverlayButtonPanel
extends Node2D


signal button_pressed(button_type)

const _MIN_OPACITY_FOR_VIEWPORT_POSITION := 0.0
const _MAX_OPACITY_FOR_VIEWPORT_POSITION := 1.0

const _OPACITY_NORMAL := 0.75
const _OPACITY_HOVER := 0.999

const _VALUE_DELTA_NORMAL := 0.0
const _VALUE_DELTA_HOVER := 0.35

const _SATURATION_DELTA_NORMAL := 0.0
const _SATURATION_DELTA_HOVER := -0.3

const _BUTTON_SIZE := Vector2(32, 32)

const _PANEL_OFFSET := Vector2(0, 4)

# Array<TextureButton>
var buttons := []

var buttons_container: Node2D

var station


func _ready() -> void:
    visible = false
    buttons_container = $Buttons
    
    for button in buttons_container.get_children():
        button.connect(
                "mouse_entered", self, "_on_button_mouse_entered", [button])
        button.connect(
                "mouse_exited", self, "_on_button_mouse_exited", [button])
        button.connect("pressed", self, "_on_button_pressed", [button])
        button.scale = _BUTTON_SIZE / button.texture.get_size()
    
    if Engine.editor_hint:
        set_buttons([
            OverlayButtonType.DESTROY,
            OverlayButtonType.BATTERY_STATION,
            OverlayButtonType.SCANNER_STATION,
            OverlayButtonType.SOLAR_COLLECTOR,
            OverlayButtonType.RUN_WIRE,
            OverlayButtonType.BUILD_CONSTRUCTOR_BOT,
        ],
        [])


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
        # FIXME: ------------ Disabled
        button.visible = is_button_visible
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
    
#    _set_shape_rectangle_extents(container_size / 2.0)
#    _set_shape_offset(Vector2(0.0, container_size.y / 2.0))


func set_viewport_opacity_weight(weight: float) -> void:
    self.modulate.a = lerp(
            _MIN_OPACITY_FOR_VIEWPORT_POSITION,
            _MAX_OPACITY_FOR_VIEWPORT_POSITION,
            weight)


func _on_button_mouse_entered(button: SpriteModulationButton) -> void:
#    button.modulate.s = 1.0 + _SATURATION_DELTA_HOVER
#    button.modulate.v = 1.0 + _VALUE_DELTA_HOVER
    button.alpha_multiplier = _OPACITY_HOVER


func _on_button_mouse_exited(button: SpriteModulationButton) -> void:
#    button.modulate.s = 1.0 + _SATURATION_DELTA_NORMAL
#    button.modulate.v = 1.0 + _VALUE_DELTA_NORMAL
    button.alpha_multiplier = _OPACITY_NORMAL


func _on_button_pressed(button: SpriteModulationButton) -> void:
    Sc.utils.give_button_press_feedback()
    var button_type := _get_type_for_button(button)
    Sc.logger.print("OverlayButton pressed: button=%s, station=%s, p=%s" % [
        OverlayButtonType.get_string(button_type),
        station.get_name(),
        station.position,
       ])
    emit_signal("button_pressed", button_type)


func _get_type_for_button(button: SpriteModulationButton) -> int:
    if button == buttons_container.get_node("Destroy"):
        return OverlayButtonType.DESTROY
    elif button == buttons_container.get_node("Battery"):
        return OverlayButtonType.BATTERY_STATION
    elif button == buttons_container.get_node("Scanner"):
        return OverlayButtonType.SCANNER_STATION
    elif button == buttons_container.get_node("Solar"):
        return OverlayButtonType.SOLAR_COLLECTOR
    elif button == buttons_container.get_node("RunPowerLine"):
        return OverlayButtonType.RUN_WIRE
    elif button == buttons_container.get_node("ConstructorBot"):
        return OverlayButtonType.BUILD_CONSTRUCTOR_BOT
    else:
        Sc.logger.error("OverlayButtonPanel._get_type_for_button")
        return OverlayButtonType.UNKNOWN
