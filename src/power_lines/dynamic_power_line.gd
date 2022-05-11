class_name DynamicPowerLine
extends PowerLine


const _STABILIZATION_DELAY_BEFORE_SWITCHING_TO_STATIC_LINE := 1.0

var origin_station
var destination_station
var rope: Rope


func _init(
        origin_station,
        destination_station,
        bot,
        mode: int).(
        origin_station,
        bot,
        mode) -> void:
    self.origin_station = origin_station
    self.destination_station = destination_station
    var target_distance: float = \
            origin_station.position.distance_to(destination_station.position)
    self.rope = Rope.new(target_distance)


func _on_connected() -> void:
    self.mode = PowerLine.CONNECTED
    self.end_attachment = destination_station
    origin_station.add_connection(destination_station)
    destination_station.add_connection(origin_station)
    Sc.time.set_timeout(
            self,
            "_replace_with_static_line",
            _STABILIZATION_DELAY_BEFORE_SWITCHING_TO_STATIC_LINE)


func _replace_with_static_line() -> void:
    var connected_power_line := StaticPowerLine.new(
            self.rope,
            self.start_attachment,
            self.destination_station,
            PowerLine.CONNECTED)
    Sc.level.add_power_line(connected_power_line)
    Sc.level.remove_power_line(self)


func _physics_process(_delta: float) -> void:
    rope.update_end_positions(
            start_attachment.get_power_line_attachment_position(),
            end_attachment.get_power_line_attachment_position())
    rope.on_physics_frame()


func _process(_delta: float) -> void:
    update()


func _update_vertices() -> void:
    _vertices.resize(rope.nodes.size())
    for i in rope.nodes.size():
        _vertices[i] = rope.nodes[i].position


func _draw() -> void:
    _update_vertices()
    _draw_polyline()


func _on_hit_by_meteor() -> void:
    Sc.logger.print("DynamicPowerLine._on_hit_by_meteor")
    ._on_hit_by_meteor()
    if end_attachment.has_method("stop"):
        # Is Bot.
        end_attachment.stop()
        Sc.level.deduct_energy(Costs.DYNAMIC_POWER_LINE_HIT)
    else:
        # Is Station.
        start_attachment.remove_connection(end_attachment)
        end_attachment.remove_connection(start_attachment)
        Sc.level.deduct_energy(Costs.STATIC_POWER_LINE_HIT)
    Sc.audio.play_sound("wire_break")
    Sc.level.remove_power_line(self)
