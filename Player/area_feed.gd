extends Area3D

# Exists so is not incorrectly thought of as a body part
var is_part : int = -1


func _ready() -> void:
	set_collision_layer_value(Globals.collision.PLAYER,true)
