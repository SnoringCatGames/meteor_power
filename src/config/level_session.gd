class_name LevelSession
extends SurfacerLevelSession
# NOTE: Don't store references to nodes that should be destroyed with the
#       level, because this session-state will persist after the level is
#       destroyed.


var _CUMULATIVE_COLLECTED_ENERGY_SETTINGS_KEY := "collected_energy"
var _CUMULATIVE_COLLIDED_METEORS_SETTINGS_KEY := "collided_meteors"
var _CUMULATIVE_STATIONS_BUILT_SETTINGS_KEY := "stations_built"
var _CUMULATIVE_BOTS_BUILT_SETTINGS_KEY := "bots_built"
var _CUMULATIVE_WIRES_BUILT_SETTINGS_KEY := "wires_built"
var _CUMULATIVE_BOT_PIXELS_TRAVELLED_SETTINGS_KEY := "bot_pixels_travelled"

var _CUMULATIVE_CONSTRUCTOR_BOTS_BUILT_SETTINGS_KEY := "constructor_bots_built"
var _CUMULATIVE_LINE_RUNNER_BOTS_BUILT_SETTINGS_KEY := "line_runner_bots_built"
var _CUMULATIVE_BARRIER_BOTS_BUILT_SETTINGS_KEY := "barrier_bots_built"

var _CUMULATIVE_COMMAND_CENTERS_BUILT_SETTINGS_KEY := "command_centers_built"
var _CUMULATIVE_SOLAR_COLLECTORS_BUILT_SETTINGS_KEY := "solar_collectors_built"
var _CUMULATIVE_SCANNER_STATIONS_BUILT_SETTINGS_KEY := "scanner_stations_built"
var _CUMULATIVE_BATTERY_STATIONS_BUILT_SETTINGS_KEY := "battery_stations_built"

var PIXELS_PER_MILE := 6400
var KM_PER_MILE := 1.60934

var total_energy := 0
var current_energy := 0

var bot_capacity := 1

var command_center_count := 0
var solar_collector_count := 0
var scanner_station_count := 0
var battery_station_count := 0
var empty_station_count := 0
var total_station_site_count: int setget ,_get_total_station_site_count
var total_station_count: int setget ,_get_total_station_count

var constructor_bot_count := 0
var line_runner_bot_count := 0
var barrier_bot_count := 0
var total_bot_count: int setget ,_get_total_bot_count

var power_line_count := 0

var meteors_collided_count := 0
var bot_pixels_travelled := 0.0
var bots_built_count := 0
var stations_built_count := 0
var power_lines_built_count := 0

var contructor_bots_built_count := 0
var line_runner_bots_built_count := 0
var barrier_bots_built_count := 0

var command_centers_built_count := 0
var solar_collectors_built_count := 0
var scanner_stations_built_count := 0
var battery_stations_built_count := 0


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


func _update_for_level_end(has_finished: bool) -> void:
    ._update_for_level_end(has_finished)
    
    var stats := [
        [
            _CUMULATIVE_COLLECTED_ENERGY_SETTINGS_KEY,
            total_energy if has_finished else 0,
        ],
        [
            _CUMULATIVE_COLLIDED_METEORS_SETTINGS_KEY,
            meteors_collided_count,
        ],
        [
            _CUMULATIVE_STATIONS_BUILT_SETTINGS_KEY,
            stations_built_count,
        ],
        [
            _CUMULATIVE_BOTS_BUILT_SETTINGS_KEY,
            bots_built_count,
        ],
        [
            _CUMULATIVE_WIRES_BUILT_SETTINGS_KEY,
            power_lines_built_count,
        ],
        [
            _CUMULATIVE_BOT_PIXELS_TRAVELLED_SETTINGS_KEY,
            bot_pixels_travelled,
        ],
        [
            _CUMULATIVE_CONSTRUCTOR_BOTS_BUILT_SETTINGS_KEY,
            contructor_bots_built_count,
        ],
        [
            _CUMULATIVE_LINE_RUNNER_BOTS_BUILT_SETTINGS_KEY,
            line_runner_bots_built_count,
        ],
        [
            _CUMULATIVE_BARRIER_BOTS_BUILT_SETTINGS_KEY,
            barrier_bots_built_count,
        ],
        [
            _CUMULATIVE_COMMAND_CENTERS_BUILT_SETTINGS_KEY,
            command_centers_built_count,
        ],
        [
            _CUMULATIVE_SOLAR_COLLECTORS_BUILT_SETTINGS_KEY,
            solar_collectors_built_count,
        ],
        [
            _CUMULATIVE_SCANNER_STATIONS_BUILT_SETTINGS_KEY,
            scanner_stations_built_count,
        ],
        [
            _CUMULATIVE_BATTERY_STATIONS_BUILT_SETTINGS_KEY,
            battery_stations_built_count,
        ],
    ]
    
    for stat in stats:
        var key: String = stat[0]
        var value = stat[1]
        var previous_global_value = Sc.save_state.get_setting(key)
        var previous_level_value = Sc.save_state.get_level_setting(_id, key)
        Sc.save_state.set_setting(key, previous_global_value + value)
        Sc.save_state.set_level_setting(_id, key, previous_level_value + value)


func _get_total_station_site_count() -> int:
    return command_center_count + \
        solar_collector_count + \
        scanner_station_count + \
        battery_station_count + \
        empty_station_count


func _get_total_station_count() -> int:
    return command_center_count + \
        solar_collector_count + \
        scanner_station_count + \
        battery_station_count


func _get_total_bot_count() -> int:
    return constructor_bot_count + \
        line_runner_bot_count + \
        barrier_bot_count
