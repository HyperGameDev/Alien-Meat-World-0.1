@tool

extends Sprite3D

# Called when the node enters the scene tree for the first time.
func _ready():
	texture = $SubViewport.get_texture()
