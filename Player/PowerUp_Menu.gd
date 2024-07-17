extends Node3D

const ORB_MOVE_SPEED = 1

@onready var orb_1: Area3D = %PowerUp_Orb_1
@onready var orb_2: Area3D = %PowerUp_Orb_2
@onready var orb_3: Area3D = %PowerUp_Orb_3

@onready var player: CharacterBody3D = %Player

const TRAVEL_DISTANCE: float = 1.725

@onready var player_height: float = 0.0
		
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
	player_height = player.position.y

	#region Travel Distance Calculation
	var offset_y = TRAVEL_DISTANCE + player_height
	var travel_distance = TRAVEL_DISTANCE
	
	if player.position.y < -.9:
		travel_distance = TRAVEL_DISTANCE + offset_y
	#endregion
		
	#region Animate menu descent
	var tween = get_tree().create_tween();
	tween.tween_property(self, "position:y", -travel_distance, ORB_MOVE_SPEED)
	
	#endregion
	
	
	
	#region Assign all available powerups to an array
	
	# Then shuffle that array
	Globals.powerups_available.shuffle()
	
	#endregion
	
	#region Assign each array'd powerup to an orb
	orb_1.powerup_key = Globals.powerups_available[0]
	orb_1.on_powerups_assigned()
	
	orb_2.powerup_key = Globals.powerups_available[1]
	orb_2.on_powerups_assigned()
	
	orb_3.powerup_key = Globals.powerups_available[2]
	orb_3.on_powerups_assigned()
	
	#debug
	#print("\n Orb 1: ", orb_1.powerup_key,
	#"\n Orb 2: ", orb_2.powerup_key, "\n Orb 3: ", orb_3.powerup_key)
	
	#endregion


func on_powerup_chosen(orb):
	
	#region Travel Distance Calculation
	var offset_y: float = TRAVEL_DISTANCE + player_height
	var travel_distance: float = TRAVEL_DISTANCE
	
	if player.position.y < 0:
		travel_distance = TRAVEL_DISTANCE + offset_y
	#endregion
	
	#region Animate menu ascent
	var tween = get_tree().create_tween();
	tween.tween_property(self, "position:y", travel_distance, ORB_MOVE_SPEED)
	await get_tree().create_timer(ORB_MOVE_SPEED).timeout
	
	#endregion
	
	visible = false
