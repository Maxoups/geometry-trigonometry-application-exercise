@tool
extends Ship
class_name ExplorerShip


const SNAP_LIMIT := 100.0

@export var speed := 300.0
@export var path_points : Array[Point] = []

var is_moving := false
var alive := true
var starting_position : Vector2
var final_position : Vector2
var current_time := 0.0
var current_point := 0


func _ready() -> void:
	$SpriteRoot/AnimationShip.play("idle")
	await get_tree().process_frame
	# Only connect signal if we are running the demo (not in editor)
	if not Engine.is_editor_hint():
		Global.world.move_explorer_ship.connect(start_moving)


func start_moving() -> void:
	set_current_point(0)
	is_moving = true

func set_current_point(new_point : int) -> void:
	if len(path_points) <= new_point:
		is_moving = false
		return
	current_point = new_point
	current_time = 0.0
	starting_position = global_position
	final_position = path_points[current_point].global_position

func _process(delta: float) -> void:
	if not alive:
		return
	super._process(delta)
	if not is_moving:
		return
	current_time += delta
	var new_pos := GP1_TD.lerp_object_position(starting_position, final_position, 
											speed, current_time)
	position = new_pos
	$SpriteRoot.rotation = GP1_TD.lerp_object_rotation($SpriteRoot.rotation+PI/2.0, 
							global_position, final_position)-PI/2.0
	if global_position.distance_squared_to(final_position) <= SNAP_LIMIT:
		set_current_point(current_point + 1)

func _on_ship_hitbox_area_body_entered(_body: Node2D) -> void:
	ship_death()

func ship_death() -> void:
	if not alive:
		return
	alive = false
	ExplosionEffect.spawn_explosion_effect(global_position)
	visible = false
