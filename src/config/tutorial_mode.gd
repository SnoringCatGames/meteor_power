class_name TutorialMode
extends Reference


# FIXME: LEFT OFF HERE: -----------------------


enum {
    UNKNOWN,
    
    NONE,
}


static func get_string(type: int) -> String:
    match type:
        UNKNOWN:
            return "UNKNOWN"
        NONE:
            return "NONE"
        _:
            Sc.logger.error("TutorialMode.get_string")
            return ""
