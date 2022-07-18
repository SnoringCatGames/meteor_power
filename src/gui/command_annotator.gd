class_name CommandAnnotator
extends Node2D


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
    
    CommandType.RUN_WIRE: preload(
        "res://src/power_lines/power_line_phantom.tscn"),
    
    CommandType.BARRIER_PYLON: preload(
        "res://src/barrier/barrier_pylon_phantom.tscn"),
}

var command: Command setget _set_command

var navigator_annotator: NavigatorAnnotator

var phantom: Phantom


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
    
    if is_instance_valid(command) and \
            (!is_instance_valid(phantom) or \
            phantom.command != command):
        if is_instance_valid(phantom) and \
                phantom.command != command:
            phantom.queue_free()
        
        match command.type:
            CommandType.BOT_BARRIER, \
            CommandType.BOT_CONSTRUCTOR, \
            CommandType.BOT_LINE_RUNNER:
                if is_instance_valid(command.target_station):
                    phantom = Sc.utils.add_scene(
                        self, PHANTOM_SCENES[command.type])
                    phantom.position = command.target_station.position
            
            CommandType.STATION_COMMAND, \
            CommandType.STATION_SOLAR, \
            CommandType.STATION_SCANNER, \
            CommandType.STATION_BATTERY:
                if is_instance_valid(command.target_station):
                    phantom = Sc.utils.add_scene(
                        self, PHANTOM_SCENES[command.type])
                    phantom.position = command.target_station.position
            CommandType.STATION_EMPTY, \
            CommandType.STATION_RECYCLE:
                if is_instance_valid(command.target_station):
                    phantom = Sc.utils.add_scene(
                        self, PHANTOM_SCENES[CommandType.STATION_EMPTY])
                    phantom.position = command.target_station.position
            
            CommandType.BOT_RECYCLE:
                # This is handled by the bot's navigator annotation.
                pass
            CommandType.BOT_COMMAND, \
            CommandType.BOT_MOVE:
                # This is handled by the bot's navigator annotation.
                pass
            
            CommandType.RUN_WIRE:
                if is_instance_valid(command.target_station) and \
                        is_instance_valid(command.next_target_station):
                    phantom = Sc.utils.add_scene(
                        self, PHANTOM_SCENES[CommandType.RUN_WIRE])
                    phantom.set_up(
                        command.target_station.position,
                        command.next_target_station.position)
            CommandType.WIRE_REPAIR:
                if is_instance_valid(command.target_station) and \
                        is_instance_valid(command.next_target_station):
                    phantom = Sc.utils.add_scene(
                        self, PHANTOM_SCENES[CommandType.RUN_WIRE])
                    phantom.set_up(
                        command.target_station.position,
                        command.next_target_station.position)
            CommandType.STATION_REPAIR:
                if is_instance_valid(command.target_station):
                    phantom = Sc.utils.add_scene(
                        self, PHANTOM_SCENES[command.type])
                    phantom.position = command.target_station.position
            
            CommandType.BARRIER_PYLON:
                # FIXME: --------------------------------------------------
#                if is_instance_valid(command.target_station):
#                    phantom = Sc.utils.add_scene(
#                        self, PHANTOM_SCENES[command.type])
#                    phantom.position = command.target_station.position
                pass
        
            _:
                Sc.logger.error("CommandAnnotator.update_command")
    
    if !is_instance_valid(command) and \
            is_instance_valid(phantom):
        phantom.queue_free()


func _set_command(value: Command) -> void:
    var previous_command := command
    command = value
    if command != previous_command:
        update_command()
