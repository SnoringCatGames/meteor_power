class_name Commands
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
]

const COSTS := {
    UNKNOWN: INF,
    
    BOT_CONSTRUCTOR: Costs.BOT_CONSTRUCTOR,
    BOT_LINE_RUNNER: Costs.BOT_LINE_RUNNER,
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
    STATION_LINK_TO_MOTHERSHIP: Costs.STATION_LINK_TO_MOTHERSHIP,
    STATION_STOP: Costs.STATION_STOP,
    STATION_RECYCLE: Costs.STATION_RECYCLE,
    STATION_INFO: Costs.STATION_INFO,
    
    RUN_WIRE: Costs.RUN_WIRE,
    STATION_REPAIR: Costs.STATION_REPAIR,
    WIRE_REPAIR: Costs.WIRE_REPAIR,
}

const ENTITY_NAMES := {
    BOT_CONSTRUCTOR: Descriptions.ENTITY_NAMES.BOT_CONSTRUCTOR,
    BOT_LINE_RUNNER: Descriptions.ENTITY_NAMES.BOT_LINE_RUNNER,
    BOT_BARRIER: Descriptions.ENTITY_NAMES.BOT_BARRIER,
    
    STATION_EMPTY: Descriptions.ENTITY_NAMES.STATION_EMPTY,
    STATION_COMMAND: Descriptions.ENTITY_NAMES.STATION_COMMAND,
    STATION_SOLAR: Descriptions.ENTITY_NAMES.STATION_SOLAR,
    STATION_SCANNER: Descriptions.ENTITY_NAMES.STATION_SCANNER,
    STATION_BATTERY: Descriptions.ENTITY_NAMES.STATION_BATTERY,
}

const ENTITY_DESCRIPTIONS := {
    BOT_CONSTRUCTOR: Descriptions.ENTITY_DESCRIPTIONS.BOT_CONSTRUCTOR,
    BOT_LINE_RUNNER: Descriptions.ENTITY_DESCRIPTIONS.BOT_LINE_RUNNER,
    BOT_BARRIER: Descriptions.ENTITY_DESCRIPTIONS.BOT_BARRIER,
    
    STATION_EMPTY: Descriptions.ENTITY_DESCRIPTIONS.STATION_EMPTY,
    STATION_COMMAND: Descriptions.ENTITY_DESCRIPTIONS.STATION_COMMAND,
    STATION_SOLAR: Descriptions.ENTITY_DESCRIPTIONS.STATION_SOLAR,
    STATION_SCANNER: Descriptions.ENTITY_DESCRIPTIONS.STATION_SCANNER,
    STATION_BATTERY: Descriptions.ENTITY_DESCRIPTIONS.STATION_BATTERY,
}

const COMMAND_LABELS := {
    UNKNOWN: "",
    
    BOT_CONSTRUCTOR: Descriptions.COMMAND_LABELS.BOT_CONSTRUCTOR,
    BOT_LINE_RUNNER: Descriptions.COMMAND_LABELS.BOT_LINE_RUNNER,
    BOT_BARRIER: Descriptions.COMMAND_LABELS.BOT_BARRIER,
    BOT_COMMAND: Descriptions.COMMAND_LABELS.BOT_COMMAND,
    BOT_STOP: Descriptions.COMMAND_LABELS.BOT_STOP,
    BOT_MOVE: Descriptions.COMMAND_LABELS.BOT_MOVE,
    BOT_RECYCLE: Descriptions.COMMAND_LABELS.BOT_RECYCLE,
    BOT_INFO: Descriptions.COMMAND_LABELS.BOT_INFO,
    
    STATION_EMPTY: INF,
    STATION_COMMAND: Descriptions.COMMAND_LABELS.STATION_COMMAND,
    STATION_SOLAR: Descriptions.COMMAND_LABELS.STATION_SOLAR,
    STATION_SCANNER: Descriptions.COMMAND_LABELS.STATION_SCANNER,
    STATION_BATTERY: Descriptions.COMMAND_LABELS.STATION_BATTERY,
    STATION_LINK_TO_MOTHERSHIP: Descriptions.COMMAND_LABELS.STATION_LINK_TO_MOTHERSHIP,
    STATION_STOP: Descriptions.COMMAND_LABELS.STATION_STOP,
    STATION_RECYCLE: Descriptions.COMMAND_LABELS.STATION_RECYCLE,
    STATION_INFO: Descriptions.COMMAND_LABELS.STATION_INFO,
    
    RUN_WIRE: Descriptions.COMMAND_LABELS.RUN_WIRE,
    STATION_REPAIR: Descriptions.COMMAND_LABELS.STATION_REPAIR,
    WIRE_REPAIR: Descriptions.COMMAND_LABELS.WIRE_REPAIR,
}

const COMMAND_DESCRIPTIONS := {
    UNKNOWN: "",
    
    BOT_CONSTRUCTOR: Descriptions.COMMAND_DESCRIPTIONS.BOT_CONSTRUCTOR,
    BOT_LINE_RUNNER: Descriptions.COMMAND_DESCRIPTIONS.BOT_LINE_RUNNER,
    BOT_BARRIER: Descriptions.COMMAND_DESCRIPTIONS.BOT_BARRIER,
    BOT_COMMAND: Descriptions.COMMAND_DESCRIPTIONS.BOT_COMMAND,
    BOT_STOP: Descriptions.COMMAND_DESCRIPTIONS.BOT_STOP,
    BOT_MOVE: Descriptions.COMMAND_DESCRIPTIONS.BOT_MOVE,
    BOT_RECYCLE: Descriptions.COMMAND_DESCRIPTIONS.BOT_RECYCLE,
    BOT_INFO: Descriptions.COMMAND_DESCRIPTIONS.BOT_INFO,
    
    STATION_EMPTY: INF,
    STATION_COMMAND: Descriptions.COMMAND_DESCRIPTIONS.STATION_COMMAND,
    STATION_SOLAR: Descriptions.COMMAND_DESCRIPTIONS.STATION_SOLAR,
    STATION_SCANNER: Descriptions.COMMAND_DESCRIPTIONS.STATION_SCANNER,
    STATION_BATTERY: Descriptions.COMMAND_DESCRIPTIONS.STATION_BATTERY,
    STATION_LINK_TO_MOTHERSHIP: Descriptions.COMMAND_DESCRIPTIONS.STATION_LINK_TO_MOTHERSHIP,
    STATION_STOP: Descriptions.COMMAND_DESCRIPTIONS.STATION_STOP,
    STATION_RECYCLE: Descriptions.COMMAND_DESCRIPTIONS.STATION_RECYCLE,
    STATION_INFO: Descriptions.COMMAND_DESCRIPTIONS.STATION_INFO,
    
    RUN_WIRE: Descriptions.COMMAND_DESCRIPTIONS.RUN_WIRE,
    STATION_REPAIR: Descriptions.COMMAND_DESCRIPTIONS.STATION_REPAIR,
    WIRE_REPAIR: Descriptions.COMMAND_DESCRIPTIONS.WIRE_REPAIR,
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
        _:
            Sc.logger.error("Commands.get_string: %s" % str(type))
            return ""
