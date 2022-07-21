tool
class_name StationarySelectable, \
"res://addons/scaffolder/assets/images/editor_icons/scaffolder_node.png"
extends ShapedLevelControl


const _STATUS_OVERLAY_SCENE := preload("res://src/gui/status_overlay.tscn")
const _VIEWPORT_CENTER_REGION_DETECTOR_SCENE := preload(
    "res://addons/scaffolder/src/camera/camera_detector/viewport_center_region_detector.tscn")
    
const _CAMERA_DETECTOR_VIEWPORT_RATIO := Vector2(0.95, 0.95)

const _MIN_HIGHLIGHT_OPACITY_FOR_VIEWPORT_POSITION := 0.0
const _MAX_HIGHLIGHT_OPACITY_FOR_VIEWPORT_POSITION := 0.95

const _MIN_HIGHLIGHT_VIEWPORT_BOUNDS_RATIO := 0.95
const _MAX_HIGHLIGHT_VIEWPORT_BOUNDS_RATIO := 0.05

const SCREEN_RADIUS_INCHES := 0.15

var entity_command_type := CommandType.UNKNOWN

var camera_detector: CameraDetector

var status_overlay: StatusOverlay

var active_outline_alpha_multiplier := 0.0
var viewport_position_outline_alpha_multiplier := 0.0
var outline_color := ColorConfig.TRANSPARENT

var start_time := INF
var total_time := INF
var previous_total_time := INF

var _health := 0
var _health_capacity := 0


func _init(entity_command_type: int) -> void:
    self.entity_command_type = entity_command_type


func _ready() -> void:
    if Engine.editor_hint:
        return
    _set_up()


func _set_up() -> void:
    _health_capacity = _get_health_capacity()
    _health = _health_capacity
    
    self.monitorable = true
    
    start_time = Sc.time.get_scaled_play_time()
    total_time = 0.0
    
    var half_width_height: Vector2 = \
        Sc.geometry.calculate_half_width_height(_shape.shape, false)
    
    status_overlay = Sc.utils.add_scene(self, _STATUS_OVERLAY_SCENE)
    status_overlay.entity = self
    status_overlay.anchor_y = -half_width_height.y * 2
    status_overlay.set_up()
    
    _set_up_camera_detector()
    
    screen_radius = Sc.device.inches_to_pixels(SCREEN_RADIUS_INCHES)
    property_list_changed_notify()
    
    Sc.info_panel.connect("closed", self, "_on_info_panel_closed")


func _destroy() -> void:
    update_info_panel_visibility(false)
    close_radial_menu()
    ._destroy()


func _physics_process(delta: float) -> void:
    if Engine.editor_hint:
        return
    
    previous_total_time = total_time
    total_time = Sc.time.get_scaled_play_time() - start_time


func _set_up_camera_detector() -> void:
    if Engine.editor_hint:
        return
    
    var preexisting_camera_detectors: Array = \
        Sc.utils.get_children_by_type(self, ViewportCenterRegionDetector)
    for detector in preexisting_camera_detectors:
        remove_child(detector)
    
    camera_detector = Sc.utils.add_scene(
        self, _VIEWPORT_CENTER_REGION_DETECTOR_SCENE)
    camera_detector.connect("camera_enter", self, "_on_camera_enter")
    camera_detector.connect("camera_exit", self, "_on_camera_exit")
    _update_camera_detector()
    if camera_detector.is_camera_intersecting:
        _on_camera_enter()


func _update_camera_detector() -> void:
    camera_detector.shape_rectangle_extents = self.shape_rectangle_extents
    camera_detector.shape_offset = self.shape_offset
    camera_detector.viewport_ratio = _CAMERA_DETECTOR_VIEWPORT_RATIO


