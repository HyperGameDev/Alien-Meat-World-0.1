extends Camera3D

@onready var window_size : Vector2 = get_window().size
@onready var mouse_pos : Vector2 = get_viewport().get_mouse_position()

var general_ray_result = null

var sensitivity: float = 1000.0 
var x_axis: float = 0.0
var y_axis: float = 0.0

var ray_mover: Vector2 = Vector2(0,0)

# Adjust these together!!
@export var cam_z_offset: float = 13.0
const CAM_Z_OFFSET = 13

# Cam Movement vars
@export var cam_lerpspeed: float = .05
@export var cam_y_offset: float = 4.0
const CAM_Y_OFFSET: float = 4.0
@export var cam_x_offset: float = 0.0
const CAM_X_OFFSET: float = 0.0

@onready var player: CharacterBody3D = %Player
@onready var cam_target: Node3D = %Cam_Target
@onready var powerup_menu: Node3D = %PowerUp_Menu
@onready var hud: CanvasLayer = %HUD
@onready var arm_r: BodyPart = $"../Player/Alien_V3/DetectionAreas/Area_ArmR"
@onready var arm_l: BodyPart = $"../Player/Alien_V3/DetectionAreas/Area_ArmL"
@onready var head: BodyPart = $"../Player/Alien_V3/DetectionAreas/Area_Head"

@export var player_proximity: Area3D
@export var powerup_proximity: Area3D
@export var interact_collision: Area3D


var menu_pickable: bool = false

# Raycast 2: Hover-Player var
var hover_target = null

var abduction_target = null

var prevent_attacking : bool = false
var powerups_selectable : bool = false

var head_grab : bool = false


func _ready():
	if player_proximity == null or powerup_proximity == null or interact_collision == null:
		print("ERROR: A raycast exclusion node is set to null!")
		breakpoint
		
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	InputMap.action_set_deadzone("Move Grabber Up",0.001)
	if !cam_z_offset == CAM_Z_OFFSET:
		print("ERROR: Ensure Camera's Z constant and variable match!")
		breakpoint
		
	Messenger.eating_begun.connect(on_eating_begun)
	Messenger.eating_finished.connect(on_eating_finished)
	Messenger.grab_begun.connect(on_grab_begun)
	Messenger.grab_ended.connect(on_grab_ended)
	Messenger.powerup_menu_begin.connect(on_powerup_menu_begin)
	Messenger.powerup_chosen.connect(on_powerup_chosen)
	Messenger.game_premenu.connect(on_game_premenu)
	Messenger.game_confirm.connect(on_game_confirm)
	Messenger.game_menu.connect(on_game_menu)
	Messenger.game_postmenu.connect(on_game_postmenu)
	Messenger.game_play.connect(on_game_play)
	Messenger.game_pause.connect(on_game_pause)
	Messenger.game_over.connect(on_game_over)
	
func _physics_process(_delta):
	
	# Camera Move back If Speeding Up
	var input_up = Input.is_action_pressed("Move Forward")
	var input_up_end = Input.is_action_just_released("Move Forward")
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

	#print("Cam Y: ", position.y, "; Offset Y: ", cam_y_offset)
	
func on_grab_begun(target):
	pass

func on_grab_ended():
	pass

func _process(delta: float) -> void:
	if x_axis != 0.0 or y_axis != 0.0:
		mouse_pos = get_viewport().get_mouse_position()
		var new_mouse_pos = mouse_pos + Vector2(x_axis, y_axis) * sensitivity * delta
		Input.warp_mouse(new_mouse_pos)
	
	
	if get_viewport() == null:
		return
		
	if Globals.is_game_state == Globals.is_game_states.OVER:
		return
		
	# Detects all things
	general_ray()
	
	# Head-look-at point
	cursor_ray()
	
	if prevent_attacking:
		if powerups_selectable:
			powerup_ray()
		return
		
	if Input.is_action_pressed("Action"):
		action_button_pressed()
		
	if Input.is_action_just_pressed("Action"):
		action_button_just_pressed()
		

	# Player Hover implementation
	player_hover_ray()
	
	# Score Dunk ray
	score_dunk_ray()

	
	# Attacking
	match player.is_hand_state:
		player.is_hand_states.IDLE:
			attack_ray(false)
			abduct_ray(false)
		player.is_hand_states.HELD:
			if has_grab_glove():
				attack_ray(true)
				abduct_ray(true)
		_:
			pass
	
	if menu_pickable:
		# Main Menu Button detection
		main_menu_ray()
		
		if Globals.level_current == 0:
			menu_alien_ray()
		
	
