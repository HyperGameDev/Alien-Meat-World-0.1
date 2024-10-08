extends Area3D

class_name BodyPart

const LIMB_MORPH_SPEED : float = 1.25

@export var is_head: Area3D
@export var player: CharacterBody3D
@export var collision: CollisionShape3D
@export var collision_hurt: CollisionShape3D
@export var collision_area_lower: CollisionShape3D
@export var collision_area_upper: CollisionShape3D
@export var collision_area_lower_hurt: CollisionShape3D
@export var collision_area_upper_hurt: CollisionShape3D
@export var collision_area_head: CollisionShape3D
@export var collision_area_head_hurt: CollisionShape3D

@onready var bodypart_name : String = name.split("_")[1]

@onready var mesh_hurt : MeshInstance3D = player.get_node("Alien_V3/Alien/Armature_hurt/Skeleton3D/Alien-hurt_" + name.split("_")[1])
@onready var mesh : MeshInstance3D = player.get_node("Alien_V3/Alien/Armature/Skeleton3D/Alien_" + name.split("_")[1])

@onready var leg_l : Area3D = $"../../../Alien_V3/DetectionAreas/Area_LegL"
@onready var leg_r : Area3D = $"../../../Alien_V3/DetectionAreas/Area_LegR"

@onready var dmg_label : Label3D = player.get_node("Alien_V3/Alien/Armature/Skeleton3D/Alien_" + name.split("_")[1] + "/Dmg_Label")
@onready var dmg_label_hurt : Label3D = player.get_node("Alien_V3/Alien/Armature_hurt/Skeleton3D/Alien-hurt_" + name.split("_")[1] + "/Dmg_Label")


@onready var score_dunk : Area3D = %ScoreDunk
@onready var animation_blood_human : AnimationPlayer = %"Particles_Blood-Human"/AnimationPlayer


#region HP Labels
@onready var hpCount_ArmL: Label3D = %hpLabels/hpCount_ArmL
@onready var animation_hpCount_ArmL = %hpLabels/hpCount_ArmL/AnimationPlayer
@onready var hpCount_ArmR: Label3D = %hpLabels/hpCount_ArmR
@onready var animation_hpCount_ArmR = %hpLabels/hpCount_ArmR/AnimationPlayer
@onready var hpCount_LegL: Label3D = %hpLabels/hpCount_LegL
@onready var animation_hpCount_LegL = %hpLabels/hpCount_LegL/AnimationPlayer
@onready var hpCount_LegR: Label3D = %hpLabels/hpCount_LegR
@onready var animation_hpCount_LegR = %hpLabels/hpCount_LegR/AnimationPlayer
@onready var hpCount_Head: Label3D = %hpLabels/hpCount_Head
@onready var animation_hpCount_Head = %hpLabels/hpCount_Head/AnimationPlayer
#endregion

var limb_dmg_flash_end : bool = false

@onready var material_damaged_timer : Timer = Timer.new()
@onready var material_reset_timer : Timer = Timer.new()
@onready var limb_dmg_flash_length : Timer = $"Timer_limb-dmg-flash_length"

const LIMB_DMG_FLASH_ON_LENGTH : float = 0.4
const LIMB_DMG_FLASH_OFF_LENGTH : float = 0.2

@export var is_part : is_parts
enum is_parts {HEAD, LEG_R, LEG_L, ARM_R, ARM_L, BODY}

var last_collided_area_old
var last_collided_area_current
var last_collided_area_count : int = 0

var amount_to_damage: float = 0.0

var max_health : float = 2.0
var current_health : float = 2.0

var stand_speed : float = 0.5

var limb_damage_amount : float = 1.0

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


# Materials
var default_material = StandardMaterial3D.new()
var damage_material = StandardMaterial3D.new()

func _ready():
#	print("Areas' Layer: ", collision_layer, "; Areas' Mask: ", collision_mask)

	
	set_collision_layer_value(16,true)
	set_collision_mask_value(3,true)
	set_collision_mask_value(8,true)
  
	area_entered.connect(on_area_entered)
	Messenger.area_damaged.connect(on_area_damaged)
	Messenger.amount_damaged.connect(_damage_amount)
	Messenger.instant_death.connect(fall_death)
	Messenger.player_head_hover.connect(on_player_head_hover)
	
	Messenger.game_prebegin.connect(on_game_prebegin)
	
# Material setup
	default_material.set_albedo(Color(0.3, 0.74, .35))
	damage_material.set_albedo(Color(0.5, .0, .0))
	
# Damage Flash timer setup
	#if !is_part == BodyPart.is_parts.BODY:
		#limb_dmg_flash_length.timeout.connect(on_limb_dmg_flash_end)
