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

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Messenger.amount_slowed.connect(slowdown)
	Messenger.area_undamaged.connect(damage_undetected)
	Messenger.mouse_pos_3d.connect(mouse_pos)
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
	

func _physics_process(delta):
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

	var debug_2 = $"../Debug".debug_2
	if debug_2 == false:
		if input_up == true:
			$Alien/AnimationPlayer.play("Run_1", 1)
		else:
			$Alien/AnimationPlayer.play("Walk_1", 1)
	else:
		$Alien/AnimationPlayer.play("Feed_Walk_1", 1)
		
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
