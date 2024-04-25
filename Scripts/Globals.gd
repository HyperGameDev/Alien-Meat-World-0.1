extends Node

var levels := [
	"res://Terrain/terrain_debug_obstacleReplenish",
	"res://Terrain/terrain_assetExpo_01/",
	"res://Terrain/terrain_blocks_blank_grass/",
	"res://Terrain/terrain_blocks_blank_dirt/",
	"res://Terrain/terrain_blocks_blank_concrete/",
	"res://Terrain/terrain_blocks_blank_military/",
	"res://Terrain/terrain_blocks_blank/",
	"res://Terrain/terrain_debug_obstacleDamage/",
	"res://Terrain/terrain_debug_obstacleAvoidance/",
	"res://Terrain/terrain_level_01/",
	"res://Terrain/terrain_level_02/",
	"res://Terrain/terrain_debug_terrainHeights/"
]
var current_level : StringName

var meat_objects := {
	Health.is_types.COW: load("res://NPCs/Cows/Cow_01-03_00.tscn"),
	Health.is_types.HUMAN: load("res://NPCs/Humans/human_01_00.tscn")
}

func _ready():
	current_level = levels[1]
