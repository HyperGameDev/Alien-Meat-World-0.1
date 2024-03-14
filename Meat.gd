extends Area3D

class_name Meat

# Called when the node enters the scene tree for the first time.
func _ready():
	Messenger.grab_target.connect(detected)

func detected(target):
	if target == self:
		
		
