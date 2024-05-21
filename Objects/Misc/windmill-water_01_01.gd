extends Node3D

@onready var animation_wheel = %"Animation_Wheel-Spin"

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_wheel.play("wheel_spin")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
