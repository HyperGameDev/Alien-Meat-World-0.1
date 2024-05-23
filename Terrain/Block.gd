extends MeshInstance3D

class_name Block

#@onready var terrain_shader = self.get_surface_override_material(0)
@onready var marker_right = %Marker_boundaryRight
@onready var marker_left = %Marker_boundaryLeft
@onready var ground = $Ground

@export var is_type: is_types
enum is_types {SAFE,OBSTACLE,POINTS}

func _ready():
	if has_node("Ground"):
		ground.set_collision_layer_value(1, true)
	if has_node("Marker_boundaryRight"):
		marker_right.visible = false
		marker_left.visible = false


func reset_block_objects():
	for object in get_children():
			if object is Block_Object:
				if object.needs_reset:
					object.reset_object()
			if object is Health:
				object.spawn_me()

#func _process(delta):
	#terrain_shader.set_shader_parameter("random_offset", Vector2(randf(),randf()))
