extends Area3D

@export var player: CharacterBody3D
@export var mesh: MeshInstance3D

var damaged = false

func _ready():		Messenger.body_damaged.connect(damage_detected)
	
func damage_detected(bodypart_area):
	if bodypart_area == self:
		print(damaged, "Body")
