extends Area3D

class_name Obstacle

signal update_hitpoints

@export var indicator_color = Color(1,.5,0,1)
@onready var hover_arrow = $Arrow_Hover
@export var health_max: int
@onready var health_current = health_max
var damage_taken = 1

@export var damage_amount: damage_amounts
@export var slowdown_amount: slowdown_amounts

enum damage_amounts {LOWEST, FULL, NONE}
enum slowdown_amounts {NONE, PARTIAL, FULL}

# Called when the node enters the scene tree for the first time.
func _ready():
	if !has_node("Arrow_Hover"):
		print("ERROR: Somewhere, a hover arrow child is missing!")
		breakpoint
		
	# Check if it is a sub-obstacle
	if $"../..".has_signal("update_hitpoints"):
		$"../..".update_hitpoints.connect(on_update_top_level_hitpoints)
		if !has_node("CollisionShape3D"):
			print("ERROR: Sub-Obstacle is missing a properly named 'CollisionShape3D'")
			breakpoint
			
		# If I'm a sub-obstacle, make sure I don't collide yet
		for collision in get_children():
			if collision is CollisionShape3D:
				collision.disabled = true
		
	if $"../..".has_signal("is_destroyed"):
		$"../..".is_destroyed.connect(on_top_level_is_destroyed)
		
	update_hitpoints.emit()
	update_hitpoints.connect(on_update_hitpoints)

	area_entered.connect(check_area)
	area_exited.connect(uncheck_area)
	
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	set_collision_layer_value(1, false)
	set_collision_layer_value(3, true)
	
	set_collision_mask_value(1, false)
	set_collision_mask_value(16, true)
	
	hover_arrow.modulate = indicator_color
	
	
func on_update_top_level_hitpoints():
	if $"../..".health_current <= 0:
		for collision in get_children():
			if collision is CollisionShape3D:
				collision.disabled = false

func on_top_level_is_destroyed():
	health_current = 0
	update_hitpoints.emit()

func on_update_hitpoints():
	if health_current <= 0: # Is Dead
		for collision in get_children():
			if collision is CollisionShape3D:
				collision.disabled = true
	
	
func check_area(collided_bodypart):
#	collided_bodypart.mesh.hide()
#	collided_bodypart.mesh
	Messenger.area_damaged.emit(collided_bodypart)
	Messenger.amount_damaged.emit(damage_amount)
	Messenger.amount_slowed.emit(slowdown_amount)
	
func uncheck_area(bodypart_unarea):
	Messenger.area_undamaged.emit(bodypart_unarea)
	
func _on_mouse_entered():
	if !Input.is_action_pressed("Grab"):
		hover_arrow.visible = true
	
func _on_mouse_exited():
	hover_arrow.visible = false

func restore_collision():
	for collision in get_children():
		if collision is CollisionShape3D:
			collision.disabled = false
