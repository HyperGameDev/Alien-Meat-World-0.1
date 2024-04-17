extends Control

var levels := [
	"res://Terrain/terrain_level_00_debug-01/",
	"res://Terrain/terrain_level_00/"
]
var current_level : StringName

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_level_debug_01_pressed():
	current_level = levels[0]


func _on_button_level_00_pressed():
	current_level = levels[1]
