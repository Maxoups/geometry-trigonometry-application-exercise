extends Sprite2D
class_name Missile


const MISSILE_RES := preload("res://scenes/space_objects/missile.tscn")

@export var explosion_force := 3500.0
@export var speed := 800.0
@export var target_position : Vector2
@export var velocity : Vector2
var has_exploded := false


static func spawn_missile(position : Vector2, rotation : float, new_target_pos : Vector2) -> void:
	var missile_instance := MISSILE_RES.instantiate()
	missile_instance.global_position = position
	missile_instance.global_rotation = rotation
	missile_instance.target_position = new_target_pos
	Global.world.add_child(missile_instance)


func _process(delta: float) -> void:
	velocity = GP1_TD.get_velocity(global_position, target_position, speed, delta, velocity)
	global_position += velocity

func explode() -> void:
	if has_exploded:
		return
	has_exploded = true
	ExplosionEffect.spawn_explosion_effect(global_position)
	queue_free()

func _on_area_collision_body_entered(body: Node2D) -> void:
	if body.has_method("explode"):
		body.explode(global_position, explosion_force)
	explode()
