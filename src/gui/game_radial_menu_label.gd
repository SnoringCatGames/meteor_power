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


func set_cost(cost: int) -> void:
    cost_label.cost = cost
