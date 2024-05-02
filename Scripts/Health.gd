extends RigidBody3D

class_name Health

@export var is_type: is_types
enum is_types {COW, HUMAN}
@export var indicator_color = Color(.5,.5,1,1)
@export var empathy_ok = false
@export var abduction_offset = Vector3(0,.5,0)

# If we decide on different meats having different values, use this (or another) value to add the meat to a different dunked group that canthen be calculated differently by the score dunk.
#@export var score_value = 1

@onready var detect_surface = $RayCast_surfaceDetect

@onready var hover_arrow = $Arrow_Hover
@onready var camera : Camera3D =  get_tree().get_current_scene().get_node("Camera3D")
@onready var player : CharacterBody3D =  get_tree().get_current_scene().get_node("Player")
@onready var collision = $CollisionShape3D

@export var velocity := 60
@export var grab_distance_offset := 14.0

var planeToMoveOn: Plane
var has_been_grabbed = false

var is_in_dunk = false
var has_been_dunked = false


var default_material = StandardMaterial3D.new()
var hover_material = StandardMaterial3D.new()
var select_material = StandardMaterial3D.new()

var spawn = false
var spawned = false

var fell = false

func _ready():
	if !has_node("Arrow_Hover"):
		print("ERROR: Somewhere, a hover arrow child is missing!")
		breakpoint
		
	if !has_node("RayCast_surfaceDetect"):
		print("ERROR: Somewhere, a surface detecting child is missing!")
		breakpoint
		
	hover_arrow.modulate = indicator_color

	
	camera = get_viewport().get_camera_3d()
	
#	print("Meat Layer: ", collision_layer, "; Meat Mask: ", collision_mask)

	#set_collision_layer_value(4, true) # Allows it to be grabbed

	set_collision_mask_value(1, true)
	set_collision_mask_value(16, false)
	
	self.add_to_group("Meat")
	

	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	
	Messenger.meat_entered_dunk.connect(on_meat_entered_dunk)
	Messenger.meat_left_dunk.connect(on_meat_left_dunk)
	Messenger.dunk_is_at_position.connect(on_dunk_is_at_position)
	
	
	
	# Setting up meat material changes based on cursor behavior
	default_material.set_albedo(Color(.32, .75, .35))
	hover_material.set_albedo(Color(.32, .75, .35))
	select_material.set_albedo(Color(1, 0, .1))
	
	
func _process(delta):
	if Input.is_action_just_released("Grab"):
		if is_in_group("Grabbed"):
			add_to_group("Dropped")
		remove_from_group("Grabbed")
		has_been_grabbed = false
		Messenger.grab_ended.emit()
		self.linear_velocity = Vector3.ZERO
		if is_in_dunk:
			Messenger.meat_in_dunk.emit(self)			
#			print(self.name, " released in dunk")
			has_been_dunked = true
		

func _physics_process(delta):
	if !spawned:
		spawn_me()
	if spawn:
		set_collision_layer_value(4, true)
		visible = true
	else:
		set_collision_layer_value(4, false)
		visible = false
		
	#if is_in_group("Dropped"):
		#set_collision_mask_value(1, false)
		
	if self.global_position.y <= -50:
		if is_in_group("Dropped"):
			print("Dropped Meat Object deleted by Y")
		else:
			if !fell:
				fell = true
				print("DEFAULT Meat Object deleted by Y")
		queue_free()
		
	if self.global_position.z > 4:
		if is_in_group("Dropped"):
			print("Dropped Meat Object deleted by Z")
			queue_free()
		
			
	if is_in_group("Grabbed"):
		if !has_been_grabbed:
			_has_been_grabbed()
			has_been_grabbed = true
			
#		collision.disabled = true
		var cursorPosition = get_viewport().get_mouse_position()
		var rayStartPoint = camera.project_ray_origin(cursorPosition)
		var rayDirection = camera.project_ray_normal(cursorPosition)
		var goTo = planeToMoveOn.intersects_ray(rayStartPoint, rayDirection)
		self.linear_velocity = (goTo - self.global_position) * velocity
	else:
		if is_in_group("Dropped") and detect_surface.is_colliding():
			if !detect_surface.get_collider() == self.get_parent():
				self.reparent(detect_surface.get_collider())
			
			
func spawn_me():
	spawned = true
	if !is_in_group("Grabbed"):
		if !is_in_group("Dunked"):
			var boolean = pow(-1, randi() % 2)
			if boolean > 0:
				spawn = true
			else:
				spawn = false
		
func on_dunk_is_at_position(dunk_position):
	if has_been_dunked:
		self.global_position = dunk_position - abduction_offset
		collision.disabled = true
		self.add_to_group("Dunked")
	
func _has_been_grabbed():
	Messenger.grab_begun.emit()
	var plane_z_position = player.global_position.z
	planeToMoveOn  = Plane(Vector3(0,0,1), plane_z_position)
#	print(plane_z_position)

	#self.reparent(get_tree().get_current_scene())


func on_meat_entered_dunk(dunked_body):
	if dunked_body == self:
		is_in_dunk = true
		
func on_meat_left_dunk(dunked_body):
	if dunked_body == self:
		is_in_dunk = false
	

#func on_area_entered(collided_bodypart):
	# collided_bodypart.mesh.hide()
	# collided_bodypart.mesh
	# print("Health Sees Player")
	#Messenger.health_detected.emit(collided_bodypart, empathy_ok)
	
 
func _on_mouse_entered():
	if !Input.is_action_pressed("Grab"):
		hover_arrow.visible = true
	
func _on_mouse_exited():
	hover_arrow.visible = false
