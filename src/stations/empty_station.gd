tool
class_name EmptyStation
extends Station


func get_buttons() -> Array:
    return [
        OverlayButtonType.SOLAR_COLLECTOR,
    ]


func get_disabled_buttons() -> Array:
    return []


func get_name() -> String:
    return "empty"
