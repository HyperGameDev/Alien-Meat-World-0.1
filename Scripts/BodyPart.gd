extends Area3D

class_name BodyPart

@export var player: CharacterBody3D
@export var mesh: MeshInstance3D
@export var damage_label: Label3D
@export var collision: CollisionShape3D
@export var collision_area: CollisionShape3D

var max_health = 4
var current_health = 4
var stand_speed = .5

var hurt_limb = 1

var is_damaged = false

func _ready():
	Messenger.area_damaged.connect(damage_detected)
	Messenger.amount_damaged.connect(damage_amount)
	Messenger.health_detected.connect(health_collected)

func damage_amount(damage_amount):
	if damage_amount == Obstacle.damage_amounts.FULL:
		hurt_limb = 100
	if damage_amount == Obstacle.damage_amounts.LOWEST:
		hurt_limb = 1
	
func damage_detected(bodypart_area):
	if bodypart_area == self:
		print(hurt_limb)
#		print(self)
#		print("Damage Dealt")
		if current_health > 0:
			current_health -= hurt_limb
			damage_label.text = str(current_health)
			mesh.show()
			is_damaged = true
			Messenger.limb_is_damaged.emit(is_damaged)
		if current_health <= 1:
			mesh.hide()
			await get_tree().process_frame
#			collision.set_deferred("disable", true)
			collision.disabled = true
	if bodypart_area == %Area_Body and collision_area == %CollisionA_AlienBody:
		if current_health > 0:
			is_damaged = true
			Messenger.body_is_damaged.emit(is_damaged)
		if current_health <= 0:
			get_tree().reload_current_scene()
			
func health_collected(bodypart_area):
	if bodypart_area == self and current_health < max_health:
		current_health += 1
		damage_label.text = str(current_health)
#		print("current_health collected")
		mesh.show()
		var tween = get_tree().create_tween();
		tween.tween_property(player, "position", Vector3(player.position.x, -.03, player.position.z), stand_speed)
		collision.set_deferred("disabled", false)
		
