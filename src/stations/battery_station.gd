tool
class_name BatteryStation
extends Station


const ENTITY_COMMAND_TYPE := CommandType.STATION_BATTERY


func _init().(ENTITY_COMMAND_TYPE) -> void:
    pass


func _ready() -> void:
    Sc.slow_motion.set_time_scale_for_node($AnimationPlayer)


func get_buttons() -> Array:
    return [
        CommandType.RUN_WIRE,
#        CommandType.STATION_RECYCLE,
    ]


func _get_radial_menu_item_types() -> Array:
    return [
        CommandType.RUN_WIRE,
        CommandType.STATION_RECYCLE,
        CommandType.STATION_INFO,
    ]


func _on_transitively_connected_to_command_center() -> void:
    Sc.logger.print("BatteryStation._on_transitively_connected_to_command_center")
    $Disconnected.visible = false
    $Connected.visible = true
    $AnimationPlayer.play("connected")


func _on_transitively_disconnected_from_command_center() -> void:
    Sc.logger.print("BatteryStation._on_transitively_disconnected_from_command_center")
    $Disconnected.visible = true
    $Connected.visible = false
    $AnimationPlayer.play("disconnected")


func _update_outline() -> void:
    for sprite in [$Connected, $Disconnected]:
        sprite.is_outlined = active_outline_alpha_multiplier > 0.0
        sprite.outline_color = outline_color
        sprite.outline_color.a *= active_outline_alpha_multiplier
