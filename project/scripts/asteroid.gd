extends Sprite2D
class_name Asteroid


const ASTEROID_RADIUS := [240.0, 175.0, 125.0, 70.0]

@export var polygon_appear_delay := 0.0
@export var is_regular := true

@onready var anim_time := randf_range(0.9, 1.4)
@onready var rotation_start := rotation + randf_range(PI/15, PI/10)
@onready var rotation_end := rotation
@onready var polygons : Array[Polygon2D] = [$Polygon2D, $PolygonInner1, $PolygonInner2]

var idle_anim_tween : Tween = null


func _ready() -> void:
	idle_animation()
	await get_tree().process_frame
	Global.world.generate_asteroids.connect(generate_asteroid_polygon)

func explode(impact_point : Vector2, explosion_force : float) -> void:
	visible = false
	if is_instance_valid(idle_anim_tween):
		idle_anim_tween.kill()
	$StaticBody2D.queue_free()
	if len($Polygon2D.polygon) == 0:
		print_debug("Polygon has not been drawn ; can't explode asteroid!")
		return
	var fragments := GP1_TD.shatter_polygon($Polygon2D.polygon, randi_range(8, 14))
	for fragment : PackedVector2Array in fragments:
		AsteroidFragment.spawn_asteroid_fragment(
			global_position, 
			global_rotation, 
			fragment, 
			GP1_TD.explode_fragment($Polygon2D.polygon, global_position, fragment, 
									impact_point, explosion_force),
			polygon_intersection(fragment, $PolygonInner1.polygon),
			polygon_intersection(fragment, $PolygonInner2.polygon)
		)

func generate_asteroid_polygon() -> void:
	await get_tree().create_timer(polygon_appear_delay).timeout
	if is_regular:
		_draw_all_regular_polygons()
	else:
		_draw_all_random_polygons()
	if len($Polygon2D.polygon) > 0:
		self_modulate = Color.TRANSPARENT
		$Line2D.points = $Polygon2D.polygon
		for p : Polygon2D in polygons:
			p.global_scale = Vector2.ONE
		$Line2D.global_scale = Vector2.ONE

func _draw_all_regular_polygons() -> void:
	for i : int in range(len(polygons)):
		var p := polygons[i]
		p.polygon = GP1_TD.generate_regular_polygon(
							scale.x * ASTEROID_RADIUS[i], 
							randi_range(6, 12))

func _draw_all_random_polygons() -> void:
	for i : int in range(len(polygons)):
		var p := polygons[i]
		p.polygon = GP1_TD.generate_random_polygon(
							scale.x * ASTEROID_RADIUS[i], 
							scale.x * ASTEROID_RADIUS[i+1], 
							randi_range(6, 12))

func idle_animation() -> void:
	var new_rot := rotation + randf_range(-PI/2, PI/2)
	idle_anim_tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	idle_anim_tween.tween_property(self, "rotation", rotation_start, anim_time)
	idle_anim_tween.tween_property(self, "rotation", rotation_end, anim_time)
	idle_anim_tween.finished.connect(idle_animation)



# Returns the intersection polygon (as PackedVector2Array)
# between polygon_a and polygon_b.
# If they don't intersect, returns an empty PackedVector2Array.
static func polygon_intersection(polygon_a: PackedVector2Array, polygon_b: PackedVector2Array) -> PackedVector2Array:
	var subject: Array[Vector2] = []
	for v in polygon_a:
		subject.append(v)
	
	for i in range(polygon_b.size()):
		var A := polygon_b[i]
		var B := polygon_b[(i + 1) % polygon_b.size()]
		var edge_normal := Vector2(B.y - A.y, -(B.x - A.x)) # inward normal
		subject = _clip_polygon(subject, A, edge_normal)
		if subject.is_empty():
			return PackedVector2Array() # no intersection
	
	var result := PackedVector2Array()
	for v in subject:
		result.append(v)
	return result

# Helper: clip polygon by one edge of the clipper polygon
# Keeps points on the inside side of the edge
static func _clip_polygon(subject: Array[Vector2], clip_edge_point: Vector2, clip_edge_normal: Vector2) -> Array[Vector2]:
	var output: Array[Vector2] = []
	var count := subject.size()
	if count == 0:
		return output
	
	for i in range(count):
		var current := subject[i]
		var prev := subject[(i - 1 + count) % count]
		var current_inside := _is_inside(current, clip_edge_point, clip_edge_normal)
		var prev_inside := _is_inside(prev, clip_edge_point, clip_edge_normal)
	
		if current_inside:
			if not prev_inside:
				output.append(_compute_intersection(prev, current, clip_edge_point, clip_edge_normal))
			output.append(current)
		elif prev_inside:
			output.append(_compute_intersection(prev, current, clip_edge_point, clip_edge_normal))
	return output

# Helper: check if point is inside the half-plane
static func _is_inside(point: Vector2, edge_point: Vector2, edge_normal: Vector2) -> bool:
	return (point - edge_point).dot(edge_normal) <= 0.0

# Helper: compute intersection between polygon edge and clip edge
static func _compute_intersection(p1: Vector2, p2: Vector2, edge_point: Vector2, edge_normal: Vector2) -> Vector2:
	var direction := p2 - p1
	var denom := direction.dot(edge_normal)
	if abs(denom) < 1e-12:
		return p2 # parallel or coincident edge
	var t := (edge_point - p1).dot(edge_normal) / denom
	t = clamp(t, 0.0, 1.0)
	return p1 + direction * t
