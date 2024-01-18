extends Area3D

class_name BodyPart

@export var is_head: Area3D
@export var player: CharacterBody3D
@export var collision: CollisionShape3D
@export var collision_area: CollisionShape3D

@onready var mesh = player.get_node("Alien/Armature/Skeleton3D/Alien_" + name.split("_")[1])

@onready var bodypart_name = name.split("_")[1]

@onready var skeleton = get_tree().get_root().get_node("Main Scene/Player/Alien/Armature/Skeleton3D")

var dmg_timer_end = false

@onready var dmg_flash_timer : Timer = Timer.new()
@onready var material_reset : Timer = Timer.new()

@export var is_part: is_parts

var amount_to_damage = null

var health_grabbed = false

var max_health = 4
var current_health = 4
var stand_speed = .5

var limb_damage_amount = 1

var bone_hit



#var is_damaged = false

enum is_parts {HEAD, LEG_R, LEG_L, ARM_R, ARM_L}

# Materials
var default_material = StandardMaterial3D.new()
var damage_material = StandardMaterial3D.new()


func _ready():

# Messenger setup
	Messenger.area_damaged.connect(damage_detected)
	Messenger.amount_damaged.connect(_damage_amount)
	Messenger.instant_death.connect(fall_death)
	Messenger.health_detected.connect(health_collected)
	
# Material setup
	default_material.set_albedo(Color(0.3, 0.74, .35))
	damage_material.set_albedo(Color(0.5, 0.0, 0.0))
	
# Damage Flash timer setup
	$Timer_Limb_Dmg_Flash.timeout.connect(flash_damage_end)

	dmg_flash_timer.timeout.connect(flash_damage)
	add_child(dmg_flash_timer)
	dmg_flash_timer.start(0.4)
	
	material_reset.one_shot = true
	add_child(material_reset)
	
	

func _damage_amount(damage_amount):
	amount_to_damage = damage_amount
	if damage_amount == Obstacle.damage_amounts.FULL:
		limb_damage_amount = 100
	if damage_amount == Obstacle.damage_amounts.LOWEST:
		limb_damage_amount = 1
	if damage_amount == Obstacle.damage_amounts.NONE:
		limb_damage_amount = 0

func set_bone_scale(scale):
	skeleton.set_bone_pose_scale(bone_hit, scale)

func damage_hp():
	var shrink_to = current_health * .25
	var shrink_from = (current_health + limb_damage_amount) * .25
	get_tree().create_tween().tween_method(set_bone_scale, Vector3(shrink_from, shrink_from, shrink_from), Vector3(shrink_to, shrink_to, shrink_to), 2)
	
	
	
#func tween_method_set_bone_scale(tween_value, skeleton, bone_hit):
#	skeleton.set_bone_pose_scale(bone_hit, tween_value)
#
#func damage_hp():
#	get_tree().create_tween().tween_method(tween_method_set_bone_scale.bind(skeleton, bone_hit), Vector3(1, 1, 1), Vector3(2, 2, 2), 2)

	
func damage_detected(collided_bodypart):
	
	# Check what limb I am
	if collided_bodypart == self:
#		print(collided_bodypart.name.split("_")[1])
#		print(limb_damage_amount)
#		print(self) 
#		print("Damage Dealt")
#		print(name)
#		
		bone_hit = skeleton.find_bone(bodypart_name)
		damage_hp()
		# Start Mesh Flash
		var flash_length = 0
		flash_length += 4
		$Timer_Limb_Dmg_Flash.start(flash_length)
		dmg_timer_end = false
		
		# This code needs work, only applies to one limb if multiple are hit
		if current_health > 0 and amount_to_damage == Obstacle.damage_amounts.FULL:
			current_health -= max_health
		
		if current_health > 0 and amount_to_damage != Obstacle.damage_amounts.NONE:
#			is_damaged = true
			# Ensure limb is visible
			mesh.show()
			# Apply damage
			current_health -= limb_damage_amount
			# Update the Damage Label
			player.get_node("Alien/Armature/Skeleton3D/Alien_" + name.split("_")[1] + "/Dmg_Label").text = str(current_health)
		
			# Inform Messenger of damage, e.g. so UI_FX can flash the screen
			Messenger.limb_is_damaged.emit()
			
			
	# Damaged with <=0 Health			
		if current_health <= 0 and is_part != BodyPart.is_parts.HEAD:
			mesh.hide()
			# Syncronise collision turning off with physics process
			await get_tree().process_frame
			collision.disabled = true
			# Alternative sync method (deprecated): collision.set_deferred("disable", true)
			
			
			
			
	# Damaged the Head?
	if collided_bodypart == is_head and is_part == BodyPart.is_parts.HEAD and amount_to_damage != Obstacle.damage_amounts.NONE:
		
		if current_health >= 0:
#			is_damaged = true

			# Inform UI_FX to flash the screen, and HP Bar to subtract health
			Messenger.head_is_damaged.emit()
			Messenger.head_health.emit(current_health, max_health)
			
		# Restart game on Death
		if current_health <= 0:
			await get_tree().create_timer(1.55).timeout
			get_tree().reload_current_scene()
			
			

func flash_damage():
	if current_health < max_health and dmg_timer_end == false:
		mesh.material_override = damage_material
		material_reset.start(.2)
		await material_reset.timeout
		mesh.material_override = default_material
		
func flash_damage_end():
	dmg_timer_end = true
#	print("dmg_timer_end")
	


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
