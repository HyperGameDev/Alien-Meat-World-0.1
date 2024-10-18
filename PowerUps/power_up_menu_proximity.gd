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
	
	Messenger.powerup_chosen.connect(on_powerup_chosen)
	Messenger.powerup_menu_descended.connect(on_powerup_menu_descended)
	
	
func on_powerup_menu_descended():
	powerup_overlaps.clear()
	for overlap in get_overlapping_areas():
		if overlap.get_owner() is Block_Object:
			overlap.get_owner().visible = false
			powerup_overlaps.append(overlap)
			overlap.set_collision_layer_value(Globals.collision.OBSTACLE_INTERACT,false)
			overlap.set_collision_layer_value(Globals.collision.NPC_INTERACT,false)
			overlap.set_collision_layer_value(Globals.collision.OBSTACLE,false)
			overlap.set_collision_layer_value(Globals.collision.NPC,false)
	
#func on_area_entered(area):

		
func on_powerup_chosen(powerup):
	for overlap in powerup_overlaps:
		overlap.get_owner().visible = true
		overlap.set_collision_layer_value(Globals.collision.OBSTACLE_INTERACT,true)
		overlap.set_collision_layer_value(Globals.collision.NPC_INTERACT,true)
		overlap.set_collision_layer_value(Globals.collision.OBSTACLE,true)
		overlap.set_collision_layer_value(Globals.collision.NPC,true)
		

		
