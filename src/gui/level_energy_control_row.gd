class_name LevelEnergyControlRow
extends CustomControlRow


const LABEL := "Energy:"
const DESCRIPTION := ""

const _ENERGY_LABEL_SCENE := preload(
    "res://src/gui/energy_label.tscn")

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
        LevelSession.START_ENERGY
    var total_energy: int = \
        Sc.levels.session.total_energy if \
        Sc.levels.session.has_started else \
        LevelSession.START_ENERGY
    var total_energy_str := str(total_energy)
    var current_energy_str := Sc.utils.pad_string(
        str(current_energy),
        total_energy_str.length(),
        false)
    text = " %s / %s" % [current_energy_str, total_energy_str]
    if is_instance_valid(energy_label):
        energy_label.text = text


func create_control() -> Control:
    var hbox := HBoxContainer.new()
    hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    
    var spacer1 := Control.new()
    spacer1.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    hbox.add_child(spacer1)
    
    energy_label = Sc.utils.add_scene(hbox, _ENERGY_LABEL_SCENE)
    energy_label.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
    
    var spacer2 := Control.new()
    spacer2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    hbox.add_child(spacer2)
    
    _update_control()
    
    return hbox


func _set_font_size(value: String) -> void:
    ._set_font_size(value)
    energy_label.font_size = value
