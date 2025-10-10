@tool
extends Node2D
class_name Ship


@export var ship_name := "Ship":
	set(value):
		ship_name = value
		$Label.text = value
@onready var ship_root_node : Node2D = $SpriteRoot
var current_transform : Transform2D


func _process(_delta: float) -> void:
	if not is_instance_valid(ship_root_node):
		return
	if current_transform != ship_root_node.global_transform:
		current_transform = ship_root_node.global_transform
		update_label_text()

func update_label_text() -> void:
	var pos_x := position.x
	var pos_y := position.y
	var r : float = ship_root_node.global_rotation_degrees
	$Label.text = ship_name + ":\n    position = (x=%0.2f, y=%0.2f)\n    rotation = %0.2f\n    scale = (x=%0.2f, y=%0.2f)" % [pos_x, pos_y, r, scale.x, scale.y]