#
		#material_damaged_timer.timeout.connect(on_material_damaged_timer_end)
		#add_child(material_damaged_timer)
		#material_damaged_timer.start(LIMB_DMG_FLASH_ON_LENGTH)
		#
		#material_reset_timer.one_shot = true
		#add_child(material_reset_timer)
	
func on_area_entered(area):
	var is_delayed = false
	Messenger.something_hit.emit(area,is_delayed)
	last_collided_area_current = area

func _damage_amount(damage_amount):
	amount_to_damage = damage_amount
	match amount_to_damage:
		Obstacle.damage_amounts.FULL or Projectile.damage_amounts.FULL:
			limb_damage_amount = 100.0
		Obstacle.damage_amounts.LOWEST or Projectile.damage_amounts.LOWEST:
			limb_damage_amount = 1.0
		Obstacle.damage_amounts.NONE or  Projectile.damage_amounts.NONE:
			limb_damage_amount = 0.0
		#print("'Damage_Amount' damage: ", limb_damage_amount)

func reset_last_collided_area_count():
	#print("Collision check timer begun!")
	await get_tree().create_timer(5).timeout
	last_collided_area_count = 0
	#print("Collision check timer ended!")
	
func on_area_damaged(collided_bodypart):
	# Check what limb I am
	if collided_bodypart == self:
#		print(collided_bodypart.name.split("_")[1])
#		print(limb_damage_amount)
#		print(self) 
#		print("Damage Dealt")
#		print(name)
#	
	
		# Define Mesh Flash Length
		if !is_part == BodyPart.is_parts.BODY:
			var limb_dmg_total_flash_length = 0
			limb_dmg_total_flash_length += 4
			limb_dmg_flash_length.start(limb_dmg_total_flash_length)
			limb_dmg_flash_end = false
		
		# This code needs work, only applies to one limb if multiple are hit
		if floorf(current_health) > 0.0 and amount_to_damage == Obstacle.damage_amounts.FULL:
			current_health -= max_health
		
		if current_health > 0.0 and !amount_to_damage == Obstacle.damage_amounts.NONE:
#			is_damaged = true
			# Ensure limb is visible
			mesh.show()
			
			if last_collided_area_count == 0:
				last_collided_area_old = last_collided_area_current
			if last_collided_area_current == last_collided_area_old:
				last_collided_area_count += 1
			else:
				last_collided_area_count = 0
			
			# Apply damage
			if last_collided_area_count < 2:
				current_health -= snappedf(limb_damage_amount,0.5)
			else:
				reset_last_collided_area_count()
				
			var damage_amount: String = "-1"
				
			# Update the DEBUG Damage Label
			dmg_label.text = str(current_health)
			dmg_label_hurt.text = str(current_health)
			
		
			# Inform Messenger of damage, e.g. so UI_FX can flash the screen
			Messenger.limb_is_damaged.emit()
			
			
			if is_part == BodyPart.is_parts.ARM_R or is_part == BodyPart.is_parts.ARM_L:
				Messenger.arm_health_update.emit()
			
			match floorf(current_health): 
				0.0:
					if is_part == BodyPart.is_parts.HEAD or is_part == BodyPart.is_parts.BODY:
						if is_part == BodyPart.is_parts.HEAD:
							dmg_label.text = str(current_health)
							mesh.visible = false
							mesh_hurt.visible = false
							
							collision_area_head.set_deferred("disabled", true)
							collision_area_head_hurt.set_deferred("disabled", true)
						
					else:
						dmg_label.text = str(current_health)
						
						mesh.visible = false
						mesh_hurt.visible = false
						
						collision_area_lower_hurt.set_deferred("disabled", true)
						collision_area_upper_hurt.set_deferred("disabled", true)
						#print("Limb: ",self.name," adjusted its collisions!")
						
						if is_part == BodyPart.is_parts.LEG_R or is_part == BodyPart.is_parts.LEG_L:
							collision_hurt.set_deferred("disabled", true)
						
				1.0:
					if is_part == BodyPart.is_parts.HEAD or is_part == BodyPart.is_parts.BODY:
						if is_part == BodyPart.is_parts.HEAD:
							dmg_label.text = str(current_health)
							mesh.visible = false
							mesh_hurt.visible = true
							
							collision_area_head.set_deferred("disabled", true)
							collision_area_head_hurt.set_deferred("disabled", false)
						
					else:
						dmg_label.text = str(current_health)
						
						mesh.visible = false
						mesh_hurt.visible = true
						
						collision_area_lower.set_deferred("disabled", true)
						collision_area_upper.set_deferred("disabled", true)
						collision_area_lower_hurt.set_deferred("disabled", false)
						collision_area_upper_hurt.set_deferred("disabled", false)
						#print("Limb: ",self.name," adjusted its collisions!")
						
						if is_part == BodyPart.is_parts.LEG_R or is_part == BodyPart.is_parts.LEG_L:
							collision.set_deferred("disabled", true)
							collision_hurt.set_deferred("disabled", false)
							
				_:
					pass
			
				
			match is_part:
				BodyPart.is_parts.ARM_L:
					hpCount_ArmL.text = damage_amount
					animation_hpCount_ArmL.play("hp_down")
				BodyPart.is_parts.ARM_R:
					hpCount_ArmR.text = damage_amount
					animation_hpCount_ArmR.play("hp_down")
				BodyPart.is_parts.LEG_L:
					hpCount_LegL.text = damage_amount
					animation_hpCount_LegL.play("hp_down")
				BodyPart.is_parts.LEG_R:
					hpCount_LegR.text = damage_amount
					animation_hpCount_LegR.play("hp_down")
				BodyPart.is_parts.HEAD:
					hpCount_Head.text = damage_amount
					animation_hpCount_Head.play("hp_down")
			
			
	# Damaged the Head?
	if collided_bodypart == is_head and is_part == BodyPart.is_parts.HEAD and amount_to_damage != Obstacle.damage_amounts.NONE:
		if floorf(current_health) > 0.0:
			pass
		
		if floorf(current_health) >= 0.0:
