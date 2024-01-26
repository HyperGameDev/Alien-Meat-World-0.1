extends Area3D

@onready var copter_area_collision = $"Collision_Copter-Proximity"

# Called when the node enters the scene tree for the first time.
func _ready():
	Messenger.copter_unit_stopped.connect(copter_area_size)

func copter_area_size(copters_stopped):
	copter_area_collision.shape.radius = (copters_stopped * 2) + copter_area_collision.shape.radius
#	print("Copter Collision Radius: ", copter_area_collision.shape.radius)
