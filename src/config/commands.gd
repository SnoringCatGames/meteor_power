class_name Commands
extends Reference


enum {
    UNKNOWN,
    
    BOT_CONSTRUCTOR,
    BOT_LINE_RUNNER,
    BOT_REPAIR,
    BOT_BARRIER,
    BOT_COMMAND,
    BOT_STOP,
    BOT_MOVE,
    BOT_RECYCLE,
    BOT_INFO,
    
    STATION_EMPTY,
    STATION_COMMAND,
    STATION_SOLAR,
    STATION_SCANNER,
    STATION_BATTERY,
    STATION_RECYCLE,
    STATION_INFO,
    
    RUN_WIRE,
}

const COSTS := {
    UNKNOWN: INF,
    
    BOT_CONSTRUCTOR: Costs.BOT_CONSTRUCTOR,
    BOT_LINE_RUNNER: Costs.BOT_LINE_RUNNER,
    BOT_REPAIR: Costs.BOT_REPAIR,
    BOT_BARRIER: Costs.BOT_BARRIER,
    BOT_COMMAND: Costs.BOT_COMMAND,
    BOT_STOP: Costs.BOT_STOP,
    BOT_MOVE: Costs.BOT_MOVE,
    BOT_RECYCLE: Costs.BOT_RECYCLE,
    BOT_INFO: Costs.BOT_INFO,
    
    STATION_EMPTY: INF,
    STATION_COMMAND: Costs.STATION_COMMAND,
    STATION_SOLAR: Costs.STATION_SOLAR,
    STATION_SCANNER: Costs.STATION_SCANNER,
    STATION_BATTERY: Costs.STATION_BATTERY,
    STATION_RECYCLE: Costs.STATION_RECYCLE,
    STATION_INFO: Costs.STATION_INFO,
    
    RUN_WIRE: Costs.RUN_WIRE,
}

const SHORT_DESCRIPTIONS := {
    UNKNOWN: "",
    
    BOT_CONSTRUCTOR: Descriptions.SHORT.BOT_CONSTRUCTOR,
    BOT_LINE_RUNNER: Descriptions.SHORT.BOT_LINE_RUNNER,
    BOT_REPAIR: Descriptions.SHORT.BOT_REPAIR,
    BOT_BARRIER: Descriptions.SHORT.BOT_BARRIER,
    BOT_COMMAND: Descriptions.SHORT.BOT_COMMAND,
    BOT_STOP: Descriptions.SHORT.BOT_STOP,
    BOT_MOVE: Descriptions.SHORT.BOT_MOVE,
    BOT_RECYCLE: Descriptions.SHORT.BOT_RECYCLE,
    BOT_INFO: Descriptions.SHORT.BOT_INFO,
    
    STATION_EMPTY: INF,
    STATION_COMMAND: Descriptions.SHORT.STATION_COMMAND,
    STATION_SOLAR: Descriptions.SHORT.STATION_SOLAR,
    STATION_SCANNER: Descriptions.SHORT.STATION_SCANNER,
    STATION_BATTERY: Descriptions.SHORT.STATION_BATTERY,
    STATION_RECYCLE: Descriptions.SHORT.STATION_RECYCLE,
    STATION_INFO: Descriptions.SHORT.STATION_INFO,
    
    RUN_WIRE: Descriptions.SHORT.RUN_WIRE,
}

const VERBOSE_DESCRIPTIONS := {
    UNKNOWN: "",
    
    BOT_CONSTRUCTOR: Descriptions.VERBOSE.BOT_CONSTRUCTOR,
    BOT_LINE_RUNNER: Descriptions.VERBOSE.BOT_LINE_RUNNER,
    BOT_REPAIR: Descriptions.VERBOSE.BOT_REPAIR,
    BOT_BARRIER: Descriptions.VERBOSE.BOT_BARRIER,
    BOT_COMMAND: Descriptions.VERBOSE.BOT_COMMAND,
    BOT_STOP: Descriptions.VERBOSE.BOT_STOP,
    BOT_MOVE: Descriptions.VERBOSE.BOT_MOVE,
    BOT_RECYCLE: Descriptions.VERBOSE.BOT_RECYCLE,
    BOT_INFO: Descriptions.VERBOSE.BOT_INFO,
    
    STATION_EMPTY: INF,
    STATION_COMMAND: Descriptions.VERBOSE.STATION_COMMAND,
    STATION_SOLAR: Descriptions.VERBOSE.STATION_SOLAR,
    STATION_SCANNER: Descriptions.VERBOSE.STATION_SCANNER,
    STATION_BATTERY: Descriptions.VERBOSE.STATION_BATTERY,
    STATION_RECYCLE: Descriptions.VERBOSE.STATION_RECYCLE,
    STATION_INFO: Descriptions.VERBOSE.STATION_INFO,
    
    RUN_WIRE: Descriptions.VERBOSE.RUN_WIRE,
}

const TEXTURES := {
    UNKNOWN: null,
    
    BOT_CONSTRUCTOR: preload("res://assets/images/gui/overlay_buttons/build_constructor_bot.png"),
    BOT_LINE_RUNNER: preload("res://assets/images/gui/overlay_buttons/line_runner_bot_overlay_button.png"),
    BOT_REPAIR: preload("res://assets/images/gui/overlay_buttons/repair_bot_overlay_button.png"),
    BOT_BARRIER: preload("res://assets/images/gui/overlay_buttons/barrier_bot_overlay_button.png"),
    BOT_COMMAND: preload("res://assets/images/gui/overlay_buttons/command_overlay_button.png"),
    BOT_STOP: preload("res://assets/images/gui/overlay_buttons/stop_overlay_button.png"),
    BOT_MOVE: preload("res://assets/images/gui/overlay_buttons/command_overlay_button.png"),
    BOT_RECYCLE: preload("res://assets/images/gui/overlay_buttons/destroy_overlay_button.png"),
    BOT_INFO: preload("res://assets/images/gui/overlay_buttons/info_overlay_button.png"),
    
    STATION_EMPTY: null,
    STATION_COMMAND: preload("res://assets/images/gui/overlay_buttons/destroy_overlay_button.png"),
    STATION_SOLAR: preload("res://assets/images/gui/overlay_buttons/solar_overlay_button.png"),
    STATION_SCANNER: preload("res://assets/images/gui/overlay_buttons/scanner_overlay_button.png"),
    STATION_BATTERY: preload("res://assets/images/gui/overlay_buttons/battery_overlay_button.png"),
    STATION_RECYCLE: preload("res://assets/images/gui/overlay_buttons/destroy_overlay_button.png"),
    STATION_INFO: preload("res://assets/images/gui/overlay_buttons/info_overlay_button.png"),
    
    RUN_WIRE: preload("res://assets/images/gui/overlay_buttons/run_power_line_button.png"),
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
        BOT_COMMAND:
            return "BOT_COMMAND"
        BOT_STOP:
            return "BOT_STOP"
        BOT_MOVE:
            return "BOT_MOVE"
        BOT_RECYCLE:
            return "BOT_RECYCLE"
        BOT_INFO:
            return "BOT_INFO"
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
        STATION_INFO:
            return "STATION_INFO"
        RUN_WIRE:
            return "RUN_WIRE"
        _:
            Sc.logger.error("Commands.get_string: %s" % str(type))
            return ""
