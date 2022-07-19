class_name GamePathPreselectionAnnotator
extends PathPreselectionAnnotator


const BARRIER_PYLON_PHANTOM_SCENE := preload(
    "res://src/barrier/barrier_pylon_phantom.tscn")

var _barrier_pylon_phantom: Phantom


func _draw() -> void:
    if !Sc.level.is_in_barrier_pylon_placement_mode or \
            !is_instance_valid(last_player_character) or \
            !last_player_character.touch_listener.get_is_drag_active():
        if is_instance_valid(_barrier_pylon_phantom):
            _barrier_pylon_phantom.queue_free()
            _barrier_pylon_phantom = null
        return
    
    if !is_instance_valid(_barrier_pylon_phantom):
        _barrier_pylon_phantom = \
            Sc.utils.add_scene(self, BARRIER_PYLON_PHANTOM_SCENE)
    
    # Render a phantom at the cursor position.
    _barrier_pylon_phantom.position = \
        last_player_character.touch_listener._last_pointer_drag_position
