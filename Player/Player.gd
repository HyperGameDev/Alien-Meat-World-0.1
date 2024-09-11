extends CharacterBody3D

const SPEED : float = 5.0
const JUMP_VELOCITY : int = 6
const FALL_DEATH_DISTANCE : int = -50
const BOUNDARY_DISTANCE : int = 30

@export var controls_locked : bool = true

@onready var camera: Camera3D = %Camera3D

@onready var animation: AnimationTree = get_node("Alien_V3/Alien/AnimationTree_Alien")
@onready var animation_armature: AnimationPlayer = get_node("Alien_V3/Alien/Armature/AnimationPlayer")

@onready var skeleton: Skeleton3D = get_node("Alien_V3/Alien/Armature/Skeleton3D")
@onready var skeleton_hurt: Skeleton3D = get_node("Alien_V3/Alien/Armature_hurt/Skeleton3D")

@onready var collision_area_armr_upper: CollisionShape3D = $Alien_V3/DetectionAreas/Area_ArmR/CollisionA_ArmR_Upper
@onready var collision_area_armr_lower: CollisionShape3D = $Alien_V3/DetectionAreas/Area_ArmR/CollisionA_ArmR_Lower
@onready var collision_area_hurt_armr_upper: CollisionShape3D = $"Alien_V3/DetectionAreas/Area_ArmR/CollisionA-hurt_ArmR_Upper"
@onready var collision_area_hurt_armr_lower: CollisionShape3D = $"Alien_V3/DetectionAreas/Area_ArmR/CollisionA-hurt_ArmR_Lower"

@onready var mesh_orb: MeshInstance3D = get_node("Alien_V3/Alien/Orb_New-Game-Teleporter")
@onready var animation_orb: AnimationPlayer = get_node("Alien_V3/Alien/Orb_New-Game-Teleporter/AnimationPlayer")
var orb_onscreen : bool = false

@onready var terrain_controller : Node3D = %TerrainController_inScene
var terrain_slowdown : bool = false

var is_grabbing : bool = false
var is_eating : bool = false


#@onready var arm_r = 7
#@onready var arm_l = 2
@onready var head : int = 6

#@onready var arm_r_rotation = skeleton.get_bone_pose_rotation(arm_r)
#@onready var arm_l_rotation = skeleton.get_bone_pose_rotation(arm_l)
@onready var head_rotation : Quaternion = skeleton.get_bone_pose_rotation(head)

var teleported : bool = false

var look_pos : Vector3

var attack : bool = false
var hit_object : Node3D
var arm_attacking : int = 12
var arm_attacking_child : int = arm_attacking + 1
var stretch_distance : Vector3 = Vector3(0,12,0)
var attack_duration : float = .2

# Distance grabbing arm travels:
var distance : float
var distance_hurt : float


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Messenger.movement_start.connect(on_movement_start)
	Messenger.movement_stop.connect(on_movement_stop)
	Messenger.amount_slowed.connect(on_amount_slowed)
	Messenger.area_undamaged.connect(on_area_undamaged)
	Messenger.mouse_pos_3d.connect(on_mouse_pos_3d)
	Messenger.something_attacked.connect(on_something_attacked)
	Messenger.level_update.connect(on_level_update)
	Messenger.game_begin.connect(on_game_begin)
	Messenger.game_play.connect(on_game_play)
	Messenger.eating_begun.connect(on_eating_begun)
	Messenger.eating_finished.connect(on_eating_finished)
	Messenger.grab_begun.connect(on_grab_begun)
	Messenger.grab_ended.connect(on_grab_ended)


#	print("Elbow L:", arm_l_rotation.x)
#	print("Elbow R:", arm_r_rotation.x)
#	print("Player Layer: ", collision_layer, "; Player Mask: ", collision_mask)
	
	on_level_update(Globals.level_current)
	set_max_slides(20)
	
	mesh_orb.visible = false

	
func _physics_process(delta):
	if Globals.is_game_state == Globals.is_game_states.BEGIN and !teleported:
		new_game_teleport()
