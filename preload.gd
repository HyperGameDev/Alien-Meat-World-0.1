extends Node3D

@onready var preload_kill_timer : Timer = Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	preload_kill_timer.timeout.connect(on_preload_kill_timeout)
	preload_kill_timer.one_shot = true
	add_child(preload_kill_timer)
	preload_kill_timer.start(.2)
	
func on_preload_kill_timeout():
	queue_free()
