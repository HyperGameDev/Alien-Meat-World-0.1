extends Node

var spawn_interval_min = 3
var spawn_interval_max = 5

@onready var spawn_interval_timer : Timer = Timer.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_interval_timer.timeout.connect(spawn_helicopter)
	spawn_interval_timer.one_shot = true
	add_child(spawn_interval_timer)
	spawn_interval_timer.start(randi_range(spawn_interval_min,spawn_interval_max))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func spawn_helicopter():
	spawn_interval_timer.start(randi_range(spawn_interval_min,spawn_interval_max))
	print("copter spawned ", "after ", spawn_interval_timer.wait_time, "s")
	
	var copter = load("res://NPCs/Helicopters/copter_001.tscn").instantiate()
	get_tree().get_current_scene().add_child(copter)
