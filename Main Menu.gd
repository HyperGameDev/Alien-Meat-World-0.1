extends Node3D

@onready var animation: AnimationPlayer = $AnimationPlayer

@onready var terrain_controller: Node3D = %TerrainController_inScene
@onready var cam_target: Node3D = %Cam_Target
@onready var camera: Camera3D = %Camera3D
@onready var sun: DirectionalLight3D = %DirectionalLight3D
@onready var blackout: Panel = %Blackout_BG
@onready var cutscenes: Node3D = %Cutscenes

@export var menu_cam_pos_y: float = 1.67
@export var menu_cam_rot_y: float = 14.3
@export var menu_cam_rot_x: float = 6.4

var past_preintro: bool = false
var past_intro: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	sun.visible = false
	terrain_controller.terrain_velocity = 0.0

	Messenger.game_menu.connect(on_game_menu)
	Messenger.game_preload.connect(on_game_preload)
	Messenger.game_begin.connect(on_game_begin)
	game_preintro()
	
func game_preintro():
	await get_tree().create_timer(2).timeout
	var tween = get_tree().create_tween();
	tween.tween_property(blackout, "self_modulate", Color(1,1,1,0), 1)
	sun.visible = true
	
	Messenger.game_intro.emit()
	await tween.finished
	past_preintro = true

func _input(event):
	if event is InputEventKey and past_preintro and !past_intro:
		if event.pressed:
			past_intro = true
			# CONSIDER refactoring these tweens into an animationplayer!
			var tween_fadeout = get_tree().create_tween();
			tween_fadeout.tween_property(blackout, "self_modulate", Color(1,1,1,1), 1)
			await get_tree().create_timer(1).timeout
			var tween_fadein = get_tree().create_tween();
			tween_fadein.tween_property(blackout, "self_modulate", Color(1,1,1,0), 1)
			Messenger.game_menu.emit()
			
func on_game_menu():
	visible = true
	terrain_controller.terrain_velocity = 6.5
	
	camera.cam_y_offset = menu_cam_pos_y

	cam_target.rot_y_offset = deg_to_rad(menu_cam_rot_y)
	cam_target.rotation.y += cam_target.rot_y_offset

	cam_target.rot_x_offset = deg_to_rad(menu_cam_rot_x)
	cam_target.rotation.x += cam_target.rot_x_offset
	
func on_game_preload():
	animation.play("menu_exit")
	
func menu_flyaway_over():
	visible = false
	
	
func on_game_begin():
	terrain_controller.terrain_velocity = terrain_controller.TERRAIN_VELOCITY
	camera.cam_x_offset = camera.CAM_X_OFFSET
	camera.cam_y_offset = camera.CAM_Y_OFFSET
