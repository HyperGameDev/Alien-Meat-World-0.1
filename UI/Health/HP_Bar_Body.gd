@tool

extends Sprite3D


@onready var hp_bar = $SubViewport/Body_HP_Bar
@onready var anim_hit_points = $"Animation_Hit-Points"
@onready var anim_hp_bar = $"Animation_HP-Bar"

var true_current_body_health = 0



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
	# Define & Create duplicate hit point animations
	var anim_player_copy = anim_hit_points.duplicate()
	add_child(anim_player_copy)
	
	# Play animation copy
	anim_player_copy.play("hp_bar_hit")
	
	# Remove animation when finished
	await anim_player_copy.animation_finished
	anim_player_copy.queue_free()

func _hp_bar_heal():
	# Define & Create duplicate hit point animations
	var anim_player_copy = anim_hit_points.duplicate()
	add_child(anim_player_copy)
	
	# Play animation copy
	anim_player_copy.play("hp_bar_heal")

	# Remove animation when finished
	await anim_player_copy.animation_finished
	anim_player_copy.queue_free()
	
	
func hp_visibility(current_body_health, max_body_health):
	# Set "True" health to avoid outdated HP values
#	true_current_body_health = current_body_health
	
	# On damage or heal, show HP bar
	if current_body_health != max_body_health or current_body_health == max_body_health:
		anim_hp_bar.play("hp_bar_show")
		await anim_hp_bar.animation_finished
		anim_hp_bar.play("hp_bar_hide")
