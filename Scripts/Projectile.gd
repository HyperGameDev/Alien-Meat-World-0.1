extends Area3D

class_name Projectile

@export var damage_amount: damage_amounts
enum damage_amounts {LOWEST, FULL, NONE}

@export var player_owned: bool = false

@onready var player_head = get_tree().get_current_scene().get_node("Player/Alien_V3/DetectionAreas/Area_Head/CollisionA_AlienHead")

var target_posd : Vector3 = Vector3.ZERO
var velocity : Vector3 = Vector3.ZERO
var speed : float = 50.0
var direction : Vector3 = Vector3(0,0,0)
var shoot_at_player : bool = true

func _ready() -> void:
	area_entered.connect(on_area_entered)
	
	set_collision_layer_value(1, false)
	set_collision_layer_value(8, true)

	
	set_collision_mask_value(1, false)
	
	if !player_owned:
		set_collision_mask_value(16, true)
		set_collision_mask_value(2, false)
	else:
		set_collision_mask_value(2, true)
		set_collision_mask_value(16, false)
		



func on_area_entered(area):
	#print("Bullet passed through ",area,"!")
	# Getting an error? Did you add a new area to the player without a defined is_part?
	if !player_owned:
		if area.is_part == BodyPart.is_parts.HEAD or area.is_part == BodyPart.is_parts.ARM_R or  area.is_part == BodyPart.is_parts.ARM_L or  area.is_part == BodyPart.is_parts.LEG_R or  area.is_part == BodyPart.is_parts.LEG_L:
			Messenger.amount_damaged.emit(damage_amount)
			Messenger.area_damaged.emit(area)
			queue_free()
			
		if area.is_part == BodyPart.is_parts.BODY:
			Messenger.amount_damaged.emit(Projectile.damage_amounts.NONE)
			Messenger.area_damaged.emit(area)
			queue_free()
			
	
	else:
		Messenger.something_hit.emit(area,false)
	
func _physics_process(delta: float) -> void:
	#var beyond_factor : int = 20
	#var direction : Vector3 = (target_pos - global_position).normalized()
	#var direction_beyond : Vector3 = direction * 70
	#velocity = direction_beyond * speed
	#global_position += velocity * delta 
	
	#global_transform.origin = global_transform.origin +(transform.basis.z * 70) * delta
	
	global_position += speed * direction
		
	if shoot_at_player:
		if global_position.z >= 100:
			queue_free()
	else:
		if global_position.z <= -200:
			queue_free()
