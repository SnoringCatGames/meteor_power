class_name Commands
extends Reference


enum {
    UNKNOWN,
    
    BOT_CONSTRUCTOR,
    BOT_LINE_RUNNER,
    BOT_REPAIR,
    BOT_BARRIER,
    BOT_MOVE,
    BOT_RECYCLE,
    
    STATION_EMPTY,
    STATION_COMMAND,
    STATION_SOLAR,
    STATION_SCANNER,
    STATION_BATTERY,
    STATION_RECYCLE,
    
    RUN_WIRE,
}

const COSTS := {
    UNKNOWN: INF,
    
    BOT_CONSTRUCTOR: Costs.BOT_CONSTRUCTOR,
    BOT_LINE_RUNNER: Costs.BOT_LINE_RUNNER,
    BOT_REPAIR: Costs.BOT_REPAIR,
    BOT_BARRIER: Costs.BOT_BARRIER,
    BOT_MOVE: Costs.BOT_MOVE,
    BOT_RECYCLE: Costs.BOT_RECYCLE,
    
    STATION_EMPTY: INF,
    STATION_COMMAND: Costs.STATION_COMMAND,
    STATION_SOLAR: Costs.STATION_SOLAR,
    STATION_SCANNER: Costs.STATION_SCANNER,
    STATION_BATTERY: Costs.STATION_BATTERY,
    STATION_RECYCLE: Costs.STATION_RECYCLE,
    
    RUN_WIRE: Costs.RUN_WIRE,
}

const TEXTURES := {
    UNKNOWN: null,
    
    BOT_CONSTRUCTOR: preload("res://assets/images/gui/overlay_buttons/construction_bot_overlay_button.png"),
    BOT_LINE_RUNNER: preload("res://assets/images/gui/overlay_buttons/line_runner_bot_overlay_button.png"),
    BOT_REPAIR: preload("res://assets/images/gui/overlay_buttons/repair_bot_overlay_button.png"),
    BOT_BARRIER: preload("res://assets/images/gui/overlay_buttons/barrier_bot_overlay_button.png"),
    BOT_MOVE: preload("res://assets/images/gui/overlay_buttons/destroy_overlay_button.png"),
    BOT_RECYCLE: preload("res://assets/images/gui/overlay_buttons/destroy_overlay_button.png"),
    
    STATION_EMPTY: null,
    STATION_COMMAND: preload("res://assets/images/gui/overlay_buttons/destroy_overlay_button.png"),
    STATION_SOLAR: preload("res://assets/images/gui/overlay_buttons/solar_overlay_button.png"),
    STATION_SCANNER: preload("res://assets/images/gui/overlay_buttons/scanner_overlay_button.png"),
    STATION_BATTERY: preload("res://assets/images/gui/overlay_buttons/battery_overlay_button.png"),
    STATION_RECYCLE: preload("res://assets/images/gui/overlay_buttons/destroy_overlay_button.png"),
    
    RUN_WIRE: preload("res://assets/images/gui/overlay_buttons/run_power_line_button.png"),
}

const OUTLINED_TEXTURES := {
    UNKNOWN: null,
    
    BOT_CONSTRUCTOR: null,
    BOT_LINE_RUNNER: null,
    BOT_REPAIR: null,
    BOT_BARRIER: null,
    BOT_MOVE: null,
    BOT_RECYCLE: null,
    
    STATION_EMPTY: null,
    STATION_COMMAND: null,
    STATION_SOLAR: null,
    STATION_SCANNER: null,
    STATION_BATTERY: null,
    STATION_RECYCLE: null,
    
    RUN_WIRE: null,
}


static func get_string(type: int) -> String:
    match type:
        UNKNOWN:
            return "UNKNOWN"
        BOT_CONSTRUCTOR:
            return "BOT_CONSTRUCTOR"
        BOT_LINE_RUNNER:
            return "BOT_LINE_RUNNER"
        BOT_REPAIR:
            return "BOT_REPAIR"
        BOT_BARRIER:
            return "BOT_BARRIER"
        BOT_MOVE:
            return "BOT_MOVE"
        BOT_RECYCLE:
            return "BOT_RECYCLE"
        STATION_EMPTY:
            return "STATION_EMPTY"
        STATION_COMMAND:
            return "STATION_COMMAND"
        STATION_SOLAR:
            return "STATION_SOLAR"
        STATION_SCANNER:
            return "STATION_SCANNER"
        STATION_BATTERY:
            return "STATION_BATTERY"
        STATION_RECYCLE:
            return "STATION_RECYCLE"
        RUN_WIRE:
            return "RUN_WIRE"
        _:
            Sc.logger.error("Commands.get_string: %s" % str(type))
            return ""
