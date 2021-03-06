tool
class_name BarrierPylon
extends StationarySelectable


# FIXME: LEFT OFF HERE: ----------------------------------
# - Add pylon-move command logic.


const ENTITY_COMMAND_TYPE := CommandType.BARRIER_PYLON

const ENERGY_FIELD_SCENE := preload(
    "res://src/barrier/barrier_energy_field.tscn")

const MAX_CONNECTION_DISTANCE := 768.0

const ENERGY_PER_SECOND_PER_64_PIXELS := 10.0
const ENERGY_DRAIN_PERIOD := 0.4

const MAX_PYLON_COUNT := 2

var energy_field: BarrierEnergyField

var total_connected_time := 0.0

var is_primary := false

var is_moving := false

var distance_squared := INF


func _init().(ENTITY_COMMAND_TYPE) -> void:
    pass


func _destroy() -> void:
    _set_is_connected(false)
    ._destroy()


func _ready() -> void:
    Sc.slow_motion.set_time_scale_for_node($AnimationPlayer)
    $AnimationPlayer.current_animation = "pylon"
    $AnimationPlayer.seek(
        randf() * $AnimationPlayer.current_animation_length, true)


func _physics_process(delta: float) -> void:
    if Engine.editor_hint:
        return
    
    if get_is_active() and is_primary:
        if is_moving:
            var other_pylon := get_other_pylon()
            distance_squared = \
                self.position.distance_squared_to(other_pylon.position)
            
            # Auto-disconnect when pylons move too far apart.
            if distance_squared > \
                    MAX_CONNECTION_DISTANCE * MAX_CONNECTION_DISTANCE:
                _set_is_connected(false)
        
        var cost := \
            ENERGY_PER_SECOND_PER_64_PIXELS * \
            ENERGY_DRAIN_PERIOD * \
            distance_squared / 64.0
        
        # Auto-disconnect when there isn't enough energy.
        if Sc.level.session.current_energy < cost:
            _set_is_connected(false)
        
        var previous_total_connected_time := total_connected_time
        var current_connected_time := \
            Sc.time.get_scaled_time_step() if \
            get_is_active() else \
            0.0
        total_connected_time += current_connected_time
        
        if int(previous_total_connected_time / ENERGY_DRAIN_PERIOD) != \
                int(total_connected_time / ENERGY_DRAIN_PERIOD):
            Sc.level.deduct_energy(cost)


func _update_outline() -> void:
    $TextureOutlineableSprite.is_outlined = \
        active_outline_alpha_multiplier > 0.0
    $TextureOutlineableSprite.outline_color = outline_color
    $TextureOutlineableSprite.outline_color.a *= \
        active_outline_alpha_multiplier


func _get_meteor_hit_cost() -> int:
    return Cost.BARRIER_PYLON_HIT


func set_is_selected(is_selected: bool) -> void:
    if is_selected == get_is_selected():
        # No change.
        return
    .set_is_selected(is_selected)
    Sc.level._on_station_selection_changed(self, is_selected)
    Sc.level._on_barrier_pylon_selection_changed(self, is_selected)


func get_is_selected() -> bool:
    return Sc.level.selected_barrier_pylon == self


func get_radial_position_in_screen_space() -> Vector2:
    return Sc.utils.get_screen_position_of_node_in_level(self)


func _get_radial_menu_item_types() -> Array:
    # TODO: Update the menu item when is-active changes while the menu is open.
    var connection_toggle := \
        CommandType.BARRIER_DISCONNECT if \
        get_is_active() else \
        CommandType.BARRIER_CONNECT
    return [
        connection_toggle,
        CommandType.BARRIER_MOVE,
        CommandType.BARRIER_RECYCLE,
        CommandType.BARRIER_INFO,
    ]


