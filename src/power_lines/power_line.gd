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

var collision_area: Area2D
var shape: SegmentShape2D


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
            Rope.DISTANCE_BETWEEN_NODES * 100.0,
            Rope.DISTANCE_BETWEEN_NODES * 0.5,
            2.0,
            width)


func _on_hit_by_meteor() -> void:
    Sc.level.session.meteors_collided_count += 1
    var damage := Healths.METEOR_DAMAGE
    # FIXME: --------------- Consider modifying damage depending on Upgrades.
    modify_health(-damage)


func on_attachment_removed() -> void:
    if start_attachment.has_method("remove_connection") and \
            end_attachment.has_method("remove_connection"):
        # Is connecting two stations.
        start_attachment.remove_connection(end_attachment)
        end_attachment.remove_connection(start_attachment)
    if end_attachment.has_method("stop"):
        # Is held by Bot.
        end_attachment.stop()


func _get_health_capacity() -> int:
    var base_capacity: int = Healths.POWER_LINE
    
    # FIXME: -------------------------
    # - Modify health-capacity for Upgrades.
    # - Update health-capacity when linking to mothership.
    
    return base_capacity


func modify_health(diff: int) -> void:
    var previous_health := _health
    _health = clamp(_health + diff, 0, _health_capacity)
    if _health == 0:
        Sc.level.on_power_line_health_depleted(self)
