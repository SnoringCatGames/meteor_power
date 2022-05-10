class_name Descriptions
extends Reference


# FIXME: ----------- Update descriptions after finishing and polishing gameplay.

const NOT_ENOUGH_ENERGY := "Not enough energy."

const ENTITY_NAMES := {
    BOT_CONSTRUCTOR = "Constructor bot",
    BOT_LINE_RUNNER = "Line-runner bot",
    BOT_BARRIER = "Barrier bot",
    
    STATION_EMPTY = "Empty station site",
    STATION_COMMAND = "Command center",
    STATION_SOLAR = "Solar station",
    STATION_SCANNER = "Scanner station",
    STATION_BATTERY = "Battery station",
}

const ENTITY_DESCRIPTIONS := {
    BOT_CONSTRUCTOR = [
        "Can build new stations.",
        "Can run wires.",
        "Slow movement.",
        "Fast repair.",
    ],
    BOT_LINE_RUNNER = [
        "Can repair stations.",
        "Can run wires.",
        "Fast movement.",
    ],
    BOT_BARRIER = [
        "Can build barriers.",
        "Slow movement.",
    ],
    
    STATION_EMPTY = [
        "An empty site where a station could be built.",
#        "Buy now! Real estate is a great investment!",
    ],
    STATION_COMMAND = [
        "Collects energy and relays it to the mother ship.",
        "Controls other stations and bots.",
        "Constantly consumes energy to power a force field, which blocks incoming meteors.",
        "It's game-over when this is destroyed!",
    ],
    STATION_SOLAR = [
        "Collects solar energy.",
        "Must be connected to the command center or a battery station.",
    ],
    STATION_SCANNER = [
        "Detects incoming meteors.",
        "Must be connected to the command center or a battery station.",
    ],
    STATION_BATTERY = [
        "Stores energy.",
        "Useful when disconnected from the command center.",
    ],
}

const COMMAND_LABELS := {
    BOT_CONSTRUCTOR = "Build construction bot",
    BOT_LINE_RUNNER = "Build line-runner bot",
    BOT_BARRIER = "Build barrier bot",
    BOT_COMMAND = "Command this bot",
    BOT_STOP = "Stop",
    BOT_MOVE = "Move bot",
    BOT_RECYCLE = "Recycle",
    BOT_INFO = "Info",
    
    STATION_EMPTY = "",
    STATION_COMMAND = "",
    STATION_SOLAR = "Build solar station",
    STATION_SCANNER = "Build scanner station",
    STATION_BATTERY = "Build battery station",
    STATION_RECYCLE = "Recycle",
    STATION_INFO = "Info",
    
    RUN_WIRE = "Run wire",
}

const COMMAND_DESCRIPTIONS := {
    BOT_CONSTRUCTOR = [
        "Builds a new constructor bot, which can build and repair stations.",
    ],
    BOT_LINE_RUNNER = [
        "Builds a new line-runner bot, which can run lines and repair stations.",
    ],
    BOT_BARRIER = [
        "Builds a new line-runner bot, which can build barriers.",
    ],
    BOT_COMMAND = [
        "Selects this bot for the next command to build a station, run a wire, or just move.",
    ],
    BOT_STOP = [
        "Cancels this bot's current command and stops their movement.",
    ],
    BOT_MOVE = [
    ],
    BOT_RECYCLE = [
        "Recycles this bot so something better can be made.",
    ],
    BOT_INFO = [
        "Shows more information about this bot.",
    ],
    
    STATION_EMPTY = [
    ],
    STATION_COMMAND = [
    ],
    STATION_SOLAR = [
        "Build a solar station, which collects solar energy.",
    ],
    STATION_SCANNER = [
        "Build a solar station, which detects incoming meteors.",
    ],
    STATION_BATTERY = [
        "Build a solar station, which stores energy for use when disconnected from the command center.",
    ],
    STATION_RECYCLE = [
        "Recycles this station so something better can be made.",
    ],
    STATION_INFO = [
        "Shows more information about this station.",
    ],
    
    RUN_WIRE = [
        "Runs a wire to connect this station to another.",
    ],
}
