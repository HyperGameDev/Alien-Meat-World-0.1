extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Messenger.add_powerup.connect(on_add_powerup)
	Messenger.upgrade_powerup.connect(on_upgrade_powerup)
	
func on_add_powerup(powerup):
	debug_message_added(powerup)
	match powerup:
		"Drone":
			Globals.powerups[powerup].powerupLevel = 1
			var drone = preload("res://PowerUps/PU_Drone/pu_drone.tscn").instantiate()
			add_child(drone)
			drone.position = Vector3(-1,2,0)
			
		"Fantastic":
			Globals.powerups[powerup].powerupLevel = 1
			Messenger.arm_health_update.emit()
			
		"Grab Glove":
			pass
			
			
		_:
			pass
			
func on_upgrade_powerup(powerup: String):
	debug_message_upgraded(powerup)
	match powerup:
		"Drone":
			Globals.powerups[powerup].powerupLevel = 2
			var drone = preload("res://PowerUps/PU_Drone/pu_drone.tscn").instantiate()
			add_child(drone)
			drone.position = Vector3(1,2,0)
			
		"Fantastic":
			Globals.powerups[powerup].powerupLevel = 2
			Messenger.arm_health_update.emit()
			
		"Grab Glove":
			Globals.powerups[powerup].powerupLevel = 2
			
		
		_:
			pass
			
func debug_message_added(powerup):
	print("Powerups script: " + powerup + " powerup added!")
	
func debug_message_upgraded(powerup):
	print("Powerups script: " + powerup + " powerup upgraded!")
