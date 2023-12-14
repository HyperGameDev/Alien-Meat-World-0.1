extends Camera3D

@export var cam_target: Node3D
@export var cam_lerpspeed = .05
@export var cam_z_offset = 5.5
@export var cam_y_offset = 3


var is_grabbed = false
var target = null
var grabbed_object = null
var grab_offset: Vector3 = Vector3(0, 0, 0)
var ray_pos: Vector3 = Vector3(0, 0, 0)

func _ready():	
	Messenger.health_grabbed.connect(move_health)
	
func _physics_process(_delta):
	var input_up = Input.is_action_pressed("ui_up")
	var input_up_end = Input.is_action_just_released("ui_up")
	if input_up and cam_z_offset <= 6:
		cam_z_offset += .75
	if input_up_end and cam_z_offset >= 5.5:
		cam_z_offset -= .75
	
	var cam_follow_pos: Vector3 = cam_target.position
	cam_follow_pos.z += cam_z_offset
	cam_follow_pos.y += cam_y_offset
	
	# Normalize
	var cam_direction: Vector3 = cam_follow_pos - self.position
	
	self.position += cam_direction * cam_lerpspeed
	self.rotation = cam_target.rotation

func _process(_delta):
	shoot_ray()
	var new_target = shoot_ray()
	Messenger.object_hovered.emit(new_target)
#	print(target)

func shoot_ray():
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_length = 3000
	var from = project_ray_origin(mouse_pos)
	var to = from + project_ray_normal(mouse_pos) * ray_length
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = from
	ray_query.to = to
	ray_query.collide_with_areas = true
	ray_query.collide_with_bodies = false
	ray_query.collision_mask = 1

	var raycast_result = space.intersect_ray(ray_query)
	if raycast_result.has("position"):
		ray_pos = raycast_result.position

	if raycast_result.has("collider"):
		target = raycast_result.collider
		return raycast_result.collider
		
func move_health(grab_state):
	is_grabbed = grab_state

	if is_grabbed:
		if grabbed_object == null:
			grabbed_object = target  # Store the grabbed object
			grab_offset = grabbed_object.global_transform.origin - ray_pos  # Calculate grab offset

		if grabbed_object != null:
			grabbed_object.set_global_position(ray_pos + grab_offset)
