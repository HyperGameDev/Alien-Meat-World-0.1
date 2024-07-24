extends Node3D

@onready var terrain_controller: Node3D = %TerrainController_inScene
@onready var cam_target: Node3D = %Cam_Target
@onready var camera: Camera3D = %Camera3D

@export var menu_cam_pos_y: float = 1.67
@export var menu_cam_rot_y: float = 14.3
@export var menu_cam_rot_x: float = 6.4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	terrain_controller.terrain_velocity = 6.5
	
	camera.cam_y_offset = menu_cam_pos_y
	
	cam_target.rot_y_offset = deg_to_rad(menu_cam_rot_y)
	cam_target.rotation.y += cam_target.rot_y_offset
	
	cam_target.rot_x_offset = deg_to_rad(menu_cam_rot_x)
	cam_target.rotation.x += cam_target.rot_x_offset
	
	Messenger.game_begin.connect(on_game_begin)

	
func on_game_begin():
	terrain_controller.terrain_velocity = terrain_controller.TERRAIN_VELOCITY
	camera.cam_x_offset = camera.CAM_X_OFFSET
	camera.cam_y_offset = camera.CAM_Y_OFFSET