func open_radial_menu() -> void:
    var radial_menu: GameRadialMenu = Sc.gui.hud.open_radial_menu(
        Sc.gui.hud.radial_menu_class,
        _get_radial_menu_items(),
        get_radial_position_in_screen_space(),
        self)
    radial_menu.connect(
        "touch_up_item", self, "_on_radial_menu_item_selected")
    radial_menu.connect(
        "touch_up_center", self, "_on_radial_menu_touch_up_center")
    radial_menu.connect(
        "touch_up_outside", self, "_on_radial_menu_touch_up_outside")


func close_radial_menu() -> void:
    if Sc.gui.hud.get_is_radial_menu_open() and \
            Sc.gui.hud._radial_menu.metadata == self:
        Sc.gui.hud.close_radial_menu()


func get_is_own_info_panel_shown() -> bool:
    var data: InfoPanelData = Sc.info_panel.get_current_data()
    return is_instance_valid(data) and data.meta == self


func update_info_panel_contents() -> void:
    if !get_is_own_info_panel_shown():
        return
    var data: InfoPanelData = Sc.info_panel.get_current_data()
    data.contents.update()


func update_info_panel_visibility(is_visible: bool) -> void:
    if is_visible:
        if !get_is_own_info_panel_shown():
            var contents = Game.INFO_PANEL_CONTENTS_SCENE.instance()
            contents.set_up(self)
            Sc.info_panel.show_panel(contents.get_data())
    else:
        if get_is_own_info_panel_shown():
            Sc.info_panel.close_panel()


func set_is_selected(is_selected: bool) -> void:
    _update_highlight()


func get_radial_position_in_screen_space() -> Vector2:
    return Vector2.ZERO


static func get_opacity_for_camera_position(
        global_position: Vector2) -> float:
    var camera_bounds: Rect2 = Sc.level.camera.get_visible_region()
    var min_opacity_bounds_size := \
        camera_bounds.size * _MIN_HIGHLIGHT_VIEWPORT_BOUNDS_RATIO
    var min_opacity_bounds_position := \
        camera_bounds.position + \
        (camera_bounds.size - min_opacity_bounds_size) / 2.0
    var min_opacity_bounds := \
        Rect2(min_opacity_bounds_position, min_opacity_bounds_size)
    var max_opacity_bounds_size := \
        camera_bounds.size * _MAX_HIGHLIGHT_VIEWPORT_BOUNDS_RATIO
    var max_opacity_bounds_position := \
        camera_bounds.position + \
        (camera_bounds.size - max_opacity_bounds_size) / 2.0
    var max_opacity_bounds := \
        Rect2(max_opacity_bounds_position, max_opacity_bounds_size)
    
    var opacity_weight: float
    if max_opacity_bounds.has_point(global_position):
        opacity_weight = _MAX_HIGHLIGHT_OPACITY_FOR_VIEWPORT_POSITION
    elif !min_opacity_bounds.has_point(global_position):
        opacity_weight = _MIN_HIGHLIGHT_OPACITY_FOR_VIEWPORT_POSITION
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
    
    return opacity_weight * opacity_weight


func _update_highlight_for_camera_position() -> void:
    var opacity := get_opacity_for_camera_position(self.global_position)
    set_highlight_weight(opacity)


func set_highlight_weight(weight: float) -> void:
    viewport_position_outline_alpha_multiplier = weight
    status_overlay.modulate.a = viewport_position_outline_alpha_multiplier
    _update_highlight()


func _update_highlight() -> void:
    active_outline_alpha_multiplier = \
        _MAX_HIGHLIGHT_OPACITY_FOR_VIEWPORT_POSITION * \
        _MAX_HIGHLIGHT_OPACITY_FOR_VIEWPORT_POSITION
    if interaction_mode == InteractionMode.HOVER or \
            interaction_mode == InteractionMode.PRESSED:
        outline_color = Sc.palette.get_color("station_hovered")
    elif get_is_selected():
        outline_color = Sc.palette.get_color("station_selected")
    else:
        outline_color = _get_normal_highlight_color()
        active_outline_alpha_multiplier = \
            viewport_position_outline_alpha_multiplier
    _update_outline()


func _get_normal_highlight_color() -> Color:
    return Sc.palette.get_color("station_normal")


