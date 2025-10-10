@tool
extends Ship
class_name MotherShip


@export var rotation_speed := 0.55

@export var target : Node2D

@onready var cannon_hull := $SpriteRoot/ShipSprites/ShipHull/ShipCannonHull
@onready var cannon_cockpit := $SpriteRoot/ShipSprites/ShipHull/ShipHead/ShipCannonCockpit
@onready var thruster_right := $SpriteRoot/ShipSprites/ShipHull/ShipThrusterRight/ThrusterEffect
@onready var thruster_left := $SpriteRoot/ShipSprites/ShipHull/ShipThrusterLeft/ThrusterEffect
@onready var firing_marker := $SpriteRoot/ShipSprites/ShipHull/ShipHead/FiringMarker2D
@onready var anim_cannon := $SpriteRoot/ShipSprites/ShipHull/ShipHead/AnimationCannon


func _ready() -> void:
	$SpriteRoot/ShipSprites/AnimationShip.play("ship_idle")
	anim_cannon.play("cannon_idle")
	if Engine.is_editor_hint():
		return
	await get_tree().process_frame
	Global.world.rotate_mothership.connect(rotate_ship)
	Global.world.shoot_missile.connect(fire_cannon)


func rotate_ship() -> void:
	var new_rotation := GP1_TD.get_angle_to(global_position, target.global_position) + 3.0*PI/2.0
	var t := create_tween().set_trans(Tween.TRANS_SINE)
	var angle_difference : float = $SpriteRoot.rotation-new_rotation
	var used_thruster : ThrusterEffect
	if angle_difference == 0.0:
		return
	elif angle_difference < 0.0:
		used_thruster = thruster_left
	else:
		used_thruster = thruster_right
	t.tween_property($SpriteRoot, "rotation", new_rotation, 
						abs(angle_difference) / rotation_speed)
	used_thruster.is_active = true
	await t.finished
	used_thruster.is_active = false

func fire_cannon() -> void:
	anim_cannon.play("cannon_fire")
	await get_tree().create_timer(0.25).timeout
	Missile.spawn_missile(firing_marker.global_position, firing_marker.global_rotation,
								target.global_position)
	await anim_cannon.animation_finished
	anim_cannon.play("cannon_idle")

func play_hull_cannon_idle() -> void:
	var new_cannon_rotation := randf_range(-0.75*PI, 0.75*PI)
	var movement_duration := randf_range(0.3, 0.7)
	var animation_delay := movement_duration + randf_range(0.5, 3.0)
	var t := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	t.tween_property(cannon_hull, "rotation", new_cannon_rotation, movement_duration)
	$SpriteRoot/ShipSprites/HullCannonAnimTimer.start(animation_delay)
