extends Control

@onready var current_level = Globals.current_level
@onready var label_currentLevel = %Label_currentLevel

# Called when the node enters the scene tree for the first time.
func _ready():
	label_currentLevel.text = str("Current Level: ",Globals.current_level.trim_prefix("res://Terrain/terrain_").trim_suffix("/"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_level_debug_01_pressed():
	Globals.current_level = Globals.levels[0]
	get_tree().call_deferred("reload_current_scene")


func _on_button_level_00_pressed():
	Globals.current_level = Globals.levels[1]
	get_tree().call_deferred("reload_current_scene")
	

func _on_button_level_blank_grass_pressed():
	Globals.current_level = Globals.levels[2]
	get_tree().call_deferred("reload_current_scene")


func _on_button_level_blank_dirt_pressed():
	Globals.current_level = Globals.levels[3]
	get_tree().call_deferred("reload_current_scene")
	

func _on_button_level_blank_concrete_pressed():
	Globals.current_level = Globals.levels[4]
	get_tree().call_deferred("reload_current_scene")


func _on_button_level_blank_military_pressed():
	Globals.current_level = Globals.levels[5]
	get_tree().call_deferred("reload_current_scene")


func _on_button_level_blank_all_pressed():
	Globals.current_level = Globals.levels[6]
	get_tree().call_deferred("reload_current_scene")


func _on_button_level_debug_02_pressed():
	Globals.current_level = Globals.levels[7]
	get_tree().call_deferred("reload_current_scene")
