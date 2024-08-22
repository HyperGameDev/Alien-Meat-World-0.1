extends Panel

@onready var camera: Camera3D = %Camera3D

func _process(delta: float) -> void:
	position = camera.mouse_pos
