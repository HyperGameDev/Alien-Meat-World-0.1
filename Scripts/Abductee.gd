extends RigidBody3D

class_name Abductee

var is_interactable: bool = false

@export var is_type: is_types
enum is_types {COW, HUMAN, TREE1}

@export var indicator_color: Color = Color(.5, .5, 1.0, 1.0)

@export var empathy_ok: bool = false
@export var abduction_offset: Vector3 = Vector3(0,.5,0)

# If we decide on different meats having different values, use this (or another) value to add the meat to a different dunked group that can then be calculated differently by the score dunk.
#@export var score_value = 1


@onready var detect_surface: RayCast3D = $RayCast_surfaceDetect
@onready var interactable_indicator: MeshInstance3D = $Mesh_Interactable

@onready var camera : Camera3D =  get_tree().get_current_scene().get_node("Camera3D")
@onready var player : CharacterBody3D =  get_tree().get_current_scene().get_node("Player")
@onready var collision : CollisionShape3D = $CollisionShape3D
#@onready var grab_target: Node3D = get_tree().get_current_scene().get_node("Player/Grab_Target/Grab_Target_offset")
@onready var grab_target: Node3D = get_tree().get_current_scene().get_node("Player/Grab_Target/Grab_Target_offset")

@export var velocity : int = 60
@export var grab_distance_offset : float = 14.0

var planeToMoveOn : Plane
var has_been_grabbed : bool = false
#var grab_position : Vector2 = Vector2(0,0)
var cursorPosition_on_grab : Vector2 = Vector2(0,0)

var is_in_dunk : bool = false
var has_been_dunked : bool = false

var default_material := StandardMaterial3D.new()
var hover_material := StandardMaterial3D.new()
var select_material := StandardMaterial3D.new()

var is_available : bool = false
var is_clone : bool = false
var spawned : bool = false

var fell : bool = false

@onready var hand_pos : Marker3D =  get_tree().get_current_scene().get_node("Player/Alien_V3/DetectionAreas/Area_ArmR/Marker_HandR")

func _ready():
	if !has_node("RayCast_surfaceDetect"):
		print("ERROR: Somewhere, a surface detecting child is missing!")
		breakpoint
		
	if !has_node("Mesh_Interactable"):
		print("ERROR: Somewhere, a Mesh interactable child is missing!")
		breakpoint

	
	camera = get_viewport().get_camera_3d()
	
#	print("Meat Layer: ", collision_layer, "; Meat Mask: ", collision_mask)

	#set_collision_layer_value(4, true) # Allows it to be grabbed

	# Cow Layer Properties are in PHYSICS PROCESS!!
	set_collision_mask_value(1, true)
	set_collision_mask_value(16, false)
	
	self.add_to_group("Abductee")
	

	body_entered.connect(on_body_entered)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	Messenger.abductee_hovered.connect(on_abductee_hovered)
	
	
	Messenger.meat_entered_dunk.connect(on_meat_entered_dunk)
	Messenger.meat_left_dunk.connect(on_meat_left_dunk)
	Messenger.dunk_is_at_position.connect(on_dunk_is_at_position)
	
	
	
	# Setting up meat material changes based on cursor behavior
	default_material.set_albedo(Color(.32, .75, .35))
	hover_material.set_albedo(Color(.32, .75, .35))
	select_material.set_albedo(Color(1.0, .0, .1))
	
	interactable_indicator.get_node("AnimationPlayer").play("interactable")
	interactable_indicator.visible = false
	
func _process(_delta: float) -> void:
	if Input.is_action_just_released("Grab"):
		if is_in_group("Grabbed"):
			add_to_group("Dropped")
			remove_from_group("Grabbed")
		has_been_grabbed = false
		Messenger.grab_ended.emit()
		self.linear_velocity = Vector3.ZERO
	if is_in_dunk:
		Messenger.meat_in_dunk.emit(self)
		has_been_dunked = true
		

func _physics_process(_delta: float) -> void:
	interactable_indicator.global_position.x = global_position.x
	interactable_indicator.global_position.z = global_position.z
	
	if !spawned:
		spawn_me()
		
	else:
		if is_interactable:
			set_collision_layer_value(4, true)
		else:
			set_collision_layer_value(4, false)
			
	if is_available:
		set_collision_layer_value(9, true)
		visible = true
	else:
		set_collision_layer_value(4, false)
		visible = false
		
	#if is_in_group("Dropped"):
		#set_collision_mask_value(1, false)
		
	if self.global_position.y <= -50:
		if is_in_group("Dropped"):
			pass
			#print("Dropped Meat Object deleted by Y")
		else:
			if !fell:
				fell = true
				#print("DEFAULT Meat Object deleted by Y")
		queue_free()
		
	if self.global_position.z > 4:
		if is_in_group("Dropped"):
			#print("Dropped Meat Object deleted by Z")
			queue_free()
		
			
	if is_in_group("Grabbed"):
		interactable_indicator.visible = false
		if !has_been_grabbed:
			_has_been_grabbed()
			has_been_grabbed = true
			
#		collision.disabled = true
		#var grab_position : Vector2 = camera.unproject_position(hand_pos.position)
		#print("Human Grabbed Pos: ",grab_position)
		##var grab_position : Vector2 = get_viewport().get_mouse_position()
		##print(cursorPosition_offset)
		#var rayStartPoint : Vector3 = camera.project_ray_origin(grab_position)
		#var rayDirection : Vector3 = camera.project_ray_normal(grab_position)
		#var goTo = planeToMoveOn.intersects_ray(rayStartPoint, rayDirection)
		
		#self.linear_velocity = (goTo - self.global_position) * velocity
		#self.linear_velocity = (grab_target.global_position - self.global_position) * velocity
		self.global_position = grab_target.global_position
		

	else:
		if is_in_group("Dropped") and detect_surface.is_colliding():
			if !detect_surface.get_collider() == self.get_parent():
				self.reparent(detect_surface.get_collider())
			
	
func on_abductee_hovered(target):
	#print("Something hovered emitted! On...?")
	if target == self:
		if has_node("Marker3D"):
			#print("Something hovered emitted! On ",self,"!")
			Messenger.something_hovered.emit(self)			
				
				
func spawn_me():
	spawned = true
	if !is_in_group("Grabbed"):
		if !is_in_group("Dunked"):
			var boolean = pow(-1, randi() % 2)
			if boolean > 0:
				is_available = true
			else:
				is_available = false
		
func on_dunk_is_at_position(dunk_position):
	if has_been_dunked:
		self.global_position = dunk_position - abduction_offset
		collision.disabled = true
		self.add_to_group("Dunked")
	
func _has_been_grabbed():
	Messenger.grab_begun.emit(self)
	var plane_z_position: float = player.global_position.z
	planeToMoveOn = Plane(Vector3(0,0,1), plane_z_position)
	#cursorPosition_on_grab = get_viewport().get_mouse_position()
	#print("Initial grab pos: ",cursorPosition_on_grab)
	
	

	#self.reparent(get_tree().get_current_scene())


func on_meat_entered_dunk(dunked_body):
	if dunked_body == self:
		is_in_dunk = true
		
func on_meat_left_dunk(dunked_body):
	if dunked_body == self:
		is_in_dunk = false
	

func on_body_entered(collided_bodypart):
	#collided_bodypart.mesh.hide()
	#collided_bodypart.mesh
	#print("Abductee Sees Player")
	Messenger.abductee_detected.emit(collided_bodypart, empathy_ok)
	
 
func _on_mouse_entered(): ## For hover arrow indicator
	pass
	
func _on_mouse_exited(): ## For hover arrow indicator
	pass
