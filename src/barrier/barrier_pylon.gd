tool
class_name BarrierPylon
extends Node2D


func _ready() -> void:
    Sc.slow_motion.set_time_scale_for_node($AnimationPlayer)


func _update_outline() -> void:
    # FIXME: LEFT OFF HERE: -----------------------
    pass
#    $TextureOutlineableSprite.is_outlined = active_outline_alpha_multiplier > 0.0
#    $TextureOutlineableSprite.outline_color = outline_color
#    $TextureOutlineableSprite.outline_color.a *= active_outline_alpha_multiplier
