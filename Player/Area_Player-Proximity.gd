extends Area3D

# Exists so is not incorrectly thought of as a body part
var is_part : int = -2

func _ready() -> void:
	set_collision_mask_value(Globals.collision.VEHICLE_INTERACT, true)	
	set_collision_mask_value(Globals.collision.ABDUCTEE_INTERACT, true)
	
	area_entered.connect(on_entered)
	
	body_entered.connect(on_entered)

func on_entered(entrant):
	if entrant.is_enemy:
		print("Player Prox: ",entrant," recognized as enemy.")
		entrant.attack()
		
 
