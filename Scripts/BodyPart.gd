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

func _ready():
	Messenger.body_damaged.connect(damage_detected)
	Messenger.health_detected.connect(health_collected)
	
func damage_detected(bodypart_area):
	if bodypart_area == self:
#		print(self)
#		print("Damage Dealt")
		if current_health > 0:
			current_health -= 1
			damage_label.text = str(current_health)
			mesh.show()
		if current_health == 0:
			mesh.hide()
#			await get_tree().process_frame
			collision.set_deferred("disabled", true)
#			collision.disabled = true
			
func health_collected(bodypart_area):
	if bodypart_area == self and current_health < max_health:
		current_health += 1
		damage_label.text = str(current_health)
#		print("current_health collected")
		mesh.show()
		var tween = get_tree().create_tween();
		tween.tween_property(player, "position", Vector3(player.position.x, 0, player.position.z), stand_speed)
		collision.set_deferred("disabled", false)
		
