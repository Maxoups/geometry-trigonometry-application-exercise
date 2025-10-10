extends Node2D
class_name ThrusterEffect


@export var is_active := false:
	set(value):
		is_active = value
		_update_thrusters()


func _ready() -> void:
	_update_thrusters()

func _update_thrusters() -> void:
	if is_active:
		$Sprite/AnimationThruster.play("move")
	else:
		$Sprite/AnimationThruster.play("hidden")
