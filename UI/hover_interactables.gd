extends Node3D

@onready var material_hilite = preload("res://Objects/object-highlight_04.tres")
var hovered_current = null
var hovered_old = null


func _ready():
	Messenger.something_hovered.connect(hover_fx_begin)
	Messenger.anything_seen.connect(hover_fx_end)
	pass

func hover_fx_end(target):
	
	if !target.is_empty():
		if target["collider"] != hovered_old:
			if !hovered_old == null:
				for mesh in Globals.obstacles_hilited:
					mesh.material_overlay = null
				Globals.obstacles_hilited.clear()

func hover_fx_begin(target):
	hovered_current = target
	if Globals.obstacles_hilited.is_empty():
		hovered_old = hovered_current
	if !target.is_in_group("Meat"):
		for node in target.get_owner().get_children():
			if node is MeshInstance3D:
				Globals.obstacles_hilited.append(node)
				if node.material_overlay == null:
					if node.get_owner().has_method("hover_fx_begin"):
						node.get_owner().hover_fx_begin()
					node.material_overlay = material_hilite
				
			# Checks children for meshes
			for subnode in node.get_children():
				if subnode is MeshInstance3D:
					Globals.obstacles_hilited.append(subnode)
					if subnode.material_overlay == null:
						subnode.material_overlay = material_hilite
		
