extends Camera3D

# Adjust these together!!
@export var cam_z_offset: float = 13.0
const CAM_Z_OFFSET = 13

# Cam Movement vars
@export var cam_lerpspeed: float = .05
@export var cam_y_offset: float = 4.0
const CAM_Y_OFFSET: float = 4.0
@export var cam_x_offset: float = 0.0
const CAM_X_OFFSET: float = 0.0

@onready var cam_target: Node3D = %Cam_Target
@onready var powerup_menu: Node3D = %PowerUp_Menu
@onready var hud: CanvasLayer = %HUD

# Temporary Grab Mechanic vars
var is_grabbed = false
var grab_offset: Vector3 = Vector3(0, 0, 0)
var attack_ray_pos: Vector3 = Vector3(0, 0, 0)
var is_attempting_grab = false

var menu_pickable: bool = false

# Raycast 1: Grab var
var attack_target = null

# Raycast 2: Hover-Player var
var hover_target = null


var powerup_menu_begin = false


func _ready():	
	if !cam_z_offset == CAM_Z_OFFSET:
		print("ERROR: Ensure Camera's Z constant and variable match!")
		breakpoint
		
	Messenger.grab_ended.connect(on_grab_ended)
	Messenger.powerup_menu_begin.connect(on_powerup_menu_begin)
	Messenger.powerup_chosen.connect(on_powerup_chosen)
	Messenger.game_menu.connect(on_game_menu)
	Messenger.game_preload.connect(on_game_preload)
	
func _physics_process(_delta):
	
	# Camera Move back If Speeding Up
	var input_up = Input.is_action_pressed("ui_up")
	var input_up_end = Input.is_action_just_released("ui_up")
	if input_up and cam_z_offset == CAM_Z_OFFSET:
		cam_z_offset += .75
	if input_up_end and cam_z_offset >= CAM_Z_OFFSET:
		cam_z_offset -= .75
		
	# Camera Follow
	var cam_follow_pos: Vector3 = cam_target.position
	cam_follow_pos.z += cam_z_offset
	cam_follow_pos.y += cam_y_offset
	cam_follow_pos.x += cam_x_offset
	
	
	# Camera Follow Normalize
	var cam_direction: Vector3 = cam_follow_pos - self.position
	
	self.position += cam_direction * cam_lerpspeed
	self.rotation = cam_target.rotation

func on_grab_ended():
	is_attempting_grab = false

func _process(_delta):
	if !powerup_menu_begin:
		var raycast_result = attack_ray() ## Shoots the ray
		if Input.is_action_pressed("Grab"): 
			get_tree().get_root().get_node("Hover_Interactables_Autoloaded/Arrow_Hover_front").force_hide_arrow()
			get_tree().get_root().get_node("Hover_Interactables_Autoloaded/Arrow_Hover_back").force_hide_arrow()
			if !raycast_result == null:
				if raycast_result.is_in_group("Abductee"):
					var meat_original = raycast_result
					if meat_original.has_method("spawn_me") and !is_attempting_grab and !is_in_group("Grabbed"):
					#disappears the object
						meat_original.spawn = false
					
						var meat_new = Globals.meat_objects[meat_original.is_type].instantiate()
						get_tree().get_current_scene().get_node("SpawnPlace").add_child(meat_new)
						meat_new.spawn = true
						meat_new.add_to_group("Grabbed")
						is_attempting_grab = true
	else:
		powerup_ray()
		
		
	# Detects all things
	general_ray()

	# Player Hover implementation
	player_hover_ray()
	
	# Cursor Position implementation
	cursor_ray()
	
	if menu_pickable:
		# Main Menu Button detection
		main_menu_ray()
		
		if Globals.level_current == 0:
			menu_alien_ray()
	
	

func hover_ray(mask,has_mask): ## Raycast that receives a target via argument
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_length = 3000
	var from = project_ray_origin(mouse_pos)
	var to = from + project_ray_normal(mouse_pos) * ray_length
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.exclude = [$"../Player/DetectionAreas/Area_Player-Proximity"]
	ray_query.from = from
	ray_query.to = to
	
	
	# collision areas vs bodies dependent on whether collide_ was set to true/false when this function was called
	ray_query.collide_with_areas = true
