class_name BotStatus
extends Reference


enum {
    UNKNOWN,
    NEW,
    ACTIVE,
    IDLE,
    PLAYER_CONTROL_ACTIVE,
    SELECTED,
    HOVERED,
    STOPPING,
}

const HIGHLIGHT_CONFIGS := {
    NEW: {
        color = "bot_new",
        scale = 0.1,
        energy = 1.0,
        outline_alpha_multiplier = 0.99,
    },
    ACTIVE: {
        color = "bot_active",
        scale = 0.1,
        energy = 0.3,
        outline_alpha_multiplier = 0.99,
    },
    IDLE: {
        color = "bot_idle",
        scale = 0.1,
        energy = 0.8,
        outline_alpha_multiplier = 0.99,
    },
    PLAYER_CONTROL_ACTIVE: {
        color = "bot_player_control_active",
        scale = 0.1,
        energy = 1.1,
        outline_alpha_multiplier = 0.99,
    },
    SELECTED: {
        color = "bot_selected",
        scale = 0.1,
        energy = 1.1,
        outline_alpha_multiplier = 0.99,
    },
    HOVERED: {
        color = "bot_hovered",
        scale = 0.1,
        energy = 1.1,
        outline_alpha_multiplier = 0.99,
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
        PLAYER_CONTROL_ACTIVE:
            return "PLAYER_CONTROL_ACTIVE"
        SELECTED:
            return "SELECTED"
        HOVERED:
            return "HOVERED"
        STOPPING:
            return "STOPPING"
        _:
            Sc.logger.error("BotStatus.get_string")
            return ""
