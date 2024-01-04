@tool

extends Sprite3D

var true_current_body_health = 0
@onready var hp_bar = $SubViewport/Body_HP_Bar

# Called when the node enters the scene tree for the first time.
func _ready():
	texture = $SubViewport.get_texture()
#	Messenger.body_health.connect(update_hp)
	Messenger.body_health.connect(hp_visibility)
	Messenger.body_is_damaged.connect(_hp_bar_hit)
	Messenger.body_is_healed.connect(_hp_bar_heal)

func hp_increase():
	hp_bar.value += 1

func hp_decrease():
	hp_bar.value -= 1
	
func _hp_bar_hit():
	var anim_player_copy = $AnimationPlayer.duplicate()
	add_child(anim_player_copy)
	anim_player_copy.play("hp_bar_hit")
	await anim_player_copy.animation_finished
	anim_player_copy.queue_free()

func _hp_bar_heal():
	var anim_player_copy = $AnimationPlayer.duplicate()
	add_child(anim_player_copy)
	anim_player_copy.play("hp_bar_heal")
	await anim_player_copy.animation_finished
	anim_player_copy.queue_free()
	
func hp_visibility(current_body_health, max_body_health):
	true_current_body_health = current_body_health
	
	if true_current_body_health != max_body_health and !hp_bar.visible:
		hp_bar.visible = true
	if true_current_body_health == max_body_health:
		# TODO: await timer length fetches from AnimationPlayer?
		await get_tree().create_timer(1.8).timeout
		if true_current_body_health == max_body_health:
			hp_bar.visible = false
	
#func update_hp(current_body_health, max_body_health):
#	true_current_body_health = current_body_health
#
#	if true_current_body_health != max_body_health and !hp_bar.visible:
#		hp_bar.visible = true
#		await get_tree().create_timer(.75).timeout
#		hp_bar.value = true_current_body_health
#
#	if true_current_body_health < max_body_health and hp_bar.visible:
#		hp_bar.value = true_current_body_health
#
#	if true_current_body_health == max_body_health:
#		hp_bar.value = true_current_body_health
#		await get_tree().create_timer(1.35).timeout
#		hp_bar.visible = false