func _input(event: InputEvent) -> void: ## Cursor movement detection
	if event is InputEventJoypadMotion:
		if event is not InputEventMouseMotion:
			#is_joypad = true
			#axis 0 and 1 for left stick, 2 and 3 for right stick
			if event.axis == 2:
				x_axis = event.axis_value
			if event.axis == 3:
				y_axis = event.axis_value
	else:
		mouse_pos = get_viewport().get_mouse_position()
	
		
func action_button_pressed():
	force_hide_arrows()
	
func action_button_just_pressed():
	player_grab_check(general_ray_result)
	
func force_hide_arrows():
	get_tree().get_root().get_node("Hover_Interactables_Autoloaded/Arrow_Hover_front").force_hide_arrow()
	get_tree().get_root().get_node("Hover_Interactables_Autoloaded/Arrow_Hover_back").force_hide_arrow()
	
func has_grab_glove():
	return Globals.powerups["Grab_Glove"].powerupLevel > 0 as bool
	
func grab_glove_level():
	return Globals.powerups["Grab_Glove"].powerupLevel as int

func hover_ray(mask,has_mask): ## Raycast that receives a target via argument
	if get_viewport() == null:
		return
	
	var ray_length = 3000
	var from = project_ray_origin(mouse_pos)
	var to = from + project_ray_normal(mouse_pos) * ray_length
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.exclude = [player_proximity,powerup_proximity,interact_collision]
	ray_query.from = from
	ray_query.to = to
	
	
	# collision areas vs bodies dependent on whether collide_bodies was set to true/false when this function was called
	ray_query.collide_with_areas = true
#	ray_query.collide_with_bodies = collide_bodies
	
	# Remember: masks/layers need to be set with the bit (2^) values!
	if has_mask:
		ray_query.collision_mask = mask
	
	return space.intersect_ray(ray_query)

func general_ray():
	general_ray_result = hover_ray(0,false)
	Messenger.anything_seen.emit(general_ray_result)
	
func player_grab_check(target):
	if target == null:
		return
	if player.is_hand_state == player.is_hand_states.HELD:
		if target["collider"].is_in_group("Abductee") and !target["collider"].is_in_group("Grabbed"):
			pass
			#print(target["collider"].name, " is new abductee! Grab not ended.",)
		else:
			#print(target["codllider"].name, " click made camera emit Grab End!")
			Messenger.grab_ended.emit()
			

func main_menu_ray():
	var raycast_result = hover_ray(64,true)
	if !raycast_result.is_empty():
		hover_target = raycast_result.collider
		Messenger.button_hovered.emit(hover_target)
		if Input.is_action_just_pressed("Action"):
			Messenger.button_chosen.emit(hover_target)

func abduct_ray(do_grab_glove):
	var raycast_result = hover_ray(8,true)
	if !raycast_result.is_empty():
		var grabbed_abductees: Array = get_tree().get_nodes_in_group("Grabbed")
		
		if do_grab_glove:
			var extra_abductee_target = raycast_result.collider
			grab_glove_abduct_ray(extra_abductee_target,grabbed_abductees)
					
		else:
			abduction_target = raycast_result.collider
			if abduction_target.is_available and grabbed_abductees.is_empty():
				Messenger.abductee_hovered.emit(abduction_target)
			
			if !grabbed_abductees.is_empty():
				force_hide_arrows()
				
