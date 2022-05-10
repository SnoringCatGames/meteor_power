class_name GameRadialMenuItem
extends SpriteModulationRadialMenuItem


var cost := 0


func _on_item_touch_entered() -> void:
    ._on_item_touch_entered()
    if cost > 0:
        _menu._label.set_cost(cost)
    elif cost < 0:
        _menu._label.set_cost_text("?")
    else:
        _menu._label.set_cost_text("")


func _on_item_touch_exited() -> void:
    ._on_item_touch_exited()
    _menu._label.set_cost_text("")
