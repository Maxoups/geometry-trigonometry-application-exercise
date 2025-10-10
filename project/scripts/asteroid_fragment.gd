extends Polygon2D
class_name AsteroidFragment


const FRAGMENT_RES := preload("res://scenes/space_objects/asteroid_fragment.tscn")


static func spawn_asteroid_fragment(pos : Vector2, rot : float, npolygon : PackedVector2Array, 
	nvelocity : Vector2, polygon_inner1 : PackedVector2Array, polygon_inner2 : PackedVector2Array) -> void:
	var fragment := FRAGMENT_RES.instantiate()
	fragment.global_position = pos
	fragment.global_rotation = rot
	fragment.polygon = npolygon
	fragment.get_node("Line2D").points = npolygon
	fragment.get_node("PolygonInner1").polygon = polygon_inner1
	fragment.get_node("PolygonInner2").polygon = polygon_inner2
	fragment.velocity = nvelocity
	Global.world.add_child(fragment)


var velocity : Vector2


func _process(delta: float) -> void:
	position += velocity * delta
