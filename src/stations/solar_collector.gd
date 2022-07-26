tool
class_name SolarCollector
extends Station


const ENTITY_COMMAND_TYPE := CommandType.STATION_SOLAR

const SECONDS_PER_ONE_ENERGY_VALUE := 0.05

var total_seconds := 0.0


func _init().(ENTITY_COMMAND_TYPE) -> void:
    pass


func _ready() -> void:
    Sc.slow_motion.set_time_scale_for_node($AnimationPlayer)


func _physics_process(delta: float) -> void:
    if is_connected_to_command_center:
        if int(previous_total_time / SECONDS_PER_ONE_ENERGY_VALUE) != \
                int(total_time / SECONDS_PER_ONE_ENERGY_VALUE):
            Sc.level.add_energy(1)


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
    ._on_transitively_connected_to_command_center()
    Sc.logger.print("SolarCollector._on_transitively_connected_to_command_center")
    $Dark.visible = false
    $Shine.visible = true
    $AnimationPlayer.play("shine")


func _on_transitively_disconnected_from_command_center() -> void:
    ._on_transitively_disconnected_from_command_center()
    Sc.logger.print("SolarCollector._on_transitively_disconnected_from_command_center")
    $Dark.visible = true
    $Shine.visible = false
    $AnimationPlayer.play("dark")


func _update_outline() -> void:
    for sprite in [$Shine, $Dark]:
        sprite.is_outlined = active_outline_alpha_multiplier > 0.0
        sprite.outline_color = outline_color
        sprite.outline_color.a *= active_outline_alpha_multiplier