func get_disabled_message(command_type: int) -> String:
    var message: String = Sc.level.command_enablement[command_type]
    if message != "":
        return message
    
    if (command_type == CommandType.BARRIER_MOVE or \
                command_type == CommandType.BARRIER_RECYCLE) and \
            Sc.level.barrier_bots.empty():
        return Description.NEED_A_BARRIER_BOT
    
    match command_type:
        CommandType.BARRIER_MOVE:
            # FIXME: --------------------------------
            return Description.NOT_IMPLEMENTED
        CommandType.BARRIER_CONNECT:
            var other_pylon := get_other_pylon()
            if !is_instance_valid(other_pylon):
                return ""
            distance_squared = self.position.distance_squared_to(other_pylon.position)
            if distance_squared > \
                    MAX_CONNECTION_DISTANCE * MAX_CONNECTION_DISTANCE:
                return Description.PYLONS_ARE_TOO_FAR_TO_CONNECT
        CommandType.BARRIER_DISCONNECT, \
        CommandType.BARRIER_RECYCLE, \
        _:
            pass
    return ""


func _on_button_pressed(button_type: int) -> void:
    ._on_button_pressed(button_type)
    
    match button_type:
        CommandType.BARRIER_INFO:
            set_is_selected(true)
            update_info_panel_visibility(true)
        CommandType.BARRIER_CONNECT:
            var other_pylon := get_other_pylon()
            if !is_instance_valid(other_pylon):
                return
            distance_squared = \
                self.position.distance_squared_to(other_pylon.position)
            if distance_squared > \
                    MAX_CONNECTION_DISTANCE * MAX_CONNECTION_DISTANCE:
                return
            set_is_selected(false)
            update_info_panel_visibility(false)
            _set_is_connected(true, true)
        CommandType.BARRIER_DISCONNECT:
            set_is_selected(false)
            update_info_panel_visibility(false)
            _set_is_connected(false)
        CommandType.BARRIER_MOVE:
            set_is_selected(false)
            update_info_panel_visibility(false)
            var destination := _get_closest_position_on_a_surface()
            Sc.level.add_command(
                CommandType.BARRIER_MOVE,
                null,
                null,
                destination,
                self)
            # FIXME: -------------------------------------------
            pass
        CommandType.BARRIER_RECYCLE:
            set_is_selected(false)
            update_info_panel_visibility(false)
            var destination := _get_closest_position_on_a_surface()
            Sc.level.add_command(
                CommandType.BARRIER_RECYCLE,
                null,
                null,
                destination,
                self)
        
        _:
            Sc.logger.error("BarrierPylon._on_button_pressed")


func _on_health_depleted() -> void:
    Sc.level.on_barrier_pylon_health_depleted(self)


func _set_is_connected(
        value: bool,
        is_primary := false) -> void:
    # FIXME: ------------------- Play a sound effect for power-on and power-off.
    
    var other_pylon := get_other_pylon()
    if value:
        if !is_instance_valid(other_pylon) or \
                get_is_active():
            return
        
        self.is_primary = is_primary
        other_pylon.is_primary = false
        
        total_connected_time = 0.0
        
        distance_squared = \
            self.position.distance_squared_to(other_pylon.position)
        
        var energy_field := \
            Sc.utils.add_scene(Sc.level, ENERGY_FIELD_SCENE)
        energy_field.set_pylons(self, other_pylon)
        _set_energy_field(energy_field)
        other_pylon._set_energy_field(energy_field)
    else:
        if !get_is_active():
            return
        
        self.is_primary = false
        other_pylon.is_primary = false
        
        total_connected_time = 0.0
        
        self.energy_field.queue_free()
        self._set_energy_field(null)
        if is_instance_valid(other_pylon):
            other_pylon._set_energy_field(null)


func _get_health_capacity() -> int:
    var base_capacity: int = \
        Health.get_default_capacity(CommandType.BARRIER_PYLON)
    
    # FIXME: -------------------------
    # - Modify health-capacity for Upgrade.
    # - Update health-capacity when linking to mothership.
    
    return base_capacity


func _get_closest_position_on_a_surface() -> PositionAlongSurface:
    return SurfaceFinder.find_closest_position_on_a_surface(
        position,
        Sc.level.graph_parser.crash_test_dummies["barrier"],
        SurfaceReachability.ANY)


func get_other_pylon() -> BarrierPylon:
    for pylon in Sc.level.barrier_pylons:
        if is_instance_valid(pylon) and \
                pylon != self:
            return pylon
    return null


func get_is_there_another_pylon() -> bool:
    return !is_instance_valid(get_other_pylon())


func get_is_active() -> bool:
    return is_instance_valid(energy_field)


func _set_energy_field(energy_field: BarrierEnergyField) -> void:
    self.energy_field = energy_field
