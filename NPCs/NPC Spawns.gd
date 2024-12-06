extends Node

var spawn_interval_min = .001
var spawn_interval_max = .002

var copter_spawns = 0
var flying_enemies_queue: Node3D
@onready var spawn_interval_timer : Timer = Timer.new()


# Called when the node enters the scene tree fqor the first time.
func _ready():
	#spawn_interval_timer.timeout.connect(spawn_copter_fleet)
	Messenger.spawn_npc.connect(on_spawn_npc)
	Messenger.game_preintro.connect(on_game_preintro)
	
	spawn_interval_timer.one_shot = true
	add_child(spawn_interval_timer)
	spawn_interval_timer.start(randi_range(spawn_interval_min,spawn_interval_max))
	
func on_game_preintro():
	flying_enemies_queue = get_tree().get_current_scene().get_node("Spawned/Spawned_FlyingEnemies")

func on_spawn_npc(npc):
	match npc:
		"copter":
			if flying_enemy_ok():
				var copter = preload("res://NPCs/Helicopters/copter_001.tscn").instantiate()
				get_tree().get_current_scene().get_node("Spawned/Spawned_FlyingEnemies").add_child(copter)
				
				flying_enemy_spawned(copter)
		_:
			pass
			
func flying_enemy_ok():
	return flying_enemies_queue.get_children().size() <= 4
			
func flying_enemy_spawned(enemy):
	Messenger.flying_enemy_spawned.emit(enemy,flying_enemies_queue.get_children().find(enemy))
	

func spawn_copter_fleet():
	#spawn_interval_timer.start(randi_range(spawn_interval_min,spawn_interval_max))

#	print(copter_spawns, " copters spawned")
	if copter_spawns <= 5:
		copter_spawns += 1
		var copter = preload("res://NPCs/Helicopters/copter_001.tscn").instantiate()
		get_tree().get_current_scene().add_child(copter)
