extends Node

@export var current_level = 0

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
	Messenger.level_update.connect(on_level_update)
	on_level_update(current_level)

func on_level_update(level):
	current_level = level
	print("Globals tried updating paths")
	current_safe_chunks = level_chunks_safe[level]
	current_points_chunks = level_chunks_points[level]
	current_obstacle_chunks = level_chunks_obstacles[level]
