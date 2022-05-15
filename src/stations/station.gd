tool
class_name Station, \
"res://addons/scaffolder/assets/images/editor_icons/scaffolder_node.png"
extends ShapedLevelControl


const _OVERLAY_BUTTON_PANEL_CLASS := \
        preload("res://src/gui/overlay_button_panel.tscn")
const _VIEWPORT_CENTER_REGION_DETECTOR_SCENE := preload(
        "res://addons/scaffolder/src/camera/camera_detector/viewport_center_region_detector.tscn")
const _STATUS_OVERLAY_SCENE := preload("res://src/gui/status_overlay.tscn")

const _CAMERA_DETECTOR_VIEWPORT_RATIO := Vector2(0.95, 0.95)

const _MIN_HIGHLIGHT_OPACITY_FOR_VIEWPORT_POSITION := 0.0
const _MAX_HIGHLIGHT_OPACITY_FOR_VIEWPORT_POSITION := 0.95

const _MIN_HIGHLIGHT_VIEWPORT_BOUNDS_RATIO := 0.95
const _MAX_HIGHLIGHT_VIEWPORT_BOUNDS_RATIO := 0.05

const SCREEN_RADIUS_INCHES := 0.15

export var rope_attachment_offset := Vector2.ZERO

var buttons: OverlayButtonPanel

var status_overlay: StatusOverlay

var camera_detector: CameraDetector

var active_outline_alpha_multiplier := 0.0
var viewport_position_outline_alpha_multiplier := 0.0
var outline_color := ColorConfig.TRANSPARENT

# Dictionary<Station, bool>
var connections := {}

var is_connected_to_command_center := false

var is_connectable := true

var shield_activated := false

var entity_command_type := Commands.UNKNOWN

var start_time := INF
var previous_total_time := INF
var total_time := INF

var _health := 0
var _health_capacity := 0


func _init(
        entity_command_type: int,
        is_connectable: bool) -> void:
    self.entity_command_type = entity_command_type
    self.is_connectable = is_connectable
    _health_capacity = _get_health_capacity()
    _health = _health_capacity


func _ready() -> void:
    self.monitorable = true
    
    start_time = Sc.time.get_scaled_play_time()
    total_time = 0.0
    
    buttons = Sc.utils.add_scene(self, _OVERLAY_BUTTON_PANEL_CLASS)
    buttons.connect("button_pressed", self, "_on_button_pressed")
    buttons.connect(
            "interaction_mode_changed",
            self,
            "_on_button_interaction_mode_changed")
    buttons.station = self
    
    _set_up_camera_detector()
    _set_up_desaturatable()
    
    Sc.info_panel.connect("closed", self, "_on_info_panel_closed")
    
    screen_radius = Sc.device.inches_to_pixels(SCREEN_RADIUS_INCHES)
    property_list_changed_notify()
    
    var half_width_height: Vector2 = \
        Sc.geometry.calculate_half_width_height(_shape.shape, false)
    
    status_overlay = Sc.utils.add_scene(self, _STATUS_OVERLAY_SCENE)
    status_overlay.entity = self
    status_overlay.anchor_y = -half_width_height.y * 2
    status_overlay.set_up()


func _destroy() -> void:
    buttons._destroy()
    update_info_panel_visibility(false)
    close_radial_menu()
    ._destroy()


func _physics_process(delta: float) -> void:
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


func _set_up_desaturatable() -> void:
    var sprites: Array = \
        Sc.utils.get_children_by_type(self, OutlineableSprite, true)
    var animated_sprites: Array = \
        Sc.utils.get_children_by_type(self, OutlineableAnimatedSprite, true)
    for collection in [sprites, animated_sprites]:
        for node in collection:
            node.is_desaturatable = true


func _on_level_started() -> void:
    pass


