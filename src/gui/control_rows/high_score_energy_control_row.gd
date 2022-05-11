class_name HighScoreEnergyControlRow
extends CustomControlRow


const LABEL := "High score:"
const DESCRIPTION := ""

const _ENERGY_LABEL_SCENE := preload("res://src/gui/energy_label.tscn")

var text_label: ScaffolderLabel
var energy_label: EnergyLabel

var text: String

var level_id: String


func _init(level_session_or_id).(
        LABEL,
        DESCRIPTION \
        ) -> void:
    self.level_id = \
            level_session_or_id.id if \
            level_session_or_id is ScaffolderLevelSession else \
            (level_session_or_id if \
            level_session_or_id is String else \
            "")


func _update_control() -> void:
    text = \
        str(Sc.save_state.get_level_high_score(level_id)) if \
        level_id != "" else \
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
