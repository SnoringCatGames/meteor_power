class_name BotCommand
extends Reference


var command := Command.UNKNOWN

var target_station: Station
var next_target_station: Station

var bot


func _init(
        command: int,
        target_station: Station,
        next_target_station: Station) -> void:
    self.command = command
    self.target_station = target_station
    self.next_target_station = next_target_station
