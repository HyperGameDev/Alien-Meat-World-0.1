extends Node3D

@onready var material_hilite = preload("res://Objects/object-highlight_04.tres")
var hovered_current = null

# Called when the node enters the scene tree for the first time.
func _ready():
	Messenger.something_hovered.connect(hover_fx_begin)
	pass


func hover_fx_begin(target):
	hovered_current = target
	if !target.is_in_group("Meat"):
		for node in target.get_owner().get_children():
			if node is MeshInstance3D:
				if node.get_owner().has_method("hover_fx_begin"):
					node.get_owner().hover_fx_begin()
				node.material_overlay = material_hilite
				
				# This doesn't work; don't know why yet; see cow_barn_01_02_00.tscn
				for subnode in node.get_children():
					if subnode is MeshInstance3D:
						
						node.material_overlay = material_hilite
		
