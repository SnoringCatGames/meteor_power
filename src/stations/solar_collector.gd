tool
class_name SolarCollector
extends Station


var seconds_per_one_energy_value := 0.05
var total_seconds := 0.0

var start_time := INF
var total_time := INF


func _ready() -> void:
    start_time = Sc.time.get_scaled_play_time()
    total_time = 0.0


func _physics_process(delta: float) -> void:
    var previous_total_time := total_time
    total_time = Sc.time.get_scaled_play_time() - start_time
    
    if is_connected_to_command_center:
        if int(previous_total_time / seconds_per_one_energy_value) != \
                int(total_time / seconds_per_one_energy_value):
            Sc.level.add_energy(1)


func get_buttons() -> Array:
    return [
        OverlayButtonType.RUN_WIRE,
#        OverlayButtonType.DESTROY,
    ]


func get_disabled_buttons() -> Array:
    return []


func get_name() -> String:
    return "solar"


func _on_connected_to_command_center() -> void:
    Sc.logger.print("SolarCollector._on_connected_to_command_center")
    $Dark.visible = false
    $Shine.visible = true
    $AnimationPlayer.play("shine")


func _on_disconnected_from_command_center() -> void:
    Sc.logger.print("SolarCollector._on_disconnected_from_command_center")
    $Dark.visible = true
    $Shine.visible = false
    $AnimationPlayer.play("dark")


func _on_hit_by_meteor() -> void:
    ._on_hit_by_meteor()
    if meteor_hit_count >= 3:
        Sc.level.replace_station(self, "empty")
