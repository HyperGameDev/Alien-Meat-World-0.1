extends Control

var show_fps = false

#@onready var testanimation = $"../Player/Alien/Armature/Skeleton3D/Alien_ArmL/Animation_Limb-Shrink"
	
# Called when the node enters the scene tree for the first time.
func _process(delta):
	if show_fps:
		%Label_showFPS.visible = true
		%Label_showFPS.text = "FPS: " + str(Engine.get_frames_per_second())
	else:
		%Label_showFPS.visible = false

func _input(event):
	if event.is_action_pressed("Debug 1"):
		for dmg_label in get_tree().get_nodes_in_group("Dmg_Labels_Player"):
			dmg_label.visible = !dmg_label.visible
	if event.is_action_pressed("Debug 2"):
		Messenger.debug_hp_nonPlayer = !Messenger.debug_hp_nonPlayer
	if event.is_action_pressed("Debug 3"):
		show_fps = !show_fps
#	if event.is_action_pressed("Debug 4"):
#		testanimation.play("shrink_hp2")
#	if event.is_action_pressed("Debug 5"):
#		testanimation.play("shrink_hp1")
#	if event.is_action_pressed("Debug 6"):
#		testanimation.play("shrink_hp0")
