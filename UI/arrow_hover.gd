@tool

extends Sprite3D


@onready var interact_animation: AnimationPlayer = get_tree().get_current_scene().get_node("UI_Interaction/AnimationPlayer")


var arrow_position : Vector3 = Vector3(0,0,0)
var arrow_target = null

var last_menu_alien = null
var arrow_hidden: bool = true

#var arrow_shown : bool = false

func _ready():
	texture = $SubViewport.get_texture()
	Messenger.something_hovered.connect(show_arrow)
	Messenger.anything_seen.connect(hide_arrow)
	get_owner().get_node("AnimationPlayer").play("bounce")
	
func show_arrow(target):
	#if !arrow_shown:
	visible = true
	arrow_target = target
	
	#print("Sees something... ",arrow_target,"...")
	if !target.is_in_group("Abductee"): # If not abductee
		#print("Sees non-abductee ",arrow_target,"!")
		if target.is_in_group("Vehicle"):
			arrow_position = target.get_node("Marker3D").global_position
		else:
			arrow_position = target.get_owner().get_node("Marker3D").global_position
	else: # Is abductee
		if target.is_available:
			#print("Sees abductee ",arrow_target,"!")
			arrow_target = target
			arrow_position = target.get_node("Marker3D").global_position
		else:
			#print("seeing that")
			force_hide_arrow()
		# End section that used to be booleaned by arrow_shown
		
	global_position = arrow_position
	#arrow_shown = true


func hide_arrow(target):
	if !target.is_empty():
		#print("Collider: ",target["collider"]," Target: ",arrow_target)
		#if arrow_target != target["collider"] and arrow_shown:
		if arrow_target != target["collider"]:
			#print("Collider: ",target["collider"]," Target: ",arrow_target)
			visible = false
			#arrow_shown = false
	
		
			
func force_hide_arrow():
	#print("Arrow forced to hide!")
	#if arrow_shown:
	visible = false
	#arrow_shown = false
