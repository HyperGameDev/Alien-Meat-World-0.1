extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Messenger.head_is_damaged.connect(body_damage)
	Messenger.limb_is_damaged.connect(limb_damage)


func body_damage():
	%Dmg_Body_BG.visible = true
	%Timer_FX_Flash.start()

func limb_damage():
	%Dmg_Limb_BG.visible = true
	%Timer_FX_Flash.start()
	pass

func _on_timer_fx_flash_timeout():
	%Dmg_Limb_BG.visible = false
	%Dmg_Body_BG.visible = false
