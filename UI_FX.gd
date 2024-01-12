extends Control

@export var limb_damage_flash : TextureRect
@export var head_damage_flash : TextureRect
@export var empathy_damage_flash : TextureRect

@export var timer_fx_flash : Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	Messenger.head_is_damaged.connect(head_damage)
	Messenger.limb_is_damaged.connect(limb_damage)


func head_damage():
	head_damage_flash.visible = true
	timer_fx_flash.start()

func limb_damage():
	limb_damage_flash.visible = true
	timer_fx_flash.start()
	pass

func _on_timer_fx_flash_timeout():
	limb_damage_flash.visible = false
	head_damage_flash.visible = false
	
