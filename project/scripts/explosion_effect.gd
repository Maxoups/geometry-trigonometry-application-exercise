extends AnimatedSprite2D
class_name ExplosionEffect


const EXPLOSION_EFFECT_RES := preload("res://scenes/space_objects/explosion_effect.tscn")


static func spawn_explosion_effect(pos : Vector2) -> void:
	var effect := EXPLOSION_EFFECT_RES.instantiate()
	effect.global_position = pos
	Global.world.add_child(effect)


func _ready() -> void:
	play("default")

func _on_animation_finished() -> void:
	queue_free()
