class_name BotCommand
extends Reference


enum {
    UNKNOWN,
    MOVE,
    STOP,
    RUN_POWER_LINE,
    DESTROY_STATION,
    REPAIR_STATION,
    BUILD_STATION,
    POWER_ON_BOT,
    BUILD_BOT,
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
        REPAIR_STATION:
            return "REPAIR_STATION"
        BUILD_STATION:
            return "BUILD_STATION"
        POWER_ON_BOT:
            return "POWER_ON_BOT"
        BUILD_BOT:
            return "BUILD_BOT"
        _:
            Sc.logger.error("BotCommand.get_string")
            return ""
