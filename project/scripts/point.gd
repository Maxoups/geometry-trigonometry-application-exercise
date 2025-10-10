@tool
extends Sprite2D
class_name Point


@export var point_name := "A":
	set(value):
		point_name = value
		update_label_text()
@export var point_color := Color.BLUE:
	set(value):
		point_color = value
		material.set_shader_parameter("replace", point_color)
var current_position := Vector2.ZERO


func _process(_delta: float) -> void:
	if current_position != position:
		current_position = position
		update_label_text()

func update_label_text() -> void:
	var pos_x := position.x
	var pos_y := position.y
	$Label.text = point_name + " (x=%0.2f, y=%0.2f)" % [pos_x, pos_y]
