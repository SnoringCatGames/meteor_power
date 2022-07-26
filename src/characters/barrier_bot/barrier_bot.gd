tool
class_name BarrierBot
extends Bot


const ENTITY_COMMAND_TYPE := CommandType.BOT_BARRIER


func _init().(ENTITY_COMMAND_TYPE) -> void:
    pass


func _get_radial_menu_item_types() -> Array:
    return [
        CommandType.BOT_COMMAND,
        CommandType.BARRIER_PYLON,
        CommandType.BOT_STOP,
        CommandType.BOT_RECYCLE,
        CommandType.BOT_INFO,
    ]


func get_can_handle_command(type: int) -> bool:
    match type:
        CommandType.BOT_COMMAND, \
        CommandType.BOT_STOP, \
        CommandType.BOT_MOVE, \
        CommandType.BOT_RECYCLE, \
        CommandType.BARRIER_PYLON, \
        CommandType.BARRIER_RECYCLE:
            return true
        
        _:
            return false


func _on_radial_menu_item_selected(item: RadialMenuItem) -> void:
    if item.id == CommandType.BARRIER_PYLON:
        set_is_player_control_active(true)
        Sc.level.enter_barrier_pylon_placement_mode()
    else:
        ._on_radial_menu_item_selected(item)


func _on_reached_position_to_build_barrier_pylon() -> void:
    assert(command.meta is PositionAlongSurface)
    Sc.level.add_barrier_pylon(command.meta.target_point)
    Sc.level.deduct_energy(Cost.BARRIER_PYLON)
    # FIXME: ------------------ Play sound.


func _on_reached_position_to_move_barrier_pylon() -> void:
    assert(command.meta is PositionAlongSurface)
    # FIXME: ------------------ Play sound.
    # FIXME: ----------------------------------------


func _on_reached_position_to_recycle_barrier_pylon() -> void:
    assert(command.meta is BarrierPylon)
    # FIXME: ------------------ Play sound.
    
    if !is_instance_valid(command) or \
            !is_instance_valid(command.meta):
        # The barrier pylon has been destroyed.
        # FIXME: Play error sound
        Sc.audio.play_sound("nav_select_fail")
        return
    
    # FIXME: Play sound and particles
    Sc.audio.play_sound("command_finished")
    assert(is_instance_valid(command.meta))
    Sc.level.deduct_energy(CommandType.COSTS[CommandType.BARRIER_RECYCLE])
    Sc.level.remove_barrier_pylon(command.meta)
