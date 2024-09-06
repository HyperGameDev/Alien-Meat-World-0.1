extends Area3D

var is_part : int = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_collision_layer_value(16,true)
