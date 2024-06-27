extends Node3D

const ORB_MOVE_SPEED = 1

@onready var orb_1 = %PowerUp_Orb_1
@onready var orb_2 = %PowerUp_Orb_2
@onready var orb_3 = %PowerUp_Orb_3

@onready var player = %Player
@onready var animation_menu = %Animation_PowerUp_Menu



# Called when the node enters the scene tree for the first time.
func _ready():
	orb_1.set_collision_layer_value(6, true)
	orb_2.set_collision_layer_value(6, true)
	orb_3.set_collision_layer_value(6, true)
	Messenger.score_minimum_met.connect(on_score_minimum_met)
	Messenger.powerup_chosen.connect(on_powerup_chosen)

func on_score_minimum_met():
	self.visible = true
	position.x = player.position.x
	var tween = get_tree().create_tween();
	tween.tween_property(self, "position:y", -1.725, ORB_MOVE_SPEED)
	
func on_powerup_chosen(orb):
	print("Orb ",orb," chosen!")
	var tween = get_tree().create_tween();
	tween.tween_property(self, "position:y", 1.5, ORB_MOVE_SPEED)
	await get_tree().create_timer(ORB_MOVE_SPEED).timeout
	self.visible = false