#	ray_query.collide_with_bodies = collide_bodies
	
	# Remember: masks/layers need to be set with the bit (2^) values!
	if has_mask:
		ray_query.collision_mask = mask
	
	return space.intersect_ray(ray_query)

func general_ray():
	var general_ray_result = hover_ray(0,false)
	Messenger.anything_seen.emit(general_ray_result)

func main_menu_ray():
	var raycast_result = hover_ray(64,true)
	if !raycast_result.is_empty():
		hover_target = raycast_result.collider
		Messenger.button_hovered.emit(hover_target)
		if Input.is_action_just_pressed("Grab"):
			Messenger.button_chosen.emit(hover_target)

func attack_ray(): ## Detects obstacles, NPC's and Meat/Abductee; emits attack_target to hitpoints, and returns attack_target to Meat/Abductee within this script
	var raycast_result = hover_ray(2 + 4 + 8 + 16384,true)
	if !raycast_result.is_empty():
		attack_ray_pos = raycast_result.position
		attack_target = raycast_result.collider
		Messenger.attack_target.emit(attack_target)
#		print("Raycast sees: ", attack_target)
#		print("Pos: ", attack_target.position)
#		return raycast_result.collider
		return attack_target
		
func menu_alien_ray():
	var raycast_result = hover_ray(16384,true)
#	print(raycast_result)
	if !raycast_result.is_empty():
		hover_target = raycast_result.collider
		
		# Emits signal with parameter "true" or "false" if the hover_target is/isn't set to %Player
		if Input.is_action_just_pressed("Grab"):
			Messenger.game_preload.emit()
#
#		return raycast_result.collider

func powerup_ray():
	var raycast_result = hover_ray(32,true)
	if !raycast_result.is_empty():
		# These regions could become a single function if needed someday
		#region Orb 1 Interaction
		if raycast_result["collider"].is_type == PowerUp_Orb.is_types.Orb_1:
			Messenger.powerup_hovered.emit(1)
			if Input.is_action_just_pressed("Grab"):
				Messenger.powerup_chosen.emit(1)
				print("Left orb chosen")
		#endregion
		#region Orb 2 Interaction
		if raycast_result["collider"].is_type == PowerUp_Orb.is_types.Orb_2:
			Messenger.powerup_hovered.emit(2)
			if Input.is_action_just_pressed("Grab"):
				Messenger.powerup_chosen.emit(2)
				print("Middle orb chosen")
		#endregion
		#region Orb 3 Interaction
		if raycast_result["collider"].is_type == PowerUp_Orb.is_types.Orb_3:
			Messenger.powerup_hovered.emit(3)
			if Input.is_action_just_pressed("Grab"):
				Messenger.powerup_chosen.emit(3)
				print("Right orb chosen")
		#endregion

func player_hover_ray(): ## Player Hover detection
	var raycast_result = hover_ray(32768,true)
#	print(raycast_result)
	if !raycast_result.is_empty():
		hover_target = raycast_result.collider
		
		# Emits signal with parameter "true" or "false" if the hover_target is/isn't set to %Player
		Messenger.player_hover.emit(hover_target == %Player)
#
#		return raycast_result.collider


func cursor_ray(): ## This should be what the player head follows
	var raycast_result = hover_ray(16,true)
	if !raycast_result.is_empty():
		Messenger.mouse_pos_3d.emit(raycast_result.position)
#	print(raycast_result)

func on_powerup_menu_begin():
	powerup_menu_begin = true

func on_powerup_chosen(orb):
	powerup_menu_begin = false
	var orb_chosen = %PowerUp_Menu.get_children()[orb - 1]
	Globals.powerups_available.erase(orb_chosen.powerup_key)

func on_game_menu():
	menu_pickable = true

func on_game_preload():
	menu_pickable = false
