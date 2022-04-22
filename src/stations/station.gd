tool
class_name Station, \
"res://addons/scaffolder/assets/images/editor_icons/scaffolder_node.png"
extends ShapedLevelControl


const _OVERLAY_BUTTON_PANEL_CLASS := \
        preload("res://src/gui/overlay_button_panel.tscn")

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
    
    if is_instance_valid(Sc.level.bot_selector):
        _on_bot_selection_changed(Sc.level.bot_selector.selected_bot)
    
    _set_up_camera_detector()


func _set_up_camera_detector() -> void:
    var preexisting_camera_detectors := \
            Sc.utils.get_children_by_type(self, CameraDetector)
    if !preexisting_camera_detectors.empty():
        camera_detector = preexisting_camera_detectors[0]
        for i in range(1, preexisting_camera_detectors.size()):
            remove_child(preexisting_camera_detectors[i])
    else:
        camera_detector = CameraDetector.new()
        add_child(camera_detector)
        camera_detector.owner = self
    _update_camera_detector()


func _update_camera_detector() -> void:
    # FIXME: LEFT OFF HERE: -----------------------------------------
    pass
#    camera_detector


func _on_bot_selection_changed(bot) -> void:
    buttons.visible = get_are_buttons_shown_for_bot_selection(bot)
    buttons.set_buttons(get_buttons(bot), get_disabled_buttons(bot))


func _on_level_started() -> void:
    _on_bot_selection_changed(Sc.level.bot_selector.selected_bot)


func _on_button_pressed(button_type: int) -> void:
    Sc.level._on_station_button_pressed(self, button_type)


func get_power_line_attachment_position() -> Vector2:
    return self.position + self.rope_attachment_offset


func get_are_buttons_shown_for_bot_selection(bot) -> bool:
    return false


func get_buttons(bot) -> Array:
    return []


func get_disabled_buttons(bot) -> Array:
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
