class_name BarrierPylonsControlRow
extends CustomControlRow


const LABEL := "Barrier pylons:"
const DESCRIPTION := ""

const _BARRIER_PYLON_ICON := preload(
    "res://assets/images/gui/hud_icons/barrier_pylon_hud_icon.png")

var barrier_pylon_count := -1

var barrier_pylon_label: ScaffolderLabel

var header: ScaffolderLabel

var barrier_pylon_texture: ScaffolderTextureRect


func _init(__ = null).(
        LABEL,
        DESCRIPTION \
        ) -> void:
    pass


func _update_control() -> void:
    var changed: bool = \
        barrier_pylon_count != Sc.levels.session.barrier_pylon_count
    
    if !is_instance_valid(barrier_pylon_label):
        return
    
    if changed:
        barrier_pylon_count = Sc.levels.session.barrier_pylon_count
        var capacity: int = BarrierPylon.MAX_PYLON_COUNT
        
        barrier_pylon_label.text = "x%s/%s" % [barrier_pylon_count, capacity]
        
        var color := _get_color(barrier_pylon_count, capacity)
        barrier_pylon_label.add_color_override("font_color", color)


func create_control() -> Control:
    var icon_color: Color = Sc.palette.get_color("hud_icon")
    var counts_color := Sc.palette.get_color("hud_count_min")
    
    var container: Control
    
    header = Sc.gui.SCAFFOLDER_LABEL_SCENE.instance()
    header.text = LABEL
    
    barrier_pylon_texture = Sc.gui.SCAFFOLDER_TEXTURE_RECT_SCENE.instance()
    barrier_pylon_texture.texture = _BARRIER_PYLON_ICON
    barrier_pylon_texture.modulate = icon_color
    
    barrier_pylon_label = Sc.gui.SCAFFOLDER_LABEL_SCENE.instance()
    barrier_pylon_label.add_color_override("font_color", counts_color)
    barrier_pylon_label.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
    
    # Display in one justified row.
    container = HBoxContainer.new()
    container.add_constant_override("separation", 0.0)
    
    header.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    header.align = Label.ALIGN_LEFT
    container.add_child(header)
    
    var spacer := Control.new()
    spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    container.add_child(spacer)
    
    var hbox := HBoxContainer.new()
    hbox.size_flags_horizontal = Control.SIZE_SHRINK_END
    hbox.add_constant_override("separation", 0.0)
    container.add_child(hbox)
    
    hbox.add_child(barrier_pylon_texture)
    hbox.add_child(barrier_pylon_label)
    
    # FIXME: ------------------
    if is_in_hud:
        pass
    
    container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    
    _update_control()
    _set_font_size(font_size)
    
    return container


func _set_font_size(value: String) -> void:
    ._set_font_size(value)
    
    if !is_instance_valid(barrier_pylon_label):
        return
    
    barrier_pylon_label.font_size = font_size
    header.font_size = font_size
    
    var texture_scale := \
        BotsControlRow._get_texture_scale_for_font_size(font_size) * Vector2.ONE
    barrier_pylon_texture.texture_scale = texture_scale


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
