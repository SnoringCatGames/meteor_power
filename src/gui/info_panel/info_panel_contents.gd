tool
class_name InfoPanelContents
extends VBoxContainer


const _INFO_PANEL_COMMAND_ROW_SCENE := preload(
    "res://src/gui/info_panel/info_panel_command_row.tscn")

var entity
var entity_command_type := Commands.UNKNOWN
# Array<InfoPanelCommandRow>
var command_rows := []


func set_up(entity) -> void:
    self.entity = entity
    self.entity_command_type = entity.entity_command_type
    
    $CommandsLabel \
        .add_color_override("font_color", Sc.palette.get_color("info_panel_header"))
    $UpgradesLabel \
        .add_color_override("font_color", Sc.palette.get_color("info_panel_header"))
    
    $CommandsSeparator.modulate = Sc.palette.get_color("separator")
    $UpgradesSeparator.modulate = Sc.palette.get_color("separator")
    
    # Render bulleted description rows.
    var description_lines: Array = \
        Commands.ENTITY_DESCRIPTIONS[entity_command_type]
    for line in description_lines:
        var row := HBoxContainer.new()
        $Description.add_child(row)
        
        var row_bullet: ScaffolderLabel = Sc.utils.add_scene(
            row, Sc.gui.SCAFFOLDER_LABEL_SCENE)
        row_bullet.text = "-  "
        row_bullet.font_size = "Xs"
        row_bullet.align = Label.ALIGN_RIGHT
        row_bullet.valign = Label.VALIGN_TOP
        row_bullet.size_flags_vertical = SIZE_FILL
        row_bullet.size_override = Vector2(61.0, 0.0)
        
        var row_label: ScaffolderLabel = Sc.utils.add_scene(
            row, Sc.gui.SCAFFOLDER_LABEL_SCENE)
        row_label.text = line
        row_label.font_size = "Xs"
        row_label.align = Label.ALIGN_LEFT
        row_label.valign = Label.VALIGN_TOP
        row_label.size_flags_horizontal = SIZE_EXPAND_FILL
        row_bullet.size_flags_vertical = SIZE_FILL
        row_label.autowrap = true
    
    # Render command rows.
    var commands: Array = entity._get_radial_menu_item_types()
    for command in commands:
        if command == Commands.STATION_INFO or \
                command == Commands.BOT_INFO:
            continue
        var row: InfoPanelCommandRow = \
            Sc.utils.add_scene($Commands, _INFO_PANEL_COMMAND_ROW_SCENE)
        row.set_up(command)
        command_rows.push_back(row)
    
    var is_empty_station := entity_command_type == Commands.STATION_EMPTY
    $Status.visible = !is_empty_station
    $UpgradesSeparator.visible = !is_empty_station
    $UpgradesLabel.visible = !is_empty_station
    $Upgrades.visible = !is_empty_station
    
    update()


func update() -> void:
    # FIXME: -------------------------------
    $Status/HealthLabel
    $Status/EnergyConsumptionLabel
    for row in command_rows:
        row.update()


func get_data() -> InfoPanelData:
    var name: String = Commands.ENTITY_NAMES[entity_command_type]
    var data := InfoPanelData.new(name, self)
    data.meta = entity
    return data
