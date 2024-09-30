extends Node

@onready var v_box_container: VBoxContainer = $Control/VBoxContainer
@onready var node_5: Label = $Control/VBoxContainer/node5

func _ready() -> void:
	v_box_container.move_child(node_5, 1)
