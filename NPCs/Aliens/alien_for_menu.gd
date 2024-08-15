extends Node3D

class_name Alien_For_Menu

@export var unhoverable: bool = false

static var is_visible: bool = false
static var is_hoverable: bool = false

@onready var hud: CanvasLayer = get_tree().get_root().get_node("Main Scene/HUD")

@onready var area: Area3D = %Area3D
@onready var animation_menu_alien: AnimationTree = $Alien/AnimationTree
@onready var animation_exclaim: AnimationPlayer = $Alien/Alien_Exclaim/AnimationPlayer 
@onready var animation_teleport: AnimationPlayer = $Orb/AnimationPlayer
@onready var exclamation: MeshInstance3D = %Alien_Exclaim
@onready var orb: MeshInstance3D = %Orb

var was_chosen : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	orb.visible = false
	area.add_to_group("Menu Alien")
	
	if is_visible:
		visible = true
	else:
		visible = false
		
	if is_hoverable and !unhoverable:
		area.set_collision_layer_value(15,true)
	else:
		area.set_collision_layer_value(15,false)
		
	var ani_pos: float = randf_range(0.0,0.9)
	animation_menu_alien.set("parameters/Transition/transition_request", "bouncing")
	#animation_menu_alien.seek(ani_pos,true)
	animation_menu_alien.set("parameters/TimeSeek/seek_request",ani_pos)
	Messenger.game_menu.connect(on_game_menu)
	Messenger.game_postmenu.connect(on_game_postmenu)
	Messenger.game_begin.connect(on_game_begin)
	Messenger.attack_target.connect(am_i_hovered)


func am_i_hovered(target):
	if target == area:
		if has_node("Marker3D"):
			Messenger.something_hovered.emit(area)
			if Input.is_action_just_pressed("Grab"):
				was_chosen = true


func on_game_menu():
	is_visible = true
	visible = true
	is_hoverable = true
	if !unhoverable:
		area.set_collision_layer_value(15,true)
	
func on_game_postmenu():
	is_hoverable = false
	area.set_collision_layer_value(15,false)
	if !was_chosen:
		animation_menu_alien.set("parameters/Transition/transition_request", "stopping")
	else:
		exclamation.visible = false
		
	
	# TODO Make this an animation that runs a function at the end
	animation_exclaim.play("exclaim_begin")

		
func animation_exclaim_halfway():
	if was_chosen:
		orb.visible = true
		var tween = get_tree().create_tween();
		tween.tween_property(orb, "transparency", 0, .4)
		animation_teleport.play("teleport")
	
		
func animation_teleport_halfway():
	if was_chosen:
		animation_menu_alien.set("parameters/Transition/transition_request", "stopping")
		
func animation_teleport_liftoff():
	if was_chosen:
		animation_menu_alien.tree_root.get("nodes/Transition/node").xfade_time = 0.0
		animation_menu_alien.set("parameters/Transition/transition_request", "teleporting")
		
func animation_teleport_ascent():
		Messenger.swap_game_state.emit(Globals.is_game_states.PREBEGIN)

func animation_teleport_finished():
	if was_chosen:
		print("Should be hidden")
		visible = false
	
	
func on_game_begin():
	visible = false
	is_visible = false


