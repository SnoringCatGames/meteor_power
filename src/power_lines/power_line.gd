class_name PowerLine
extends Node2D


enum {
    UNKNOWN,
    HELD_BY_BOT,
    CONNECTED,
    BROKEN,
}

const ROPE_COLOR := Color("ffcf9a1f")

const ROPE_WIDTH := 2.0

var start_attachment
var end_attachment

var mode := UNKNOWN

var _health := 0
var _health_capacity := 0

var _vertices := []

var viewport_position_outline_alpha_multiplier := 1.0

var collision_area: Area2D
var shape: SegmentShape2D

var _destroyed := false


func _init(
        start_attachment,
        end_attachment,
        mode: int) -> void:
    self.start_attachment = start_attachment
    self.end_attachment = end_attachment
    self.mode = mode
    _health_capacity = _get_health_capacity()
    _health = _health_capacity
    _create_collision_area()


#func _ready() -> void:
#    center_position = Position2D.new()
#    add_child(center_position)
#
#    status_overlay = Sc.utils.add_scene(self, Station._STATUS_OVERLAY_SCENE)
#    status_overlay.entity = self
#    status_overlay.anchor_y = center_position.position
#    status_overlay.set_up()


func _destroy() -> void:
    _destroyed = true
    queue_free()


func _create_collision_area() -> void:
    collision_area = Area2D.new()
    collision_area.set_meta("PowerLine", self)
    collision_area.collision_layer = \
            Sc.utils.get_physics_layer_bitmask_from_name("wires")
    collision_area.collision_mask = 0
    collision_area.monitoring = false
    collision_area.monitorable = true
    var collision_shape := CollisionShape2D.new()
    self.shape = SegmentShape2D.new()
    collision_shape.shape = shape
    collision_area.add_child(collision_shape)
    self.add_child(collision_area)


func _draw_polyline() -> void:
    # FIXME: Base color on health?
    var color := ROPE_COLOR
    var width := ROPE_WIDTH
    
    shape.a = _vertices[0]
    shape.b = _vertices[_vertices.size() - 1]
    
    draw_polyline(_vertices, Color.black, width * 2)
    Sc.draw.draw_dashed_polyline(
            self,
            _vertices,
            color,
            DynamicRope.DEFAULT_DISTANCE_BETWEEN_NODES * 100.0,
            DynamicRope.DEFAULT_DISTANCE_BETWEEN_NODES * 0.5,
            2.0,
            width)


func _on_hit_by_meteor() -> void:
    if _destroyed:
        return
    Sc.level.session.meteors_collided_count += 1
    var damage := Health.METEOR_DAMAGE
    # FIXME: --------------- Consider modifying damage depending on Upgrade.
    modify_health(-damage)


func _on_panned() -> void:
    if _destroyed:
        return
    _update_highlight_for_camera_position()


func _on_zoomed() -> void:
    if _destroyed:
        return
    _update_highlight_for_camera_position()


func _update_highlight_for_camera_position() -> void:
    pass
#    var opacity := Station.get_opacity_for_camera_position(
#        center_position.global_position)
#    viewport_position_outline_alpha_multiplier = opacity
#    status_overlay.modulate.a = viewport_position_outline_alpha_multiplier


func _get_health_capacity() -> int:
    var base_capacity: int = Health.POWER_LINE
    
    # FIXME: -------------------------
    # - Modify health-capacity for Upgrade.
    # - Update health-capacity when linking to mothership.
    
    return base_capacity


func modify_health(diff: int) -> void:
    var previous_health := _health
    _health = clamp(_health + diff, 0, _health_capacity)
    if _health == previous_health:
        return
#    status_overlay.update()
    if _health == 0:
        Sc.level.on_power_line_health_depleted(self)
