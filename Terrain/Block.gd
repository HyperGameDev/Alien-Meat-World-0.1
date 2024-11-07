extends MeshInstance3D

class_name Block


static var menu_is_visible: bool = false
var is_level: int = -1

#@onready var terrain_shader = self.get_surface_override_material(0)
@onready var marker_right = %Marker_boundaryRight
@onready var marker_left = %Marker_boundaryLeft
@onready var ground = $Ground
@onready var grass_material = preload("res://Terrain/BASE_TERRAIN_BLOCKS/block_default-grass-shader.tres")

@export var is_type: is_types
enum is_types {SAFE,OBSTACLE,POINTS,MENU}
@export_range(1,2) var menu_skin_array_to_use: int = 1

func _ready():
	Messenger.game_menu.connect(on_game_menu)
	Messenger.game_begin.connect(on_game_begin)
	
	if has_node("Ground"):
		ground.set_collision_layer_value(1, true)
	if has_node("Marker_boundaryRight"):
		marker_right.visible = false
		marker_left.visible = false
		
	## Identifies the level number by finding the two level digits in the scene file path, after moving 30 characters in from the left; level digits are then 2 characters back from the right.
	if !is_type == is_types.MENU:
		is_level = scene_file_path.left(30).right(2).to_int() 
	else: # If is a menu:
		is_level = 100
		if menu_is_visible:
			visible = true
		else:
			visible = false
			
		var skins_1 = Globals.skins_1.duplicate()
		var skins_2 = Globals.skins_2.duplicate()
		
		var skins_1_2 = Globals.skins_1.duplicate()
		var skins_2_2 = Globals.skins_2.duplicate()
		
		match menu_skin_array_to_use:
			1:
				for node in get_children():
					if node is Alien_For_Menu:
						if node.unhoverable == false:
							if !skins_1.is_empty():
								var skin_to_apply: StandardMaterial3D
								skin_to_apply = skins_1.pick_random()
								skins_1.erase(skin_to_apply)
								node.mesh.set_surface_override_material(0, skin_to_apply)
								node.mesh.get_surface_override_material(0).disable_receive_shadows = true
								
								
						else: # Node is unhoverable:
							if !skins_1_2.is_empty():
								var skin_to_apply: StandardMaterial3D
								skin_to_apply = skins_1_2.pick_random()
								skins_1_2.erase(skin_to_apply)
								node.mesh.set_surface_override_material(0, skin_to_apply)
								node.mesh.get_surface_override_material(0).disable_receive_shadows = true
						
				#print(Globals.skins_1.pick_random())
			2:
				var skin_to_apply: StandardMaterial3D = Globals.skins_2.pick_random()
			_:
				pass
			

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
		menu_is_visible = true

func on_game_begin():
	if is_type == is_types.MENU:
		if has_node("grass_plane_01-01_00"):
			$"grass_plane_01-01_00".visible = true
			material_override = grass_material
