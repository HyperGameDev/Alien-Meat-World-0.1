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
	Messenger.interact_npc_begin.connect(on_interact_npc_begin)
	Messenger.interact_npc_end.connect(on_interact_npc_end)

func on_something_hovered(target): ## Begins the hover effect
	hovered_current = target
	if Globals.obstacles_hilited.is_empty():
		hovered_old = hovered_current
	if !target.is_in_group("Abductee") and !target.is_in_group("Menu Alien"):
		if target.is_in_group("NPC"):
			for node in target.get_children():
				hilite_fx_begin(node)
				for subnode in node.get_children():
					hilite_fx_begin(subnode)
		else:
			for node in target.get_owner().get_children():
				hilite_fx_begin(node)
				
				if !node.get_node("../..").has_signal("update_hitpoints"):
					for subnode in node.get_children():
						hilite_fx_begin(subnode)
		
func hilite_fx_begin(node):
	if node is MeshInstance3D:
		Globals.obstacles_hilited.append(node)
		if node.material_overlay == null or node.material_overlay == material_interactable:
			node.material_overlay = material_hilite
	
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


func on_interact_obstacle_begin(area):
	if area.get_owner() == null:
		interact_fx_begin(area)
	else:
		interact_fx_begin(area.get_owner())

func on_interact_obstacle_end(area):
	if area.get_owner() == null:
		interact_fx_end(area)
	else:
		interact_fx_end(area.get_owner())
	
func on_interact_npc_begin(area):
	if area.get_owner() == null:
		interact_fx_begin(area)
	else:
		interact_fx_begin(area.get_owner())

func on_interact_npc_end(area):
	if area.get_owner() == null:
		interact_fx_end(area)
	else:
		interact_fx_end(area.get_owner())	
		
func interact_fx_begin(target):
	target.interactable = true
	for node in target.get_children():
		if node.has_node("%Mesh_Collection"):
			#print("Sees mesh collection")
			node.get_node("%Mesh_Collection").interactable = true
		if node is MeshInstance3D:
			if node.material_overlay == null:
				node.material_overlay = material_interactable
	
		# Checks children for meshes
		for subnode in node.get_children():
			if subnode is MeshInstance3D:
				if subnode.material_overlay == null:
					subnode.material_overlay = material_interactable

func interact_fx_end(target):
	target.interactable = false
	for node in target.get_children():
		if node.has_node("%Mesh_Collection"):
			node.get_node("%Mesh_Collection").interactable = false
		if node is MeshInstance3D:
			if node.material_overlay == material_interactable:
				node.material_overlay = null
	
		# Checks children for meshes
		for subnode in node.get_children():
			if subnode is MeshInstance3D:
				if subnode.material_overlay == material_interactable:
					subnode.material_overlay = null
