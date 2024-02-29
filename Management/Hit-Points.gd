extends Node3D

class_name HitPoints

func _ready():
	$"..".update_hitpoints.connect(update_number)

func update_number():
	$Dmg_Label.text = str($"..".health_current)
