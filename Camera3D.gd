extends Camera3D

# Cam Movement varsf
@export var cam_lerpspeed = .05
@export var cam_z_offset = 10
const CAM_Z_OFFSET = 10
@export var cam_y_offset = 3.7
@export var cam_x_offset = 0

# Temporary Grab Mechanic vars
@onready var cam_target = %Cam_Target
var is_grabbed = false
var grabbed_object = null
var grab_offset: Vector3 = Vector3(0, 0, 0)
var grab_ray_pos: Vector3 = Vector3(0, 0, 0)

# Raycast 1: Grab var
var grab_target = null

# Raycast 2: Hover-Player var
var hover_target = null


func _ready():	
# Temp Grab setup
	Messenger.health_grabbed.connect(move_health)
	
func _physics_process(_delta):
	# Camera Follow input control
	var input_up = Input.is_action_pressed("ui_up")
	var input_up_end = Input.is_action_just_released("ui_up")
	if input_up and cam_z_offset == CAM_Z_OFFSET:
		cam_z_offset += .75
	if input_up_end and cam_z_offset >= CAM_Z_OFFSET:
		cam_z_offset -= .75
	
	var cam_follow_pos: Vector3 = cam_target.position
	cam_follow_pos.z += cam_z_offset
	cam_follow_pos.y += cam_y_offset
	cam_follow_pos.x += cam_x_offset
	
	# Camera Follow Normalize
	var cam_direction: Vector3 = cam_follow_pos - self.position
	
	self.position += cam_direction * cam_lerpspeed
	self.rotation = cam_target.rotation

func _process(_delta):	
	# Raycast 1: Grab implementation
	grab_ray()
#	print(grab_target)
	
	# Raycast 2: Player Hover implementation
	hover_ray()
	
	# Raycast 3: Cursor Position implementation
	cursor_ray()
	
#	#	# Raycaast 1: Temp Grab-specific
#	if !grab_target: return
#	if grab_target.is_in_group("Meat"):
##		print("Raycast: Sees Health")
#		Messenger.health_hovered.emit(grab_target)

func shoot_ray(mask):
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
	ray_query.collision_mask = mask
	
	return space.intersect_ray(ray_query)


# Raycast 1: Grab hovering
func grab_ray():
	var raycast_result = shoot_ray(2 + 4 + 8)
	if !raycast_result.is_empty():
		grab_ray_pos = raycast_result.position
		grab_target = raycast_result.collider
		Messenger.grab_target.emit(grab_target)
#		print("Raycast sees: ", grab_target)
#		print("Pos: ", grab_target.position)
#		return raycast_result.collider

# Raycast 1: Temp grab application
func move_health():
	if grabbed_object == null:
		grabbed_object = grab_target  # Store the grabbed object
		grab_offset = grabbed_object.global_transform.origin - grab_ray_pos  # Calculate grab offset

	if grabbed_object != null:
		grabbed_object.set_global_position(grab_ray_pos + grab_offset)


# Raycast 2: Player Hovering
func hover_ray():
	var raycast_result = shoot_ray(32768)
#	print(raycast_result)
	if !raycast_result.is_empty():
		hover_target = raycast_result.collider
		
		# Emits signal with parameter "true" or "false" if the hover_target is/isn't set to %Player
		Messenger.player_hover.emit(hover_target == %Player)
#
#		return raycast_result.collider


func cursor_ray():
	var raycast_result = shoot_ray(16)
	if !raycast_result.is_empty():
		Messenger.mouse_pos_3d.emit(raycast_result.position)
#	print(raycast_result)
