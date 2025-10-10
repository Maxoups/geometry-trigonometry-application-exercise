extends Node
class_name ToggleableObject


var parent_object : CanvasItem

func _ready() -> void:
	parent_object = get_parent()
	if not is_instance_valid(parent_object):
		print_debug("ToggleableObject has no valid parent")
		queue_free()
	else:
		await get_tree().process_frame	
		Global.player_camera.toggle_geometry.connect(toggle_object)

func toggle_object(new_visibility : bool) -> void:
	parent_object.visible = new_visibility
