extends Node3D

class_name Alien_For_Menu

static var is_visible: bool = true

@onready var animation: AnimationPlayer = %AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if is_visible:
		visible = true
	else:
		visible = false
	var ani_pos: float = randf_range(0.0,0.9)
	animation.play("bounce")
	animation.seek(ani_pos,true)
	
	Messenger.game_begin.connect(on_game_begin)


func on_game_begin():
	visible = false
	is_visible = false
