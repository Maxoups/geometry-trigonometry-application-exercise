extends Camera2D
class_name PlayerCamera

signal toggle_geometry(is_toggled : bool)

@export var camera_speed := 750.0
@export var zoom_speed := 0.03
@export var min_zoom := 0.2
@export var max_zoom := 3.0
var is_geometry_on := true


func _ready() -> void:
	Global.player_camera = self

func _process(delta: float) -> void:
	# camera movements
	var velocity := Vector2.ZERO
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	position += velocity.normalized() * delta * camera_speed
	
	# display mouse position on grid
	var mouse_pos := get_global_mouse_position()
	$CanvasLayer/LabelMousePosition.text = "(x=%0.2f, y=%0.2f)" % [mouse_pos.x, mouse_pos.y]
	
	# toggle geometry objects
	if Input.is_action_just_pressed("toggle"):
		is_geometry_on = not is_geometry_on
		toggle_geometry.emit(is_geometry_on)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom = (zoom - Vector2.ONE * zoom_speed).clamp(Vector2(min_zoom, min_zoom), Vector2(max_zoom, max_zoom))
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom = (zoom + Vector2.ONE * zoom_speed).clamp(Vector2(min_zoom, min_zoom), Vector2(max_zoom, max_zoom))

func display_exercise(exercise_title : String, exercise_content : String) -> void:
	$CanvasLayer/LabelExercise.text = " " + exercise_title
	$CanvasLayer/LabelExercise/ExerciseContent.text = exercise_content
