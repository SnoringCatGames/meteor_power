class_name PowerLinePhantom
extends Phantom


const POWER_LINE_WIDTH_RATIO := 1.5

var rope: StaticRope


func set_up(
        start_position: Vector2,
        end_position: Vector2) -> void:
    rope = StaticRope.new(
        start_position,
        end_position)
    update()


func _draw() -> void:
    if !is_instance_valid(rope):
        return
    draw_polyline(
        PoolVector2Array(rope.vertices),
        Color.white,
        PowerLine.ROPE_WIDTH * POWER_LINE_WIDTH_RATIO)
