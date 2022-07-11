class_name StaticPowerLine
extends PowerLine


func _init(
        rope: DynamicRope,
        start_attachment,
        end_attachment,
        mode: int).(
        start_attachment,
        end_attachment,
        mode) -> void:
    _parse_points(rope)
    _update_collision_segments()


func _parse_points(rope: DynamicRope) -> void:
    _vertices.resize(rope.nodes.size())
    for i in rope.nodes.size():
        _vertices[i] = rope.nodes[i].position


func _draw() -> void:
    _draw_polyline()


func _on_hit_by_meteor() -> void:
    if _destroyed:
        return
    Sc.logger.print("StaticPowerLine._on_hit_by_meteor")
    Sc.level.deduct_energy(Cost.STATIC_POWER_LINE_HIT)
    ._on_hit_by_meteor()
