class_name BotsControlRow
extends CustomControlRow


const LABEL := "Bots:"
const DESCRIPTION := ""

const _CONSTRUCTOR_BOT_ICON := preload(
    "res://assets/images/gui/hud_icons/constructor_bot_hud_icon.png")
const _LINE_RUNNER_BOT_ICON := preload(
    "res://assets/images/gui/hud_icons/line_runner_bot_hud_icon.png")
const _BARRIER_BOT_ICON := preload(
    "res://assets/images/gui/hud_icons/barrier_bot_hud_icon.png")

var constructor_bot_count: int
var line_runner_bot_count: int
var barrier_bot_count: int

var constructor_bot_label: ScaffolderLabel
var line_runner_bot_label: ScaffolderLabel
var barrier_bot_label: ScaffolderLabel

var header: ScaffolderLabel
var totals_label: ScaffolderLabel

var constructor_bot_texture: ScaffolderTextureRect
var line_runner_bot_texture: ScaffolderTextureRect
var barrier_bot_texture: ScaffolderTextureRect


func _init(__ = null).(
        LABEL,
        DESCRIPTION \
        ) -> void:
    pass


func _update_control() -> void:
    var changed: bool = \
        constructor_bot_count != Sc.levels.session.constructor_bot_count or \
        line_runner_bot_count != Sc.levels.session.line_runner_bot_count or \
        barrier_bot_count != Sc.levels.session.barrier_bot_count
    
    if !is_instance_valid(constructor_bot_label):
        return
    
    if changed:
        constructor_bot_count = Sc.levels.session.constructor_bot_count
        line_runner_bot_count = Sc.levels.session.line_runner_bot_count
        barrier_bot_count = Sc.levels.session.barrier_bot_count
        var total_count: int = Sc.levels.session.total_bot_count
        var bot_capacity: int = Sc.levels.session.bot_capacity
        
        constructor_bot_label.text = "x%s  " % constructor_bot_count
        line_runner_bot_label.text = "x%s  " % line_runner_bot_count
        barrier_bot_label.text = "x%s  " % barrier_bot_count
        totals_label.text = "  (%s/%s)" % [total_count, bot_capacity]


func create_control() -> Control:
    var vbox := VBoxContainer.new()
    vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    
    var header_hbox := HBoxContainer.new()
    header_hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    vbox.add_child(header_hbox)
    
    var header_spacer1 := Control.new()
    header_spacer1.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    header_hbox.add_child(header_spacer1)
    
    header = Sc.utils.add_scene(header_hbox, Sc.gui.SCAFFOLDER_LABEL_SCENE)
    header.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
    header.text = "Bots:"
    
    totals_label = Sc.utils.add_scene(header_hbox, Sc.gui.SCAFFOLDER_LABEL_SCENE)
    totals_label.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
    
    var header_spacer2 := Control.new()
    header_spacer2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    header_hbox.add_child(header_spacer2)
    
    var hbox := HBoxContainer.new()
    hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    vbox.add_child(hbox)
    
    var spacer1 := Control.new()
    spacer1.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    hbox.add_child(spacer1)
    
    var icon_color: Color = Sc.palette.get_color("hud_icon")
    
    constructor_bot_texture = \
        Sc.utils.add_scene(hbox, Sc.gui.SCAFFOLDER_TEXTURE_RECT_SCENE)
    constructor_bot_texture.texture = _CONSTRUCTOR_BOT_ICON
    constructor_bot_texture.modulate = icon_color
    
    constructor_bot_label = \
        Sc.utils.add_scene(hbox, Sc.gui.SCAFFOLDER_LABEL_SCENE)
    constructor_bot_label.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
    
    line_runner_bot_texture = \
        Sc.utils.add_scene(hbox, Sc.gui.SCAFFOLDER_TEXTURE_RECT_SCENE)
    line_runner_bot_texture.texture = _LINE_RUNNER_BOT_ICON
    line_runner_bot_texture.modulate = icon_color
    
    line_runner_bot_label = \
        Sc.utils.add_scene(hbox, Sc.gui.SCAFFOLDER_LABEL_SCENE)
    line_runner_bot_label.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
    
    barrier_bot_texture = \
        Sc.utils.add_scene(hbox, Sc.gui.SCAFFOLDER_TEXTURE_RECT_SCENE)
    barrier_bot_texture.texture = _BARRIER_BOT_ICON
    barrier_bot_texture.modulate = icon_color
    
    barrier_bot_label = Sc.utils.add_scene(hbox, Sc.gui.SCAFFOLDER_LABEL_SCENE)
    barrier_bot_label.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
    
    var spacer2 := Control.new()
    spacer2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    hbox.add_child(spacer2)
    
    _update_control()
    _set_font_size(font_size)
    
    return vbox


func _set_font_size(value: String) -> void:
    ._set_font_size(value)
    
    if !is_instance_valid(constructor_bot_label):
        return
    
    constructor_bot_label.font_size = font_size
    line_runner_bot_label.font_size = font_size
    barrier_bot_label.font_size = font_size
    header.font_size = font_size
    totals_label.font_size = font_size
    
    var texture_scale := \
        _get_texture_scale_for_font_size(font_size) * Vector2.ONE
    constructor_bot_texture.texture_scale = texture_scale
    barrier_bot_texture.texture_scale = texture_scale
    line_runner_bot_texture.texture_scale = texture_scale


static func _get_texture_scale_for_font_size(font_size: String) -> float:
    match font_size:
        "Xs":
            return 1.5
        "S":
            return 2.0
        "M":
            return 3.0
        _:
            Sc.logger.error("BotsControlRow._get_texture_scale_for_font_size")
            return INF
