tool
class_name Hud
extends SurfacerHud


const COMMAND_QUEUE_LIST_SCENE := \
    preload("res://src/gui/command_queue_list.tscn")

var command_queue_list: CommandQueueList


func set_up() -> void:
    command_queue_list = Sc.utils.add_scene(self, COMMAND_QUEUE_LIST_SCENE)


func _destroy() -> void:
    command_queue_list._destroy()
    ._destroy()
