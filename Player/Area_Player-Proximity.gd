extends Area3D

# Exists so is not incorrectly thought of as a body part
var is_part : int = -2

@onready var copter_area_collision = $"Collision_Copter-Proximity"

# Called when the node enters the scene tree for the first time.
func _ready():
	Messenger.copter_unit_stopped.connect(copter_area_size)

	set_collision_mask_value(Globals.collision.NPC_INTERACT, true)

func copter_area_size(copters_stopped):
	copter_area_collision.shape.radius = (copters_stopped * 2) + copter_area_collision.shape.radius
#	print("Copter Collision Radius: ", copter_area_collision.shape.radius)