func _update_outline() -> void:
    Sc.logger.error(
        "Abstract StationarySelectable._update_outline is not implemented.")


func get_is_selected() -> bool:
    Sc.logger.error(
        "Abstract StationarySelectable.get_is_selected is not implemented.")
    return false


func _get_radial_menu_items() -> Array:
    var types := _get_radial_menu_item_types()
    var result := []
    for type in types:
        var command_item := GameRadialMenuItem.new()
        command_item.cost = CommandType.COSTS[type]
        command_item.id = type
        command_item.description = CommandType.COMMAND_LABELS[type]
        command_item.texture = CommandType.TEXTURES[type]
        command_item.disabled_message = get_disabled_message(type)
        result.push_back(command_item)
    return result


func _get_radial_menu_item_types() -> Array:
    Sc.logger.error(
        "Abstract StationarySelectable._get_radial_menu_item_types " +
        "is not implemented.")
    return []


func get_disabled_message(command_type: int) -> String:
    return ""


func get_health() -> int:
    return _health


func get_health_capacity() -> int:
    return _health_capacity


func _get_health_capacity() -> int:
    Sc.logger.error(
        "Abstract StationarySelectable._get_health_capacity is not implemented.")
    return -1


func modify_health(diff: int) -> void:
    var previous_health := _health
    _health = clamp(_health + diff, 0, _health_capacity)
    if _health == previous_health:
        return
    update_info_panel_contents()
    status_overlay.update()
    if _health == _health_capacity or \
            previous_health == _health_capacity:
        _on_command_enablement_changed()
    if _health == 0:
        _on_health_depleted()


func _on_health_depleted() -> void:
    Sc.logger.error(
        "Abstract StationarySelectable._on_health_depleted is not implemented.")


func _get_meteor_hit_cost() -> int:
    Sc.logger.error(
        "Abstract StationarySelectable._get_meteor_hit_cost is not implemented")
    return -1


func _on_level_started() -> void:
    _update_highlight_for_camera_position()


func _on_touch_down(
        level_position: Vector2,
        is_already_handled: bool) -> void:
    set_is_selected(true)
    
    if is_instance_valid(Sc.level.selected_bot):
        Sc.level.selected_bot.set_is_player_control_active(false)
    
    open_radial_menu()


func _on_touch_up(
        level_position: Vector2,
        is_already_handled: bool) -> void:
    ._on_touch_up(level_position, is_already_handled)
    Sc.level.touch_listener.set_current_touch_as_not_handled()


func _on_button_pressed(button_type: int) -> void:
    pass


func _on_radial_menu_item_selected(item: RadialMenuItem) -> void:
    _on_button_pressed(item.id)


func _on_radial_menu_touch_up_center() -> void:
    set_is_selected(false)


func _on_radial_menu_touch_up_outside() -> void:
    set_is_selected(false)


func _on_camera_enter() -> void:
    pass


func _on_camera_exit() -> void:
    pass


func _on_info_panel_closed(data: InfoPanelData) -> void:
    set_is_selected(false)


func _on_panned() -> void:
    _update_highlight_for_camera_position()


func _on_zoomed() -> void:
    _update_highlight_for_camera_position()


func _on_interaction_mode_changed(interaction_mode: int) -> void:
    ._on_interaction_mode_changed(interaction_mode)
    _update_highlight()


func _on_hit_by_meteor(meteor) -> void:
    Sc.level.session.meteors_collided_count += 1
    Sc.level.deduct_energy(_get_meteor_hit_cost())
    var damage := Health.METEOR_DAMAGE
    # FIXME: --------------- Consider modifying damage depending on Upgrade.
    modify_health(-damage)


func _on_command_enablement_changed() -> void:
    update_info_panel_contents()
    if Sc.gui.hud.get_is_radial_menu_open() and \
            Sc.gui.hud._radial_menu.metadata == self:
        for item in Sc.gui.hud._radial_menu._items:
            item.disabled_message = get_disabled_message(item.id)
