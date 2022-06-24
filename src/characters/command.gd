class_name Command
extends Reference


var type := CommandType.UNKNOWN

var target_station: Station
var next_target_station: Station

var destination: PositionAlongSurface

var bot

var is_active := false


func _init(
        type: int,
        target_station: Station,
        next_target_station: Station = null,
        destination: PositionAlongSurface = null) -> void:
    assert(target_station == null or target_station != next_target_station)
    self.type = type
    self.target_station = target_station
    self.next_target_station = next_target_station
    self.destination = destination
