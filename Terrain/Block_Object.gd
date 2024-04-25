extends Node3D

# 3 METERS APART FROM EACHOTHER

class_name Block_Object

signal update_reset_status

var needs_reset = false
var damaged_parts := []

func _ready():
	update_reset_status.connect(on_update_reset_status)
	
func on_update_reset_status(damaged_part):
	needs_reset = true
	damaged_parts.append(damaged_part)
	
func reset_object():
	if needs_reset:
		for part in damaged_parts:
			part.reset_damage()
		needs_reset = false
