class_name BotsControlRow
extends CustomControlRow


const LABEL := "Bots:"
const DESCRIPTION := ""

var constructor_bot_count: int
var line_runner_bot_count: int
var barrier_bot_count: int

var constructor_bot_label: ScaffolderLabel
var line_runner_bot_label: ScaffolderLabel
var barrier_bot_label: ScaffolderLabel


func _init(__ = null).(
        LABEL,
        DESCRIPTION \
        ) -> void:
    pass


func _update_control() -> void:
    pass
#    var current_energy: int = \
#        Sc.levels.session.current_energy if \
#        Sc.levels.session.has_started else \
#        LevelSession.START_ENERGY
#    var total_energy: int = \
#        Sc.levels.session.total_energy if \
#        Sc.levels.session.has_started else \
#        LevelSession.START_ENERGY
#    var total_energy_str := str(total_energy)
#    var current_energy_str := Sc.utils.pad_string(
#        str(current_energy),
#        total_energy_str.length(),
#        false)
#    text = " %s / %s" % [current_energy_str, total_energy_str]
#    if is_instance_valid(energy_label):
#        energy_label.text = text


func create_control() -> Control:
    var hbox := HBoxContainer.new()
    hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    
    var spacer1 := Control.new()
    spacer1.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    hbox.add_child(spacer1)
    
    constructor_bot_label = \
        Sc.utils.add_scene(hbox, Sc.gui.SCAFFOLDER_LABEL_SCENE)
    constructor_bot_label.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
    
    var spacer2 := Control.new()
    spacer2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    hbox.add_child(spacer2)
    
    _update_control()
    
    return hbox


func _set_font_size(value: String) -> void:
    ._set_font_size(value)
    constructor_bot_label.font_size = value
    line_runner_bot_label.font_size = value
    barrier_bot_label.font_size = value
