class_name Command
extends Reference


var type := CommandType.UNKNOWN

var target_station: Station
var next_target_station: Station

var destination: PositionAlongSurface

var bot

var meta

var is_navigating := false


func _init(
        type: int,
        target_station: Station,
        next_target_station: Station = null,
        destination: PositionAlongSurface = null,
        meta = null) -> void:
    assert(target_station == null or target_station != next_target_station)
    self.type = type
    self.target_station = target_station
    self.next_target_station = next_target_station
    self.destination = destination
    self.meta = meta


func get_depends_on_target_station() -> bool:
    return type != CommandType.BARRIER_PYLON and \
            type != CommandType.BARRIER_MOVE and \
            type != CommandType.BARRIER_RECYCLE and \
            type != CommandType.BOT_MOVE


func get_position() -> Vector2:
    return destination.target_point if \
        is_instance_valid(destination) else \
        target_station.position if \
        is_instance_valid(target_station) else \
        Vector2.INF
