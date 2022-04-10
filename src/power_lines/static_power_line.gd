class_name StaticPowerLine
extends PowerLine


func _init(
        rope: Rope,
        start_attachment,
        end_attachment,
        mode: int).(
        start_attachment,
        end_attachment,
        mode) -> void:
    _parse_points(rope)


func _parse_points(rope: Rope) -> void:
    _vertices.resize(rope.nodes.size())
    for i in rope.nodes.size():
        _vertices[i] = rope.nodes[i].position


func _draw() -> void:
    _draw_polyline()


func _on_hit_by_meteor() -> void:
    Sc.logger.print("StaticPowerLine._on_hit_by_meteor")
    start_attachment.remove_connection(end_attachment)
    end_attachment.remove_connection(start_attachment)
    Sc.level.deduct_energy_for_action(OverlayButtonType.STATIC_POWER_LINE_HIT)
    Sc.audio.play_sound("wire_break")
    Sc.level.remove_power_line(self)
