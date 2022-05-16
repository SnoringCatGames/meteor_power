tool
class_name BatteryStation
extends Station


const ENTITY_COMMAND_TYPE := Command.STATION_BATTERY
const IS_CONNECTABLE := true


func _init().(ENTITY_COMMAND_TYPE, IS_CONNECTABLE) -> void:
    pass


func get_buttons() -> Array:
    return [
        Command.RUN_WIRE,
#        Command.STATION_RECYCLE,
    ]


func _get_radial_menu_item_types() -> Array:
    return [
        Command.RUN_WIRE,
        Command.STATION_RECYCLE,
        Command.STATION_INFO,
    ]


func _on_connected_to_command_center() -> void:
    Sc.logger.print("BatteryStation._on_connected_to_command_center")
    $Disconnected.visible = false
    $Connected.visible = true
    $AnimationPlayer.play("connected")


func _on_disconnected_from_command_center() -> void:
    Sc.logger.print("BatteryStation._on_disconnected_from_command_center")
    $Disconnected.visible = true
    $Connected.visible = false
    $AnimationPlayer.play("disconnected")


func _update_outline() -> void:
    for sprite in [$Connected, $Disconnected]:
        sprite.is_outlined = active_outline_alpha_multiplier > 0.0
        sprite.outline_color = outline_color
        sprite.outline_color.a *= active_outline_alpha_multiplier
