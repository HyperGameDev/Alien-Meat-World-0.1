extends Area3D

class_name BodyPart

const LIMB_MORPH_SPEED = 1.25

@export var is_head: Area3D
@export var player: CharacterBody3D
@export var collision: CollisionShape3D
@export var collision_area: CollisionShape3D

@onready var mesh = player.get_node("Alien/Armature/Skeleton3D/Alien_" + name.split("_")[1])

@onready var bodypart_name = name.split("_")[1]	

@onready var skeleton = get_tree().get_root().get_node("Main Scene/Player/Alien/Armature/Skeleton3D")

var limb_dmg_flash_end = false

@onready var material_damaged_timer : Timer = Timer.new()
@onready var material_reset_timer : Timer = Timer.new()
@onready var limb_dmg_flash_length = $"Timer_limb-dmg-flash_length"

const LIMB_DMG_FLASH_ON_LENGTH = 0.4
const LIMB_DMG_FLASH_OFF_LENGTH = 0.2

@export var is_part: is_parts

var amount_to_damage = null

var max_health = 4
var current_health = 4
var stand_speed = .5

var limb_damage_amount = 1

var bone_hit

var dict_scale_limbs:Dictionary = {
	0: Vector3(0.0, 0.0, 0.0),
	1: Vector3(.25,.25,.25), 
	2: Vector3(.5,.5,.5),
	3: Vector3(.7,.8,.9),
	4: Vector3(1.0,1.0,1.0),
	5: Vector3(1.0,1.0,1.0)
}

var dict_position_limbs_r:Dictionary = {
	0: Vector3(0,0,0),
	1: Vector3(.0006,0,0), 
	2: Vector3(.0006,0,0),
	3: Vector3(.0006,0,0),
	4: Vector3(0,0,0),
	5: Vector3(0,0,0)
}

var dict_position_limbs_l:Dictionary = {
	0: Vector3(0,0,0),
	1: Vector3(-.0006,0,0), 
	2: Vector3(-.0006,0,0),
	3: Vector3(-.0006,0,0),
	4: Vector3(0,0,0),
	5: Vector3(0,0,0)
}

#var is_damaged = false

enum is_parts {HEAD, LEG_R, LEG_L, ARM_R, ARM_L}

# Materials
var default_material = StandardMaterial3D.new()
var damage_material = StandardMaterial3D.new()


func _ready():
#	print("Areas' Layer: ", collision_layer, "; Areas' Mask: ", collision_mask)
# Messenger setup
	area_entered.connect(on_area_entered)
	Messenger.area_damaged.connect(on_area_damaged)
	Messenger.amount_damaged.connect(_damage_amount)
	Messenger.instant_death.connect(fall_death)
	Messenger.health_detected.connect(health_collected)
	
# Material setup
	default_material.set_albedo(Color(0.3, 0.74, .35))
	damage_material.set_albedo(Color(0.5, 0.0, 0.0))
	
# Damage Flash timer setup
	limb_dmg_flash_length.timeout.connect(on_limb_dmg_flash_end)

	material_damaged_timer.timeout.connect(on_material_damaged_timer_end)
	add_child(material_damaged_timer)
	material_damaged_timer.start(LIMB_DMG_FLASH_ON_LENGTH)
	
	material_reset_timer.one_shot = true
	add_child(material_reset_timer)
	
func on_area_entered(area):
	var is_delayed = false
	Messenger.something_hit.emit(area,is_delayed)

func _damage_amount(damage_amount):
	amount_to_damage = damage_amount
	if amount_to_damage == Obstacle.damage_amounts.FULL:
		limb_damage_amount = 100
	if amount_to_damage == Obstacle.damage_amounts.LOWEST:
		limb_damage_amount = 1
	if amount_to_damage == Obstacle.damage_amounts.NONE:
		limb_damage_amount = 0
		#print("'Damage_Amount' damage: ", limb_damage_amount)

func set_bone_scale(scale):
	skeleton.set_bone_pose_scale(bone_hit, scale)
	
func set_bone_offset(offset):
	var bone_pos = skeleton.get_bone_pose_position(bone_hit)
	skeleton.set_bone_pose_position(bone_hit, bone_pos + offset)

func shape_change_limbs_any():
	get_tree().create_tween().tween_method(set_bone_scale, dict_scale_limbs[current_health+1], dict_scale_limbs[current_health], LIMB_MORPH_SPEED)
	
func shape_change_limbs_r():
	get_tree().create_tween().tween_method(set_bone_offset, dict_position_limbs_r[current_health+1], dict_position_limbs_r[current_health], LIMB_MORPH_SPEED)
	
func shape_change_limbs_l():
	get_tree().create_tween().tween_method(set_bone_offset, dict_position_limbs_l[current_health+1], dict_position_limbs_l[current_health], LIMB_MORPH_SPEED)
	
