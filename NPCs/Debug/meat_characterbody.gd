extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var is_grabbed = false
var move_position: Vector3
var grab_offset
var mouse_pos: Vector2

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Messenger.grab_target.connect(on_target_hovered)
	Messenger.mouse_pos_3d.connect(get_raycast_pos)
	
	set_collision_layer_value(3, true)
	set_collision_layer_value(4, true)
	
	set_collision_mask_value(1, true)
	set_collision_mask_value(16, true)
	
	self.add_to_group("Meat")
	
func get_raycast_pos(ray_position):
	move_position = ray_position
	
	
func on_target_hovered(target):
	if target == self and Input.is_action_pressed("Grab"):
		print(move_position)
		is_grabbed = true
	else:
		is_grabbed = false
		

func _process(delta):
	mouse_pos = get_viewport().get_mouse_position()
	move_position = Vector3(mouse_pos.x,mouse_pos.y,position.z)
	
	if Input.is_action_just_released("Grab"):
		is_grabbed = false
	
	if is_grabbed:# Calculate grab offset
		if !move_position == null:
			velocity = move_position


func _physics_process(delta):
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

#	# Handle Jump.
#	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
#		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
#	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
#	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
#	if direction:
#		velocity.x = direction.x * SPEED
#		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
