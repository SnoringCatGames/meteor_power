class_name CommandType
extends Reference


enum {
    UNKNOWN,
    
    BOT_CONSTRUCTOR,
    BOT_LINE_RUNNER,
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
    STATION_LINK_TO_MOTHERSHIP,
    STATION_STOP,
    STATION_RECYCLE,
    STATION_INFO,
    
    RUN_WIRE,
    STATION_REPAIR,
    WIRE_REPAIR,
    
    BARRIER_PYLON,
}

const VALUES := [
    UNKNOWN,
    
    BOT_CONSTRUCTOR,
    BOT_LINE_RUNNER,
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
    STATION_LINK_TO_MOTHERSHIP,
    STATION_STOP,
    STATION_RECYCLE,
    STATION_INFO,
    
    RUN_WIRE,
    STATION_REPAIR,
    WIRE_REPAIR,
    
    BARRIER_PYLON,
]

const COSTS := {
    UNKNOWN: INF,
    
    BOT_CONSTRUCTOR: Cost.BOT_CONSTRUCTOR,
    BOT_LINE_RUNNER: Cost.BOT_LINE_RUNNER,
    BOT_BARRIER: Cost.BOT_BARRIER,
    BOT_COMMAND: Cost.BOT_COMMAND,
    BOT_STOP: Cost.BOT_STOP,
    BOT_MOVE: Cost.BOT_MOVE,
    BOT_RECYCLE: Cost.BOT_RECYCLE,
    BOT_INFO: Cost.BOT_INFO,
    
    STATION_EMPTY: INF,
    STATION_COMMAND: Cost.STATION_COMMAND,
    STATION_SOLAR: Cost.STATION_SOLAR,
    STATION_SCANNER: Cost.STATION_SCANNER,
    STATION_BATTERY: Cost.STATION_BATTERY,
    STATION_LINK_TO_MOTHERSHIP: Cost.STATION_LINK_TO_MOTHERSHIP,
    STATION_STOP: Cost.STATION_STOP,
    STATION_RECYCLE: Cost.STATION_RECYCLE,
    STATION_INFO: Cost.STATION_INFO,
    
    RUN_WIRE: Cost.RUN_WIRE,
    STATION_REPAIR: Cost.STATION_REPAIR,
    WIRE_REPAIR: Cost.WIRE_REPAIR,
    
    BARRIER_PYLON: Cost.BARRIER_PYLON,
}

const ENTITY_NAMES := {
    BOT_CONSTRUCTOR: Description.ENTITY_NAMES.BOT_CONSTRUCTOR,
    BOT_LINE_RUNNER: Description.ENTITY_NAMES.BOT_LINE_RUNNER,
    BOT_BARRIER: Description.ENTITY_NAMES.BOT_BARRIER,
    
    STATION_EMPTY: Description.ENTITY_NAMES.STATION_EMPTY,
    STATION_COMMAND: Description.ENTITY_NAMES.STATION_COMMAND,
    STATION_SOLAR: Description.ENTITY_NAMES.STATION_SOLAR,
    STATION_SCANNER: Description.ENTITY_NAMES.STATION_SCANNER,
    STATION_BATTERY: Description.ENTITY_NAMES.STATION_BATTERY,
    
    BARRIER_PYLON: Description.ENTITY_NAMES.BARRIER_PYLON,
}

const ENTITY_DESCRIPTIONS := {
    BOT_CONSTRUCTOR: Description.ENTITY_DESCRIPTIONS.BOT_CONSTRUCTOR,
    BOT_LINE_RUNNER: Description.ENTITY_DESCRIPTIONS.BOT_LINE_RUNNER,
    BOT_BARRIER: Description.ENTITY_DESCRIPTIONS.BOT_BARRIER,
    
    STATION_EMPTY: Description.ENTITY_DESCRIPTIONS.STATION_EMPTY,
    STATION_COMMAND: Description.ENTITY_DESCRIPTIONS.STATION_COMMAND,
    STATION_SOLAR: Description.ENTITY_DESCRIPTIONS.STATION_SOLAR,
    STATION_SCANNER: Description.ENTITY_DESCRIPTIONS.STATION_SCANNER,
    STATION_BATTERY: Description.ENTITY_DESCRIPTIONS.STATION_BATTERY,
    
    BARRIER_PYLON: Description.ENTITY_DESCRIPTIONS.BARRIER_PYLON,
}

const COMMAND_LABELS := {
    UNKNOWN: "",
    
    BOT_CONSTRUCTOR: Description.COMMAND_LABELS.BOT_CONSTRUCTOR,
    BOT_LINE_RUNNER: Description.COMMAND_LABELS.BOT_LINE_RUNNER,
    BOT_BARRIER: Description.COMMAND_LABELS.BOT_BARRIER,
    BOT_COMMAND: Description.COMMAND_LABELS.BOT_COMMAND,
    BOT_STOP: Description.COMMAND_LABELS.BOT_STOP,
    BOT_MOVE: Description.COMMAND_LABELS.BOT_MOVE,
    BOT_RECYCLE: Description.COMMAND_LABELS.BOT_RECYCLE,
    BOT_INFO: Description.COMMAND_LABELS.BOT_INFO,
    
    STATION_EMPTY: INF,
    STATION_COMMAND: Description.COMMAND_LABELS.STATION_COMMAND,
    STATION_SOLAR: Description.COMMAND_LABELS.STATION_SOLAR,
    STATION_SCANNER: Description.COMMAND_LABELS.STATION_SCANNER,
    STATION_BATTERY: Description.COMMAND_LABELS.STATION_BATTERY,
    STATION_LINK_TO_MOTHERSHIP: Description.COMMAND_LABELS.STATION_LINK_TO_MOTHERSHIP,
    STATION_STOP: Description.COMMAND_LABELS.STATION_STOP,
    STATION_RECYCLE: Description.COMMAND_LABELS.STATION_RECYCLE,
    STATION_INFO: Description.COMMAND_LABELS.STATION_INFO,
    
    RUN_WIRE: Description.COMMAND_LABELS.RUN_WIRE,
    STATION_REPAIR: Description.COMMAND_LABELS.STATION_REPAIR,
    WIRE_REPAIR: Description.COMMAND_LABELS.WIRE_REPAIR,
    
    BARRIER_PYLON: Description.COMMAND_LABELS.BARRIER_PYLON,
}

