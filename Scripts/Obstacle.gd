extends Area3D

class_name Obstacle

@export var damage_amount: damage_amounts
@export var slowdown_amount: slowdown_amounts

enum damage_amounts {LOWEST, FULL, NONE}
enum slowdown_amounts {NONE, PARTIAL, FULL}

# Called when the node enters the scene tree for the first time.
func _ready():
	area_entered.connect(check_area)
	area_exited.connect(uncheck_area)
	set_collision_layer_value(3, true)
	set_collision_mask_value(3, true)

# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(_delta):
	pass
	
func check_area(bodypart_area):
#	bodypart_area.mesh.hide()
#	bodypart_area.mesh
	Messenger.area_damaged.emit(bodypart_area)
	Messenger.amount_damaged.emit(damage_amount)
	Messenger.amount_slowed.emit(slowdown_amount)
	
func uncheck_area(bodypart_unarea):
	Messenger.area_undamaged.emit(bodypart_unarea)
