tool
class_name TestCharacter
extends SurfacerCharacter


#func _on_started_colliding(
#        target: Node2D,
#        layer_names: Array) -> void:
#    match layer_names[0]:
#        "foo":
#            pass
#        _:
#            Sc.logger.error()


func _process_sounds() -> void:
    if just_triggered_jump:
        Sc.audio.play_sound("test_character_jump")
    
    if surface_state.just_left_air:
        Sc.audio.play_sound("test_character_land")
    elif surface_state.just_touched_surface:
        Sc.audio.play_sound("test_character_hit_surface")
