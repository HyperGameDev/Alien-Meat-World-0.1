extends MeshInstance3D

class_name Block


static var menu_is_visible: bool = false
var is_level: int = -1

@onready var alien_headpieces: Node3D = get_tree().get_current_scene().get_node("Player/Alien_V3/Alien/Armature/Skeleton3D/Alien_Head/Alien_Headpieces")

#@onready var terrain_shader = self.get_surface_override_material(0)
@onready var marker_right = %Marker_boundaryRight
@onready var marker_left = %Marker_boundaryLeft
@onready var ground = $Ground
@onready var grass_material = preload("res://Terrain/BASE_TERRAIN_BLOCKS/block_default-grass-shader.tres")

@export var is_type: is_types
enum is_types {SAFE,OBSTACLE,POINTS,MENU}
@export_range(1,2) var menu_skin_array_to_use: int = 1

func _ready():
	#Messenger.game_intro
	Messenger.game_premenu.connect(on_game_premenu)
	Messenger.game_begin.connect(on_game_begin)
	Messenger.game_confirm.connect(on_game_confirm)
	
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

			
			
func show_available_skins():
	var skins_1_left = Globals.skins_1.duplicate(true)
	var skins_2_left = Globals.skins_2.duplicate(true)
	
	var skins_1_right = Globals.skins_1.duplicate(true)
	var skins_2_right = Globals.skins_2.duplicate(true)
	
	match menu_skin_array_to_use:
		1:
			for node in get_children():
				if node is Alien_For_Menu:
					if node.unhoverable == false:
						if !skins_1_left.is_empty():
							var skin_chosen: String
							skin_chosen = choose_random_skin(skins_1_left)
							
							if Globals.skins[skin_chosen]["is_unlocked"]:
								assign_skin_to_alien(node,skin_chosen)
								choose_and_apply_materials(skin_chosen,node,"skin_material",0)
								choose_and_apply_materials(skin_chosen,node,"eyes_material",2)
								
								if Globals.skins[skin_chosen]["has_head_piece"]:
									apply_headpiece(skin_chosen,node)
							
							
					else: # Node is unhoverable:
						if !skins_1_right.is_empty():
							var skin_chosen: String
							skin_chosen = choose_random_skin(skins_1_right)
							
							if Globals.skins[skin_chosen]["is_unlocked"]:
								assign_skin_to_alien(node,skin_chosen)
								choose_and_apply_materials(skin_chosen,node,"skin_material",0)
								choose_and_apply_materials(skin_chosen,node,"eyes_material",2)
								
								if Globals.skins[skin_chosen]["has_head_piece"]:
									apply_headpiece(skin_chosen,node)
		2:
			for node in get_children():
				if node is Alien_For_Menu:
					if node.unhoverable == false:
						if !skins_2_left.is_empty():
							var skin_chosen: String
							skin_chosen = choose_random_skin(skins_2_left)
							
							if Globals.skins[skin_chosen]["is_unlocked"]:
								assign_skin_to_alien(node,skin_chosen)
								choose_and_apply_materials(skin_chosen,node,"skin_material",0)
								
								if Globals.skins[skin_chosen]["has_head_piece"]:
									apply_headpiece(skin_chosen,node)
								choose_and_apply_materials(skin_chosen,node,"eyes_material",2)
								
								if Globals.skins[skin_chosen]["has_head_piece"]:
									apply_headpiece(skin_chosen,node)
							
							
					else: # Node is unhoverable:
						if !skins_2_right.is_empty():
							var skin_chosen: String
							skin_chosen = choose_random_skin(skins_2_right)
							
							if Globals.skins[skin_chosen]["is_unlocked"]:
								assign_skin_to_alien(node,skin_chosen)
								choose_and_apply_materials(skin_chosen,node,"skin_material",0)
								choose_and_apply_materials(skin_chosen,node,"eyes_material",2)
								
								if Globals.skins[skin_chosen]["has_head_piece"]:
									apply_headpiece(skin_chosen,node)
		_:
			pass

func reset_block_objects():
	for object in get_children():
			if object is Block_Object:
				if object.needs_reset:
					object.reset_object()
			if object is Abductee:
				object.spawn_me()

func on_game_premenu():
	show_available_skins()
	if is_type == is_types.MENU:
		visible = true
		menu_is_visible = true
	
func on_game_confirm():
	for node in get_children():
		if node is Alien_For_Menu:
			if node.was_chosen == false:
				node.animation_menu_alien.set("parameters/Transition/transition_request", "stopping")
				node.shadow()
				


func on_game_begin():
	if is_type == is_types.MENU:
		if has_node("grass_plane_01-01_00"):
			$"grass_plane_01-01_00".visible = true
			material_override = grass_material
			
func choose_random_skin(skins_dictionary):
	if skins_dictionary.size() > 0:
		var skin_to_choose = choose_random_key_from_dict(skins_dictionary)
		skins_dictionary.erase(skin_to_choose)
		return skin_to_choose

func choose_random_key_from_dict(dictionary):
	var keys = dictionary.keys()
	var random_index = randi() % keys.size()
	return keys[random_index]
	
func assign_skin_to_alien(menu_alien,skin_clicked):
	menu_alien.skin = skin_clicked
	
func choose_and_apply_materials(skin_chosen,mat_target,mat_key,mat_number):
	var mat_to_apply: Material
	mat_to_apply = Globals.skins[skin_chosen][mat_key]
	
	mat_target.mesh.set_surface_override_material(mat_number, mat_to_apply)
	
	if mat_to_apply is StandardMaterial3D:
		mat_target.mesh.get_surface_override_material(mat_number).disable_receive_shadows = true

func apply_headpiece(skin_chosen,alien):
	var alien_headpieces: Node3D = alien.get_node("Alien/Alien_Headpieces")
	alien_headpieces.get_node(Globals.skins[skin_chosen]["head_piece"]).visible = true
		
