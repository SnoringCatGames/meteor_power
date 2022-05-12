class_name Healths
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

const METEOR_DAMAGE := 100


static func get_default_capacity(entity_command_type: int) -> int:
    match entity_command_type:
        Commands.BOT_CONSTRUCTOR:
            return BOT_CONSTRUCTOR
        Commands.BOT_LINE_RUNNER:
            return BOT_LINE_RUNNER
        Commands.BOT_BARRIER:
            return BOT_BARRIER
        
        Commands.STATION_COMMAND:
            return STATION_COMMAND
        Commands.STATION_SOLAR:
            return STATION_SOLAR
        Commands.STATION_SCANNER:
            return STATION_SCANNER
        Commands.STATION_BATTERY:
            return STATION_BATTERY
        Commands.STATION_EMPTY:
            return STATION_EMPTY
        
        Commands.RUN_WIRE:
            return POWER_LINE
        
        _:
            Sc.logger.error("Healths.get_default_capacity")
            return -1
