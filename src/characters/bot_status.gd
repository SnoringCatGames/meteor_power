class_name BotStatus
extends Reference


enum {
    UNKNOWN,
    NEW,
    ACTIVE,
    IDLE,
    SELECTED,
    HOVERED,
    POWERED_DOWN,
    STOPPING,
}

const HIGHLIGHT_CONFIGS := {
    NEW: {
        color = "new",
        scale = 0.1,
        energy = 1.0,
        outline_alpha = 0.2,
    },
    ACTIVE: {
        color = "active",
        scale = 0.1,
        energy = 0.3,
        outline_alpha = 0.0,
    },
    IDLE: {
        color = "idle",
        scale = 0.1,
        energy = 0.8,
        outline_alpha = 0.2,
    },
    STOPPING: {
        color = "stopping",
        scale = 0.1,
        energy = 0.9,
        outline_alpha = 0.0,
    },
    SELECTED: {
        color = "selected",
        scale = 0.1,
        energy = 1.1,
        outline_alpha = 0.5,
    },
    HOVERED: {
        color = "hovered",
        scale = 0.1,
        energy = 1.1,
        outline_alpha = 0.5,
    },
    POWERED_DOWN: {
        color = "powered_down",
        scale = 0.1,
        energy = 0.6,
        outline_alpha = 0.5,
    },
}


static func get_string(type: int) -> String:
    match type:
        UNKNOWN:
            return "UNKNOWN"
        NEW:
            return "NEW"
        ACTIVE:
            return "ACTIVE"
        IDLE:
            return "IDLE"
        SELECTED:
            return "SELECTED"
        HOVERED:
            return "HOVERED"
        POWERED_DOWN:
            return "POWERED_DOWN"
        STOPPING:
            return "STOPPING"
        _:
            Sc.logger.error("BotStatus.get_string")
            return ""
