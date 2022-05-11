class_name ScoreEnergyControlRow
extends CustomControlRow


const LABEL := "Score:"
const DESCRIPTION := ""

const _ENERGY_LABEL_SCENE := preload("res://src/gui/energy_label.tscn")

var text_label: ScaffolderLabel
var energy_label: EnergyLabel

var text: String


func _init(__ = null).(
        LABEL,
        DESCRIPTION \
        ) -> void:
    pass


func _update_control() -> void:
    text = str(int(Sc.levels.session.score)) if \
            is_instance_valid(Sc.levels.session) else \
            "—"
    if is_instance_valid(energy_label):
        energy_label.text = text


func create_control() -> Control:
    var hbox := HBoxContainer.new()
    hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    
    text_label = Sc.utils.add_scene(hbox, Sc.gui.SCAFFOLDER_LABEL_SCENE)
    text_label.align = Label.ALIGN_LEFT
    text_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    text_label.text = LABEL
    
    energy_label = Sc.utils.add_scene(hbox, _ENERGY_LABEL_SCENE)
    energy_label.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
    
    _set_font_size(font_size)
    _update_control()
    
    return hbox


func _set_font_size(value: String) -> void:
    ._set_font_size(value)
    
    if !is_instance_valid(energy_label):
        return
    
    text_label.font_size = value
    energy_label.font_size = value
