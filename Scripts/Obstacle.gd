extends Area3D

class_name Obstacle

signal update_hitpoints

@export var health_max: int
@onready var health_current = health_max
var damage_taken = 1

@export var damage_amount: damage_amounts
@export var slowdown_amount: slowdown_amounts

enum damage_amounts {LOWEST, FULL, NONE}
enum slowdown_amounts {NONE, PARTIAL, FULL}

# Called when the node enters the scene tree for the first time.
func _ready():
	if $"../..".has_signal("update_hitpoints"):
		$"../..".update_hitpoints.connect(on_update_top_level_hitpoints)
		if !has_node("CollisionShape3D"):
			print("ERROR: Sub-Obstacle is missing a properly named 'CollisionShape3D'")
			breakpoint
		$CollisionShape3D.disabled = true
	if $"../..".has_signal("is_destroyed"):
		$"../..".is_destroyed.connect(on_top_level_is_destroyed)
		
	update_hitpoints.emit()
	update_hitpoints.connect(health_effects)
	area_entered.connect(check_area)
	area_exited.connect(uncheck_area)
	
	set_collision_layer_value(1, false)
	set_collision_layer_value(3, true)
	
	set_collision_mask_value(1, false)
	set_collision_mask_value(16, true)
	
func on_update_top_level_hitpoints():
	if $"../..".health_current <= 0:
		$CollisionShape3D.disabled = false

func on_top_level_is_destroyed():
	health_current = 0
	update_hitpoints.emit()

func health_effects():
	if health_current <= 0: # Is Dead
		$CollisionShape3D.disabled = true
	
	
func check_area(collided_bodypart):
#	collided_bodypart.mesh.hide()
#	collided_bodypart.mesh
	Messenger.area_damaged.emit(collided_bodypart)
	Messenger.amount_damaged.emit(damage_amount)
	Messenger.amount_slowed.emit(slowdown_amount)
	
func uncheck_area(bodypart_unarea):
	Messenger.area_undamaged.emit(bodypart_unarea)
	

