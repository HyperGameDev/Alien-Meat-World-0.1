extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 6
const FALL_DEATH_DISTANCE = -50

@onready var skeleton: Skeleton3D = get_node("Alien/Armature/Skeleton3D")

var terrain_slowdown = false

#@onready var arm_r = 7
#@onready var arm_l = 2
@onready var head = 5

#@onready var arm_r_rotation = skeleton.get_bone_pose_rotation(arm_r)
#@onready var arm_l_rotation = skeleton.get_bone_pose_rotation(arm_l)
@onready var head_rotation = skeleton.get_bone_pose_rotation(head)

var look_pos

var grab = false
var grabbed_object
var arm_grabbing = 8

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Messenger.amount_slowed.connect(slowdown)
	Messenger.area_undamaged.connect(damage_undetected)
	Messenger.mouse_pos_3d.connect(mouse_pos)
	Messenger.something_grabbed.connect(do_grab)
#
#	print("Elbow L:", arm_l_rotation.x)
#	print("Elbow R:", arm_r_rotation.x)
#	print("Player Layer: ", collision_layer, "; Player Mask: ", collision_mask)
	
	set_max_slides(20)
	
	
	
#func rotate_arm_r_to_direction(dir:Vector3):
#	# Movement logic
#	var pos_2D: Vector2 = Vector2(-transform.basis.z.x, -transform.basis.z.z)
#
#	# Movement application
#	skeleton.set_bone_pose_rotation(arm_r, Quaternion((atan2(dir.x, -dir.z) - .25) * 4, arm_r_rotation.y, arm_r_rotation.z, arm_r_rotation.w))
#	print("R Arm Rotation: ", skeleton.get_bone_pose_rotation(arm_r))
#
#func rotate_arm_l_to_direction(dir:Vector3):
#	# Movement logic
#	var pos_2D: Vector2 = Vector2(-transform.basis.z.x, -transform.basis.z.z)
#
#	# Movement application
#	skeleton.set_bone_pose_rotation(arm_l, Quaternion((atan2(-dir.x, -dir.z) - .25) * 4, arm_l_rotation.y, arm_l_rotation.z, arm_l_rotation.w))
#	print("L Arm Rotation: ", skeleton.get_bone_pose_rotation(arm_l))
	
	
func rotate_head_to_direction(dir:Vector3):
	# Movement logic
	var pos_2D: Vector2 = Vector2(-transform.basis.z.x, -transform.basis.z.z)
	
	# Movement application
	skeleton.set_bone_pose_rotation(head, Quaternion(head_rotation.x, atan2(dir.x, -dir.z) * -2.3, head_rotation.z, head_rotation.w))
	
	
#func rotate_player_to_direction(dir:Vector3):
#	# Movement logic
#	var pos_2D: Vector2 = Vector2(-transform.basis.z.x, -transform.basis.z.z)
#
#	# Movement application
#	rotation.y = -atan2(dir.x, -dir.z)
	


func mouse_pos(mouse):
	look_pos = mouse - self.global_position
#	rotate_arm_r_to_direction(look_pos)
#	rotate_arm_l_to_direction(look_pos)
	rotate_head_to_direction(look_pos)
#	rotate_player_to_direction(look_pos)
	
#	# Follow Cursor
#	skeleton.set_bone_pose_rotation(arm_r, look_pos)
#	skeleton.set_bone_pose_rotation(arm_l, look_pos)
	
func do_grab(what_is_grabbed):
	grabbed_object = what_is_grabbed
#	print("Pos On Grab: ", what_is_grabbed.global_position)
	grab = true
#	aim_bone_at_target(arm_grabbing,grabbed_object)
	move_bone_at_target(arm_grabbing,grabbed_object)
	
