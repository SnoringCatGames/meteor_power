class_name Upgrade
extends Reference


# FIXME: LEFT OFF HERE: -----------------------


enum {
    UNKNOWN,
    
    # FIXME: ------------- Revisit these; implement all; add anything else? Cheapness upgrades?
    
    BOT_LINE_RUNNER,
    BOT_BARRIER,
    
    STATION_SCANNER,
    STATION_BATTERY,
    
    FASTER_BOT_MOVEMENT,
    FASTER_BUILDS,
    FASTER_REPAIRS,
    AUTO_PASSING_REPAIR,
    AUTO_NEARBY_REPAIR,
    LINE_RUNNER_WALL_GRIP,
    LINE_RUNNER_WIRE_REPAIR,
    BOT_HEALTH_INCREASE,
    
    SOLAR_EFFICIENCY,
    COMMAND_CENTER_SHIELD_EFFICIENCY,
    SCANNER_RADIUS_INCREASE,
    STATION_HEALTH_INCREASE,
    
    METEOROLOGY,
    WIRE_HEALTH_INCREASE,
    
    # Unlock new levels.
    INTER_STELLAR_TRAVEL_1,
    INTER_STELLAR_TRAVEL_2,
    INTER_STELLAR_TRAVEL_3,
    INTER_STELLAR_TRAVEL_4,
}

const VALUES := [
    UNKNOWN,
    
    BOT_LINE_RUNNER,
    BOT_BARRIER,
    
    STATION_SCANNER,
    STATION_BATTERY,
    
    FASTER_BOT_MOVEMENT,
    FASTER_BUILDS,
    FASTER_REPAIRS,
    AUTO_PASSING_REPAIR,
    AUTO_NEARBY_REPAIR,
    LINE_RUNNER_WALL_GRIP,
    LINE_RUNNER_WIRE_REPAIR,
    BOT_HEALTH_INCREASE,
    
    SOLAR_EFFICIENCY,
    COMMAND_CENTER_SHIELD_EFFICIENCY,
    SCANNER_RADIUS_INCREASE,
    STATION_HEALTH_INCREASE,
    
    METEOROLOGY,
    WIRE_HEALTH_INCREASE,
    
    INTER_STELLAR_TRAVEL_1,
    INTER_STELLAR_TRAVEL_2,
    INTER_STELLAR_TRAVEL_3,
    INTER_STELLAR_TRAVEL_4,
]


static func get_string(type: int) -> String:
    match type:
        UNKNOWN:
            return "UNKNOWN"
        BOT_LINE_RUNNER:
            return "BOT_LINE_RUNNER"
        BOT_BARRIER:
            return "BOT_BARRIER"
        
        STATION_SCANNER:
            return "STATION_SCANNER"
        STATION_BATTERY:
            return "STATION_BATTERY"
        
        FASTER_BOT_MOVEMENT:
            return "FASTER_BOT_MOVEMENT"
        FASTER_BUILDS:
            return "FASTER_BUILDS"
        FASTER_REPAIRS:
            return "FASTER_REPAIRS"
        AUTO_PASSING_REPAIR:
            return "AUTO_PASSING_REPAIR"
        AUTO_NEARBY_REPAIR:
            return "AUTO_NEARBY_REPAIR"
        LINE_RUNNER_WALL_GRIP:
            return "LINE_RUNNER_WALL_GRIP"
        LINE_RUNNER_WIRE_REPAIR:
            return "LINE_RUNNER_WIRE_REPAIR"
        BOT_HEALTH_INCREASE:
            return "BOT_HEALTH_INCREASE"
        
        SOLAR_EFFICIENCY:
            return "SOLAR_EFFICIENCY"
        COMMAND_CENTER_SHIELD_EFFICIENCY:
            return "COMMAND_CENTER_SHIELD_EFFICIENCY"
        SCANNER_RADIUS_INCREASE:
            return "SCANNER_RADIUS_INCREASE"
        STATION_HEALTH_INCREASE:
            return "STATION_HEALTH_INCREASE"
        
        METEOROLOGY:
            return "METEOROLOGY"
        WIRE_HEALTH_INCREASE:
            return "WIRE_HEALTH_INCREASE"
        
        INTER_STELLAR_TRAVEL_1:
            return "INTER_STELLAR_TRAVEL_1"
        INTER_STELLAR_TRAVEL_2:
            return "INTER_STELLAR_TRAVEL_2"
        INTER_STELLAR_TRAVEL_3:
            return "INTER_STELLAR_TRAVEL_3"
        INTER_STELLAR_TRAVEL_4:
            return "INTER_STELLAR_TRAVEL_4"
        
        _:
            Sc.logger.error("TutorialMode.get_string")
            return ""
