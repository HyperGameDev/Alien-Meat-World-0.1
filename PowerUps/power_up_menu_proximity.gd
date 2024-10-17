extends Area3D

@onready var powerup_menu: Node3D = %PowerUp_Menu


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_collision_layer_value(Globals.collision.GROUND,false)
	set_collision_layer_value(Globals.collision.POWERUPS,false)
	set_collision_mask_value(Globals.collision.OBSTACLE_INTERACT,true)
	set_collision_mask_value(Globals.collision.NPC_INTERACT,true)
	
	area_entered.connect(on_area_entered)
	area_exited.connect(on_area_exited)
	
func _process(delta: float) -> void:
	global_position = powerup_menu.global_position
	
func on_area_entered(area):
	for object in get_overlapping_areas():
		object.visible = false
		object.set_collision_layer_value(Globals.collision.OBSTACLE_INTERACT,false)
		object.set_collision_layer_value(Globals.collision.NPC_INTERACT,false)
		object.set_collision_layer_value(Globals.collision.OBSTACLE,false)
		object.set_collision_layer_value(Globals.collision.NPC,false)
		
func on_area_exited(area):
	for object in get_overlapping_areas():
		object.visible = true
		object.set_collision_layer_value(Globals.collision.OBSTACLE_INTERACT,true)
		object.set_collision_layer_value(Globals.collision.NPC_INTERACT,true)
		object.set_collision_layer_value(Globals.collision.OBSTACLE,true)
		object.set_collision_layer_value(Globals.collision.NPC,true)
		

		
