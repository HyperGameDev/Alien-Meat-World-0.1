extends Area3D

class_name PowerUp_Orb

@onready var hud: CanvasLayer = %HUD
@onready var animation: AnimationPlayer = $Animation_PowerUp_Orb
@onready var icon: MeshInstance3D = $MeshInstance3D/Icon

@export var is_type: is_types
enum is_types {Orb_1, Orb_2, Orb_3}

var is_orb: int = 0
var powerup_key: Variant

# Called when the node enters the scene tree for the first time.
func _ready():
	
	Messenger.anything_seen.connect(on_anything_seen)
	Messenger.powerup_hovered.connect(on_powerup_hovered)
	
	match is_type:
		is_types.Orb_1:
			is_orb = 1
		is_types.Orb_2:
			is_orb = 2
		is_types.Orb_3:
			is_orb = 3


func on_powerups_assigned():
	var texture = load(Globals.powerups[powerup_key].powerupIcon)
	icon.get("surface_material_override/0").set_texture(StandardMaterial3D.TEXTURE_ALBEDO, texture)

func on_powerup_hovered(orb_hovered):
	if orb_hovered == is_orb:
		animation.play("hover")
		
		
func on_anything_seen(target):
	if !target.is_empty():
		if target["collider"].has_method("on_powerup_hovered"):
			if !target["collider"].is_orb == is_orb:
				animation.stop()
		else:
			animation.stop()
			hud.on_powerup_unhovered()
