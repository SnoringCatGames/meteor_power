class_name BarrierEnergyField
extends Node2D


const BARRIER_ENERGY_SCENE := preload("res://src/barrier/barrier_energy.tscn")
const BARRIER_ENERGY_WIDTH := 88.0

var first_pylon
var second_pylon

var collision_segment: SegmentShape2D


func _ready() -> void:
    collision_segment = $CollisionShape2D.shape


func set_pylons(
        first_pylon,
        second_pylon) -> void:
    self.first_pylon = first_pylon
    self.second_pylon = second_pylon
    
    collision_segment.a = first_pylon.position
    collision_segment.b = second_pylon.position
    
    # FIXME: ---------------------------------------
    # - Show some indication for how much energy is consumed by the force-field
    #   according to the distance.
    #   - Probably add an outlined version of the animation?
    #     - BUT, would need to force the outline to have a lower z-index, so no
    #       outlines appear above adjacent energy animations.
    
    var animation_rotation: float = \
        first_pylon.position.angle_to_point(second_pylon.position)
    var direction: Vector2 = \
        first_pylon.position.direction_to(second_pylon.position)
    var distance: float = \
        first_pylon.position.distance_to(second_pylon.position) - \
        BARRIER_ENERGY_WIDTH
    var displacement := distance * direction
    
    var start_position: Vector2 = \
        first_pylon.position + BARRIER_ENERGY_WIDTH / 2.0 * direction
    
    var animation_count := ceil(distance / BARRIER_ENERGY_WIDTH) + 1
    var animation_position_delta := displacement / (animation_count - 1)
    
    var animation_position := start_position
    for i in animation_count:
        var energy_animation: BarrierEnergy = \
            Sc.utils.add_scene(self, BARRIER_ENERGY_SCENE)
        energy_animation.position = animation_position
        energy_animation.rotation = animation_rotation
        animation_position += animation_position_delta


func _on_hit_by_meteor(meteor) -> void:
    # Do nothing.
    pass
