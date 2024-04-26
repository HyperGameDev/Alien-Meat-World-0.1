extends MeshInstance3D

class_name Block

@onready var marker_right = %Marker_boundaryRight
@onready var marker_left = %Marker_boundaryLeft


func _ready():
	if has_node("Marker_boundaryRight"):
		marker_right.visible = false
		marker_left.visible = false



func reset_block_objects():
	for object in get_children():
		if object is Block_Object:
			object.reset_object()
		if object is Health:
			object.spawn_me()