func _on_button_pressed(button_type: int) -> void:
    match button_type:
        Commands.STATION_LINK_TO_MOTHERSHIP:
            # FIXME: LEFT OFF HERE: ----------------------------------------
            # - Show a fancy energy-field shimmer effect over all bots and
            #   stations to indicate the boost.
            # - Play a success sound.
            # - Animate a fancy beaming-up effect from the command center.
            # - Show a persistent beaming-up ray from the command center?
            Sc.level.did_level_succeed = true
            Sc.level.deduct_energy(Costs.STATION_LINK_TO_MOTHERSHIP)
            set_is_selected(false)
            update_info_panel_visibility(false)
        
        Commands.STATION_STOP:
            set_is_selected(false)
            update_info_panel_visibility(false)
            Sc.level.clear_station_power_line_selection()
        
        Commands.STATION_RECYCLE:
            # FIXME: LEFT OFF HERE: ----------------------------------------
            pass
            set_is_selected(false)
            update_info_panel_visibility(false)
            var bot = Sc.level.get_bot_for_station_command(self, button_type)
            bot.move_to_destroy_station(self)
        
        Commands.STATION_INFO:
            set_is_selected(true)
            update_info_panel_visibility(true)
        
        Commands.RUN_WIRE:
            # FIXME: LEFT OFF HERE: ----------------------------------------
            pass
            set_is_selected(true)
            update_info_panel_visibility(false)
            Sc.level.set_selected_station_for_running_power_line(self)
        
        Commands.STATION_COMMAND, \
        Commands.STATION_SOLAR, \
        Commands.STATION_SCANNER, \
        Commands.STATION_BATTERY:
            set_is_selected(false)
            update_info_panel_visibility(false)
            var bot = Sc.level.get_bot_for_station_command(self, button_type)
            _build_station(button_type, bot)
        
        Commands.BOT_CONSTRUCTOR, \
        Commands.BOT_LINE_RUNNER, \
        Commands.BOT_BARRIER:
            # FIXME: LEFT OFF HERE: ----------------------------------------
            pass
            var bot = Sc.level.get_bot_for_station_command(self, button_type)
            bot.move_to_build_bot(self, button_type)
        
        _:
            Sc.logger.error("Station._on_button_pressed")
    
    if button_type != Commands.RUN_WIRE:
        Sc.level.clear_station_power_line_selection()


func _on_radial_menu_item_selected(item: RadialMenuItem) -> void:
    _on_button_pressed(item.id)


func _on_radial_menu_touch_up_center() -> void:
    set_is_selected(false)


func _on_radial_menu_touch_up_outside() -> void:
    set_is_selected(false)


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
    if is_instance_valid(Sc.gui.hud._radial_menu) and \
            Sc.gui.hud._radial_menu.metadata == self:
        close_radial_menu()


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
            var contents: InfoPanelContents = \
                Game.INFO_PANEL_CONTENTS_SCENE.instance()
            contents.set_up(self)
            Sc.info_panel.show_panel(contents.get_data())
    else:
        if get_is_own_info_panel_shown():
            Sc.info_panel.close_panel()


func _build_station(
        button_type: int,
        bot) -> void:
    Sc.logger.error("Abstract Station._build_station is not implemented")


func _on_info_panel_closed(data: InfoPanelData) -> void:
    set_is_selected(false)


func _on_camera_enter() -> void:
    buttons.visible = true
    # FIXME: --------------------------
    # - Update button visibility and enablement in a different, more direct and
    #   on-demand, way.
    buttons.set_buttons(get_buttons())


func _on_camera_exit() -> void:
    buttons.visible = false


func _on_panned() -> void:
    _update_highlight_for_camera_position()


func _on_zoomed() -> void:
    _update_highlight_for_camera_position()


func _on_interaction_mode_changed(interaction_mode: int) -> void:
    ._on_interaction_mode_changed(interaction_mode)
    _update_highlight()


func _on_button_interaction_mode_changed() -> void:
    _update_highlight()


