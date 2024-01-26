extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 6
const FALL_DEATH_DISTANCE = -50

var terrain_slowdown = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Messenger.amount_slowed.connect(slowdown)
	Messenger.area_undamaged.connect(damage_undetected)
	
	set_max_slides(20)


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
#		print("terrain_slowdown:", terrain_slowdown)
		%TerrainController.terrain_velocity = 0
		
func damage_undetected(_bodypart_unarea):
#	print("Feet Unseen")
	terrain_slowdown = false


	
func health_hovered(meat_hovered):
	print(meat_hovered)
