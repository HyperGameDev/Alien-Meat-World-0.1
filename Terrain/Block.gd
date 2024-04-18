extends MeshInstance3D

class_name Block




func reset_block_objects():
	for object in get_children():
		if object is Block_Object:
			object.reset_object()
