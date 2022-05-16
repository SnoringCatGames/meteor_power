class_name BotCommand
extends Reference


enum {
    UNKNOWN,
    MOVE,
    STOP,
    RUN_POWER_LINE,
    DESTROY_STATION,
    STATION_REPAIR,
    BUILD_STATION,
    POWER_ON_BOT,
    BUILD_BOT,
    BOT_RECYCLE,
}


static func get_string(type: int) -> String:
    match type:
        UNKNOWN:
            return "UNKNOWN"
        MOVE:
            return "MOVE"
        STOP:
            return "STOP"
        RUN_POWER_LINE:
            return "RUN_POWER_LINE"
        DESTROY_STATION:
            return "DESTROY_STATION"
        STATION_REPAIR:
            return "STATION_REPAIR"
        BUILD_STATION:
            return "BUILD_STATION"
        POWER_ON_BOT:
            return "POWER_ON_BOT"
        BUILD_BOT:
            return "BUILD_BOT"
        BOT_RECYCLE:
            return "BOT_RECYCLE"
        _:
            Sc.logger.error("BotCommand.get_string")
            return ""
