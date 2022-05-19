class_name Command
extends Reference


var type := CommandType.UNKNOWN

var target_station: Station
var next_target_station: Station

var bot

var is_active := false


func _init(
        type: int,
        target_station: Station,
        next_target_station: Station) -> void:
    self.type = type
    self.target_station = target_station
    self.next_target_station = next_target_station
