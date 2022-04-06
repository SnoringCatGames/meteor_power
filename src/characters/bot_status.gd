class_name BotStatus
extends Reference


enum {
    UNKNOWN,
    NEW,
    ACTIVE,
    IDLE,
    SELECTED,
    POWERED_DOWN,
    STOPPING,
}

const HIGHLIGHT_CONFIGS := {
    NEW: {
        color = Color("e0b400"),
        scale = 0.1,
        energy = 1.0,
    },
    ACTIVE: {
        color = Color("53c700"),
        scale = 0.1,
        energy = 0.3,
    },
    IDLE: {
        color = Color("ffd000"),
        scale = 0.1,
        energy = 0.8,
    },
    STOPPING: {
        color = Color("ffd000"),
        scale = 0.1,
        energy = 0.9,
    },
    SELECTED: {
        color = Color("1cb0ff"),
        scale = 0.1,
        energy = 1.1,
    },
    POWERED_DOWN: {
        color = Color("cc2c16"),
        scale = 0.1,
        energy = 0.6,
    },
}
