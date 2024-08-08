extends Node

@onready var blackout: Panel = get_tree().current_scene.get_node("%Blackout_BG")
@onready var sun: DirectionalLight3D = get_tree().current_scene.get_node("%DirectionalLight3D")
@onready var terrain_controller: Node3D = get_tree().current_scene.get_node("%TerrainController_inScene")
@onready var cam_target: Node3D = get_tree().current_scene.get_node("%Cam_Target")
@onready var camera: Camera3D = get_tree().current_scene.get_node("%Camera3D")
@onready var main_menu: Node3D = get_tree().current_scene.get_node("%Main_Menu")

func _ready() -> void:
	Messenger.swap_game_state.connect(on_swap_game_state)

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
			
		Globals.is_game_states.BEGIN:
			on_game_state_begin()
			
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
	await get_tree().create_timer(1).timeout
	var tween_fadein = get_tree().create_tween();
	tween_fadein.tween_property(blackout, "self_modulate", Color(1.0,1.0,1.0,.0), 0.1)
	
	
func on_game_state_menu():
	Messenger.game_menu.emit()
	main_menu.visible = true
	terrain_controller.terrain_velocity = 6.5
	
	camera.cam_y_offset = main_menu.menu_cam_pos_y

	cam_target.rot_y_offset = deg_to_rad(main_menu.menu_cam_rot_y)
	cam_target.rotation.y += cam_target.rot_y_offset

	cam_target.rot_x_offset = deg_to_rad(main_menu.menu_cam_rot_x)
	cam_target.rotation.x += cam_target.rot_x_offset
	
func on_game_state_postmenu():
	main_menu.animation.play("menu_exit")
	terrain_controller.terrain_velocity = 0.0
	Messenger.game_postmenu.emit()

func on_game_state_begin():
	Messenger.game_begin.emit()
	terrain_controller.terrain_velocity = terrain_controller.TERRAIN_VELOCITY
	camera.cam_x_offset = camera.CAM_X_OFFSET
	camera.cam_y_offset = camera.CAM_Y_OFFSET
