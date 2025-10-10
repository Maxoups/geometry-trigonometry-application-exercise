extends Sprite2D
class_name Satellite


@export var central_body : Node2D
@export var orbit_duration := 9.0
@export var current_time := 0.0
@export var orbit_radius : Vector2 = Vector2.ZERO
@export var orbit_speed : float = 0.0
@export var starting_angle : float = 0.0
@export var initial_delay := 1.0

@onready var orbit_center : Vector2 = central_body.global_position
@onready var starting_position : Vector2 = global_position

var has_orbit_started := false


func _ready() -> void:
	await get_tree().process_frame
	Global.world.start_satellite_orbits.connect(start_satellite_orbits)

func start_satellite_orbits() -> void:
	var orbit_parameters := GP1_TD.get_satellite_orbit_parameters(
							orbit_center, orbit_duration, starting_position)
	if orbit_radius == Vector2.ZERO:
		orbit_radius = Vector2.ONE * orbit_parameters["radius"]
	orbit_speed = orbit_parameters["speed"]
	starting_angle = orbit_parameters["starting_angle"]
	await get_tree().create_timer(initial_delay).timeout
	compute_satellite_transform()
	await get_tree().create_timer(0.5).timeout
	has_orbit_started = true

func _process(delta: float) -> void:
	if not has_orbit_started:
		return
	current_time += delta
	compute_satellite_transform()

func compute_satellite_transform() -> void:
	var t : Transform2D = GP1_TD.get_satellite_orbit_transform(orbit_center, starting_angle, 
									orbit_radius, orbit_duration, current_time)
	rotation = t.get_rotation()
	position = t.get_origin()
