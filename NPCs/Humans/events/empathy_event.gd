extends Node3D

@onready var human_left: RigidBody3D = %Human_Left
@onready var human_right: RigidBody3D = %Human_Right
@onready var dialogue_left: CanvasLayer = human_left.get_node("%Canvas_Layer")
@onready var dialogue_right: CanvasLayer = human_right.get_node("%Canvas_Layer")

@onready var animation: AnimationPlayer = %AnimationPlayer

var empathy_events: Dictionary = Globals.empathy_events

func _ready() -> void:
	var empathy_event: String =  empathy_events.keys().pick_random()
	
	if empathy_events[empathy_event]["right_is_enemy"]:
		human_right.is_enemy = true
		animation.play(empathy_event)
		
func dialogue_left_1():
	dialogue_right.visible = false
	dialogue_left.visible = true
	#dialogue_left.
		
