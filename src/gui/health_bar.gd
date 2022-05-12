class_name HealthBar, \
"res://addons/scaffolder/assets/images/editor_icons/scaffolder_node.png"
extends StatusBar


func update() -> void:
    if !is_instance_valid(entity):
        return
    
    current = entity.get_health()
    capacity = entity.get_health_capacity()
    background_color = Sc.palette.get_color("health_bar_background")
    full_color = Sc.palette.get_color("health_bar_full")
    medium_color = Sc.palette.get_color("health_bar_medium")
    empty_color = Sc.palette.get_color("health_bar_empty")
    
    .update()
