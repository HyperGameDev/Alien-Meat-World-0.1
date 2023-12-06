extends Node3D

func _ready():		Messenger.body_damaged.connect(damage_detected)
	
func damage_detected(bodypart_area):
#	print(damaged)
	pass
