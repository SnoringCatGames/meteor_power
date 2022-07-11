tool
class_name MeteorController
extends Node2D



# FIXME: ------------------
# - Finish scheduler.
# - Create meteor art: big and small.
# - Create metor class, with movement.
# - Add meteor spawning with schedule.
# - Use complete random locations, within level x range, at first.
# - Use straight vertical, at first.
# - Then add some angular randomness.
# - Then add some more likely targeting of wires.
#   - Every X meteor is targeted?
# - Add collision detection for platforms, bots, and stations.
# - Add collision detection for wire.
# - Add wire complete removal.
# - Add a steady energy drain for bots just existing.
# - Add a energy hit for damaged wires.

# - Add music
# - Add sfx
# - Add better level and playtest.
# - Check notes

var METEOR_CLASS := preload("res://src/meteors/meteor.tscn")

var WAVE_PERIOD := 40.0
var WAVE_DURATION_START := 10.0
var WAVE_DURATION_DELTA := 10.0

var METEOR_WAVE_FREQUENCY_START := 0.8
var METEOR_WAVE_FREQUENCY_MULTIPLIER := 1.5

var NON_WAVE_METEOR_FREQUENCY_START := 0.1
var NON_WAVE_METEOR_FREQUENCY_MULTIPLIER := 1.5

var LARGE_METEOR_RATIO := 0.2

var is_in_wave := false

var start_time := INF
var next_meteor_time := INF
var next_wave_start_time := INF
var next_wave_end_time := INF

var current_wave_duration := WAVE_DURATION_START
var current_wave_meteor_frequency := METEOR_WAVE_FREQUENCY_START
var current_non_wave_meteor_frequency := NON_WAVE_METEOR_FREQUENCY_START


func _init() -> void:
    start_time = Sc.time.get_scaled_play_time()
    next_wave_start_time = start_time + WAVE_PERIOD
    next_meteor_time = 5.0


func _physics_process(delta: float) -> void:
    var total_time := Sc.time.get_scaled_play_time() - start_time
    
    while total_time > next_wave_start_time:
        _start_wave()
    
    if total_time > next_wave_end_time:
        _end_wave()
    
    while total_time > next_meteor_time:
        _trigger_meteor()


func _start_wave() -> void:
#    Sc.logger.print("MeteorController._start_wave")
    
    is_in_wave = true
    
    next_wave_start_time += WAVE_PERIOD
    next_wave_end_time = next_wave_start_time + current_wave_duration
    
    current_wave_duration += WAVE_DURATION_DELTA
    current_wave_meteor_frequency *= METEOR_WAVE_FREQUENCY_MULTIPLIER
    current_non_wave_meteor_frequency *= NON_WAVE_METEOR_FREQUENCY_MULTIPLIER
    
    _trigger_meteor()


func _end_wave() -> void:
#    Sc.logger.print("MeteorController._end_wave")
    
    is_in_wave = false
    
    Sc.level.session.waves_completed_count += 1


func _trigger_meteor() -> void:
#    Sc.logger.print("MeteorController._trigger_meteor")
    
    var current_meteor_frequency := \
            current_wave_meteor_frequency if \
            is_in_wave else \
            current_non_wave_meteor_frequency
    var current_meteor_period := 1.0 / current_meteor_frequency
    var next_meteor_delay := randf() * 2.0 * current_meteor_period
    next_meteor_time += next_meteor_delay
    
    _spawn_meteor()


func _spawn_meteor() -> void:
    var meteor: Meteor = Sc.utils.add_scene(self, METEOR_CLASS)
    meteor.is_large = randf() < LARGE_METEOR_RATIO
    meteor.position.y = Sc.level.level_bounds.position.y - 1000.0
    meteor.position.x = \
            randf() * Sc.level.level_bounds.size.x + \
            Sc.level.level_bounds.position.x
    meteor.run()
