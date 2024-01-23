extends Control

var debug_2 = false

@onready var dmg_label_ArmL = $"../Player/Alien/Armature/Skeleton3D/Alien_ArmL/Dmg_Label"
@onready var dmg_label_ArmR = $"../Player/Alien/Armature/Skeleton3D/Alien_ArmR/Dmg_Label"
@onready var dmg_label_Head = $"../Player/Alien/Armature/Skeleton3D/Alien_Head/Dmg_Label"
@onready var dmg_label_LegL = $"../Player/Alien/Armature/Skeleton3D/Alien_LegL/Dmg_Label"
@onready var dmg_label_LegR = $"../Player/Alien/Armature/Skeleton3D/Alien_LegR/Dmg_Label"

#@onready var testanimation = $"../Player/Alien/Armature/Skeleton3D/Alien_ArmL/Animation_Limb-Shrink"
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _input(event):
	if event.is_action_pressed("Debug 1"):
		dmg_label_ArmL.visible = !dmg_label_ArmL.visible
		dmg_label_ArmR.visible = !dmg_label_ArmR.visible
		dmg_label_LegL.visible = !dmg_label_LegL.visible
		dmg_label_LegR.visible = !dmg_label_LegR.visible
		dmg_label_Head.visible = !dmg_label_Head.visible
	if event.is_action_pressed("Debug 2"):
		debug_2 = true
	if event.is_action_released("Debug 2"):
		debug_2 = false
#	if event.is_action_pressed("Debug 3"):
#		Messenger.debug_nodes.emit()
#		print(Debug.OFFSCREEN_POSITION)
#	if event.is_action_pressed("Debug 4"):
#		testanimation.play("shrink_hp2")
#	if event.is_action_pressed("Debug 5"):
#		testanimation.play("shrink_hp1")
#	if event.is_action_pressed("Debug 6"):
#		testanimation.play("shrink_hp0")
