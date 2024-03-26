extends RigidBody3D

class_name Health

@export var indicator_color = Color(.5,.5,1,1)
@export var empathy_ok = false

@onready var detect_floor = $"RayCast_Floor-Detect"
@onready var hover_arrow = $Arrow_Hover
@onready var camera : Camera3D =  get_tree().get_current_scene().get_node("Camera3D")
@onready var collision = $CollisionShape3D

@export var velocity := 60
@export var grab_distance_offset := 14.

var planeToMoveOn: Plane
var has_been_grabbed = false



var default_material = StandardMaterial3D.new()
var hover_material = StandardMaterial3D.new()
var select_material = StandardMaterial3D.new()


func _ready():
	if !has_node("Arrow_Hover"):
		print("ERROR: Somewhere, a hover arrow child is missing!")
		breakpoint
		
	if !has_node("RayCast_Floor-Detect"):
		print("ERROR: Somewhere, a floor-detect child is missing!")
		breakpoint
		
	hover_arrow.modulate = indicator_color

	
	camera = get_viewport().get_camera_3d()
	
	# TODO: Cows shouldn't need to be on layer 1, but unfortunately... they dowwwwwww3, true)
	set_collision_layer_value(4, true)
	
	set_collision_mask_value(1, true)
	set_collision_mask_value(16, false)
	
	self.add_to_group("Meat")
	# Temporary Collidable Healing
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	
	# Setting up meat material changes based on cursor behavior
	default_material.set_albedo(Color(.32, .75, .35))
	hover_material.set_albedo(Color(.32, .75, .35))
	select_material.set_albedo(Color(1, 0, .1))
	
func _process(delta):
	if not Input.is_action_pressed("Grab"):
		remove_from_group("grabbed")
		
	if Input.is_action_just_released("Grab"):
		has_been_grabbed = false
		Messenger.grab_ending.emit()
		self.linear_velocity = Vector3.ZERO
		

func _physics_process(delta):		
	if is_in_group("grabbed"):
		if !has_been_grabbed:
			_has_been_grabbed()
			has_been_grabbed = true
			
		collision.disabled = true
		var cursorPosition = get_viewport().get_mouse_position()
		var rayStartPoint = camera.project_ray_origin(cursorPosition)
		var rayDirection = camera.project_ray_normal(cursorPosition)
		var goTo = planeToMoveOn.intersects_ray(rayStartPoint, rayDirection)
		self.linear_velocity = (goTo - self.global_position) * velocity
		if detect_floor.is_colliding():
			collision.disabled = false
		else:
			collision.disabled = true
	else:
		collision.disabled = false
		
func _has_been_grabbed():
	planeToMoveOn  = Plane(Vector3(0, 0, 1), camera.global_position.z - grab_distance_offset)
	

func check_area(collided_bodypart):
	# collided_bodypart.mesh.hide()
	# collided_bodypart.mesh
	# print("Health Sees Player")
	Messenger.health_detected.emit(collided_bodypart, empathy_ok)
	

func _on_mouse_entered():
	if !Input.is_action_pressed("Grab"):
		hover_arrow.visible = true
	
func _on_mouse_exited():
	hover_arrow.visible = false
