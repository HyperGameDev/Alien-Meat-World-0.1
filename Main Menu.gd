extends Node3D

@onready var animation: AnimationPlayer = $AnimationPlayer


@onready var cutscenes: Node3D = %Cutscenes

@export var menu_cam_pos_y: float = 1.67
@export var menu_cam_rot_y: float = 14.3
@export var menu_cam_rot_x: float = 6.4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	Messenger.swap_game_state.emit(Globals.is_game_states.PREINTRO)


func _input(event):
	if event is InputEventKey and Globals.is_game_state == Globals.is_game_states.INTRO:
		if event.pressed:	
			Messenger.swap_game_state.emit(Globals.is_game_states.MENU)
	
func menu_flyaway_over():
	visible = false