#	aim_bone_at_target(arm_attacking, hit_object)
#	print(hit_object)
#	print("Is on floor: ", is_on_floor())
#	print(self.global_position.y)

	# Fall Death
	if self.global_position.y <= FALL_DEATH_DISTANCE:
		var fall_death = true
		Messenger.instant_death.emit(fall_death)
	
#	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	if !controls_locked:
		# Handle Jump.
		var input_jump = Input.is_action_just_pressed("Jump")
		if input_jump and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_x = Input.get_axis("Move Left", "Move Right")
		var direction_x = (transform.basis * Vector3(input_x, 0, 0)).normalized()
		if direction_x:
			velocity.x = direction_x.x * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
		var input_up = Input.is_action_pressed("Move Forward")
		if input_up and terrain_slowdown == false:
			terrain_controller.terrain_velocity = move_toward(terrain_controller.terrain_velocity, 30, 1)
		if input_up == false and terrain_slowdown == false:
			Messenger.movement_start.emit(false)

		if input_up == true:
			animation.set("parameters/walk to run/transition_request", "running")
		else: 
			if !terrain_slowdown:
				animation.set("parameters/walk to run/transition_request", "walking")

# Collision stops level movement
	move_and_slide()
	position.x = clamp(position.x,-BOUNDARY_DISTANCE,BOUNDARY_DISTANCE)


func rotate_head_to_direction(dir:Vector3):
	# Movement logic
	var pos_2D: Vector2 = Vector2(-transform.basis.z.x, -transform.basis.z.z)
	
	# Movement application
	skeleton.set_bone_pose_rotation(head, Quaternion(head_rotation.x, atan2(dir.x, -dir.z) * -3, head_rotation.z, head_rotation.w))
	skeleton_hurt.set_bone_pose_rotation(head, Quaternion(head_rotation.x, atan2(dir.x, -dir.z) * -3, head_rotation.z, head_rotation.w))
	
#func rotate_player_to_direction(dir:Vector3):
#	# Movement logic
#	var pos_2D: Vector2 = Vector2(-transform.basis.z.x, -transform.basis.z.z)
#
#	# Movement application
#	rotation.y = -atan2(dir.x, -dir.z)

func on_mouse_pos_3d(mouse):
	look_pos = mouse - self.global_position
#	rotate_arm_r_to_direction(look_pos)
#	rotate_arm_l_to_direction(look_pos)

	rotate_head_to_direction(look_pos)
	
#	rotate_player_to_direction(look_pos)
	
#	# Follow Cursor
#	skeleton.set_bone_pose_rotation(arm_r, look_pos)
#	skeleton.set_bone_pose_rotation(arm_l, look_pos)

func attack_action_tween(amount):
	if !skeleton.is_inside_tree():
		return
		
	if hit_object != null:
	#		print("Object isn't Null (", hit_object.name, ")")
			aim_bone_at_target(arm_attacking,hit_object,amount)
			
	else:
	#		print("Object Null!")
			aim_bone_at_target(arm_attacking,null,amount)
	
func on_something_attacked(what_is_hit):
	if !attack:
		attack = true
		
		collision_area_armr_upper.set_deferred("disabled", true)
		collision_area_armr_lower.set_deferred("disabled", true)
		collision_area_hurt_armr_upper.set_deferred("disabled", true)
		collision_area_hurt_armr_lower.set_deferred("disabled", true)
		
	#	if grab == true
		hit_object = what_is_hit
		#print("Grab Begun on ", hit_object.name)

		animation.set("parameters/reach right/request", 1)
		get_tree().create_tween().tween_method(attack_action_tween,0.0,1.0,attack_duration)
		
	#	aim_bone_at_target(arm_attacking,hit_object, 0.0)
		await get_tree().create_timer(attack_duration * 2).timeout
		var area = what_is_hit
		var is_delayed = true
		Messenger.something_hit.emit(area,is_delayed)
	#	print("Grab Ending from ", hit_object.name)
		# Retract the arm
		get_tree().create_tween().tween_method(attack_action_tween,1.0,0.0,attack_duration)
		await get_tree().create_timer(attack_duration).timeout
		collision_area_armr_upper.set_deferred("disabled", false)
		collision_area_armr_lower.set_deferred("disabled", false)
		collision_area_hurt_armr_upper.set_deferred("disabled", false)
		collision_area_hurt_armr_lower.set_deferred("disabled", false)
		
		attack = false
	


