class_name CommandAnnotator
extends Node2D


# FIXME: LEFT OFF HERE: -----------------------------------


const PHANTOM_SCENES := {
    CommandType.BOT_BARRIER: preload(
        "res://src/characters/barrier_bot/barrier_bot_phantom.tscn"),
    CommandType.BOT_CONSTRUCTOR: preload(
        "res://src/characters/construction_bot/construction_bot_phantom.tscn"),
    CommandType.BOT_LINE_RUNNER: preload(
        "res://src/characters/line_runner_bot/line_runner_bot_phantom.tscn"),
    
    CommandType.STATION_BATTERY: preload(
        "res://src/stations/battery_station_phantom.tscn"),
    CommandType.STATION_COMMAND: preload(
        "res://src/stations/command_center_phantom.tscn"),
    CommandType.STATION_RECYCLE: preload(
        "res://src/stations/empty_station_phantom.tscn"),
    CommandType.STATION_SCANNER: preload(
        "res://src/stations/scanner_station_phantom.tscn"),
    CommandType.STATION_SOLAR: preload(
        "res://src/stations/solar_collector_phantom.tscn"),
}

var command: Command setget _set_command

var navigator_annotator: NavigatorAnnotator


# FIXME: ----------------------------
# - Call this when the item is selected, and the is-active status changes.
func update_command() -> void:
    if is_instance_valid(command) and \
            is_instance_valid(command.bot):
        # FIXME: ------------------ Highlight the bot.
        if !is_instance_valid(navigator_annotator) or \
                command.bot.navigator != navigator_annotator.navigator:
            if is_instance_valid(navigator_annotator):
                navigator_annotator.queue_free()
            navigator_annotator = \
                NavigatorAnnotator.new(command.bot.navigator)
            navigator_annotator.excludes_beat_hashes = true
            navigator_annotator.excludes_previous_path = true
            navigator_annotator.excludes_slow_motion_consideration = true
            add_child(navigator_annotator)
    else:
        if is_instance_valid(navigator_annotator):
            navigator_annotator.queue_free()
    
    # FIXME: LEFT OFF HERE: ---------------------------
    # - Build station:
    #   - Render a phantom of the building.
    # - Build bot:
    #   - Render a phantom of the bot, offset from the command center.
    # - Run line:
    #   - Render a phantom of the line.
    # - Command bot:
    #   - (This should be handled by the is-active default logic.)
    # - Destroy station:
    #   - Highlight the building to destroy.
    # - Destroy bot:
    #   - (This should be handled by the is-active default logic.)
    
    if is_instance_valid(command):
        match command.type:
            CommandType.BOT_BARRIER:
                pass
            CommandType.BOT_CONSTRUCTOR:
                pass
            CommandType.BOT_LINE_RUNNER:
                pass
            
            CommandType.STATION_COMMAND:
                pass
            CommandType.STATION_SOLAR:
                pass
            CommandType.STATION_SCANNER:
                pass
            CommandType.STATION_BATTERY:
                pass
            CommandType.STATION_EMPTY, \
            CommandType.STATION_RECYCLE:
                pass
            
            CommandType.BOT_RECYCLE:
                pass
            CommandType.BOT_COMMAND, \
            CommandType.BOT_MOVE:
                pass
            
            CommandType.RUN_WIRE:
                pass
            CommandType.STATION_REPAIR:
                pass
            CommandType.WIRE_REPAIR:
                pass
        
            _:
                Sc.logger.error("CommandAnnotator.update_command")


func _set_command(value: Command) -> void:
    var previous_command := command
    command = value
    if command != previous_command:
        update_command()