const COMMAND_DESCRIPTIONS := {
    UNKNOWN: "",
    
    BOT_CONSTRUCTOR: Description.COMMAND_DESCRIPTIONS.BOT_CONSTRUCTOR,
    BOT_LINE_RUNNER: Description.COMMAND_DESCRIPTIONS.BOT_LINE_RUNNER,
    BOT_BARRIER: Description.COMMAND_DESCRIPTIONS.BOT_BARRIER,
    BOT_COMMAND: Description.COMMAND_DESCRIPTIONS.BOT_COMMAND,
    BOT_STOP: Description.COMMAND_DESCRIPTIONS.BOT_STOP,
    BOT_MOVE: Description.COMMAND_DESCRIPTIONS.BOT_MOVE,
    BOT_RECYCLE: Description.COMMAND_DESCRIPTIONS.BOT_RECYCLE,
    BOT_INFO: Description.COMMAND_DESCRIPTIONS.BOT_INFO,
    
    STATION_EMPTY: INF,
    STATION_COMMAND: Description.COMMAND_DESCRIPTIONS.STATION_COMMAND,
    STATION_SOLAR: Description.COMMAND_DESCRIPTIONS.STATION_SOLAR,
    STATION_SCANNER: Description.COMMAND_DESCRIPTIONS.STATION_SCANNER,
    STATION_BATTERY: Description.COMMAND_DESCRIPTIONS.STATION_BATTERY,
    STATION_LINK_TO_MOTHERSHIP: Description.COMMAND_DESCRIPTIONS.STATION_LINK_TO_MOTHERSHIP,
    STATION_STOP: Description.COMMAND_DESCRIPTIONS.STATION_STOP,
    STATION_RECYCLE: Description.COMMAND_DESCRIPTIONS.STATION_RECYCLE,
    STATION_INFO: Description.COMMAND_DESCRIPTIONS.STATION_INFO,
    
    RUN_WIRE: Description.COMMAND_DESCRIPTIONS.RUN_WIRE,
    STATION_REPAIR: Description.COMMAND_DESCRIPTIONS.STATION_REPAIR,
    WIRE_REPAIR: Description.COMMAND_DESCRIPTIONS.WIRE_REPAIR,
    
    BARRIER_PYLON: Description.COMMAND_DESCRIPTIONS.BARRIER_PYLON,
}

const TEXTURES := {
    UNKNOWN: null,
    
    BOT_CONSTRUCTOR: preload("res://assets/images/gui/overlay_buttons/build_constructor_bot.png"),
    BOT_LINE_RUNNER: preload("res://assets/images/gui/overlay_buttons/line_runner_bot_overlay_button.png"),
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
    STATION_LINK_TO_MOTHERSHIP: preload("res://assets/images/gui/overlay_buttons/link_to_mother_ship_overlay_button.png"),
    STATION_STOP: preload("res://assets/images/gui/overlay_buttons/stop_overlay_button.png"),
    STATION_RECYCLE: preload("res://assets/images/gui/overlay_buttons/destroy_overlay_button.png"),
    STATION_INFO: preload("res://assets/images/gui/overlay_buttons/info_overlay_button.png"),
    STATION_REPAIR: preload("res://assets/images/gui/overlay_buttons/repair_overlay_button.png"),
    
    RUN_WIRE: preload("res://assets/images/gui/overlay_buttons/run_power_line_button.png"),
    WIRE_REPAIR: preload("res://assets/images/gui/overlay_buttons/repair_overlay_button.png"),
    
    BARRIER_PYLON: preload("res://assets/images/gui/overlay_buttons/barrier_pylon_button.png"),
}


static func get_string(type: int) -> String:
    match type:
        UNKNOWN:
            return "UNKNOWN"
        BOT_CONSTRUCTOR:
            return "BOT_CONSTRUCTOR"
        BOT_LINE_RUNNER:
            return "BOT_LINE_RUNNER"
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
        STATION_LINK_TO_MOTHERSHIP:
            return "STATION_LINK_TO_MOTHERSHIP"
        STATION_STOP:
            return "STATION_STOP"
        STATION_RECYCLE:
            return "STATION_RECYCLE"
        STATION_INFO:
            return "STATION_INFO"
        RUN_WIRE:
            return "RUN_WIRE"
        STATION_REPAIR:
            return "STATION_REPAIR"
        WIRE_REPAIR:
            return "WIRE_REPAIR"
        BARRIER_PYLON:
            return "BARRIER_PYLON"
        _:
            Sc.logger.error("CommandType.get_string: %s" % str(type))
            return ""