func aim_bone_at_target(bone_index:int, target:Node3D, amount:float):
	var bone_transform = skeleton.get_bone_global_pose_no_override(bone_index)
	var bone_transform_hurt = skeleton_hurt.get_bone_global_pose_no_override(bone_index)
	
	var bone_origin = bone_transform.origin
	var bone_origin_hurt = bone_transform_hurt.origin
	
	if(target == null):
#		print("Object Null, Arm is snapping back.", "(Tween amount is: ", amount, ")")
		skeleton.set_bone_global_pose_override(bone_index,bone_transform,amount,false)
		skeleton_hurt.set_bone_global_pose_override(bone_index,bone_transform_hurt,amount,false)
		return
		
#	print ("Object is ", target.name, ". Arm is moving.", "(Tween amount is: ", amount, ")")
	
#region Healthy Arm Code
	var target_pos = skeleton.to_local(target.global_position)
	var direction = (target_pos - bone_transform.origin).normalized()
	distance = target_pos.distance_to(bone_transform.origin)
	
	var new_transform:Transform3D = bone_transform
	new_transform.origin = bone_origin
	
	new_transform = transform_look_at(new_transform, direction)

	new_transform.basis.y *= distance
#endregion

#region Hurt Arm Code
	var target_pos_hurt = skeleton_hurt.to_local(target.global_position)
	var direction_hurt = (target_pos_hurt - bone_transform_hurt.origin).normalized()
	distance_hurt = target_pos_hurt.distance_to(bone_transform_hurt.origin)
	
	var new_transform_hurt:Transform3D = bone_transform_hurt
	new_transform_hurt.origin = bone_origin_hurt
	
	new_transform_hurt = transform_look_at(new_transform_hurt, direction_hurt)

	new_transform_hurt.basis.y *= distance_hurt
#endregion

	skeleton.set_bone_global_pose_override(bone_index,new_transform,amount,true)
	skeleton_hurt.set_bone_global_pose_override(bone_index,new_transform_hurt,amount,true)


func transform_look_at(_transform,direction):
	var xform:Transform3D = _transform
	xform.basis.y = direction
	xform.basis.x = -xform.basis.z.cross(direction)
	xform.basis = xform.basis.orthonormalized()
#	stretch_to_target()
	return xform
	

func on_area_undamaged(_bodypart_unarea):
#	print("Feet Unseen")
	terrain_slowdown = false
#	print("terrain_slowdown:", terrain_slowdown)
	
func abductee_hovered(abductee):
#	print(abductee)
	pass


func on_amount_slowed(slowdown_amount):
	if slowdown_amount == Obstacle.slowdown_amounts.FULL:
		Messenger.movement_stop.emit(false)
		
func on_level_update(level):
	if level == 0:
		self.visible = false
		controls_locked = true
		
func on_movement_start(unlock_controls):
	terrain_slowdown = false
	animation.set("parameters/walk to run/transition_request", "walking")
	if unlock_controls:
		controls_locked = false
	
func on_movement_stop(lock_controls):
	terrain_slowdown = true
	velocity = Vector3(0,0,0)
	animation.set("parameters/walk to run/transition_request", "idling")
	if lock_controls:
		controls_locked = true

func on_game_begin():
	self.visible = true
	
func new_game_teleport():
	if camera.position.y <= 30.0:
		teleported = true
		mesh_orb.visible = true
		animation_orb.play("teleport")
		animation_armature.play("teleport")
		

func on_game_play():
	controls_locked = false
	
	
func on_grab_begun():
	is_grabbing = true
	animation.process_priority = 0
	animation.set("parameters/hungry/request", 1)
	
func on_grab_ended():
	if is_grabbing:
		animation.set("parameters/hungry/request", 3)
		await get_tree().create_timer(.2).timeout
		is_grabbing = false
		if !is_eating:
			animation.process_priority = -1
		else:
			pass
	
func on_eating_begun():
	is_eating = true
	animation.process_priority = 0
	animation.set("parameters/feed/request", 1)
	
func on_eating_finished():
	animation.process_priority = -1
	is_eating = false
