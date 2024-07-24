extends Node3D

@export var rot_x_offset: float = 0.0
const ROTATION_X: float = -9.0
@export var rot_y_offset: float = 0.0
@export var rot_z_offset: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	Messenger.game_begin.connect(on_game_begin)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position = %Player.position
	
func on_game_begin():
	var tween_rot_y = get_tree().create_tween();
	tween_rot_y.tween_property(self, "rotation:y", deg_to_rad(-rot_y_offset), 1)
	
	var tween_rot_x = get_tree().create_tween();
	tween_rot_x.tween_property(self, "rotation:x", deg_to_rad(ROTATION_X), 1)
