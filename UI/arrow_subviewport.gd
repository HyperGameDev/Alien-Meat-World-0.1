@tool

extends Sprite3D

var arrow_position = Vector3(0,0,0)
var arrow_target = null

func _ready():		
	texture = $SubViewport.get_texture()
	Messenger.something_hovered.connect(show_arrow)
	Messenger.anything_seen.connect(hide_arrow)
	get_owner().get_node("AnimationPlayer").play("bounce")
	
func show_arrow(target):
	visible = true
	arrow_target = target
	if !target.is_in_group("Meat"):
		arrow_position = target.get_owner().get_node("Marker3D").global_position
	else:
		arrow_position = target.get_node("Marker3D").global_position
	global_position = arrow_position

func hide_arrow(target):
	if !target.is_empty():
		if arrow_target != target["collider"]:
			visible = false
			
func force_hide_arrow():
	visible = false
