extends Node

@export var level_current = 0

var is_game_state: is_game_states
enum is_game_states {PREINTRO,INTRO,MENU,POSTMENU,PREBEGIN,BEGIN,PLAY,PAUSE,OVER}

var human_tops_paths: Array = [
	"res://NPCs/Humans/textures/human_clothes_grn_01.tres",
	"res://NPCs/Humans/textures/human_clothes_wht_01.tres"
]

var human_tops: Array = [
]

var powerups_available: Array = []
var powerups_chosen: Array = []
var powerups := {
	Drone = {
		powerupName = "Drone",
		powerupDescription = "Spawns a drone that attacks enemies.",
		powerupIcon = "res://UI/Powerups/Icons/powerup_icons_temp/powerup_icon_temp_01.png",
		powerupLevel = 0
	},
	Fantastic = {
		powerupName = "Fantastic Arms",
		powerupDescription = "Arms stretch further.",
		powerupIcon = "res://UI/Powerups/Icons/powerup_icons_temp/powerup_icon_temp_02.png",
		powerupLevel = 0
	},
	Powerup3 = {
		powerupName = "PowerUp No. Three",
		powerupDescription = "It might be strong.",
		powerupIcon = "res://UI/Powerups/Icons/powerup_icons_temp/powerup_icon_temp_03.png",
		powerupLevel = 0
	},
	Powerup4 = {
		powerupName = "PowerUp 4th",
		powerupDescription = "Just works.",
		powerupIcon = "res://UI/Powerups/Icons/powerup_icons_temp/powerup_icon_temp_04.png",
		powerupLevel = 0
	},
	Powerup5 = {
		powerupName = "5th Powerup",
		powerupDescription = "Really great, not the worst; you like it.",
		powerupIcon = "res://UI/Powerups/Icons/powerup_icons_temp/powerup_icon_temp_05.png",
		powerupLevel = 0
	},
	Powerup6 = {
		powerupName = "Number Six Powerup",
		powerupDescription = "It does SO many things. WOW. We just LOVE IT!!!",
		powerupIcon = "res://UI/Powerups/Icons/powerup_icons_temp/powerup_icon_temp_06.png",
		powerupLevel = 0
	},
	Powerup7 = {
		powerupName = "Seventh Powerup!",
		powerupDescription = "GOOD.",
		powerupIcon = "res://UI/Powerups/Icons/powerup_icons_temp/powerup_icon_temp_07.png",
		powerupLevel = 0
	},
	Powerup8 = {
		powerupName = "Of all, this is 8th",
		powerupDescription = "You're gonna love this one because it will make you so strong, that you won't have any fun anymore, in a GOOD way tho.",
		powerupIcon = "res://UI/Powerups/Icons/powerup_icons_temp/powerup_icon_temp_08.png",
		powerupLevel = 0
	},
	Powerup9 = { 
		powerupName = "Powerup 8 + 1",
		powerupDescription = "This amazing powerup will help you be better.",
		powerupIcon = "res://UI/Powerups/Icons/powerup_icons_temp/powerup_icon_temp_09.png",
		powerupLevel = 0
	},
	Powerup10 = {
		powerupName = "The tenth Powerup",
		powerupDescription = "Use this when playing.",
		powerupIcon = "res://UI/Powerups/Icons/powerup_icons_temp/powerup_icon_temp_10.png",
		powerupLevel = 0
	},
	Powerup11 = {
		powerupName = "11th Powerup",
		powerupDescription = "Have a good time making yourself Strong. Or not.",
		powerupIcon = "res://UI/Powerups/Icons/powerup_icons_temp/powerup_icon_temp_11.png",
		powerupLevel = 0
	},
	Powerup12 = {
		powerupName = "Uncle Ben Powerup",
		powerupDescription = "With great power, comes great responsibility.",
		powerupIcon = "res://UI/Powerups/Icons/powerup_icons_temp/powerup_icon_temp_12.png",
		powerupLevel = 0
	},
	Powerup13 = {
		powerupName = "Unlucky",
		powerupDescription = "Don't get this one. Don't use it. You've been warned.",
		powerupIcon = "res://UI/Powerups/Icons/powerup_icons_temp/powerup_icon_temp_13.png",
		powerupLevel = 0
	},
	Powerup14 = {
		powerupName = "P.U. #14",
		powerupDescription = "This is Final Placeholder powerup FOR NOW... until it's not. Maybe add a way to get a fourth powerup loading in (as the player)?",
		powerupIcon = "res://UI/Powerups/Icons/powerup_icons_temp/powerup_icon_temp_14.png",
		powerupLevel = 0
	}
}
		