#	var stretch_to = what_is_grabbed.global_position
#	var stretch_from: Vector3 = skeleton.get_bone_pose_position(arm_grabbing)
#	skeleton.set_bone_pose_position(arm_grabbing, stretch_to)
#	get_tree().create_tween().tween_method(set_bone_position, Vector3(stretch_from.x, stretch_from.y, stretch_from.z), Vector3(stretch_to.x, stretch_to.y, stretch_to.z), .3)
#	print("Bone Position: ", skeleton.get_bone_pose_position(arm_grabbing))
	await get_tree().create_timer(1.3).timeout
	grab = false
#	aim_bone_at_target(arm_grabbing, null)
	move_bone_at_target(arm_grabbing,null)
	
#func aim_bone_at_target(bone_index:int, target:Node3D):
#	var bone_transform = skeleton.get_bone_global_pose_no_override(bone_index)
#	if(target == null):
#		skeleton.set_bone_global_pose_override(bone_index,bone_transform,1.0,false)
#		return
#
#	var target_pos = to_local(target.global_position)
#	var bone_origin = bone_transform.origin
#	#should also try -PI/2 and also rotated_local() instead of rotated
#	bone_transform.basis = bone_transform.basis.looking_at( -(target_pos - bone_transform.origin).normalized()).rotated(Vector3(1,0,0), -PI/2) 
#	bone_transform.origin = bone_origin
#	skeleton.set_bone_global_pose_override(bone_index,bone_transform,1.0,true)

	
#func set_bone_position(position):
#	skeleton.set_bone_pose_position(arm_grabbing, position)
	
	
func move_bone_at_target(bone_index:int, target:Area3D):
	var bone_transform = skeleton.get_bone_global_pose_no_override(bone_index)
	if(target == null):
		skeleton.set_bone_global_pose_override(bone_index,bone_transform,1.0,false)
		return
	var target_pos = to_local(target.global_position)
	var bone_origin = bone_transform.origin
	bone_transform.origin = target_pos + Vector3(0,((target_pos.z / 8) * -2),0) #could be target.global_position (I don't know xD)
	skeleton.set_bone_global_pose_override(bone_index,bone_transform,1.0,true)

	

func _physics_process(delta):
#	print(grabbed_object)
#	print("Is on floor: ", is_on_floor())
#	print(self.global_position.y)
	if self.global_position.y <= FALL_DEATH_DISTANCE:
		var fall_death = true
		Messenger.instant_death.emit(fall_death)
	
#	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	var input_jump = Input.is_action_just_pressed("ui_accept")
	if input_jump and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_x = Input.get_axis("ui_left", "ui_right")
	var direction_x = (transform.basis * Vector3(input_x, 0, 0)).normalized()
	if direction_x:
		velocity.x = direction_x.x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	var input_up = Input.is_action_pressed("ui_up")
	if input_up and terrain_slowdown == false:
		%TerrainController.terrain_velocity = move_toward(%TerrainController.terrain_velocity, 30, 1)
	if input_up == false and terrain_slowdown == false:
		%TerrainController.terrain_velocity = %TerrainController.TERRAIN_VELOCITY

	var debug_ani_turnaround = $"../Debug".debug_2
#	if grab == false:
	if debug_ani_turnaround == false:
		if input_up == true:
			$Alien/AnimationPlayer.play("Run_1", 1)
		else:
			$Alien/AnimationPlayer.play("Walk_1", 1)
	else:
		$Alien/AnimationPlayer.play("Feed_Walk_1", 1)
#	else:
#		$Alien/AnimationPlayer.play("Walk_1_Grab", .1)
#		await $Alien/AnimationPlayer.animation_finished
#		grab = false
		
	if terrain_slowdown == true:
		$Alien/AnimationPlayer.stop(true)

# Collision stops level movement
	move_and_slide()
	
	

func slowdown(slowdown_amount):
	if slowdown_amount == Obstacle.slowdown_amounts.FULL:
		terrain_slowdown = true
		print("terrain_slowdown:", terrain_slowdown)
		%TerrainController.terrain_velocity = 0
		
func damage_undetected(_bodypart_unarea):
#	print("Feet Unseen")
	terrain_slowdown = false
	print("terrain_slowdown:", terrain_slowdown)



	
func health_hovered(meat_hovered):
	print(meat_hovered)
