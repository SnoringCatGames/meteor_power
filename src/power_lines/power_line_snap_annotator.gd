class_name PowerLineSnapAnnotator
extends TransientAnnotator


const DURATION := 2.0
const OPACITY_DELAY := 1.0

var start_rope: DynamicRope
var end_rope: DynamicRope

var start_vertices: Array
var end_vertices: Array

var opacity: float


func _init(power_line: PowerLine).(DURATION) -> void:
    var cut_start_index := \
        power_line.cut_start_index if \
        power_line.cut_start_index >= 0 else \
        power_line._vertices.size() - 2
    var snap_position: Vector2 = lerp(
        power_line._vertices[cut_start_index],
        power_line._vertices[cut_start_index + 1],
        0.5)
    
    if cut_start_index > 0:
        start_vertices = power_line._vertices.slice(0, cut_start_index)
    else:
        start_vertices = []
    
    if cut_start_index < power_line._vertices.size() - 2:
        end_vertices = power_line._vertices.slice(
            cut_start_index + 1,
            power_line._vertices.size() - 1)
    else:
        end_vertices = []
    
    if !start_vertices.empty():
        start_rope = DynamicRope.new(snap_position.distance_to(
            power_line._vertices.front()))
        start_rope.update_end_positions(
            power_line._vertices.front(), snap_position)
        start_rope.override_nodes(start_vertices)
        start_rope.nodes.back().previous_position = snap_position
        start_rope.nodes.back().is_fixed = false
    
    if !end_vertices.empty():
        end_rope = DynamicRope.new(snap_position.distance_to(
            power_line._vertices.back()))
        end_rope.update_end_positions(
            snap_position, power_line._vertices.back())
        end_rope.override_nodes(end_vertices)
        end_rope.nodes.front().previous_position = snap_position
        end_rope.nodes.front().is_fixed = false
        end_rope.nodes.back().is_fixed = \
            power_line.mode != PowerLine.HELD_BY_BOT
    
    _update()


func _update() -> void:
    ._update()
    
    var opacity_progress := \
            (current_time - start_time - OPACITY_DELAY) / \
            (duration - OPACITY_DELAY)
    opacity_progress = clamp(
            opacity_progress,
            0.0,
            1.0)
    opacity_progress = Sc.utils.ease_by_name(
            opacity_progress, "ease_in_strong")
    opacity = lerp(
            1.0,
            0.0,
            opacity_progress)
    
    if is_instance_valid(start_rope):
        start_rope.on_physics_frame()
    
    if is_instance_valid(end_rope):
        end_rope.on_physics_frame()


func _update_vertices(
        vertices: Array,
        rope: DynamicRope) -> void:
    vertices.resize(rope.nodes.size())
    for i in rope.nodes.size():
        vertices[i] = rope.nodes[i].position


func _draw() -> void:
    self.modulate.a = opacity
    
    var color := PowerLine.ROPE_COLOR
    var width := PowerLine.ROPE_WIDTH
    
    if is_instance_valid(start_rope):
        _update_vertices(start_vertices, start_rope)
        draw_polyline(start_vertices, Color.black, width * 2)
        Sc.draw.draw_dashed_polyline(
            self,
            start_vertices,
            color,
            DynamicRope.DEFAULT_DISTANCE_BETWEEN_NODES * 100.0,
            DynamicRope.DEFAULT_DISTANCE_BETWEEN_NODES * 0.5,
            2.0,
            width)
    
    if is_instance_valid(end_rope):
        _update_vertices(end_vertices, end_rope)
        draw_polyline(end_vertices, Color.black, width * 2)
        Sc.draw.draw_dashed_polyline(
            self,
            end_vertices,
            color,
            DynamicRope.DEFAULT_DISTANCE_BETWEEN_NODES * 100.0,
            DynamicRope.DEFAULT_DISTANCE_BETWEEN_NODES * 0.5,
            2.0,
            width)
