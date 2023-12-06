extends Area3D

class_name Obstacle

# Called when the node enters the scene tree for the first time.
func _ready():
	area_entered.connect(check_area)

# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(delta):
	pass
	
func check_area(bodypart_area):
#	bodypart_area.mesh.hide()
#	bodypart_area.mesh
	Messenger.body_damaged.emit(bodypart_area)
	
	
