@tool

extends Sprite3D

var true_current_body_health = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	texture = $SubViewport.get_texture()
	Messenger.body_health.connect(update_hp)
	
func update_hp(current_body_health, max_body_health):
	true_current_body_health = current_body_health
	var hp_bar = $SubViewport/Body_HP_Bar
	
	if true_current_body_health != max_body_health and !hp_bar.visible:
		hp_bar.visible = true
		await get_tree().create_timer(.75).timeout
		hp_bar.value = true_current_body_health
		
	if true_current_body_health < max_body_health and hp_bar.visible:
		hp_bar.value = true_current_body_health
	
	if true_current_body_health == max_body_health:
		hp_bar.value = true_current_body_health
		await get_tree().create_timer(1.35).timeout
		hp_bar.visible = false
