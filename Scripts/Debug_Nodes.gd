extends Node3D

class_name Debug

@export var is_hidden = true 

const OFFSCREEN_POSITION = Vector3(-300,0,0)
var current_position = Vector3(0,0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	current_position = self.global_position
	Messenger.debug_nodes.connect(control_nodes)
	control_nodes()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func control_nodes():
	turn_off_on()
		
func turn_off_on():
	if is_hidden == true:
		self.global_position = OFFSCREEN_POSITION
		is_hidden = false
	else:
		self.global_position = current_position
		is_hidden = true
