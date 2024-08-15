extends Node

var spawn_interval_min = .001
var spawn_interval_max = .002

var copter_spawns = 0

@onready var spawn_interval_timer : Timer = Timer.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_interval_timer.timeout.connect(spawn_helicopter)
	spawn_interval_timer.one_shot = true
	add_child(spawn_interval_timer)
	spawn_interval_timer.start(randi_range(spawn_interval_min,spawn_interval_max))



func spawn_helicopter():
	spawn_interval_timer.start(randi_range(spawn_interval_min,spawn_interval_max))

#	print(copter_spawns, " copters spawned")
	if copter_spawns <= 5:
		copter_spawns += 1
		var copter = preload("res://NPCs/Helicopters/copter_001.tscn").instantiate()
		get_tree().get_current_scene().add_child(copter)
