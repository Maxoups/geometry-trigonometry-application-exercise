extends StaticBody2D
class_name ExplodableObject

signal explosion(impact_point : Vector2, explosion_force : float)


func explode(impact_point : Vector2, explosion_force : float):
	explosion.emit(impact_point, explosion_force)
