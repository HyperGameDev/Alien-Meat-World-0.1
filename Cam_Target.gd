extends Node3D

@export var rot_x_offset: float = 0.0
const ROTATION_X: float = -9.0
@export var rot_y_offset: float = 0.0
const ROTATION_Y: float = 0.0
@export var rot_z_offset: float = 0.0


func _physics_process(delta: float) -> void:
	position = %Player.position
