extends Area3D

class_name Obstacle

signal update_hitpoints

static var is_collidable: bool = true
static var is_visible: bool = true

var is_interactable: bool = false

@export var has_arrow: bool = true
@export var indicator_color: Color = Color(1.0,.5,.0,1.0)

@export var health_max: int
@onready var health_current = health_max
var damage_taken = 1

@export var damage_amount: damage_amounts
@export var slowdown_amount: slowdown_amounts

enum damage_amounts {LOWEST, FULL, NONE}
enum slowdown_amounts {NONE, PARTIAL, FULL}

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_collidable:
		monitoring = true
		monitorable = true
	else:
		monitoring = false
		monitorable = false
		
	if is_visible:
		get_owner().visible = true
	else:
		get_owner().visible = false
		
	# Check if it is a sub-obstacle
	if $"../..".has_signal("update_hitpoints"):
	
		$"../..".update_hitpoints.connect(on_update_top_level_hitpoints)
		if !has_node("CollisionShape3D"):
			print("ERROR: Sub-Obstacle is missing a properly named 'CollisionShape3D'")
			breakpoint
			
		# If I'm a sub-obstacle, make sure I don't collide yet
		for collision in get_children():
			if collision is CollisionShape3D:
				collision.disabled = true
		
	if $"../..".has_signal("is_destroyed"):
		$"../..".is_destroyed.connect(on_top_level_is_destroyed)
		
	update_hitpoints.emit()
	update_hitpoints.connect(on_update_hitpoints)

	area_entered.connect(on_area_entered)
	area_exited.connect(on_area_exited)
	
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	Messenger.interact_obstacle_begin.connect(on_interact_obstacle_begin)
	Messenger.interact_obstacle_end.connect(on_interact_obstacle_end)
	
	set_collision_layer_value(Globals.collision.GROUND, false)
	set_collision_layer_value(Globals.collision.NPC, false)
	set_collision_layer_value(Globals.collision.OBSTACLE, false)
	set_collision_layer_value(Globals.collision.ABDUCTEE, false)
	set_collision_layer_value(Globals.collision.PROJECTILE, false)
	set_collision_layer_value(Globals.collision.OBSTACLE_INTERACT, true)

	
	set_collision_mask_value(Globals.collision.GROUND, false)
	set_collision_mask_value(Globals.collision.NPC, false)
	set_collision_mask_value(Globals.collision.OBSTACLE, false)
	set_collision_mask_value(Globals.collision.ABDUCTEE, false)
	set_collision_mask_value(Globals.collision.PROJECTILE, false)
	set_collision_mask_value(Globals.collision.PLAYER, true)
	
	# If this is set, obstacled the copter collides with also impact the player's collision (namely on full slowdowns)
	#set_collision_mask_value(2, true)
	
	
	
func on_update_top_level_hitpoints():
	if $"../..".health_current <= 0:
		for collision in get_children():
			if collision is CollisionShape3D:
				collision.disabled = false

func on_top_level_is_destroyed():
	health_current = 0
	update_hitpoints.emit()

func on_update_hitpoints():
	if health_current <= 0: # Is Dead
		for collision in get_children():
			if collision is CollisionShape3D:
				collision.set_deferred("disabled", true)
	
	
func on_area_entered(collided_bodypart):
	# Getting an error? Did you add a new area to the player without a defined is_part?
	if collided_bodypart.is_part == BodyPart.is_parts.BODY:
		Messenger.amount_damaged.emit(Obstacle.damage_amounts.NONE)
	else:
		Messenger.amount_damaged.emit(damage_amount)
		
	Messenger.area_damaged.emit(collided_bodypart)
	Messenger.amount_slowed.emit(slowdown_amount)
	
func on_area_exited(bodypart_unarea):
	Messenger.area_undamaged.emit(bodypart_unarea)
	
func _on_mouse_entered(): ## For hover arrow indicator
	pass
	
func _on_mouse_exited(): ## For hover arrow indicator
	pass

func restore_collision():
	for collision in get_children():
		if collision is CollisionShape3D:
			collision.disabled = false
			
func on_interact_obstacle_begin(area):
	if area == self:
		set_collision_layer_value(Globals.collision.OBSTACLE, true)
	

func on_interact_obstacle_end(area):
	if area == self:
		set_collision_layer_value(Globals.collision.OBSTACLE, false)
