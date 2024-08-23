extends Marker3D


@onready var grab_point_target: CharacterBody3D = %Player

# Adjust these together!
@export var grab_point_y_offset : float = 2.3
const GRAB_POINT_Y_OFFSET : float = 2.3

# Adjust these together!
@export var grab_point_x_offset : float = 0.0
const GRAB_POINT_X_OFFSET : float = 0.0

@export var grab_point_lerpspeed : float = .05
@export var grab_point_z_offset : float = 0.0

func _ready() -> void:
	Messenger.grab_point_offset.connect(on_grab_point_offset)

func _physics_process(delta: float) -> void:
	# Grab Point follow position
	var grab_point_follow_pos: Vector3 = grab_point_target.position
#	dunk_follow_pos.z += dunk_z_offset
	grab_point_follow_pos.y += grab_point_y_offset
	grab_point_follow_pos.x += grab_point_x_offset

	# Dunk Follow Normalize
	var grab_point_direction: Vector3 = grab_point_follow_pos - self.position

	self.position += grab_point_direction * grab_point_lerpspeed
	
func on_grab_point_offset(direction):
	#print(direction)
	match direction:
		0:
			grab_point_x_offset = GRAB_POINT_X_OFFSET
			grab_point_y_offset = GRAB_POINT_Y_OFFSET
		1:
			grab_point_x_offset = -2
		2:
			grab_point_x_offset = 2
		3:
			grab_point_y_offset = 2
		4:
			grab_point_y_offset = -2
		_:
			pass
