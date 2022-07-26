class_name StationsControlRow
extends CustomControlRow


const LABEL := "Stations:"
const DESCRIPTION := ""

const _COMMAND_CENTER_ICON := preload(
    "res://assets/images/gui/hud_icons/command_center_hud_icon.png")
const _SOLAR_COLLECTOR_ICON := preload(
    "res://assets/images/gui/hud_icons/solar_collector_hud_icon.png")
const _SCANNER_STATION_ICON := preload(
    "res://assets/images/gui/hud_icons/scanner_station_hud_icon.png")
const _BATTERY_STATION_ICON := preload(
    "res://assets/images/gui/hud_icons/battery_station_hud_icon.png")

var command_center_count := -1
var solar_collector_count := -1
var scanner_station_count := -1
var battery_station_count := -1
var empty_station_count := -1

var command_center_label: ScaffolderLabel
var solar_collector_label: ScaffolderLabel
var scanner_station_label: ScaffolderLabel
var battery_station_label: ScaffolderLabel

var header: ScaffolderLabel
var totals_label: ScaffolderLabel

var command_center_texture: ScaffolderTextureRect
var solar_collector_texture: ScaffolderTextureRect
var scanner_station_texture: ScaffolderTextureRect
var battery_station_texture: ScaffolderTextureRect


func _init(__ = null).(
        LABEL,
        DESCRIPTION \
        ) -> void:
    pass


func _update_control() -> void:
    var changed: bool = \
        command_center_count != Sc.levels.session.command_center_count or \
        solar_collector_count != Sc.levels.session.solar_collector_count or \
        scanner_station_count != Sc.levels.session.scanner_station_count or \
        battery_station_count != Sc.levels.session.battery_station_count or \
        empty_station_count != Sc.levels.session.empty_station_count
    
    if !is_instance_valid(command_center_label):
        return
    
    if changed:
        command_center_count = Sc.levels.session.command_center_count
        solar_collector_count = Sc.levels.session.solar_collector_count
        scanner_station_count = Sc.levels.session.scanner_station_count
        battery_station_count = Sc.levels.session.battery_station_count
        empty_station_count = Sc.levels.session.empty_station_count
        var total_count: int = Sc.levels.session.total_station_count
        var capacity: int = Sc.levels.session.total_station_site_count
        
        command_center_label.text = "x%s" % command_center_count
        solar_collector_label.text = "x%s" % solar_collector_count
        scanner_station_label.text = "x%s" % scanner_station_count
        battery_station_label.text = "x%s" % battery_station_count
        totals_label.text = "  (%s/%s)" % [total_count, capacity]
        
        var totals_color := _get_color(total_count, capacity)
        
        var max_color_station_count := int(ceil(capacity / 3.0))
        var command_center_color := \
            _get_color(command_center_count, max_color_station_count)
        var solar_collector_color := \
            _get_color(solar_collector_count, max_color_station_count)
        var scanner_station_color := \
            _get_color(scanner_station_count, max_color_station_count)
        var battery_station_color := \
            _get_color(battery_station_count, max_color_station_count)
        
        totals_label \
            .add_color_override("font_color", totals_color)
        command_center_label \
            .add_color_override("font_color", command_center_color)
        solar_collector_label \
            .add_color_override("font_color", solar_collector_color)
        scanner_station_label \
            .add_color_override("font_color", scanner_station_color)
        battery_station_label \
            .add_color_override("font_color", battery_station_color)


