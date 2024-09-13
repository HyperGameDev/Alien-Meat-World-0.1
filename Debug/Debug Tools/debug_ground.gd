extends StaticBody3D

@onready var mesh: MeshInstance3D = $MeshInstance3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mesh.visible = false
