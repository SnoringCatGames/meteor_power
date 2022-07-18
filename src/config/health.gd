class_name Health
extends Reference


const BOT_CONSTRUCTOR := 300
const BOT_LINE_RUNNER := 300
const BOT_BARRIER := 300

const STATION_COMMAND := 300
const STATION_SOLAR := 300
const STATION_SCANNER := 300
const STATION_BATTERY := 300
const STATION_EMPTY := -1

const POWER_LINE := 100

const BARRIER_PYLON := 200

const METEOR_DAMAGE := 100


static func get_default_capacity(entity_command_type: int) -> int:
    match entity_command_type:
        CommandType.BOT_CONSTRUCTOR:
            return BOT_CONSTRUCTOR
        CommandType.BOT_LINE_RUNNER:
            return BOT_LINE_RUNNER
        CommandType.BOT_BARRIER:
            return BOT_BARRIER
        
        CommandType.STATION_COMMAND:
            return STATION_COMMAND
        CommandType.STATION_SOLAR:
            return STATION_SOLAR
        CommandType.STATION_SCANNER:
            return STATION_SCANNER
        CommandType.STATION_BATTERY:
            return STATION_BATTERY
        CommandType.STATION_EMPTY:
            return STATION_EMPTY
        
        CommandType.RUN_WIRE:
            return POWER_LINE
        
        CommandType.BARRIER_PYLON:
            return BARRIER_PYLON
        
        _:
            Sc.logger.error("Health.get_default_capacity")
            return -1
