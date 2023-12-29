extends Node3D

@export var health_bar: ProgressBar # Declare health_bar as a member variable

func _ready():
	# Create the viewport, add something to it, and add it to the scene tree:
	var viewport = SubViewport.new()
	add_something_to_viewport(viewport)
	add_child(viewport)
	
	# Finally create a sprite that uses the viewport texture:
	var sprite = Sprite3D.new()
	sprite.centered = false
	sprite.texture = viewport.get_texture() # Just get the texture directly.
	add_child(sprite)

func add_something_to_viewport(viewport: SubViewport):
	# Use the existing health_bar instance
	health_bar = ProgressBar.new()
	viewport.add_child(health_bar)
