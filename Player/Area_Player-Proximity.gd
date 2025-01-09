extends Area3D

# Exists so is not incorrectly thought of as a body part
var is_part : int = -2

func _ready() -> void:
	set_collision_mask_value(Globals.collision.VEHICLE_INTERACT, true)
