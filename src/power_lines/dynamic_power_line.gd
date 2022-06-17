class_name DynamicPowerLine
extends PowerLine


const _STABILIZATION_DELAY_BEFORE_SWITCHING_TO_STATIC_LINE := 1.0

var bot
var origin_station
var destination_station
var rope: DynamicRope


func _init(
        origin_station,
        destination_station,
        bot,
        mode: int).(
        origin_station,
        bot,
        mode) -> void:
    self.bot = bot
    self.origin_station = origin_station
    self.destination_station = destination_station
    var target_distance: float = \
            origin_station.position.distance_to(destination_station.position)
    self.rope = DynamicRope.new(target_distance)
    origin_station.add_bot_connection(bot, self)
    origin_station._on_plugged_into_bot(bot)


func _on_connected() -> void:
    if _destroyed:
        return
    var bot = end_attachment
    self.mode = PowerLine.CONNECTED
    self.end_attachment = destination_station
    Sc.level.connect_dynamic_power_line_to_second_station(
        origin_station,
        destination_station,
        bot,
        self)
    Sc.time.set_timeout(
            self,
            "_replace_with_static_line",
            _STABILIZATION_DELAY_BEFORE_SWITCHING_TO_STATIC_LINE)


func _replace_with_static_line() -> void:
    var static_power_line := StaticPowerLine.new(
            rope,
            start_attachment,
            destination_station,
            PowerLine.CONNECTED)
    Sc.level.replace_dynamic_power_line(self, static_power_line)


func _physics_process(_delta: float) -> void:
    if _destroyed:
        return
    rope.update_end_positions(
            start_attachment.get_power_line_attachment_position(end_attachment),
            end_attachment.get_power_line_attachment_position(start_attachment))
    rope.on_physics_frame()


func _process(_delta: float) -> void:
    if _destroyed:
        return
    update()


func _update_vertices() -> void:
    _vertices.resize(rope.nodes.size())
    for i in rope.nodes.size():
        _vertices[i] = rope.nodes[i].position


func _draw() -> void:
    _update_vertices()
    _draw_polyline()


func _on_hit_by_meteor() -> void:
    if _destroyed:
        return
    Sc.logger.print("DynamicPowerLine._on_hit_by_meteor")
    if mode == PowerLine.CONNECTED:
        Sc.level.deduct_energy(Cost.STATIC_POWER_LINE_HIT)
    else:
        Sc.level.deduct_energy(Cost.DYNAMIC_POWER_LINE_HIT)
    ._on_hit_by_meteor()
