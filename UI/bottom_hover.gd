extends Node3D

@onready var indicator: MeshInstance3D = $Mesh_Interactable

var indicator_position : Vector3 = Vector3(0,0,0)
var indicator_target = null

var last_menu_alien = null
var indicator_hidden: bool = true


func _ready():
	#Messenger.something_hovered.connect(show_arrow)
	Messenger.anything_seen.connect(hide_arrow)
	Messenger.menu_alien_seen.connect(show_indicator)
	
	visible = false
	
	indicator.get_node("AnimationPlayer").play("interactable")
	
	
func show_indicator(target):
	visible = true
	indicator_target = target
		
	indicator.global_position.x = target.global_position.x
	indicator.global_position.z = target.global_position.z


func hide_arrow(target):
	if !target.is_empty() and indicator_target != null:
		#print("Collider: ",target["collider"]," Target: ",indicator_target)
		#if indicator_target != target["collider"] and arrow_shown:
		if indicator_target != target["collider"]:
			visible = false
	
	
