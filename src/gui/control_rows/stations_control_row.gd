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

var command_center_count: int
var solar_collector_count: int
var scanner_station_count: int
var battery_station_count: int
var empty_station_count: int

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
        var total_count: int = \
            command_center_count + \
            solar_collector_count + \
            scanner_station_count + \
            battery_station_count
        var capacity: int = \
            total_count + \
            empty_station_count
        
        command_center_label.text = "x%s  " % command_center_count
        solar_collector_label.text = "x%s  " % solar_collector_count
        scanner_station_label.text = "x%s  " % scanner_station_count
        battery_station_label.text = "x%s  " % battery_station_count
        totals_label.text = "  (%s/%s)" % [total_count, capacity]


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
    header.text = "Stations:"
    
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
    
    command_center_texture = \
        Sc.utils.add_scene(hbox, Sc.gui.SCAFFOLDER_TEXTURE_RECT_SCENE)
    command_center_texture.texture = _COMMAND_CENTER_ICON
    command_center_texture.modulate = icon_color
    
    command_center_label = \
        Sc.utils.add_scene(hbox, Sc.gui.SCAFFOLDER_LABEL_SCENE)
    command_center_label.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
    
    solar_collector_texture = \
        Sc.utils.add_scene(hbox, Sc.gui.SCAFFOLDER_TEXTURE_RECT_SCENE)
    solar_collector_texture.texture = _SOLAR_COLLECTOR_ICON
    solar_collector_texture.modulate = icon_color
    
    solar_collector_label = \
        Sc.utils.add_scene(hbox, Sc.gui.SCAFFOLDER_LABEL_SCENE)
    solar_collector_label.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
    
    scanner_station_texture = \
        Sc.utils.add_scene(hbox, Sc.gui.SCAFFOLDER_TEXTURE_RECT_SCENE)
    scanner_station_texture.texture = _SCANNER_STATION_ICON
    scanner_station_texture.modulate = icon_color
    
    scanner_station_label = Sc.utils.add_scene(hbox, Sc.gui.SCAFFOLDER_LABEL_SCENE)
    scanner_station_label.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
    
    battery_station_texture = \
        Sc.utils.add_scene(hbox, Sc.gui.SCAFFOLDER_TEXTURE_RECT_SCENE)
    battery_station_texture.texture = _BATTERY_STATION_ICON
    battery_station_texture.modulate = icon_color
    
    battery_station_label = Sc.utils.add_scene(hbox, Sc.gui.SCAFFOLDER_LABEL_SCENE)
    battery_station_label.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
    
    var spacer2 := Control.new()
    spacer2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    hbox.add_child(spacer2)
    
    _update_control()
    _set_font_size(font_size)
    
    return vbox


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
