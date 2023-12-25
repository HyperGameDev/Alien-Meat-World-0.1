extends Control

var debug_2 = false

@onready var dmg_label_ArmL = $"../Player/Alien/Armature/Skeleton3D/Alien_ArmL/Dmg_Label"
@onready var dmg_label_ArmR = $"../Player/Alien/Armature/Skeleton3D/Alien_ArmR/Dmg_Label"
@onready var dmg_label_Body = $"../Player/Alien/Armature/Skeleton3D/Alien_Body/Dmg_Label"
@onready var dmg_label_LegL = $"../Player/Alien/Armature/Skeleton3D/Alien_LegL/Dmg_Label"
@onready var dmg_label_LegR = $"../Player/Alien/Armature/Skeleton3D/Alien_LegR/Dmg_Label"
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _input(event):
	if event.is_action_pressed("Debug 1"):
		dmg_label_ArmL.visible = !dmg_label_ArmL.visible
		dmg_label_ArmR.visible = !dmg_label_ArmR.visible
		dmg_label_LegL.visible = !dmg_label_LegL.visible
		dmg_label_LegR.visible = !dmg_label_LegR.visible
		dmg_label_Body.visible = !dmg_label_Body.visible
	if event.is_action_pressed("Debug 2"):
		debug_2 = true
	if event.is_action_released("Debug 2"):
		debug_2 = false

