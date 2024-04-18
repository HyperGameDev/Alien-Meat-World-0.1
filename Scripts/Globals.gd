extends Node

var levels := [
	"res://Terrain/terrain_level_00_debug-01/",
	"res://Terrain/terrain_assetExpo_01/",
	"res://Terrain/terrain_blocks_blank_grass/",
	"res://Terrain/terrain_blocks_blank_dirt/",
	"res://Terrain/terrain_blocks_blank_concrete/",
	"res://Terrain/terrain_blocks_blank_military/",
	"res://Terrain/terrain_blocks_blank/",
	"res://Terrain/terrain_debug_obstacleDamage/"
]
var current_level : StringName

func _ready():
	current_level = levels[1]
