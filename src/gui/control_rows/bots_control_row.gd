class_name BotsControlRow
extends CustomControlRow


const LABEL := "Bots:"
const DESCRIPTION := ""

const MARGIN_Y := 4.0

const _CONSTRUCTOR_BOT_ICON := preload(
    "res://assets/images/gui/hud_icons/constructor_bot_hud_icon.png")
const _LINE_RUNNER_BOT_ICON := preload(
    "res://assets/images/gui/hud_icons/line_runner_bot_hud_icon.png")
const _BARRIER_BOT_ICON := preload(
    "res://assets/images/gui/hud_icons/barrier_bot_hud_icon.png")

var constructor_bot_count := -1
var line_runner_bot_count := -1
var barrier_bot_count := -1

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
        
        constructor_bot_label.text = "x%s" % constructor_bot_count
        line_runner_bot_label.text = "x%s" % line_runner_bot_count
        barrier_bot_label.text = "x%s" % barrier_bot_count
        totals_label.text = "  (%s/%s)" % [total_count, bot_capacity]
        
        var totals_color := _get_color(total_count, bot_capacity)
        
        var max_color_bot_count := int(ceil(bot_capacity / 3.0))
        var constructor_bot_color := \
            _get_color(constructor_bot_count, max_color_bot_count)
        var line_runner_bot_color := \
            _get_color(line_runner_bot_count, max_color_bot_count)
        var barrier_bot_color := \
            _get_color(barrier_bot_count, max_color_bot_count)
        
        totals_label \
            .add_color_override("font_color", totals_color)
        constructor_bot_label \
            .add_color_override("font_color", constructor_bot_color)
        line_runner_bot_label \
            .add_color_override("font_color", line_runner_bot_color)
        barrier_bot_label \
            .add_color_override("font_color", barrier_bot_color)


func create_control() -> Control:
    var icon_color: Color = Sc.palette.get_color("hud_icon")
    var counts_color := Sc.palette.get_color("hud_count_min")
    
    var container: Control
    
    header = Sc.gui.SCAFFOLDER_LABEL_SCENE.instance()
    header.text = "Bots:"
    
    totals_label = Sc.gui.SCAFFOLDER_LABEL_SCENE.instance()
    totals_label.add_color_override("font_color", counts_color)
    totals_label.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
    
    constructor_bot_texture = Sc.gui.SCAFFOLDER_TEXTURE_RECT_SCENE.instance()
    constructor_bot_texture.texture = _CONSTRUCTOR_BOT_ICON
    constructor_bot_texture.modulate = icon_color
    
    constructor_bot_label = Sc.gui.SCAFFOLDER_LABEL_SCENE.instance()
    constructor_bot_label.add_color_override("font_color", counts_color)
    constructor_bot_label.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
    
    line_runner_bot_texture = Sc.gui.SCAFFOLDER_TEXTURE_RECT_SCENE.instance()
    line_runner_bot_texture.texture = _LINE_RUNNER_BOT_ICON
    line_runner_bot_texture.modulate = icon_color
    
    line_runner_bot_label = Sc.gui.SCAFFOLDER_LABEL_SCENE.instance()
    line_runner_bot_label.add_color_override("font_color", counts_color)
    line_runner_bot_label.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
    
    barrier_bot_texture = Sc.gui.SCAFFOLDER_TEXTURE_RECT_SCENE.instance()
    barrier_bot_texture.texture = _BARRIER_BOT_ICON
    barrier_bot_texture.modulate = icon_color
    
    barrier_bot_label = Sc.gui.SCAFFOLDER_LABEL_SCENE.instance()
    barrier_bot_label.add_color_override("font_color", counts_color)
    barrier_bot_label.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
    
    var intra_spacer_1 := Control.new()
    intra_spacer_1.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
    intra_spacer_1.rect_min_size.x = 3.0
    
    var intra_spacer_2 := Control.new()
    intra_spacer_2.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
    intra_spacer_2.rect_min_size.x = 3.0
    
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
        
        header_hbox.add_child(totals_label)
        
        var header_spacer2 := Control.new()
        header_spacer2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        header_hbox.add_child(header_spacer2)
        
        var vspacer: Spacer = Sc.utils.add_scene(container, Sc.gui.SPACER_SCENE)
        vspacer.size = Vector2(0.0, MARGIN_Y)
        
        var hbox := HBoxContainer.new()
        hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        container.add_child(hbox)
        
        var spacer1 := Control.new()
        spacer1.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        hbox.add_child(spacer1)
        
        hbox.add_child(constructor_bot_texture)
        hbox.add_child(constructor_bot_label)
        hbox.add_child(intra_spacer_1)
        hbox.add_child(line_runner_bot_texture)
        hbox.add_child(line_runner_bot_label)
        hbox.add_child(intra_spacer_2)
        hbox.add_child(barrier_bot_texture)
        hbox.add_child(barrier_bot_label)
        
        var spacer2 := Control.new()
        spacer2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        hbox.add_child(spacer2)
        
    else:
        # Display in one justified row.
        container = HBoxContainer.new()
        
        header.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        header.align = Label.ALIGN_LEFT
        container.add_child(header)
        
        var hbox := HBoxContainer.new()
        hbox.size_flags_horizontal = Control.SIZE_SHRINK_END
        container.add_child(hbox)
    
        var intra_spacer_3 := Control.new()
        intra_spacer_3.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
        intra_spacer_3.rect_min_size.x = 3.0
        
        hbox.add_child(constructor_bot_texture)
        hbox.add_child(constructor_bot_label)
        hbox.add_child(intra_spacer_1)
        hbox.add_child(line_runner_bot_texture)
        hbox.add_child(line_runner_bot_label)
        hbox.add_child(intra_spacer_2)
        hbox.add_child(barrier_bot_texture)
        hbox.add_child(barrier_bot_label)
        hbox.add_child(intra_spacer_3)
        hbox.add_child(totals_label)
    
    container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    
    _update_control()
    _set_font_size(font_size)
    
    return container


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


func _get_color(
        count: int,
        capacity: int) -> Color:
    if count == 0:
        return Sc.palette.get_color("hud_count_min")
    else:
        var weight := count / capacity
        return lerp(
            Sc.palette.get_color("hud_count_non_zero_min"),
            Sc.palette.get_color("hud_count_max"),
            weight)


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
