tool
class_name InfoPanelContents
extends VBoxContainer


const _INFO_PANEL_COMMAND_ROW_SCENE := preload(
    "res://src/gui/info_panel_command_row.tscn")

var entity
var entity_command_type := Commands.UNKNOWN


func set_up(entity) -> void:
    self.entity = entity
    self.entity_command_type = entity.entity_command_type
    
    $CommandsLabel \
        .add_color_override("font_color", Sc.palette.get_color("header"))
    $UpgradesLabel \
        .add_color_override("font_color", Sc.palette.get_color("header"))
    
    var description_lines: Array = \
        Commands.ENTITY_DESCRIPTIONS[entity_command_type]
    for line in description_lines:
        var row: ScaffolderLabel = Sc.utils.add_scene(
            $Description, Sc.gui.SCAFFOLDER_LABEL_SCENE)
        row.text = "     -  " + line
        row.font_size = "Xs"
        row.align = Label.ALIGN_LEFT
        row.autowrap = true
    
    var commands: Array = entity._get_radial_menu_item_types()
    for command in commands:
        if command == Commands.STATION_INFO or \
                command == Commands.BOT_INFO:
            continue
        var row: InfoPanelCommandRow = \
            Sc.utils.add_scene($Commands, _INFO_PANEL_COMMAND_ROW_SCENE)
        row.set_up(command)
    
    var is_empty_station := entity_command_type == Commands.STATION_EMPTY
    $Status.visible = !is_empty_station
    $UpgradesSeparator.visible = !is_empty_station
    $UpgradesLabel.visible = !is_empty_station
    $Upgrades.visible = !is_empty_station


func get_data() -> InfoPanelData:
    var name: String = Commands.ENTITY_NAMES[entity_command_type]
    var data := InfoPanelData.new(name, self)
    data.meta = entity
    return data
