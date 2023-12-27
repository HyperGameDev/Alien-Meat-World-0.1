extends Area3D

class_name BodyPart

@export var player: CharacterBody3D
@export var collision: CollisionShape3D
@export var collision_area: CollisionShape3D

@onready var mesh = player.get_node("Alien/Armature/Skeleton3D/Alien_" + name.split("_")[1])

@onready var dmg_flash_begin : Timer = Timer.new()
@onready var dmg_flash_end : Timer = Timer.new()

@export var is_part: is_parts

var amount_to_damage = null

var max_health = 4
var current_health = 4
var stand_speed = .5

var hurt_limb = 1

var is_damaged = false

enum is_parts {BODY, LEG_R, LEG_L, ARM_R, ARM_L}

# Materials
var default_material = StandardMaterial3D.new()
var damage_material = StandardMaterial3D.new()


func _ready():

# Messenger setup
	Messenger.area_damaged.connect(damage_detected)
	Messenger.amount_damaged.connect(damage_amount)
	Messenger.instant_death.connect(fall_death)
	Messenger.health_detected.connect(health_collected)
	
# Material setup

	default_material.set_albedo(Color(0.3, 0.74, .35))
	damage_material.set_albedo(Color(0.5, 0.0, 0.0))
	
# Timer timeout setup
	dmg_flash_begin.timeout.connect(_dmg_flash_end)
	add_child(dmg_flash_begin)
	
	dmg_flash_end.timeout.connect(_dmg_flash_begin)
	add_child(dmg_flash_end)
	

func damage_amount(damage_amount):
	amount_to_damage = damage_amount
	if damage_amount == Obstacle.damage_amounts.FULL:
		hurt_limb = 100
	if damage_amount == Obstacle.damage_amounts.LOWEST:
		hurt_limb = 1
	if damage_amount == Obstacle.damage_amounts.NONE:
		hurt_limb = 0
	
	
func damage_detected(bodypart_area):
	
	# Check what limb I am
	if bodypart_area == self:
#		print(hurt_limb)
#		print(self) 
#		print("Damage Dealt")

		# Hit flash check
		mesh.material_override = damage_material
		dmg_flash_begin.start(1)

	# Damaged with >0 Health
		if current_health > 0 and amount_to_damage != Obstacle.damage_amounts.NONE:
			current_health -= hurt_limb
			player.get_node("Alien/Armature/Skeleton3D/Alien_" + name.split("_")[1] + "/Dmg_Label").text = str(current_health)
			mesh.show()
			is_damaged = true
		
	# Damaged with <=0 Health
			Messenger.limb_is_damaged.emit(is_damaged)
		if current_health <= 0:
			mesh.hide()
			await get_tree().process_frame
#			collision.set_deferred("disable", true)
			collision.disabled = true
			
	# Damaged the Body
	if bodypart_area == %Area_Body and is_part == BodyPart.is_parts.BODY and amount_to_damage != Obstacle.damage_amounts.NONE:
		if current_health > 0:
			is_damaged = true
	
			Messenger.body_is_damaged.emit(is_damaged)
		if current_health <= 0:
			get_tree().reload_current_scene()
	
	
func _dmg_flash_end():
	if current_health == max_health:
		mesh.material_override = default_material
		dmg_flash_end.stop()
	else:
		mesh.material_override = default_material
		dmg_flash_end.start(.2)
	
func _dmg_flash_begin():
	if current_health < max_health:
		mesh.material_override = damage_material
		dmg_flash_begin.start(.2)



func fall_death(fall_death):
	if fall_death == true and is_part == BodyPart.is_parts.BODY:
		current_health = 0
		is_damaged = true
		Messenger.body_is_damaged.emit(is_damaged)
		get_tree().reload_current_scene()
		
			
func health_collected(bodypart_area):
	if bodypart_area == self and current_health < max_health:
		current_health += 1
		player.get_node("Alien/Armature/Skeleton3D/Alien_" + name.split("_")[1] + "/Dmg_Label").text = str(current_health)
#		print("current_health collected")
		mesh.show()
		var tween = get_tree().create_tween();
		tween.tween_property(player, "position", Vector3(player.position.x, -.03, player.position.z), stand_speed)
		collision.set_deferred("disabled", false)
