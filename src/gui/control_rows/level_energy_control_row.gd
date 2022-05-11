class_name LevelEnergyControlRow
extends CustomControlRow


const LABEL := "Energy:"
const DESCRIPTION := ""

const _ENERGY_LABEL_SCENE := preload(
    "res://src/gui/energy_label.tscn")

var header: ScaffolderLabel
var energy_label: EnergyLabel

var text: String


func _init(__ = null).(
        LABEL,
        DESCRIPTION \
        ) -> void:
    pass


func _update_control() -> void:
    var current_energy: int = \
        Sc.levels.session.current_energy if \
        Sc.levels.session.has_started else \
        0
    var total_energy: int = \
        Sc.levels.session.total_energy if \
        Sc.levels.session.has_started else \
        0
    var total_energy_str := str(total_energy)
    var current_energy_str := Sc.utils.pad_string(
        str(current_energy),
        total_energy_str.length(),
        false)
    text = " %s / %s" % [current_energy_str, total_energy_str]
    if is_instance_valid(energy_label):
        energy_label.text = text


func create_control() -> Control:
    var container: Control
    
    header = Sc.gui.SCAFFOLDER_LABEL_SCENE.instance()
    header.text = "Energy:"
    
    energy_label = _ENERGY_LABEL_SCENE.instance()
    energy_label.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
    
    if is_in_hud:
        # Display in two centered rows.
        container = VBoxContainer.new()
        
        var header_hbox := HBoxContainer.new()
        header_hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        container.add_child(header_hbox)
        
        var header_spacer1 := Control.new()
        header_spacer1.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        header_hbox.add_child(header_spacer1)
        
        header.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
        header_hbox.add_child(header)
        
        var header_spacer2 := Control.new()
        header_spacer2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        header_hbox.add_child(header_spacer2)
        
        var vspacer: Spacer = Sc.utils.add_scene(container, Sc.gui.SPACER_SCENE)
        vspacer.size = Vector2(0.0, BotsControlRow.MARGIN_Y)
        
        var hbox := HBoxContainer.new()
        hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        container.add_child(hbox)
        
        var spacer1 := Control.new()
        spacer1.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        hbox.add_child(spacer1)
        
        hbox.add_child(energy_label)
        
        var spacer2 := Control.new()
        spacer2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        hbox.add_child(spacer2)
        
    else:
        # Display in one justified row.
        container = HBoxContainer.new()
        container.add_child(header)
        container.add_child(energy_label)
        
        header.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        header.align = Label.ALIGN_LEFT
        energy_label.size_flags_horizontal = Control.SIZE_SHRINK_END
    
    container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    
    _set_font_size(font_size)
    _update_control()
    
    return container


func _set_font_size(value: String) -> void:
    ._set_font_size(value)
    
    if !is_instance_valid(energy_label):
        return
    
    header.font_size = value
    energy_label.font_size = value
