extends Line2D
class_name ShipPathTrace


@export var monitored_ship : ExplorerShip

var current_point : int = 0


func _ready() -> void:
	points.resize(2)
	await get_tree().process_frame
	points[0] = monitored_ship.position
	points[1] = monitored_ship.position

func _process(delta: float) -> void:
	points[len(points)-1] = monitored_ship.position
	if monitored_ship.current_point > current_point:
		current_point += 1
		add_point(monitored_ship.position)
