@tool

extends Node3D
   
@export var default_color: Color = Color(.35,.2,.4)

var default_material = StandardMaterial3D.new()

func _ready():
	default_material.set_albedo(default_color)
	var children = get_children()
	for meshes in children:
		meshes.material_override = default_material
		meshes.material_override = default_material
