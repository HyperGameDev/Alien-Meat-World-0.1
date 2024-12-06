extends Area3D

class_name Copter

signal update_hitpoints
signal is_destroyed

var interactable: bool = false
var formation_queue_pos: int

@onready var copter_mesh : Node3D = %Mesh_Collection
@onready var terrain_controller : Node3D = get_tree().get_current_scene().get_node("%TerrainController_inScene")
@onready var detect_copterDeath : RayCast3D = %RayCast_copterDeath
#@onready var detect_left = %RayCast_Left
#@onready var detect_right = %RayCast_Right

@onready var flying_enemies_queue: Node3D = get_tree().get_current_scene().get_node("Spawned/Spawned_FlyingEnemies")
@onready var flying_enemies_dying_queue: Node3D = get_tree().get_current_scene().get_node("Spawned/Spawned_FlyingEnemies-dying")
@onready var flying_formation_z_pos: Array = Globals.flying_formation_z_pos

static var copters_stopped : int = 0


@export var is_attacking: bool = true

@export var health_max : int = 2
var health_current : int = health_max
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

var new_meat_spawned: bool = false

@onready var projectile_interval_timer : Timer = Timer.new()


@onready var copter_area : Area3D = self
@onready var player_target : Marker3D = get_tree().get_current_scene().get_node("Player/Alien_V3/Alien/Armature/Skeleton3D/Alien_Head/Alien_Headpieces/Player_Attack_Target")

@onready var player_head = get_tree().get_current_scene().get_node("Player/Alien_V3/DetectionAreas/Area_Head/CollisionA_AlienHead")


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("NPC")
	update_hitpoints.emit()
	
	update_hitpoints.connect(health_effects)
	set_collision_layer_value(Globals.collision.GROUND, false)
	set_collision_layer_value(Globals.collision.NPC, false)
	set_collision_layer_value(Globals.collision.NPC_INTERACT, true)
	set_collision_mask_value(1, false)
	
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	Messenger.interact_npc_begin.connect(on_interact_npc_begin)
	Messenger.interact_npc_end.connect(on_interact_npc_end)
	Messenger.flying_enemy_spawned.connect(on_flying_enemy_spawned)
	Messenger.flying_is_dying.connect(on_flying_is_dying)
	
	
	
	
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
	look_at(player_target.global_position)
	if is_moving and !is_dying:
		var direction = (player_target.global_position - global_position).normalized()
		velocity = direction * speed
		global_position += velocity * delta 
		
		check_for_stop(false)
		
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
		
	
func on_flying_enemy_spawned(enemy,queue_pos):
	if enemy == self:
		formation_queue_pos = queue_pos
		#print(enemy.name," q pos = ",formation_queue_pos)
	
func on_flying_is_dying(dying_enemy):
	if dying_enemy == self:
		reparent(flying_enemies_dying_queue)
	check_for_stop(true)
	
func check_for_stop(recheck_formation):
	var z_pos_for_stopping: float = flying_formation_z_pos[formation_queue_pos]
	if recheck_formation:
		var current_formation_queue_pos = flying_enemies_queue.get_children().find(self)
		if formation_queue_pos != current_formation_queue_pos:
			formation_queue_pos = current_formation_queue_pos
			#print(self.name," new q pos = ",formation_queue_pos)
			is_moving = true
			
		
	else:
		if global_position.z >= z_pos_for_stopping:
			is_moving = false
		
		
		
func copter_nav(safe_velocity):
	global_position += safe_velocity * get_physics_process_delta_time()
	

func health_effects():
	if health_current <= 0: # Is Dead
		Messenger.flying_is_dying.emit(self)
		is_moving = false
		is_dying = true
		$CollisionShape3D.disabled = true
		$HitPoints.is_dead = true
#		$Animation_CopterDeath.play("falling")
		var tween = get_tree().create_tween();
		tween.tween_property(copter_mesh, "rotation:x", deg_to_rad(44), 1)
		
		if !new_meat_spawned:
			new_meat_spawned = true
			var meat_new = preload("res://NPCs/Humans/human_02-01_00.tscn").instantiate()
			get_tree().get_current_scene().get_node("Spawned/Spawned_HumanEnemies").add_child(meat_new)
			meat_new.is_enemy = true
			meat_new.is_available = true
			meat_new.always_spawn = true
			meat_new.parachuting(true)
			meat_new.add_to_group("Dropping")
			meat_new.global_position = global_position
		

func _on_mouse_entered(): ## For hover arrow indicator
	pass
	
func _on_mouse_exited(): ## For hover arrow indicator
	pass
	
func on_interact_npc_begin(area):
	if area == self:
		set_collision_layer_value(Globals.collision.NPC, true)
	
func on_interact_npc_end(area):
	if area == self:
		set_collision_layer_value(Globals.collision.NPC, false)
	
	
func on_projectile_interval_timeout():
	if !is_dying and is_attacking:
		projectile_interval_timer.start(randf_range(projectile_interval_min,projectile_interval_max))
		
		var copter_bullet = preload("res://Projectiles/copter_projectile_01.tscn").instantiate()
		get_tree().get_current_scene().add_child(copter_bullet)
		
		copter_bullet.global_position = copter_mesh.global_position
		
		copter_bullet.get_node("Projectile").speed = .5
		
		copter_bullet.get_node("Projectile").direction = (player_head.global_position - copter_bullet.global_position).normalized()
