extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta):
#	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
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
	if input_up:
		%TerrainController.terrain_velocity = move_toward(%TerrainController.terrain_velocity, 30, 1)
	else:
		%TerrainController.terrain_velocity = %TerrainController.TERRAIN_VELOCITY

# Collision stops level movement
		
	move_and_slide()
