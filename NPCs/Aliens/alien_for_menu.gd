extends Node3D

class_name Alien_For_Menu

@export var unhoverable: bool = false

static var is_visible: bool = false
static var is_hoverable: bool = false

@onready var hud: CanvasLayer = get_tree().get_root().get_node("Main Scene/HUD")
@onready var confirm_menu: CanvasLayer = get_tree().get_root().get_node("Main Scene/Confirm_Menu")

@onready var alien_headpieces: Node3D = $Alien/Alien_Headpieces

@onready var alien_shadowed: StandardMaterial3D = preload("res://NPCs/Aliens/shadowed_alien.tres") as StandardMaterial3D

@onready var mesh: MeshInstance3D = $Alien
@onready var area: Area3D = %Area3D
@onready var animation_menu_alien: AnimationTree = $Alien/AnimationTree
@onready var animation_exclaim: AnimationPlayer = $Alien/Alien_Exclaim/AnimationPlayer 
@onready var animation_teleport: AnimationPlayer = $Orb/AnimationPlayer
@onready var exclamation: MeshInstance3D = %Alien_Exclaim
@onready var orb: MeshInstance3D = %Orb

var was_chosen : bool = false
var is_hovered : bool = false

var skin : String = "Skin_01"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for headpiece in alien_headpieces.get_children():
		headpiece.visible = false
	orb.visible = false
	area.add_to_group("Menu Alien")
	mesh.get_surface_override_material(0).disable_receive_shadows = true

	
	if is_visible:
		visible = true
	else:
		visible = false
		
	if is_hoverable and !unhoverable:
		area.set_collision_layer_value(15,true)
	else:
		area.set_collision_layer_value(15,false)
		
	aliens_bounce()
	Messenger.game_intro.connect(on_game_intro)
	Messenger.game_premenu.connect(on_game_premenu)
	Messenger.game_postmenu.connect(on_game_postmenu)
	Messenger.game_begin.connect(on_game_begin)
	Messenger.attack_target.connect(am_i_hovered)
	Messenger.skin_confirm.connect(on_skin_confirm)
	Messenger.anything_seen.connect(on_anything_seen)
	
	
func on_anything_seen(target):
	if !target.is_empty():
		if !target["collider"] == area:
			if Globals.is_game_state == Globals.is_game_states.CONFIRM and !was_chosen:
				shadow()
	
func am_i_hovered(target):
	if target == area:
		if Globals.is_game_state == Globals.is_game_states.CONFIRM:
			unshadow()
		if has_node("Marker3D"):
			Messenger.something_hovered.emit(area)
			Messenger.menu_alien_seen.emit(area)
			if Input.is_action_just_pressed("Grab"):
				#confirm_menu.animation.set("parameters/Transition/transition_request", "growing")
				#await get_tree().create_timer(.1).timeout
				confirm_menu.animation.set("parameters/Transition/transition_request", "growing")
				was_chosen = true
				animation_menu_alien.set("parameters/Transition/transition_request", "bouncing")
	else:
		if Input.is_action_just_pressed("Grab") and was_chosen:
			unchoose_unshadow()
			
func unchoose_unshadow():
	was_chosen = false
	unshadow()
				
func unshadow():
	mesh.material_overlay = null
	
	for headpiece in alien_headpieces.get_children():
		for node in headpiece.get_children():
			if node is MeshInstance3D:
				node.material_overlay = null
		
func shadow():
	mesh.material_overlay = alien_shadowed
	
	for headpiece in alien_headpieces.get_children():
		for node in headpiece.get_children():
			if node is MeshInstance3D:
				node.material_overlay = alien_shadowed

func on_game_intro():
	is_visible = false
	visible = false
	is_hoverable = false
	if !unhoverable:
		area.set_collision_layer_value(15,false)

func on_game_premenu(): #prem
	is_visible = true
	visible = true
	is_hoverable = true
	if !unhoverable:
		area.set_collision_layer_value(15,true)
	
func on_game_postmenu():
	is_hoverable = false
	area.set_collision_layer_value(15,false)
	if was_chosen:
		exclamation.visible = false
		Messenger.skin_clicked.emit(skin)
	else:
		animation_menu_alien.set("parameters/Transition/transition_request", "stopping")
		
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
		#print("Should be hidden")
		visible = false
		
func aliens_bounce():
	var ani_pos: float = randf_range(0.0,0.9)
	animation_menu_alien.set("parameters/Transition/transition_request", "bouncing")
	#animation_menu_alien.seek(ani_pos,true)
	animation_menu_alien.set("parameters/TimeSeek/seek_request",ani_pos)
	
func on_game_begin():
	visible = false
	is_visible = false

func on_skin_confirm(confirmed):
	if confirmed:
		#unshadow()
		pass
	else:
		unchoose_unshadow()
		aliens_bounce()
