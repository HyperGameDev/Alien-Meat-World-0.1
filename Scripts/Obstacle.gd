extends Area3D

class_name Obstacle

@export var damage_amount: damage_amounts

enum damage_amounts {LOWEST, FULL}

# Called when the node enters the scene tree for the first time.
func _ready():
	area_entered.connect(check_area)

# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(_delta):
	pass
	
func check_area(bodypart_area):
#	bodypart_area.mesh.hide()
#	bodypart_area.mesh
	Messenger.area_damaged.emit(bodypart_area)
	Messenger.amount_damaged.emit(damage_amount)
