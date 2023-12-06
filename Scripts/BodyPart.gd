extends Area3D

class_name BodyPart

@export var player: CharacterBody3D
@export var mesh: MeshInstance3D
@export var damage_label: Label3D
@export var collision: CollisionShape3D
@export var collision_area: CollisionShape3D

@export var id: ids

var health: int = 4

enum ids {BODY, LEG_R, LEG_L, ARM_R, ARM_L}

func _ready():		Messenger.body_damaged.connect(damage_detected)
	
func damage_detected(bodypart_area):
	if bodypart_area == self:
		print(self)
		if health > 0:
			health -= 1
			damage_label.text = str(health)
		if health == 0:
			mesh.hide()
			collision.disabled = true
			collision_area.disabled = true
