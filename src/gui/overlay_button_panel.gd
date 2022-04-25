tool
class_name OverlayButtonPanel
extends ShapedLevelControl


signal button_pressed(button_type)

const _MIN_OPACITY_VIEWPORT_BOUNDS_RATIO := 0.95
const _MAX_OPACITY_VIEWPORT_BOUNDS_RATIO := 0.05

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
    
    Sc.camera.connect("panned", self, "_on_panned")
    Sc.camera.connect("zoomed", self, "_on_zoomed")


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
    
    _set_shape_rectangle_extents(container_size / 2.0)
    _set_shape_offset(Vector2(0.0, container_size.y / 2.0))


func _update_opacity_for_camera_position() -> void:
    var global_position := self.global_position
    
    var camera_bounds: Rect2 = Sc.level.camera.get_visible_region()
    var min_opacity_bounds_size := \
            camera_bounds.size * _MIN_OPACITY_VIEWPORT_BOUNDS_RATIO
    var min_opacity_bounds_position := \
            camera_bounds.position + \
            (camera_bounds.size - min_opacity_bounds_size) / 2.0
    var min_opacity_bounds := \
            Rect2(min_opacity_bounds_position, min_opacity_bounds_size)
    var max_opacity_bounds_size := \
            camera_bounds.size * _MAX_OPACITY_VIEWPORT_BOUNDS_RATIO
    var max_opacity_bounds_position := \
            camera_bounds.position + \
            (camera_bounds.size - max_opacity_bounds_size) / 2.0
    var max_opacity_bounds := \
            Rect2(max_opacity_bounds_position, max_opacity_bounds_size)
    
    var opacity_weight: float
    if max_opacity_bounds.has_point(global_position):
        opacity_weight = _MAX_OPACITY_FOR_VIEWPORT_POSITION
    elif !min_opacity_bounds.has_point(global_position):
        opacity_weight = _MIN_OPACITY_FOR_VIEWPORT_POSITION
    else:
        var x_weight: float
        if global_position.x >= max_opacity_bounds.position.x and \
                global_position.x <= max_opacity_bounds.end.x:
            x_weight = 1.0
        elif global_position.x <= max_opacity_bounds.position.x:
            x_weight = \
                    (global_position.x - \
                        min_opacity_bounds.position.x) / \
                    (max_opacity_bounds.position.x - \
                        min_opacity_bounds.position.x)
        else:
            x_weight = \
                    (min_opacity_bounds.end.x - global_position.x) / \
                    (min_opacity_bounds.end.x - max_opacity_bounds.end.x)
        var y_weight: float
        if global_position.y >= max_opacity_bounds.position.y and \
                global_position.y <= max_opacity_bounds.end.y:
            y_weight = 1.0
        elif global_position.y <= max_opacity_bounds.position.y:
            y_weight = \
                    (global_position.y - \
                        min_opacity_bounds.position.y) / \
                    (max_opacity_bounds.position.y - \
                        min_opacity_bounds.position.y)
        else:
            y_weight = \
                    (min_opacity_bounds.end.y - global_position.y) / \
                    (min_opacity_bounds.end.y - max_opacity_bounds.end.y)
        opacity_weight = min(x_weight, y_weight)
    
    self.modulate.a = lerp(
            _MIN_OPACITY_FOR_VIEWPORT_POSITION,
            _MAX_OPACITY_FOR_VIEWPORT_POSITION,
            opacity_weight)


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


func _on_panned() -> void:
    _update_opacity_for_camera_position()


func _on_zoomed() -> void:
    _update_opacity_for_camera_position()


func _on_mouse_entered() -> void:
    ._on_mouse_entered()
    self.modulate.a = _MAX_OPACITY_FOR_VIEWPORT_POSITION


func _on_mouse_exited() -> void:
    ._on_mouse_exited()
    _update_opacity_for_camera_position()


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
