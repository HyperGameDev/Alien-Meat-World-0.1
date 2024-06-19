extends Node3D

# 3 METERS APART FROM EACHOTHER

class_name Block_Object

signal update_reset_status

var hilited = false
var needs_reset = false
var damaged_parts := []

func _ready():
	update_reset_status.connect(on_update_reset_status)
	Messenger.anything_seen.connect(hover_fx_end)
	
func on_update_reset_status(damaged_part):
	needs_reset = true
	damaged_parts.append(damaged_part)
	
func reset_object():
	if needs_reset:
		for part in damaged_parts:
			part.reset_damage()
		needs_reset = false
		
func hover_fx_begin():
	hilited = true
	
func hover_fx_end(target):
	if has_node("Obstacle"):
		if !target.is_empty():
			if $Obstacle != target["collider"]:
				for node in get_children():
					if node is MeshInstance3D:
						node.material_overlay = null
						# This doesn't work; don't know why yet; see cow_barn_01_02_00.tscn
						for subnode in node.get_children():
							if subnode is MeshInstance3D:
					
								node.material_overlay = null
	pass
		
	
	
	
