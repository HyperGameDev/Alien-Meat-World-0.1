@tool

extends Sprite3D

# Called when the node enters the scene tree for the first time.
func _ready():
	texture = $SubViewport.get_texture()
	Messenger.body_health.connect(update_hp)
	
func update_hp(current_body_health):
	$SubViewport/Body_HP_Bar.value = current_body_health