var obstacles_hilited := []
var score = 0

enum collision {DO_NOT_SET = 0,
				GROUND = 1,
				NPC = 2,
				OBSTACLE = 3,
				ABDUCTEE = 4,
				CURSOR_ZONE = 5,
				POWERUPS = 6,
				MENU_BUTTONS = 7,
				PROJECTILE = 8,
				ABDUCTEE_INTERACT = 9,
				OBSTACLE_INTERACT = 10,
				NPC_INTERACT = 11,
				SCORE_DUNK = 12,
				PLAYER = 16
				}

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

var level_chunks_menu := [
	"res://Terrain/terrain_level_menu/",
	"res://Terrain/terrain_level_menu/",
	"res://Terrain/terrain_level_menu/",
	"res://Terrain/terrain_level_menu/",
	"res://Terrain/terrain_level_menu/",
	"res://Terrain/terrain_level_menu/",
	"res://Terrain/terrain_level_menu/",
	"res://Terrain/terrain_level_menu/",
	"res://Terrain/terrain_level_menu/",
	"res://Terrain/terrain_level_menu/",
	"res://Terrain/terrain_level_menu/",
	"res://Terrain/terrain_level_menu/",
	"res://Terrain/terrain_level_menu/"
]

var current_safe_chunks : StringName
var current_obstacle_chunks : StringName
var current_points_chunks : StringName
var current_menu_chunks : StringName

var meat_objects := {
	Abductee.is_types.COW: load("res://NPCs/Cows/Cow_01-03_00.tscn"),
	Abductee.is_types.HUMAN: load("res://NPCs/Humans/human_02-01_00.tscn"),
	Abductee.is_types.TREE1: load("res://Objects/Foliage/Tree_01/tree_01_02_grabbable.tscn")
}

func _ready():
	Messenger.swap_game_state.connect(on_swap_game_state)
	Messenger.abduction.connect(on_abduction)
	Messenger.level_update.connect(on_level_update)
	Messenger.restart.connect(on_restart)
	Messenger.retry.connect(on_retry)
	on_level_update(level_current)
	
	powerups_available = powerups.keys()
	
	load_humans(human_tops_paths,human_tops)

func load_humans(paths_array,destination_array):
	for path in paths_array:
		var loaded_material: StandardMaterial3D = load(path) as StandardMaterial3D
		destination_array.append(loaded_material)

func on_level_update(level):
	level_current = level
	#print("Globals tried updating paths")
	current_safe_chunks = level_chunks_safe[level]
	
	current_points_chunks = level_chunks_points[level]
	
	current_obstacle_chunks = level_chunks_obstacles[level]
	
	current_menu_chunks = level_chunks_menu[level]
	
func on_retry(is_restart):
	Game_States.is_paused = false
	get_tree().paused = false
	powerups_available = powerups.keys()
	obstacles_hilited = [] ## Empties out the last hilighted obstacle arrayd
	score = 0
	if !is_restart:
		Messenger.level_update.emit(1)
		Messenger.swap_game_state.emit(Globals.is_game_states.PLAY)
		
	
func on_restart():
	#print("Restart attempted")
	Messenger.retry.emit(true)
	Messenger.level_update.emit(0)
	get_tree().call_deferred("reload_current_scene")
	#get_tree().call_deferred("change_scene_to_file","res://main_scene.tscn")
	Messenger.swap_game_state.emit(Globals.is_game_states.PREINTRO)
	
func on_abduction(score_value):
	score += score_value
	
#func find_obstacles(to_check: Node) --> Block_Object

func on_swap_game_state(game_state):
	is_game_state = game_state
	#print("Is State #: ",is_game_state)
