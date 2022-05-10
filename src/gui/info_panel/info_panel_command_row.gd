tool
class_name InfoPanelCommandRow
extends VBoxContainer


var command := Commands.UNKNOWN


func set_up(command) -> void:
    self.command = command
    
    var cost: int = Commands.COSTS[command]
#    var label: String = Commands.COMMAND_LABELS[command]
    var texture: Texture = Commands.TEXTURES[command]
    var description_lines: Array = Commands.COMMAND_DESCRIPTIONS[command]
    
    $HBoxContainer/VBoxContainer2/ScaffolderTextureRect.texture = texture
    $HBoxContainer/VBoxContainer2/ScaffolderTextureRect.modulate = \
        Sc.gui.hud.radial_menu_item_normal_color_modulate.sample()
    
    $HBoxContainer/VBoxContainer2/EnergyLabel.modulate.a = \
            1.0 if \
            cost != 0 else \
            0.0
    if cost > 0:
        $HBoxContainer/VBoxContainer2/EnergyLabel.cost = cost
    elif cost < 0:
        $HBoxContainer/VBoxContainer2/EnergyLabel.text = "?"
    
    for line in description_lines:
        var row: ScaffolderLabel = Sc.utils.add_scene(
            $HBoxContainer/VBoxContainer, Sc.gui.SCAFFOLDER_LABEL_SCENE)
        row.text = line
        row.font_size = "Xs"
        row.align = Label.ALIGN_LEFT
        row.autowrap = true
