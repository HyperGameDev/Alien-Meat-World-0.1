extends Node3D

class_name Collector

func _ready():
	Messenger.level_update.connect(on_level_update)
	
func on_level_update(level):
	for chunk in get_children():
		chunk.queue_free()
