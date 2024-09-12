extends Area3D

class_name Copter

signal update_hitpoints
signal is_destroyed

@onready var copter_mesh : Node3D = $copter_001
@onready var terrain_controller : Node3D = get_tree().get_current_scene().get_node("%TerrainController_inScene")
@onready var detect_copterDeath : RayCast3D = %RayCast_copterDeath
#@onready var detect_left = %RayCast_Left
#@onready var detect_right = %RayCast_Right

static var copters_stopped : int = 0

var health_max : int = 2
var health_current : int = 2
var damage_taken : int = 1

var copter_pos: Vector3
var copter_x_pos_min : int = -15
var copter_x_pos_max : int = 15

var copter_spawn_z_pos : int = -130

var speed : int = 50

var velocity = Vector3.ZERO

var is_moving : bool = true
var is_dying : bool = false

var projectile_interval_min : float = .1
var projectile_interval_max : float = 4.0

@onready var projectile_interval_timer : Timer = Timer.new()


@onready var copter_area : Area3D = self
@onready var player_proximity : Area3D = get_tree().get_current_scene().get_node("Player/Alien_V3/DetectionAreas/Area_Player-Proximity")

@onready var player_head = get_tree().get_current_scene().get_node("Player/Alien_V3/DetectionAreas/Area_Head/CollisionA_AlienHead")


# Called when the node enters the scene tree for the first time.
func _ready():
	update_hitpoints.emit()
	update_hitpoints.connect(health_effects)
	set_collision_layer_value(1, false)
	set_collision_layer_value(2, true)
	
	set_collision_mask_value(1, false)
	
	player_proximity.area_entered.connect(copter_stop)
	
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	projectile_interval_timer.timeout.connect(on_projectile_interval_timeout)
	projectile_interval_timer.one_shot = true
	add_child(projectile_interval_timer)
	projectile_interval_timer.start(randf_range(projectile_interval_min,projectile_interval_max))

	
	$Animation_CopterBlades.play("propeller_speed-01")

	var copter_x_pos = randf_range(copter_x_pos_min,copter_x_pos_max)
	var copter_x_offset = Vector3(copter_x_pos, 0, 0)
	copter_pos = Vector3(0,7,copter_spawn_z_pos)
	global_position = copter_pos + copter_x_offset
#
#	print("Trying to move copter ", "(", global_position.z, ") ", "to ", "Player at ", player_proximity.global_position.z)


func _physics_process(delta):
	look_at(player_proximity.global_position)
	if is_moving and !is_dying:
		var direction = (player_proximity.global_position - global_position).normalized()
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
		
		# CONSIDER moving copters_stopped calculation to the Area on the Player if this count is needed on a per-copter basis!
		copters_stopped += 1
		Messenger.copter_unit_stopped.emit(copters_stopped)
#		print(copters_stopped)
		#$Animation_CopterMovement.play("strafing")
		
		
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
		#$Animation_CopterMovement.stop()
		

func _on_mouse_entered(): ## For hover arrow indicator
	pass
	
func _on_mouse_exited(): ## For hover arrow indicator
	pass
	
func on_projectile_interval_timeout():
	projectile_interval_timer.start(randf_range(projectile_interval_min,projectile_interval_max))
	
	var copter_bullet = preload("res://Projectiles/copter_projectile_01.tscn").instantiate()
	get_tree().get_current_scene().add_child(copter_bullet)
	
	copter_bullet.global_position = copter_mesh.global_position
	
	copter_bullet.get_node("Projectile").speed = 1
	
	copter_bullet.get_node("Projectile").direction = (player_head.global_position - copter_bullet.global_position).normalized()
