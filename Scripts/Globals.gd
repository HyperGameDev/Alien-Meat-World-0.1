extends Node

@export var level_current = 0

var powerups_available: Array = []
var powerups := {
	PowerUp1 = {
		powerupName = "PowerUp 1",
		powerupDescription = "This is the first powerup in the dictionary. It will do something.",
		powerupIcon = "res://UI/Powerups/Icons/powerup_icons_temp/powerup_icon_temp_01.png"
	},
	PowerUp2 = {
		powerupName = "P.U. 2",
		powerupDescription = "The second powerup will do some things.",
		powerupIcon = "res://UI/Powerups/Icons/powerup_icons_temp/powerup_icon_temp_02.png"
	},
	Powerup3 = {
		powerupName = "PowerUp No. Three",
		powerupDescription = "It might be strong.",
		powerupIcon = "res://UI/Powerups/Icons/powerup_icons_temp/powerup_icon_temp_03.png"
	},
	Powerup4 = {
		powerupName = "PowerUp 4th",
		powerupDescription = "Just works.",
		powerupIcon = "res://UI/Powerups/Icons/powerup_icons_temp/powerup_icon_temp_04.png"
	},
	Powerup5 = {
		powerupName = "5th Powerup",
		powerupDescription = "Really great, not the worst; you like it.",
		powerupIcon = "res://UI/Powerups/Icons/powerup_icons_temp/powerup_icon_temp_05.png"
	},
	Powerup6 = {
		powerupName = "Number Six Powerup",
		powerupDescription = "It does SO many things. WOW. We just LOVE IT!!!",
		powerupIcon = "res://UI/Powerups/Icons/powerup_icons_temp/powerup_icon_temp_06.png"
	},
	Powerup7 = {
		powerupName = "Seventh Powerup!",
		powerupDescription = "GOOD.",
		powerupIcon = "res://UI/Powerups/Icons/powerup_icons_temp/powerup_icon_temp_07.png"
	},
	Powerup8 = {
		powerupName = "Of all, this is 8th",
		powerupDescription = "You're gonna love this one because it will make you so strong, that you won't have any fun anymore, in a GOOD way tho.",
		powerupIcon = "res://UI/Powerups/Icons/powerup_icons_temp/powerup_icon_temp_08.png"
	},
	Powerup9 = { 
		powerupName = "Powerup 8 + 1",
		powerupDescription = "This amazing powerup will help you be better.",
		powerupIcon = "res://UI/Powerups/Icons/powerup_icons_temp/powerup_icon_temp_09.png"
	},
	Powerup10 = {
		powerupName = "The tenth Powerup",
		powerupDescription = "Use this when playing.",
		powerupIcon = "res://UI/Powerups/Icons/powerup_icons_temp/powerup_icon_temp_10.png"
	},
	Powerup11 = {
		powerupName = "11th Powerup",
		powerupDescription = "Have a good time making yourself Strong. Or not.",
		powerupIcon = "res://UI/Powerups/Icons/powerup_icons_temp/powerup_icon_temp_11.png"
	},
	Powerup12 = {
		powerupName = "Uncle Ben Powerup",
		powerupDescription = "With great power, comes great responsibility.",
		powerupIcon = "res://UI/Powerups/Icons/powerup_icons_temp/powerup_icon_temp_12.png"
	},
	Powerup13 = {
		powerupName = "Unlucky",
		powerupDescription = "Don't get this one. Don't use it. You've been warned.",
		powerupIcon = "res://UI/Powerups/Icons/powerup_icons_temp/powerup_icon_temp_13.png"
	},
	Powerup14 = {
		powerupName = "P.U. #14",
		powerupDescription = "This is Final Placeholder powerup FOR NOW... until it's not. Maybe add a way to get a fourth powerup loading in (as the player)?",
		powerupIcon = "res://UI/Powerups/Icons/powerup_icons_temp/powerup_icon_temp_14.png"
	}
}
		

var obstacles_hilited := []
var score = 0



var level_chunks_safe := [
	"res://Terrain/terrain_level_00/terrain_level_00_safes/",
	"res://Terrain/terrain_level_01/terrain_level_01_safes/",
	"res://Terrain/terrain_level_02/terrain_level_02_safes/",
	"res://Terrain/terrain_level_03/terrain_level_03_safes/",
	"res://Terrain/terrain_level_04/terrain_level_04_safes/",
	"res://Terrain/terrain_level_05/terrain_level_05_safes/",
	"res://Terrain/terrain_level_06/terrain_level_06_safes/",
	"res://Terrain/terrain_level_07/terrain_level_07_safes/",
	"res://Terrain/terrain_level_08/terrain_level_08_safes/",
	"res://Terrain/terrain_level_09/terrain_level_09_safes/",
	"res://Terrain/terrain_level_10/terrain_level_10_safes/",
	"res://Terrain/terrain_level_11/terrain_level_11_safes/",
	"res://Terrain/terrain_level_12/terrain_level_12_safes/"
	
]
var level_chunks_points := [
	"res://Terrain/terrain_level_00/terrain_level_00_points/",
	"res://Terrain/terrain_level_01/terrain_level_01_points/",
	"res://Terrain/terrain_level_02/terrain_level_02_points/",
	"res://Terrain/terrain_level_03/terrain_level_03_points/",
	"res://Terrain/terrain_level_04/terrain_level_04_points/",
	"res://Terrain/terrain_level_05/terrain_level_05_points/",
	"res://Terrain/terrain_level_06/terrain_level_06_points/",
	"res://Terrain/terrain_level_07/terrain_level_07_points/",
	"res://Terrain/terrain_level_08/terrain_level_08_points/",
	"res://Terrain/terrain_level_09/terrain_level_09_points/",
	"res://Terrain/terrain_level_10/terrain_level_10_points/",
	"res://Terrain/terrain_level_11/terrain_level_11_points/",
	"res://Terrain/terrain_level_12/terrain_level_12_points/"
	
]
var level_chunks_obstacles := [
	"res://Terrain/terrain_level_00/terrain_level_00_obstacles/",
	"res://Terrain/terrain_level_01/terrain_level_01_obstacles/",
	"res://Terrain/terrain_level_02/terrain_level_02_obstacles/",
	"res://Terrain/terrain_level_03/terrain_level_03_obstacles/",
	"res://Terrain/terrain_level_04/terrain_level_04_obstacles/",
	"res://Terrain/terrain_level_05/terrain_level_05_obstacles/",
	"res://Terrain/terrain_level_06/terrain_level_06_obstacles/",
	"res://Terrain/terrain_level_07/terrain_level_07_obstacles/",
	"res://Terrain/terrain_level_08/terrain_level_08_obstacles/",
	"res://Terrain/terrain_level_09/terrain_level_09_obstacles/",
	"res://Terrain/terrain_level_10/terrain_level_10_obstacles/",
	"res://Terrain/terrain_level_11/terrain_level_11_obstacles/",
	"res://Terrain/terrain_level_12/terrain_level_12_obstacles/"
]

var current_safe_chunks : StringName
var current_obstacle_chunks : StringName
var current_points_chunks : StringName

var meat_objects := {
	Abductee.is_types.COW: load("res://NPCs/Cows/Cow_01-03_00.tscn"),
	Abductee.is_types.HUMAN: load("res://NPCs/Humans/human_01_00.tscn")
}

func _ready():
	
	Messenger.abduction.connect(on_abduction)
	Messenger.game_over.connect(on_game_over)
	Messenger.level_update.connect(on_level_update)
	on_level_update(level_current)
	
	powerups_available = powerups.keys()

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
	
