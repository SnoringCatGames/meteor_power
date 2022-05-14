tool
class_name InfoPanelHealthLabel, \
"res://addons/scaffolder/assets/images/editor_icons/progress_bar.png"
extends Control


var bar_width := 160.0
var bar_height := 14.0
var icon_scale := 2.0

var entity


func set_up() -> void:
    $Health.entity = entity
    _on_gui_scale_changed()


func _on_gui_scale_changed() -> bool:
    $Health.width = bar_width * Sc.gui.scale
    $Health.height = bar_height * Sc.gui.scale
    $Health.icon_scale = icon_scale * Sc.gui.scale
    
    update()
    
    self.rect_min_size.x = bar_width * Sc.gui.scale
    self.rect_min_size.y = $Health.get_height()
    
    $Health.position.y = (self.rect_min_size.y - $Health.height) / 2.0
    
    return true


func update() -> void:
    if !is_instance_valid(entity):
        return
    
    $Health.update()
