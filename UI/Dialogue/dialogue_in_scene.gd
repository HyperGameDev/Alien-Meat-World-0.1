extends Node3D

@onready var dialogue_box: Sprite3D = $Sprite3D
@onready var canvas_dialogue: CanvasLayer = $Sprite3D/SubViewport/CanvasLayer


@export var dialogue_z_pos_right: float = -3.26 
@export var dialogue_z_pos_left: float = 3.67
var is_right: bool = false

func _ready() -> void:
	if is_right:
		global_position.z = dialogue_z_pos_right
		var right_tail: MarginContainer = canvas_dialogue.get_node("%Container_tailRight")
		right_tail.visible = true
		
	else:
		global_position.z = dialogue_z_pos_left
		var left_tail: MarginContainer = canvas_dialogue.get_node("%Container_tailLeft")
		left_tail.visible = true
		
	
