extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Messenger.add_powerup.connect(on_add_powerup)
	
func on_add_powerup(powerup):
	match powerup:
		"drone":
			var drone = preload("res://PowerUps/PU_Drone/pu_drone.tscn").instantiate()
			add_child(drone)
			drone.position = Vector3(-1,2,0)
