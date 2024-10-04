@tool

extends Sprite3D


@onready var interact_animation: AnimationPlayer = get_tree().get_current_scene().get_node("UI_Interaction/AnimationPlayer")

var arrow_position : Vector3 = Vector3(0,0,0)
var arrow_target = null

var arrow_shown : bool = false

func _ready():
	texture = $SubViewport.get_texture()
	Messenger.something_hovered.connect(show_arrow)
	Messenger.anything_seen.connect(hide_arrow)
	get_owner().get_node("AnimationPlayer").play("bounce")
	
func show_arrow(target):
	if !arrow_shown:
		visible = true
		arrow_target = target
		
		#print("Sees something... ",arrow_target,"...")
		if !target.is_in_group("Abductee"):
			#print("Sees non-abductee ",arrow_target,"!")
			pass
			if target.is_in_group("NPC"):
				arrow_position = target.get_node("Marker3D").global_position
			else:
				arrow_position = target.get_owner().get_node("Marker3D").global_position
		else:
			if target.is_available:
				#print("Sees abductee ",arrow_target,"!")
				arrow_target = target
				arrow_position = target.get_node("Marker3D").global_position
		
		global_position = arrow_position
		arrow_shown = true


func hide_arrow(target):
	if !target.is_empty():
		if arrow_target != target["collider"] and arrow_shown:
			visible = false
			arrow_shown = false
	
			
func force_hide_arrow():
	if arrow_shown:
		visible = false
		arrow_shown = false