#			is_damaged = true

			# Inform UI_FX to flash the screen, and HP Bar to subtract health
			Messenger.head_is_damaged.emit()
			Messenger.head_health.emit(current_health, max_health)
			
		# Restart game on Death
		if floorf(current_health) <= 0.0:
			await get_tree().create_timer(LIMB_MORPH_SPEED + .3).timeout
			
			Messenger.swap_game_state.emit(Globals.is_game_states.OVER)
			

func on_material_damaged_timer_end():
	if floorf(current_health) < max_health and limb_dmg_flash_end == false and amount_to_damage != Obstacle.damage_amounts.NONE:
			mesh.material_override = damage_material
			mesh_hurt.material_override = damage_material
			material_reset_timer.start(LIMB_DMG_FLASH_OFF_LENGTH)
			await material_reset_timer.timeout
			mesh.material_override = default_material
			mesh_hurt.material_override = default_material
		
func on_limb_dmg_flash_end():
	limb_dmg_flash_end = true
	


func fall_death(fall_death):
	if fall_death == true and is_part == BodyPart.is_parts.HEAD:
		current_health = 0.0
#		is_damaged = true
		Messenger.head_is_damaged.emit()
		
		Messenger.swap_game_state.emit(Globals.is_game_states.OVER)


func on_player_head_hover(is_hovered):
	#if collided_bodypart == self and empathy_ok == false:
		#Messenger.empathy_consumed.emit()