func create_control() -> Control:
    var icon_color: Color = Sc.palette.get_color("hud_icon")
    var counts_color := Sc.palette.get_color("hud_count_min")
    
    var container: Control
    
    header = Sc.gui.SCAFFOLDER_LABEL_SCENE.instance()
    header.text = "Stations:"
    
    totals_label = Sc.gui.SCAFFOLDER_LABEL_SCENE.instance()
    totals_label.add_color_override("font_color", counts_color)
    totals_label.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
    
    command_center_texture = Sc.gui.SCAFFOLDER_TEXTURE_RECT_SCENE.instance()
    command_center_texture.texture = _COMMAND_CENTER_ICON
    command_center_texture.modulate = icon_color
    
    command_center_label = Sc.gui.SCAFFOLDER_LABEL_SCENE.instance()
    command_center_label.add_color_override("font_color", counts_color)
    command_center_label.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
    
    solar_collector_texture = Sc.gui.SCAFFOLDER_TEXTURE_RECT_SCENE.instance()
    solar_collector_texture.texture = _SOLAR_COLLECTOR_ICON
    solar_collector_texture.modulate = icon_color
    
    solar_collector_label = Sc.gui.SCAFFOLDER_LABEL_SCENE.instance()
    solar_collector_label.add_color_override("font_color", counts_color)
    solar_collector_label.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
    
    scanner_station_texture = Sc.gui.SCAFFOLDER_TEXTURE_RECT_SCENE.instance()
    scanner_station_texture.texture = _SCANNER_STATION_ICON
    scanner_station_texture.modulate = icon_color
    
    scanner_station_label = Sc.gui.SCAFFOLDER_LABEL_SCENE.instance()
    scanner_station_label.add_color_override("font_color", counts_color)
    scanner_station_label.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
    
    battery_station_texture = Sc.gui.SCAFFOLDER_TEXTURE_RECT_SCENE.instance()
    battery_station_texture.texture = _BATTERY_STATION_ICON
    battery_station_texture.modulate = icon_color
    
    battery_station_label = Sc.gui.SCAFFOLDER_LABEL_SCENE.instance()
    battery_station_label.add_color_override("font_color", counts_color)
    battery_station_label.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
    
    var intra_spacer_1 := Control.new()
    intra_spacer_1.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
    intra_spacer_1.rect_min_size.x = 3.0
    
    var intra_spacer_2 := Control.new()
    intra_spacer_2.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
    intra_spacer_2.rect_min_size.x = 3.0
    
    var intra_spacer_3 := Control.new()
    intra_spacer_3.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
    intra_spacer_3.rect_min_size.x = 3.0
    
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
        vspacer.size = Vector2(0.0, BotsControlRow.MARGIN_Y)
        
        var hbox := HBoxContainer.new()
        hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        container.add_child(hbox)
        
        var spacer1 := Control.new()
        spacer1.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        hbox.add_child(spacer1)
        
        hbox.add_child(command_center_texture)
        hbox.add_child(command_center_label)
        hbox.add_child(intra_spacer_1)
        hbox.add_child(solar_collector_texture)
        hbox.add_child(solar_collector_label)
        hbox.add_child(intra_spacer_2)
        hbox.add_child(scanner_station_texture)
        hbox.add_child(scanner_station_label)
        hbox.add_child(intra_spacer_3)
        hbox.add_child(battery_station_texture)
        hbox.add_child(battery_station_label)
        
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
    
        var intra_spacer_4 := Control.new()
        intra_spacer_4.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
        intra_spacer_4.rect_min_size.x = 3.0
        
        hbox.add_child(command_center_texture)
        hbox.add_child(command_center_label)
        hbox.add_child(intra_spacer_1)
        hbox.add_child(solar_collector_texture)
        hbox.add_child(solar_collector_label)
        hbox.add_child(intra_spacer_2)
        hbox.add_child(scanner_station_texture)
        hbox.add_child(scanner_station_label)
        hbox.add_child(intra_spacer_3)
        hbox.add_child(battery_station_texture)
        hbox.add_child(battery_station_label)
        hbox.add_child(intra_spacer_4)
        hbox.add_child(totals_label)
    
    container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    
    _update_control()
    _set_font_size(font_size)
    
    return container


func _set_font_size(value: String) -> void:
    ._set_font_size(value)
    
    if !is_instance_valid(command_center_label):
        return
    
    command_center_label.font_size = font_size
    solar_collector_label.font_size = font_size
    scanner_station_label.font_size = font_size
    battery_station_label.font_size = font_size
    header.font_size = font_size
    totals_label.font_size = font_size
    
    var texture_scale := \
        BotsControlRow._get_texture_scale_for_font_size(font_size) * Vector2.ONE
    command_center_texture.texture_scale = texture_scale
    solar_collector_texture.texture_scale = texture_scale
    scanner_station_texture.texture_scale = texture_scale
    battery_station_texture.texture_scale = texture_scale


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
