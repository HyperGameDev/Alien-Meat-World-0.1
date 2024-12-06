extends Node3D

@onready var dialogue_box: Sprite3D = $Sprite3D

@export var dialogue_x_pos_right: float = -3.26 
@export var dialogue_x_pos_left: float = 3.67
var is_right: bool = false

func _ready() -> void:
	if is_right:
		dialogue_box.global_position.x = dialogue_x_pos_right
	else:
		dialogue_box.global_position.x = dialogue_x_pos_left
		
	
