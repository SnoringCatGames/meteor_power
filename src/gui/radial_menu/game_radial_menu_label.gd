class_name GameRadialMenuLabel
extends RadialMenuLabel


var cost_label: EnergyLabel


func _ready() -> void:
    cost_label.color = Sc.palette.get_color("energy")


func _initialize_node_references() -> void:
    panel_container = $ScaffolderPanelContainer
    label = $ScaffolderPanelContainer/VBoxContainer/Description
    cost_label = $ScaffolderPanelContainer/VBoxContainer/EnergyLabel
    disablement_explanation_label = \
        $ScaffolderPanelContainer/VBoxContainer/DisablementExplanation


func _get_height() -> float:
    var height := 0.0
    for child in $ScaffolderPanelContainer/VBoxContainer.get_children():
        height += \
            child.rect_size.y if \
            child.visible else \
            0.0
    return height


func set_cost(cost: int) -> void:
    cost_label.cost = cost
    cost_label.visible = cost != 0
    _on_gui_scale_changed()


func set_cost_text(cost_text: String) -> void:
    cost_label.text = cost_text
    cost_label.visible = cost_text != ""
    _on_gui_scale_changed()
