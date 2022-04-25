tool
class_name Station, \
"res://addons/scaffolder/assets/images/editor_icons/scaffolder_node.png"
extends ShapedLevelControl


const _OVERLAY_BUTTON_PANEL_CLASS := \
        preload("res://src/gui/overlay_button_panel.tscn")
const _VIEWPORT_CENTER_REGION_DETECTOR_SCENE := preload(
        "res://addons/scaffolder/src/camera/camera_detector/viewport_center_region_detector.tscn")

const _CAMERA_DETECTOR_VIEWPORT_RATIO := Vector2(0.95, 0.95)

export var rope_attachment_offset := Vector2.ZERO

var buttons: OverlayButtonPanel

var camera_detector: CameraDetector

var health := 1.0

# Dictionary<Station, bool>
var connections := {}

var is_connected_to_command_center := false

var meteor_hit_count := 0


func _ready() -> void:
    buttons = Sc.utils.add_scene(self, _OVERLAY_BUTTON_PANEL_CLASS)
    buttons.connect("button_pressed", self, "_on_button_pressed")
    buttons.station = self
    
    _set_up_camera_detector()


func _set_up_camera_detector() -> void:
    var preexisting_camera_detectors := \
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


func _on_level_started() -> void:
    pass


func _on_button_pressed(button_type: int) -> void:
    Sc.level._on_station_button_pressed(self, button_type)


func _on_camera_enter() -> void:
    buttons.visible = true
    # FIXME: -------------------------
    # - Update button visibility and enablement in a different, more direct and
    #   on-demand, way.
    buttons.set_buttons(get_buttons(), get_disabled_buttons())


func _on_camera_exit() -> void:
    buttons.visible = false


func get_power_line_attachment_position() -> Vector2:
    return self.position + self.rope_attachment_offset


func get_buttons() -> Array:
    return []


func get_disabled_buttons() -> Array:
    return []


func get_position_along_surface(
        character: SurfacerCharacter) -> PositionAlongSurface:
    var surface := SurfaceFinder.find_closest_surface_in_direction(
            character.surface_store,
            self.position,
            Vector2.DOWN)
    return PositionAlongSurfaceFactory.create_position_offset_from_target_point(
            self.position,
            surface,
            character.collider,
            true,
            true)


func add_connection(other_station: Station) -> void:
    if connections.has(other_station):
#        Sc.logger.warning("Station.add_connection")
        return
    connections[other_station] = true
    _check_is_connected_to_command_center()


func remove_connection(other_station: Station) -> void:
    if !connections.has(other_station):
#        Sc.logger.warning("Station.remove_connection")
        return
    connections.erase(other_station)
    _check_is_connected_to_command_center()


func _check_is_connected_to_command_center() -> void:
    var was_connected_to_command_center := is_connected_to_command_center
    self.is_connected_to_command_center = \
            _check_is_connected_to_command_center_recursive(self, {})
    if was_connected_to_command_center != is_connected_to_command_center:
        if is_connected_to_command_center:
            _on_connected_to_command_center()
        else:
            _on_disconnected_from_command_center()
        _update_all_connections_connected_to_command_center_recursive(
                is_connected_to_command_center, self, {})


func _check_is_connected_to_command_center_recursive(
        station: Station,
        visited_stations: Dictionary) -> bool:
    visited_stations[station] = true
    for other_station in station.connections:
        if other_station.get_name() == "command":
            return true
        if visited_stations.has(other_station):
            continue
        if _check_is_connected_to_command_center_recursive(
                other_station, visited_stations):
            return true
    return false


func _update_all_connections_connected_to_command_center_recursive(
        is_connected_to_command_center: bool,
        station: Station,
        visited_stations: Dictionary) -> void:
    station.is_connected_to_command_center = is_connected_to_command_center
    visited_stations[station] = true
    for other_station in station.connections:
        if visited_stations.has(other_station):
            continue
        _update_all_connections_connected_to_command_center_recursive(
                is_connected_to_command_center, other_station, visited_stations)


func _on_connected_to_command_center() -> void:
    pass


func _on_disconnected_from_command_center() -> void:
    pass


func _on_hit_by_meteor() -> void:
    meteor_hit_count += 1
