extends Camera3D

var is_grabbed = false
var target = null
var grabbed_object = null
var grab_offset: Vector3 = Vector3(0, 0, 0)
var ray_pos: Vector3 = Vector3(0, 0, 0)

func _ready():
	Messenger.health_grabbed.connect(move_health)

func _process(delta):
	shoot_ray()
	var new_target = shoot_ray()
	Messenger.object_hovered.emit(new_target)

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
