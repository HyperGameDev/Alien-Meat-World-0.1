extends RigidBody3D

class_name Health

@export var empathy_ok = false
@onready var meat_mesh = $Meat_Object
@onready var camera : Camera3D =  get_tree().get_current_scene().get_node("Camera3D")

@export var velocity := 0

var planeToMoveOn: Plane
var has_been_grabbed = false



var default_material = StandardMaterial3D.new()
var hover_material = StandardMaterial3D.new()
var select_material = StandardMaterial3D.new()


func _ready():
	camera = get_viewport().get_camera_3d()
	
	# TODO: Cows shouldn't need to be on layer 1, but unfortunately... they do
#	set_collision_layer_value(1, false)
	
	set_collision_layer_value(3, true)
	set_collision_layer_value(4, true)
	
	set_collision_mask_value(1, true)
	set_collision_mask_value(16, true)
	
	self.add_to_group("Meat")
	# Temporary Collidable Healing
#	area_entered.connect(check_area)
	
	# Messenger informing script what is hovered
	Messenger.grab_target.connect(is_grabbed)	
	
	
	# Setting up meat material changes based on cursor behavior
	default_material.set_albedo(Color(.32, .75, .35))
	hover_material.set_albedo(Color(.32, .75, .35))
	select_material.set_albedo(Color(1, 0, .1))
	
func _process(delta):
	if not Input.is_action_pressed("Grab"):
		remove_from_group("grabbed")
	if Input.is_action_just_released("Grab"):
		has_been_grabbed = false

func _physics_process(delta):
	if is_in_group("grabbed"):
		if !has_been_grabbed:
			_has_been_grabbed()
			has_been_grabbed = true
		velocity = 100
		var cursorPosition = get_viewport().get_mouse_position()
		var rayStartPoint = camera.project_ray_origin(cursorPosition)
		var rayDirection = camera.project_ray_normal(cursorPosition)
		var goTo = planeToMoveOn.intersects_ray(rayStartPoint, rayDirection)
		self.linear_velocity = (goTo - self.global_position) * velocity
	else:
		velocity = 0
		self.linear_velocity = self.global_position * velocity
		
func _has_been_grabbed():
	planeToMoveOn  = Plane(Vector3(0, 0, 1), self.global_position.z)
	

func check_area(collided_bodypart):
	# collided_bodypart.mesh.hide()
	# collided_bodypart.mesh
	# print("Health Sees Player")
	Messenger.health_detected.emit(collided_bodypart, empathy_ok)
	
	
func is_grabbed(grab_target):
	# Meat is Hovered
	if self == grab_target:
		# Show Arrow
		meat_mesh.visible = true
	else:
		# Hide Arrow
		meat_mesh.visible = false
		
	# Meat is Selected	
	if self == grab_target and Input.is_action_pressed("Grab"):
		Messenger.health_grabbed.emit()
		# Hide Arrow
		meat_mesh.visible = false

		
	# Meat is Unselected (When Not Hovering)	
	if meat_mesh.material_override == select_material and self == grab_target:
		# Hide Arrow
		meat_mesh.visible = false
		# Change Material
		meat_mesh.material_override = default_material
