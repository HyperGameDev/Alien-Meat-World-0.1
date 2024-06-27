extends Node

var obstacles_hilited := []
var score = 0

@export var level_current = 0

var level_chunks_safe := [
	"res://Terrain/terrain_level_00/terrain_level_00_safes/",
	"res://Terrain/terrain_level_01/terrain_level_01_safes/"
	
]
var level_chunks_points := [
	"res://Terrain/terrain_level_00/terrain_level_00_points/",
	"res://Terrain/terrain_level_01/terrain_level_01_points/"
]
var level_chunks_obstacles := [
	"res://Terrain/terrain_level_00/terrain_level_00_obstacles/",
	"res://Terrain/terrain_level_01/terrain_level_01_obstacles/"
]

var current_safe_chunks : StringName
var current_obstacle_chunks : StringName
var current_points_chunks : StringName

var meat_objects := {
	Health.is_types.COW: load("res://NPCs/Cows/Cow_01-03_00.tscn"),
	Health.is_types.HUMAN: load("res://NPCs/Humans/human_01_00.tscn")
}

func _ready():
	
	Messenger.abduction.connect(on_abduction)
	Messenger.game_over.connect(on_game_over)
	Messenger.level_update.connect(on_level_update)
	on_level_update(level_current)

func on_level_update(level):
	level_current = level
	print("Globals tried updating paths")
	current_safe_chunks = level_chunks_safe[level]
	current_points_chunks = level_chunks_points[level]
	current_obstacle_chunks = level_chunks_obstacles[level]
	
func on_game_over():
	obstacles_hilited = [] ## Empties out the last hilighted obstacle array
	get_tree().reload_current_scene()
	
func on_abduction(score_value):
	score += score_value
	
