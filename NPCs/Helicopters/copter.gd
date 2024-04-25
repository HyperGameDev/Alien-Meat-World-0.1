extends Area3D

class_name Copter

signal update_hitpoints
signal is_destroyed

@export var indicator_color = Color(1,0,0,1)
@onready var hover_arrow = $Arrow_Hover
@onready var copter_mesh = $copter_001
@onready var terrain_controller = get_tree().get_current_scene().get_node("%TerrainController_inScene")
@onready var detect_copterDeath = %RayCast_copterDeath
#@onready var detect_left = %RayCast_Left
#@onready var detect_right = %RayCast_Right

static var copters_stopped = 0

var health_max = 2
var health_current = 2
var damage_taken = 1

var copter_pos: Vector3
var copter_x_pos_min = -15
var copter_x_pos_max = 15

var copter_spawn_z_pos = -130

var speed = 50

var velocity = Vector3.ZERO

var is_moving = true
var is_dying = false

@onready var nav_agent = $NavigationAgent3D

@onready var copter_area = self
@onready var player = get_tree().get_current_scene().get_node("Player/DetectionAreas/Area_Player-Proximity")


# Called when the node enters the scene tree for the first time.
func _ready():
	if !has_node("Arrow_Hover"):
		print("ERROR: Somewhere, a hover arrow child is missing!")
		breakpoint
		
	update_hitpoints.emit()
	update_hitpoints.connect(health_effects)
	set_collision_layer_value(1, false)
	set_collision_layer_value(3, true)
	
	set_collision_mask_value(1, false)
	
	player.area_entered.connect(copter_stop)
	nav_agent.velocity_computed.connect(copter_nav)
	
	
	hover_arrow.modulate = indicator_color
	
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

	
	$Animation_CopterBlades.play("propeller_speed-01")

	var copter_x_pos = randf_range(copter_x_pos_min,copter_x_pos_max)
	var copter_x_offset = Vector3(copter_x_pos, 0, 0)
	copter_pos = Vector3(0,7,copter_spawn_z_pos)
	global_position = copter_pos + copter_x_offset
#
#	print("Trying to move copter ", "(", global_position.z, ") ", "to ", "Player at ", player.global_position.z)


func _physics_process(delta):
	look_at(player.global_position)
	if is_moving and !is_dying:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		global_position += velocity * delta 
	if is_dying:
		var ROTATION_SPEED = 7
		var direction = Vector3(0,-.02,terrain_controller.terrain_velocity/50)
		velocity = direction * speed
		global_position += velocity * delta
		copter_mesh.rotation.y += ROTATION_SPEED * delta
	
	if detect_copterDeath.is_colliding():
		is_destroyed.emit()
		copter_mesh.visible = false
		$NavigationAgent3D.avoidance_enabled = false
		
	# Part of an attempt at custom pathfinding. Should look into PhysicsDirectSpaceState3D class or something. Will need to interpolate movement	
	#if detect_left.is_colliding():
		#var left = detect_left.get_target_position()
		#global_position += left * -1 
		#print(left)
		
		
#	if global_position.y >= 2.3:
#		nav_agent.use_3d_avoidance = false
#		print("A Copter Went Too High! 3D Avoidance is ", nav_agent.use_3d_avoidance)

		
	
func copter_stop(thing_in_player_perimeter):
#	print("Player Proximity sees: ", thing_in_player_perimeter, "; it should see: ", copter_area)
	if thing_in_player_perimeter == copter_area:
		is_moving = false
#		print(copter_area, " was actually seen!")
		
		# Consider moving copters_stopped calculation to the Area on the Player if this count is needed on a per-copter basis!
		copters_stopped += 1
		Messenger.copter_unit_stopped.emit(copters_stopped)
#		print(copters_stopped)
		
func copter_nav(safe_velocity):
	global_position += safe_velocity * get_physics_process_delta_time()
	

func health_effects():
	if health_current <= 0: # Is Dead
		is_moving = false
		is_dying = true
		$CollisionShape3D.disabled = true
		$HitPoints.is_dead = true
#		$Animation_CopterDeath.play("falling")
		var tween = get_tree().create_tween();
		tween.tween_property(copter_mesh, "rotation:x", deg_to_rad(44), 1)
		

func _on_mouse_entered():
	if !Input.is_action_pressed("Grab"):
		hover_arrow.visible = true
	
func _on_mouse_exited():
	hover_arrow.visible = false

