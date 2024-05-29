extends Control

@onready var current_level = Globals.current_safe_chunks
@onready var label_currentLevel = %Label_currentLevel

# Called when the node enters the scene tree for the first time.
func _ready():
	%Button_levelDebug_01.pressed.connect(on_levelDebug_01)
	%Button_level_01.pressed.connect(on_level_01)
	
	label_currentLevel.text = str("Current Level: ",Globals.current_safe_chunks.trim_prefix("res://Terrain/terrain_").trim_suffix("/"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func on_levelDebug_01():
	Messenger.level_update.emit(0)

func on_level_01():
	Messenger.level_update.emit(1)
