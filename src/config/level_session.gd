class_name LevelSession
extends SurfacerLevelSession
# NOTE: Don't store references to nodes that should be destroyed with the
#       level, because this session-state will persist after the level is
#       destroyed.


var total_energy := 0
var current_energy := 0

var bot_capacity := 1

var command_center_count := 0
var solar_collector_count := 0
var scanner_station_count := 0
var battery_station_count := 0
var empty_station_count := 0

var constructor_bot_count := 0
var line_runner_bot_count := 0
var barrier_bot_count := 0
var power_line_count := 0


func reset(id: String) -> void:
    .reset(id)
    
    total_energy = config.start_energy
    current_energy = config.start_energy
    bot_capacity = config.bot_capacity
    
    command_center_count = 0
    solar_collector_count = 0
    scanner_station_count = 0
    battery_station_count = 0
    empty_station_count = 0
    
    constructor_bot_count = 0
    line_runner_bot_count = 0
    barrier_bot_count = 0
    power_line_count = 0
