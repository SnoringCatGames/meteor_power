class_name StatusOverlay, \
"res://addons/scaffolder/assets/images/editor_icons/scaffolder_node.png"
extends Node2D


# FIXME: ---------------- Implement energy consumption.

var margin := 8.0

var anchor_y := 0.0

var bar_width := 30.0
var bar_height := 3.0

var entity


func set_up() -> void:
    $Health.width = bar_width
    $Health.height = bar_height
    $Health.entity = entity
    
    self.position.x = 0.0
    self.position.y = anchor_y - margin
    
    $Health.position.x = -bar_width / 2.0
    $Health.position.y = -bar_height
    
    update()


func update() -> void:
    if !is_instance_valid(entity):
        return
    
    $Health.update()
    
    $Health.visible = entity.get_health() != entity.get_health_capacity()