func shape_change_head():
	var shrink_to = current_health * .25
	var shrink_from = (current_health + limb_damage_amount) * .25
	get_tree().create_tween().tween_method(set_bone_scale, Vector3(shrink_from, shrink_from, shrink_from), Vector3(shrink_to, shrink_to, shrink_to), LIMB_MORPH_SPEED)
	
	
#func tween_method_set_bone_scale(tween_value, skeleton, bone_hit):
#	skeleton.set_bone_pose_scale(bone_hit, tween_value)
#
#func damage_hp():
#	get_tree().create_tween().tween_method(tween_method_set_bone_scale.bind(skeleton, bone_hit), Vector3(1, 1, 1), Vector3(2, 2, 2), 2)

	
func on_area_damaged(collided_bodypart):
	
	# Check what limb I am
	if collided_bodypart == self:
#		print(collided_bodypart.name.split("_")[1])
#		print(limb_damage_amount)
#		print(self) 
#		print("Damage Dealt")
#		print(name)
#		
		bone_hit = skeleton.find_bone(bodypart_name)
	
		# Define Mesh Flash Length
		var limb_dmg_total_flash_length = 0
		limb_dmg_total_flash_length += 4
		limb_dmg_flash_length.start(limb_dmg_total_flash_length)
		limb_dmg_flash_end = false
		
		# This code needs work, only applies to one limb if multiple are hit
		if current_health > 0 and amount_to_damage == Obstacle.damage_amounts.FULL:
			current_health -= max_health
		
		if current_health > 0 and amount_to_damage != Obstacle.damage_amounts.NONE:
#			is_damaged = true
			# Ensure limb is visible
			mesh.show()
			# Apply damage
			current_health -= limb_damage_amount
			#print("'Damage_Detected' damage: ", limb_damage_amount)
			# Update the Damage Label
			player.get_node("Alien/Armature/Skeleton3D/Alien_" + name.split("_")[1] + "/Dmg_Label").text = str(current_health)
		
			# Inform Messenger of damage, e.g. so UI_FX can flash the screen
			Messenger.limb_is_damaged.emit()
			shape_change_limbs_any()
			if is_part == BodyPart.is_parts.ARM_L or is_part == BodyPart.is_parts.LEG_L:
				shape_change_limbs_l()
			if is_part == BodyPart.is_parts.ARM_R or is_part == BodyPart.is_parts.LEG_R:
				shape_change_limbs_r()
			
	# Damaged with <=0 Health			
		if current_health <= 0 and is_part != BodyPart.is_parts.HEAD:
			await get_tree().create_timer(LIMB_MORPH_SPEED).timeout
			mesh.hide()
			# Syncronise collision turning off with physics process
			await get_tree().process_frame
			collision.disabled = true
			# Alternative sync method (deprecated): collision.set_deferred("disable", true)
			
			
			
			
	# Damaged the Head?
	if collided_bodypart == is_head and is_part == BodyPart.is_parts.HEAD and amount_to_damage != Obstacle.damage_amounts.NONE:
		if current_health > 0:
			shape_change_head()
		
		if current_health >= 0:
#			is_damaged = true

			# Inform UI_FX to flash the screen, and HP Bar to subtract health
			Messenger.head_is_damaged.emit()
			Messenger.head_health.emit(current_health, max_health)
			
		# Restart game on Death
		if current_health <= 0:
			await get_tree().create_timer(LIMB_MORPH_SPEED + .3).timeout
			get_tree().reload_current_scene()
			
			

func on_material_damaged_timer_end():
	if current_health < max_health and limb_dmg_flash_end == false and amount_to_damage != Obstacle.damage_amounts.NONE:
			mesh.material_override = damage_material
			material_reset_timer.start(LIMB_DMG_FLASH_OFF_LENGTH)
			await material_reset_timer.timeout
			mesh.material_override = default_material
		
func on_limb_dmg_flash_end():
	limb_dmg_flash_end = true
	


func fall_death(fall_death):
	if fall_death == true and is_part == BodyPart.is_parts.HEAD:
		current_health = 0
#		is_damaged = true
		Messenger.head_is_damaged.emit()
		get_tree().reload_current_scene()
		
			
func health_collected(collided_bodypart, empathy_ok):
	if collided_bodypart == self and empathy_ok == false:
		Messenger.empathy_consumed.emit()
#		print("collided with bad health")
	if collided_bodypart == self and current_health < max_health:
		current_health += 1
		shape_change_limbs_any()
		player.get_node("Alien/Armature/Skeleton3D/Alien_" + name.split("_")[1] + "/Dmg_Label").text = str(current_health)
#		print("current_health collected")
		mesh.show()
		var tween = get_tree().create_tween();
		tween.tween_property(player, "position", Vector3(player.position.x, -.03, player.position.z), stand_speed)
		collision.set_deferred("disabled", false)
		
		# Healed the Head?
	if collided_bodypart == is_head and is_part == BodyPart.is_parts.HEAD:
		Messenger.head_health.emit(current_health, max_health)
		Messenger.head_is_healed.emit()
