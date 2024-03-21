extends Node3D

func _ready():
	var cow = preload("res://NPCs/Cows/Cow_01-02_00.tscn").instantiate()
	get_tree().get_current_scene().add_child(cow)
