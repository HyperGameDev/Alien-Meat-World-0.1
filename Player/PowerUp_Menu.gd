extends Node3D

const ORB_MOVE_SPEED = 1

@onready var orb_1: Area3D = %PowerUp_Orb_1
@onready var orb_2: Area3D = %PowerUp_Orb_2
@onready var orb_3: Area3D = %PowerUp_Orb_3

@onready var player: CharacterBody3D = %Player

@export var travel_distance: float = 1.725



# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	orb_1.set_collision_layer_value(6, true)
	orb_2.set_collision_layer_value(6, true)
	orb_3.set_collision_layer_value(6, true)
	Messenger.powerup_menu_begin.connect(on_powerup_menu_begin)
	Messenger.powerup_chosen.connect(on_powerup_chosen)

func on_powerup_menu_begin():
	visible = true
	position.x = player.position.x
	var tween = get_tree().create_tween();
	tween.tween_property(self, "position:y", -travel_distance, ORB_MOVE_SPEED)
	
func on_powerup_chosen(orb):
	print("Orb ",orb," chosen!")
	var tween = get_tree().create_tween();
	tween.tween_property(self, "position:y", travel_distance, ORB_MOVE_SPEED)
	await get_tree().create_timer(ORB_MOVE_SPEED).timeout
	visible = false
