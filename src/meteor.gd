class_name Meteor
extends Area2D


const MAX_Y := 10000.0

var LARGE_RADIUS := 15.0
var SMALL_RADIUS := 7.0

var DEFAULT_SPEED := 200.0

var velocity: Vector2

var is_large := false

var _is_running := false

var _last_scaled_time := INF


func _ready() -> void:
    _set_up_desaturatable()
    Sc.slow_motion.set_time_scale_for_node($LargeTail)
    Sc.slow_motion.set_time_scale_for_node($SmallTail)


func _set_up_desaturatable() -> void:
    var sprites: Array = \
        Sc.utils.get_children_by_type(self, Sprite, true)
    var animated_sprites: Array = \
        Sc.utils.get_children_by_type(self, AnimatedSprite, true)
    for collection in [sprites, animated_sprites]:
        for node in collection:
            node.add_to_group(Sc.slow_motion.GROUP_NAME_DESATURATABLES)


func run() -> void:
    _is_running = true
    
    _last_scaled_time = Sc.time.get_scaled_play_time()
    
    if is_large:
        $Large.visible = true
        $LargeTail.visible = true
        $CollisionShape2D.shape.radius = LARGE_RADIUS
        $Small.visible = false
        $SmallTail.visible = false
    else:
        $Small.visible = true
        $SmallTail.visible = true
        $CollisionShape2D.shape.radius = SMALL_RADIUS
        $Large.visible = false
        $LargeTail.visible = false
    
    var rotation := PI * (randf() * 1.0/6.0 - 1.0/12.0)
    self.rotation = rotation
    
    var speed := DEFAULT_SPEED * (1.0 + randf() * 0.2 - 0.1)
    velocity = Vector2.DOWN.rotated(rotation) * speed


func get_radius() -> float:
    return LARGE_RADIUS if is_large else SMALL_RADIUS


func _physics_process(delta: float) -> void:
    var current_scaled_time := Sc.time.get_scaled_play_time()
    var elapsed_scaled_time := current_scaled_time - _last_scaled_time
    _last_scaled_time = current_scaled_time
    
    self.position += velocity * elapsed_scaled_time
    
    if position.y > MAX_Y:
        _destroy()


func _on_Meteor_body_entered(body) -> void:
    if body is TileMap:
#        Sc.logger.print("Meteor hit tilemap")
        Sc.audio.play_sound("meteor_land")
        _destroy()


func _on_Meteor_area_entered(area) -> void:
    if area is Station and !area is EmptyStation:
#        Sc.logger.print("Meteor hit station")
        area._on_hit_by_meteor(self)
        Sc.audio.play_sound("meteor_land")
        _destroy()
    elif area.has_meta("PowerLine"):
#        Sc.logger.print("Meteor hit power-line")
        var power_line = area.get_meta("PowerLine")
        power_line._on_hit_by_meteor(self)
        Sc.audio.play_sound("meteor_land")
        _destroy()


func _on_collided_with_bot(bot) -> void:
    Sc.logger.print("Meteor hit bot")
    Sc.audio.play_sound("meteor_land")
    _destroy()


func _destroy() -> void:
    # FIXME: sfx, particles
    self.queue_free()
    pass
