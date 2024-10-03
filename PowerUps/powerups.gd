extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Messenger.add_powerup.connect(on_add_powerup)
	Messenger.remove_powerup.connect(on_add_powerup)
	Messenger.upgrade_powerup.connect(on_upgrade_powerup)
	
func on_add_powerup(powerup):
	match powerup:
		"Drone":
			Globals.powerups[powerup].powerupLevel = 1
			var drone = preload("res://PowerUps/PU_Drone/pu_drone.tscn").instantiate()
			add_child(drone)
			drone.position = Vector3(-1,2,0)
			
		"Fantastic":
			print("Powerups script: Fantastic powerup updgraded to 1")
			Globals.powerups[powerup].powerupLevel = 1
			Messenger.arm_health_update.emit()
			
		_:
			pass
			
func on_upgrade_powerup(powerup):
	match powerup:
		"Drone":
			Globals.powerups[powerup].powerupLevel = 2
			var drone = preload("res://PowerUps/PU_Drone/pu_drone.tscn").instantiate()
			add_child(drone)
			drone.position = Vector3(1,2,0)
			
		"Fantastic":
			Globals.powerups[powerup].powerupLevel = 2
			Messenger.arm_health_update.emit()
		
		_:
			pass
			
func on_remove_powerup(powerup):
	match powerup:
		"Fantastic":
			print("Powerups script: Fantastic powerup removed :(")
			Globals.powerups[powerup].powerupLevel = 0