func grab_glove_abduct_ray(extra_abductee_target,grabbed_abductees):
	print("Grab glove abduct ray attempted to run")
	match grab_glove_level():
		1:
			if grabbed_abductees.size() < 2:
				if extra_abductee_target.is_available:
					Messenger.abductee_hovered.emit(abduction_target)
					print("Abductee seen with grab glove Lv1")
			else:
				force_hide_arrows()
		2:
			if grabbed_abductees.size() < 4:
				if extra_abductee_target.is_available:
					Messenger.abductee_hovered.emit(abduction_target)
					print("Abductee grabbed with grab glove Lv2")
			else:
				force_hide_arrows()

func attack_ray(do_grab_glove: bool): ## Detects obstacles, NPC's and Meat/Abductee; emits attack_target to hitpoints, and returns attack_target to Meat/Abductee within this script
	
	var raycast_result = hover_ray(2 + 4 + 8 + 16384,true)
	if !raycast_result.is_empty():
		
		if do_grab_glove:
			var extra_abductee_target = raycast_result.collider
			grab_glove_attack_ray(extra_abductee_target)
			
		else:
			var attack_target = raycast_result.collider
			Messenger.attack_target.emit(attack_target)
			
			
			if attack_target.is_in_group("Abductee"):
				if Input.is_action_just_pressed("Action"):
					if player.is_hand_state == player.is_hand_states.IDLE:
						#print("Camera: ",attack_target.name, " is targeted!")
						abductee_grabbed(attack_target, false)
						
func grab_glove_attack_ray(extra_abductee_target):
	if extra_abductee_target.is_in_group("Abductee"):
		if Input.is_action_just_pressed("Action"):
			
			print("Camera: ",extra_abductee_target," is targeted with GRAB GLOVE!")
			abductee_grabbed(extra_abductee_target,true)

func abductee_grabbed(attack_target,grab_glove:bool):
	if grab_glove:
		pass
	else:
		var grabbed_abductee = attack_target
		if grabbed_abductee.is_clone:
			grabbed_abductee.add_to_group("Grabbed")
			Messenger.grab_begun.emit(grabbed_abductee)
		else: # Abductee is NOT a clone
			if !head_grab and arm_r.current_health == 0 and arm_l.current_health == 0: # Head is grabbing
				og_abductee_grabbed_by_head(grabbed_abductee)
			else:
				og_abductee_grabbed_by_arms(grabbed_abductee)

func og_abductee_grabbed_by_head(grabbed_abductee):
	head_grab = true
	Messenger.something_attacked.emit(grabbed_abductee)
	await get_tree().create_timer(player.attack_duration).timeout
	grabbed_abductee.is_available = false
	Messenger.player_head_hover.emit(false,true)
	Messenger.abductee_destroyed.emit(grabbed_abductee.is_military,grabbed_abductee.is_empathy_event)
	
func og_abductee_grabbed_by_arms(og_grabbed_abductee):
	og_grabbed_abductee.is_available = false
	
	var abductee_cloned = Globals.abductee_objects[og_grabbed_abductee.is_type].instantiate()
	get_tree().get_current_scene().get_node("Spawned/Spawned_Humans").add_child(abductee_cloned)
	abductee_cloned.add_to_group("Grabbed")
	abductee_cloned.is_clone = true
	abductee_cloned.is_available = true
	Messenger.grab_begun.emit(abductee_cloned)
	
	set_cloned_abductee_properties(abductee_cloned,og_grabbed_abductee)
	abductee_cloned.apply_human_appearance() # Bool is "should_randomize"

func set_cloned_abductee_properties(clone, og):
	var variables = [
		"is_empathy_event",
		"is_military",
		"clothing_top",
		"clothing_bottom",
		"head_name",
		"is_armed",
		"has_weapon",
	]
	
	for variable in variables:
		clone.set(variable, og.get(variable))

		
