extends Node3D

@onready var material_hilite = preload("res://Objects/object-highlight_04.tres")
@onready var material_interactable = preload("res://Objects/object-interactable_01.tres")
var hovered_current = null
var hovered_old = null


func _ready():
	Messenger.something_hovered.connect(on_something_hovered)
	Messenger.anything_seen.connect(on_anything_seen)
	
	Messenger.interact_obstacle_begin.connect(on_interact_obstacle_begin)
	Messenger.interact_obstacle_end.connect(on_interact_obstacle_end)

func on_anything_seen(target): ## Ends the hover effect
	
	if !target.is_empty():
		if target["collider"] != hovered_old:
			if !hovered_old == null:
				for mesh in Globals.obstacles_hilited:
					if mesh.get_owner().interactable == true:
						mesh.material_overlay = material_interactable
					else:
						mesh.material_overlay = null
				Globals.obstacles_hilited.clear()

func on_something_hovered(target): ## Begins the hover effect
	hovered_current = target
	if Globals.obstacles_hilited.is_empty():
		hovered_old = hovered_current
	if !target.is_in_group("Abductee") and !target.is_in_group("Menu Alien"):
		for node in target.get_owner().get_children():
			if node is MeshInstance3D:
				Globals.obstacles_hilited.append(node)
				if node.material_overlay == null or node.material_overlay == material_interactable:
					#if node.get_owner().has_method("hover_fx_begin"):
						#print("IT DOES SOMETHING")
						#node.get_owner().hover_fx_begin()
					node.material_overlay = material_hilite
				
			# Checks children for meshes
			for subnode in node.get_children():
				if subnode is MeshInstance3D:
					Globals.obstacles_hilited.append(subnode)
					if subnode.material_overlay == null or subnode.material_overlay == material_interactable:
						subnode.material_overlay = material_hilite
		
func on_interact_obstacle_begin(area):
	area.get_owner().interactable = true
	for node in area.get_owner().get_children():
		if node is MeshInstance3D:
			if node.material_overlay == null:
				node.material_overlay = material_interactable
	
		# Checks children for meshes
		for subnode in node.get_children():
			if subnode is MeshInstance3D:
				if subnode.material_overlay == null:
					subnode.material_overlay = material_interactable
	
func on_interact_obstacle_end(area):
	area.get_owner().interactable = false
	for node in area.get_owner().get_children():
		if node is MeshInstance3D:
			if node.material_overlay == material_interactable:
				node.material_overlay = null
	
		# Checks children for meshes
		for subnode in node.get_children():
			if subnode is MeshInstance3D:
				if subnode.material_overlay == material_interactable:
					subnode.material_overlay = null
