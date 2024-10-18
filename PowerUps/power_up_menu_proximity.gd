extends Area3D

@onready var powerup_menu: Node3D = %PowerUp_Menu

var powerup_overlaps: Array = []
var powerup_menu_begun: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_collision_layer_value(Globals.collision.GROUND,false)
	set_collision_layer_value(Globals.collision.POWERUPS,false)
	set_collision_mask_value(Globals.collision.OBSTACLE_INTERACT,true)
	set_collision_mask_value(Globals.collision.NPC_INTERACT,true)
	
	area_entered.connect(on_area_entered)
	Messenger.powerup_menu_begin.connect(on_powerup_menu_begin)
	Messenger.powerup_chosen.connect(on_powerup_chosen)
	
func _process(delta: float) -> void:
	global_position = powerup_menu.global_position
	
func on_powerup_menu_begin():
	powerup_menu_begun = true
	
func on_area_entered(area):
	if powerup_menu_begun:
		powerup_overlaps = get_overlapping_areas()
		for overlap in powerup_overlaps:
			pass
			overlap.get_owner().visible = false
			overlap.set_collision_layer_value(Globals.collision.OBSTACLE_INTERACT,false)
			overlap.set_collision_layer_value(Globals.collision.NPC_INTERACT,false)
			overlap.set_collision_layer_value(Globals.collision.OBSTACLE,false)
			overlap.set_collision_layer_value(Globals.collision.NPC,false)
		
func on_powerup_chosen(powerup):
	powerup_menu_begun = false
	for overlap in powerup_overlaps:
		
		
		overlap.get_owner().visible = true
		overlap.set_collision_layer_value(Globals.collision.OBSTACLE_INTERACT,true)
		overlap.set_collision_layer_value(Globals.collision.NPC_INTERACT,true)
		overlap.set_collision_layer_value(Globals.collision.OBSTACLE,true)
		overlap.set_collision_layer_value(Globals.collision.NPC,true)
		

		
