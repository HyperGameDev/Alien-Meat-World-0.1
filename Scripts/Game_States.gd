extends Node

## Search files for swap_game_state to find other transition points between states

@onready var blackout: Panel = get_tree().current_scene.get_node("%Blackout_BG")
@onready var sun: DirectionalLight3D = get_tree().current_scene.get_node("%DirectionalLight3D")
@onready var terrain_controller: Node3D = get_tree().current_scene.get_node("%TerrainController_inScene")
@onready var cam_target: Node3D = get_tree().current_scene.get_node("%Cam_Target")
@onready var camera: Camera3D = get_tree().current_scene.get_node("%Camera3D")
@onready var main_menu: Node3D = get_tree().current_scene.get_node("%Main_Menu")
@onready var pause_menu: CanvasLayer = get_tree().current_scene.get_node("Pause_Menu")

var is_paused: bool = false


func _ready() -> void:
	Messenger.swap_game_state.connect(on_swap_game_state)
	
	Messenger.swap_game_state.emit(Globals.is_game_states.PREINTRO)

func on_swap_game_state(game_state):
	match game_state:
		Globals.is_game_states.PREINTRO:
			on_game_state_preintro()
			
		Globals.is_game_states.INTRO:
			on_game_state_intro()
			
		Globals.is_game_states.MENU:
			on_game_state_menu()
			
		Globals.is_game_states.POSTMENU:
			on_game_state_postmenu()
			
		Globals.is_game_states.PREBEGIN:
			on_game_state_prebegin()
			
		Globals.is_game_states.BEGIN:
			on_game_state_begin()
			
		Globals.is_game_states.PLAY:
			on_game_state_play()
		
		Globals.is_game_states.PAUSE:
			on_game_state_pause()
			
		_:
			pass
			
func on_game_state_preintro():
	await get_tree().create_timer(2).timeout
	#region Fade in the game
	var tween = get_tree().create_tween();
	tween.tween_property(blackout, "self_modulate", Color(1.0, 1.0, 1.0, .0), 1.0)
	sun.visible = true
	#endregion
	Messenger.swap_game_state.emit(Globals.is_game_states.INTRO)
	Messenger.game_intro.emit()
	

func on_game_state_intro():
	# CONSIDER refactoring these tweens into an animationplayer!
	var tween_fadeout = get_tree().create_tween();
	tween_fadeout.tween_property(blackout, "self_modulate", Color(1.0, 1.0, 1.0, 1.0), 1.0)
	
	await tween_fadeout.finished
	var tween_fadein = get_tree().create_tween();
	tween_fadein.tween_property(blackout, "self_modulate", Color(1.0,1.0,1.0,.0), 0.1)
	
	
func on_game_state_menu():
	var tween_fadeout = get_tree().create_tween();
	tween_fadeout.tween_property(blackout, "self_modulate", Color(1.0, 1.0, 1.0, 1.0), .6)
	
	await tween_fadeout.finished
	
	main_menu.visible = true
	terrain_controller.terrain_velocity = 6.5
	
	var tween_fadein = get_tree().create_tween();
	tween_fadein.tween_property(blackout, "self_modulate", Color(1.0,1.0,1.0,.0), 1.0)
	
	Messenger.game_menu.emit()
	
	camera.cam_y_offset = main_menu.menu_cam_pos_y

	cam_target.rot_y_offset = deg_to_rad(main_menu.menu_cam_rot_y)
	cam_target.rotation.y += cam_target.rot_y_offset

	cam_target.rot_x_offset = deg_to_rad(main_menu.menu_cam_rot_x)
	cam_target.rotation.x += cam_target.rot_x_offset
	
func on_game_state_postmenu():
	main_menu.animation.play("menu_exit")
	Messenger.movement_stop.emit(false)
	Messenger.game_postmenu.emit()
	
func on_game_state_prebegin():
	camera.cam_y_offset += 6.0
	var tween_fadeout = get_tree().create_tween();
	tween_fadeout.tween_property(blackout, "self_modulate", Color(1.0, 1.0, 1.0, 1.0), .3)
	
	await tween_fadeout.finished
	Messenger.game_prebegin.emit()
	Messenger.level_update.emit(1)
	camera.cam_y_offset += 20.0
	
	await get_tree().create_timer(2.0).timeout
	cam_target.rotation.y = cam_target.ROTATION_Y
	cam_target.rotation.x = deg_to_rad(cam_target.ROTATION_X)
	camera.cam_x_offset = camera.CAM_X_OFFSET
	camera.cam_y_offset -= camera.cam_y_offset - camera.CAM_Y_OFFSET
	Messenger.swap_game_state.emit(Globals.is_game_states.BEGIN)
	
	var tween_fadein = get_tree().create_tween();
	tween_fadein.tween_property(blackout, "self_modulate", Color(1.0,1.0,1.0,.0), .6)

func on_game_state_begin():
	Messenger.game_begin.emit()
	
func on_game_state_play():
	pause_menu.visible = false
	Messenger.game_play.emit()
	Messenger.movement_start.emit(false)


func _input(event: InputEvent):
	if event.is_action_pressed("Pause") and Globals.is_game_state == Globals.is_game_states.PLAY:
		Messenger.swap_game_state.emit(Globals.is_game_states.PAUSE)
		is_paused = true
		
func on_game_state_pause():
	Messenger.game_pause.emit()
	get_tree().paused = true
	pause_menu.visible = true

func _process(delta: float) -> void:
	if is_paused and !get_tree().paused:
		Messenger.swap_game_state.emit(Globals.is_game_states.PLAY)
		is_paused = false
