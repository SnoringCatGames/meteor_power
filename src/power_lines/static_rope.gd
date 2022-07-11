class_name StaticRope
extends Reference


const DEFAULT_NUMBER_OF_NEIGHBOR_CONSTRAINT_UPDATE_ITERATIONS := 30

const DEFAULT_NUMBER_OF_NEIGHBOR_CONSTRAINT_UPDATE_ITERATIONS_PER_FRAME := 5

# Array<Vector2>
var vertices: Array


func _init(
        start_position: Vector2,
        end_position: Vector2,
        number_of_physics_frames_between_node_physics_frames := \
            DynamicRope \
            .DEFAULT_NUMBER_OF_PHYSICS_FRAMES_BETWEEN_NODE_PHYSICS_FRAMES,
        number_of_neighbor_constraint_update_iterations_per_frame := \
            DEFAULT_NUMBER_OF_NEIGHBOR_CONSTRAINT_UPDATE_ITERATIONS_PER_FRAME,
        number_of_neighbor_constraint_update_iterations := \
            DEFAULT_NUMBER_OF_NEIGHBOR_CONSTRAINT_UPDATE_ITERATIONS,
        rope_length_to_distance_ratio := \
            DynamicRope.DEFAULT_ROPE_LENGTH_TO_DISTANCE_RATIO,
        node_mass := DynamicRope.DEFAULT_NODE_MASS,
        node_damping := DynamicRope.DEFAULT_NODE_DAMPING,
        distance_between_nodes := \
            DynamicRope.DEFAULT_DISTANCE_BETWEEN_NODES) -> void:
    var distance := start_position.distance_to(end_position)
    
    # Run a rope simulation to calculate the vertices.
    var dynamic_rope := DynamicRope.new(
        distance,
        number_of_physics_frames_between_node_physics_frames,
        number_of_neighbor_constraint_update_iterations_per_frame,
        rope_length_to_distance_ratio,
        node_mass,
        node_damping,
        distance_between_nodes)
    dynamic_rope.update_end_positions(start_position, end_position)
    for i in number_of_neighbor_constraint_update_iterations:
        dynamic_rope._update_nodes()
    
    # Record the vertices.
    vertices.resize(dynamic_rope.nodes.size())
    for i in vertices.size():
        vertices[i] = dynamic_rope.nodes[i].position


func get_stretched_length() -> float:
    var length := 0.0
    for i in range(1, vertices.size()):
        length += vertices[i - 1].distance_to(vertices[i])
    return length
