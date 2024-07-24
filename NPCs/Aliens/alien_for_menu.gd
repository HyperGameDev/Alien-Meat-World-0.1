extends Node3D

class_name Alien_For_Menu

static var is_visible: bool = true

@onready var area: Area3D = %Area3D
@onready var animation: AnimationPlayer = %AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area.add_to_group("Menu Alien")
	
	if is_visible:
		visible = true
	else:
		visible = false
	var ani_pos: float = randf_range(0.0,0.9)
	animation.play("bounce")
	animation.seek(ani_pos,true)
	
	Messenger.game_begin.connect(on_game_begin)
	Messenger.attack_target.connect(am_i_hovered)


func on_game_begin():
	visible = false
	is_visible = false

func am_i_hovered(target):
	if target == area:
		if has_node("Marker3D"):
			Messenger.something_hovered.emit(area)