#		print("collided with bad Abductee")


		#dmg_label.text = str(current_health)]
	if is_hovered:
		var grabbed_abductees : Array = get_tree().get_nodes_in_group("Grabbed")
		var grabbed_abductees_int: int = grabbed_abductees.size()
		if grabbed_abductees_int > 0:
			#print("Player hovered is ",is_hovered," with ",grabbed_abductees_int," abductee(s) hand!")
			
			do_eating()
			
			var standup_mid : bool = false
			var standup_high : bool = false
			
			var legs_either_0 : bool = false
			var legs_either_1 : bool = false
			var legs_either_2 : bool = false
			
			if floorf(leg_l.current_health) == 2.0 or floorf(leg_r.current_health) == 2.0:
				legs_either_2 = true
			
			if floorf(leg_l.current_health) == 1.0 or floorf(leg_r.current_health) == 1.0:
				legs_either_1 = true
			
			if floorf(leg_l.current_health) == 0.0 or floorf(leg_r.current_health) == 0.0:
				legs_either_0 = true
			
				
			if legs_either_0:
				if legs_either_1:
					standup_high = true
				
			if !legs_either_0:
				if legs_either_1:
					standup_high = true
			
			if legs_either_0:
				if !legs_either_1:
					standup_mid = true
			
	
			if floorf(current_health) < max_health:
				current_health += snappedf(1.0,0.5)
				var heal_amount: String = "+1"

				#if !powerup_hp:
					#heal_amount = "+1"
				#else:
					#heal_amount = "+2"
				
				if is_part == BodyPart.is_parts.ARM_R or is_part == BodyPart.is_parts.ARM_L:
					Messenger.arm_health_update.emit()
			
				match floorf(current_health): # Checks the hp it's healing INTO, not from:
					1.0:
						if is_part == BodyPart.is_parts.HEAD or is_part == BodyPart.is_parts.BODY:
							if is_part == BodyPart.is_parts.HEAD:
								dmg_label.text = str(current_health)
								mesh.visible = false
								mesh_hurt.visible = true
								
								collision_area_head.set_deferred("disabled", true)
								collision_area_head_hurt.set_deferred("disabled", false)
							
						else:
							#print("Healing on limbs attempted!")
							dmg_label.text = str(current_health)
							dmg_label_hurt.text = str(current_health)
							
							mesh_hurt.visible = true
							
							collision_area_lower_hurt.set_deferred("disabled", false)
							collision_area_upper_hurt.set_deferred("disabled", false)
							
							if is_part == BodyPart.is_parts.LEG_L or is_part == BodyPart.is_parts.LEG_R:
								collision_hurt.set_deferred("disabled", false)
								
								if standup_mid and !legs_either_2:
									var tween = get_tree().create_tween();
									tween.set_ease(Tween.EASE_IN)
									tween.tween_property(player, "position", Vector3(player.position.x, -.25, player.position.z), stand_speed)
									
					2.0:
						if is_part == BodyPart.is_parts.HEAD or is_part == BodyPart.is_parts.BODY:
							if is_part == BodyPart.is_parts.HEAD:
								dmg_label.text = str(current_health)
								mesh.visible = true
								mesh_hurt.visible = false
								
								collision_area_head.set_deferred("disabled", false)
								collision_area_head_hurt.set_deferred("disabled", true)
							
						else:
							dmg_label.text = str(current_health)
							
							mesh.visible = true
							mesh_hurt.visible = false
							
							collision_area_lower.set_deferred("disabled", false)
							collision_area_upper.set_deferred("disabled", false)
							collision_area_lower_hurt.set_deferred("disabled", true)
							collision_area_upper_hurt.set_deferred("disabled", true)
							
							if is_part == BodyPart.is_parts.LEG_L or is_part == BodyPart.is_parts.LEG_R:
								collision.set_deferred("disabled", false)
								collision_hurt.set_deferred("disabled", true)
								
								if standup_high and !legs_either_2:
									var tween = get_tree().create_tween();
									tween.set_ease(Tween.EASE_IN)
									tween.tween_property(player, "position", Vector3(player.position.x, -.03, player.position.z), stand_speed)
					_:
						pass
						
				match is_part:
					BodyPart.is_parts.ARM_L:
						hpCount_ArmL.text = heal_amount
						animation_hpCount_ArmL.play("hp_up")
					BodyPart.is_parts.ARM_R:
						hpCount_ArmR.text = heal_amount
						animation_hpCount_ArmR.play("hp_up")
					BodyPart.is_parts.LEG_L:
						hpCount_LegL.text = heal_amount
						animation_hpCount_LegL.play("hp_up")
					BodyPart.is_parts.LEG_R:
						hpCount_LegR.text = heal_amount
						animation_hpCount_LegR.play("hp_up")
					BodyPart.is_parts.HEAD:
						hpCount_Head.text = heal_amount
						animation_hpCount_Head.play("hp_up")
						
						
			else:
				pass
				
			for abductee in grabbed_abductees:
				abductee.queue_free()
				score_dunk.dunk_ascent_timer_duration = 0.2
				score_dunk.on_grab_ended()
				
		
func do_eating():
	animation_blood_human.play("feed")
	Messenger.eating_begun.emit()
	
	await animation_blood_human.animation_finished
	Messenger.eating_finished.emit()

func on_game_prebegin():
	if is_part == BodyPart.is_parts.LEG_L or is_part == BodyPart.is_parts.LEG_R:
		#print(collision_area_lower)
		current_health = 0.0
		collision.set_deferred("disabled", true)
		collision_area_lower.set_deferred("disabled", true)
		collision_area_upper.set_deferred("disabled", true)
		collision_area_lower_hurt.set_deferred("disabled", true)
		collision_area_upper_hurt.set_deferred("disabled", true)
		mesh.visible = false
		mesh_hurt.visible = false
	if is_part == BodyPart.is_parts.ARM_L or is_part == BodyPart.is_parts.ARM_R:
		current_health = 0.0
		collision_area_lower.set_deferred("disabled", true)
		collision_area_upper.set_deferred("disabled", true)
		collision_area_lower_hurt.set_deferred("disabled", true)
		collision_area_upper_hurt.set_deferred("disabled", true)
		mesh.visible = false
		mesh_hurt.visible = false
	if is_part == BodyPart.is_parts.HEAD:
		mesh_hurt.visible = false
		collision_area_head.set_deferred("disabled", false)
		collision_area_head_hurt.set_deferred("disabled", true)
		
