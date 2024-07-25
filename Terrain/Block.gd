extends MeshInstance3D

class_name Block

var is_level: int = -1

#@onready var terrain_shader = self.get_surface_override_material(0)
@onready var marker_right = %Marker_boundaryRight
@onready var marker_left = %Marker_boundaryLeft
@onready var ground = $Ground

@export var is_type: is_types
enum is_types {SAFE,OBSTACLE,POINTS,MENU}

func _ready():
	Messenger.game_menu.connect(on_game_menu)
	
	if has_node("Ground"):
		ground.set_collision_layer_value(1, true)
	if has_node("Marker_boundaryRight"):
		marker_right.visible = false
		marker_left.visible = false
		
	## Identifies the level number by finding the two level digits in the scene file path, after moving 30 characters in from the left; level digits are then 2 characters back from the right.
	if !is_type == is_types.MENU:
		is_level = scene_file_path.left(30).right(2).to_int() 
	else:
		is_level = 100
		visible = false

func reset_block_objects():
	for object in get_children():
			if object is Block_Object:
				if object.needs_reset:
					object.reset_object()
			if object is Abductee:
				object.spawn_me()

func on_game_menu():
	if is_type == is_types.MENU:
		visible = true
