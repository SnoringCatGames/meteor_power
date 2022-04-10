class_name OverlayButtonType
extends Reference


enum {
    UNKNOWN,
    
    MOVE,
    
    DESTROY,
    
    RUN_WIRE,
    
    COMMAND_CENTER,
    SOLAR_COLLECTOR,
    SCANNER_STATION,
    BATTERY_STATION,
    
    BUILD_CONSTRUCTOR_BOT,
    BUILD_LINE_RUNNER_BOT,
    BUILD_REPAIR_BOT,
    BUILD_BARRIER_BOT,
    
    DYNAMIC_POWER_LINE_HIT,
    STATIC_POWER_LINE_HIT,
    STATION_HIT,
    BOT_HIT,
    
    BOT_ALIVE,
}


static func get_string(type: int) -> String:
    match type:
        MOVE:
            return "MOVE"
        DESTROY:
            return "DESTROY"
        RUN_WIRE:
            return "RUN_WIRE"
        COMMAND_CENTER:
            return "COMMAND_CENTER"
        SOLAR_COLLECTOR:
            return "SOLAR_COLLECTOR"
        SCANNER_STATION:
            return "SCANNER_STATION"
        BATTERY_STATION:
            return "BATTERY_STATION"
        BUILD_CONSTRUCTOR_BOT:
            return "BUILD_CONSTRUCTOR_BOT"
        BUILD_LINE_RUNNER_BOT:
            return "BUILD_LINE_RUNNER_BOT"
        BUILD_REPAIR_BOT:
            return "BUILD_REPAIR_BOT"
        BUILD_BARRIER_BOT:
            return "BUILD_BARRIER_BOT"
        DYNAMIC_POWER_LINE_HIT:
            return "DYNAMIC_POWER_LINE_HIT"
        STATIC_POWER_LINE_HIT:
            return "STATIC_POWER_LINE_HIT"
        STATION_HIT:
            return "STATION_HIT"
        BOT_HIT:
            return "BOT_HIT"
        BOT_ALIVE:
            return "BOT_ALIVE"
        _:
            Sc.logger.error("OverlayButtonType.get_string")
            return ""
