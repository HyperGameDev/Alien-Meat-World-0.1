extends Node3D


@onready var player: CharacterBody3D = %Player
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var cutscenes: Node3D = %Cutscenes

@onready var title: Node3D = $"Title/Title_Harvest-Earth_01"
@onready var menu: Node3D = $Menu_Buttons

@onready var shadowed: StandardMaterial3D = preload("res://NPCs/Aliens/shadowed_alien.tres") as StandardMaterial3D

@export var menu_cam_pos_y: float = 1.67
@export var menu_cam_rot_y: float = 14.3
@export var menu_cam_rot_x: float = 6.4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Messenger.game_confirm.connect(on_game_confirm)
	Messenger.skin_confirm.connect(on_skin_confirm)
	visible = false


func _input(event):
	if event is InputEventKey and Globals.is_game_state == Globals.is_game_states.INTRO:
		if event.pressed:	
			Messenger.swap_game_state.emit(Globals.is_game_states.PREMENU)
	if event is InputEventJoypadButton and Globals.is_game_state == Globals.is_game_states.INTRO:
		if event.pressed:	
			Messenger.swap_game_state.emit(Globals.is_game_states.PREMENU)
		

func menu_flyaway_over():
	visible = false
	
	
func on_game_confirm():
	for node in title.get_children():
		if node is MeshInstance3D:
				node.material_overlay = shadowed
	for node in menu.get_children():
		for subnode in node.get_children():
			if subnode is MeshInstance3D:
				subnode.material_overlay = shadowed


func on_skin_confirm(confirmed):
	if confirmed:
		pass
	else:
		for node in title.get_children():
			if node is MeshInstance3D:
				node.material_overlay = null
		for node in menu.get_children():
			for subnode in node.get_children():
				if subnode is MeshInstance3D:
					subnode.material_overlay = null
		
