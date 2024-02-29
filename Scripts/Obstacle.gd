extends Area3D

class_name Obstacle

signal update_hitpoints

var damage_taken = 1
@export var health_max: int
@onready var health_current = health_max

@export var damage_amount: damage_amounts
@export var slowdown_amount: slowdown_amounts

enum damage_amounts {LOWEST, FULL, NONE}
enum slowdown_amounts {NONE, PARTIAL, FULL}

# Called when the node enters the scene tree for the first time.
func _ready():
	update_hitpoints.emit()
	area_entered.connect(check_area)
	area_exited.connect(uncheck_area)
	
	set_collision_layer_value(1, false)
	set_collision_layer_value(3, true)
	
	set_collision_mask_value(1, false)
	set_collision_mask_value(16, true)

# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(_delta):
	pass
	
func check_area(collided_bodypart):
#	collided_bodypart.mesh.hide()
#	collided_bodypart.mesh
	Messenger.area_damaged.emit(collided_bodypart)
	Messenger.amount_damaged.emit(damage_amount)
	Messenger.amount_slowed.emit(slowdown_amount)
	
func uncheck_area(bodypart_unarea):
	Messenger.area_undamaged.emit(bodypart_unarea)