func _on_touch_down(
        level_position: Vector2,
        is_already_handled: bool) -> void:
    set_is_selected(true)
    
    if is_instance_valid(Sc.level.selected_bot):
        Sc.level.selected_bot.set_is_player_control_active(false)
        
        if Sc.level.get_is_first_station_selected_for_running_power_line():
            _on_button_pressed(Commands.RUN_WIRE)
            return
    
    open_radial_menu()


func _on_touch_up(
        level_position: Vector2,
        is_already_handled: bool) -> void:
    ._on_touch_up(level_position, is_already_handled)
    Sc.level.touch_listener.set_current_touch_as_not_handled()


func set_is_selected(is_selected: bool) -> void:
    if is_selected == get_is_selected():
        # No change.
        return
    Sc.level._on_station_selection_changed(self, is_selected)
    _update_highlight()


func get_is_selected() -> bool:
    return Sc.level.selected_station == self


func get_radial_position_in_screen_space() -> Vector2:
    return Sc.utils.get_screen_position_of_node_in_level($Center)


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
            interaction_mode == InteractionMode.PRESSED or \
            buttons.get_is_hovered_or_pressed():
        outline_color = Sc.palette.get_color("station_hovered")
    elif get_is_selected():
        outline_color = Sc.palette.get_color("station_selected")
    elif !is_connected_to_command_center and \
            is_connectable:
        outline_color = Sc.palette.get_color("station_disconnected")
    else:
        outline_color = _get_normal_highlight_color()
        active_outline_alpha_multiplier = \
                viewport_position_outline_alpha_multiplier
    _update_outline()
    buttons.set_viewport_opacity_weight(active_outline_alpha_multiplier)


func _get_normal_highlight_color() -> Color:
    return Sc.palette.get_color("station_normal")


func _update_outline() -> void:
    Sc.logger.error("Abstract Station._update_outline is not implemented")


func get_power_line_attachment_position() -> Vector2:
    return self.position + self.rope_attachment_offset


func get_buttons() -> Array:
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
        if other_station.entity_command_type == Commands.STATION_COMMAND:
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
    Sc.level.session.meteors_collided_count += 1
    if !shield_activated:
        Sc.level.deduct_energy(Costs.STATION_HIT)
        var damage := Healths.METEOR_DAMAGE
        # FIXME: --------------- Consider modifying damage depending on Upgrades.
        modify_health(-damage)


func _get_common_radial_menu_item_types() -> Array:
    return [
        Commands.RUN_WIRE,
        Commands.STATION_RECYCLE,
        Commands.STATION_INFO,
    ]


func _get_radial_menu_items() -> Array:
    var types := _get_radial_menu_item_types()
    var result := []
    for type in types:
        var command_item := GameRadialMenuItem.new()
        command_item.cost = Commands.COSTS[type]
        command_item.id = type
        command_item.description = Commands.COMMAND_LABELS[type]
        command_item.texture = Commands.TEXTURES[type]
        command_item.disabled_message = Sc.level.command_enablement[type]
        result.push_back(command_item)
    return result


func _get_radial_menu_item_types() -> Array:
    Sc.logger.error(
            "Abstract Station._get_radial_menu_item_types is not implemented")
    return []


func _on_command_enablement_changed() -> void:
    buttons._on_command_enablement_changed()
    update_info_panel_contents()


func get_health() -> int:
    return _health


func get_health_capacity() -> int:
    return _health_capacity


func _get_health_capacity() -> int:
    var base_capacity: int = Healths.get_default_capacity(entity_command_type)
    
    # FIXME: -------------------------
    # - Modify health-capacity for Upgrades.
    # - Update health-capacity when linking to mothership.
    
    return base_capacity


func modify_health(diff: int) -> void:
    var previous_health := _health
    _health = clamp(_health + diff, 0, _health_capacity)
    if _health == previous_health:
        return
    update_info_panel_contents()
    status_overlay.update()
    if _health == 0:
        Sc.level.on_station_health_depleted(self)
