tool
class_name InfoPanelHealthLabel, \
"res://addons/scaffolder/assets/images/editor_icons/progress_bar.png"
extends Control


var bar_width := 160.0
var bar_height := 16.0

var entity


func set_up() -> void:
    $Health.entity = entity
    _on_gui_scale_changed()


func _on_gui_scale_changed() -> bool:
    $Health.width = bar_width * Sc.gui.scale
    $Health.height = bar_height * Sc.gui.scale
    
    self.rect_min_size.x = bar_width * Sc.gui.scale
    self.rect_min_size.y = bar_height * Sc.gui.scale
    
    update()
    
    return true


func update() -> void:
    if !is_instance_valid(entity):
        return
    
    $Health.update()