func menu_alien_ray():
	if get_viewport() == null:
		return
		
	var raycast_result = hover_ray(16384,true)
	#print(raycast_result)
	if !raycast_result.is_empty():
		hover_target = raycast_result.collider
		
		# Emits signal with parameter "true" or "false" if the hover_target is/isn't set to %Player
		
		if Input.is_action_just_pressed("Action"):
			Messenger.swap_game_state.emit(Globals.is_game_states.CONFIRM)
			#Messenger.swap_game_state.emit(Globals.is_game_states.POSTMENU)

#
#		return raycast_result.collider

func powerup_ray():
	var raycast_result = hover_ray(32,true)
	if !raycast_result.is_empty():
		# These regions could become a single function if needed someday
		#region Orb 1 Interaction
		if raycast_result["collider"].is_type == PowerUp_Orb.is_types.Orb_1:
			#print("Orb 1 is hovered!")
			Messenger.powerup_hovered.emit(1)
			if Input.is_action_just_pressed("Action"):
				Messenger.powerup_chosen.emit(1)
				#print("Left orb chosen")
		#endregion
		#region Orb 2 Interaction
		if raycast_result["collider"].is_type == PowerUp_Orb.is_types.Orb_2:
			Messenger.powerup_hovered.emit(2)
			if Input.is_action_just_pressed("Action"):
				Messenger.powerup_chosen.emit(2)
				print("Middle orb chosen")
		#endregion
		#region Orb 3 Interaction
		if raycast_result["collider"].is_type == PowerUp_Orb.is_types.Orb_3:
			Messenger.powerup_hovered.emit(3)
			if Input.is_action_just_pressed("Action"):
				Messenger.powerup_chosen.emit(3)
				print("Right orb chosen")
		#endregion

func player_hover_ray(): ## Player Hover detection
	var raycast_result = hover_ray(32768,true)
	#print(raycast_result)
	if !raycast_result.is_empty():
		hover_target = raycast_result.collider
		
		# Emits signal with parameter 1 being "true" or "false" if the hover_target is/isn't set to %Player; parameter 2 determines if the player is attacking with its head or not.
		Messenger.player_hover.emit(hover_target == %Player or hover_target == $"../Player/Alien_V3/DetectionAreas/Area_Head", false)
		#print("Player hover target: ",hover_target.name)
		Messenger.player_head_hover.emit(hover_target == $"../Player/Alien_V3/DetectionAreas/Area_Feed", false)
#
#		return raycast_result.collider

func score_dunk_ray(): ## Score Dunk detection
	var raycast_result = hover_ray(2048,true)
	#print(raycast_result)
	if !raycast_result.is_empty():
		hover_target = raycast_result.collider
		
		# Emits signal with parameter 1 being "true" or "false" if the hover_target is/isn't set to %ScoreDunk
		Messenger.score_dunk_hover.emit(hover_target == %ScoreDunk)
#
#		return raycast_result.collider

func cursor_ray(): ## This should be what the player head follows
	var raycast_result = hover_ray(16,true)
	if !raycast_result.is_empty():
		Messenger.mouse_pos_3d.emit(raycast_result.position)
#	print(raycast_result)

func on_powerup_menu_begin():
	print("Camera3D began powerup menu")
	prevent_attacking = true
	powerups_selectable = true

func on_powerup_chosen(orb):
	prevent_attacking = false
	var orb_chosen = %PowerUp_Menu.get_children()[orb - 1]
	Globals.powerups_available.erase(orb_chosen.powerup_key)
	Globals.powerups_chosen.append(orb_chosen.powerup_key)
	Messenger.add_powerup.emit(orb_chosen.powerup_key)
	powerups_selectable = false

func on_game_premenu():
	menu_pickable = true

func on_game_postmenu():
	menu_pickable = false
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func on_eating_begun():
	prevent_attacking = true

func on_eating_finished():
	prevent_attacking = false

func on_game_play():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func on_game_pause():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
func on_game_menu():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
func on_game_confirm():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
func on_game_over():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
