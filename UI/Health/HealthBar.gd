@tool

extends Sprite3D

class_name HealthBar

@export_enum("head_is_damaged","empathy_is_damaged","limbs_is_damaged") var what_is_damaged : String
@export_enum("head_is_healed","empathy_is_healed","limbs_is_healed") var what_is_healed : String
@export_enum("head_health","empathy_health","limbs_health") var what_health : String

@onready var hp_bar = $"SubViewport/HP_Bar"
@onready var anim_hit_points = $"Animation_Hit-Points"
@onready var anim_hp_bar = $"SubViewport/HP_Bar/Animation_HP-Bar"

var true_current_health = 4
var true_max_health = 4

var bodypart_hit

var skeleton
var bone_hit

func _ready():		
	texture = $SubViewport.get_texture()
#	Messenger.head_health.connect(update_hp)
	Messenger.connect(str(what_health), hp_action_visibility)
	Messenger.connect(str(what_is_damaged), _hp_bar_damage)
	Messenger.connect(str(what_is_healed), _hp_bar_heal)
	Messenger.player_hover.connect(hp_visibility)
#	Messenger.area_damaged.connect(_bodypart_hit)
	
	hp_bar.self_modulate.a = 0

#func _bodypart_hit(bodypart_name):
#	bodypart_hit = bodypart_name.name.split("_")[1]
#	skeleton = get_node("../Armature/Skeleton3D")
#	bone_hit = skeleton.find_bone(bodypart_hit)
#	skeleton.set_bone_pose_scale(bone_hit, Vector3(2, 2, 2))
	

# Damage Animation Functions
func _damage_hp_3():
	get_tree().create_tween().tween_property(hp_bar, "value", 3, 1.25)
	
func _damage_hp_2():
	get_tree().create_tween().tween_property(hp_bar, "value", 2, 1.25)
	
func _damage_hp_1():
	get_tree().create_tween().tween_property(hp_bar, "value", 1, 1.25)
	
func _damage_hp_0():
	get_tree().create_tween().tween_property(hp_bar, "value", 0, 1.25)	
	
# Damage AnimationPlayer Controls
func _hp_bar_damage():
	# Define & Create duplicate hit point animations
	var anim_player_copy = anim_hit_points.duplicate()
	add_child(anim_player_copy)
	
	# Wait for true hit point values to be captured
	await get_tree().create_timer(.01).timeout
	
	# Play correct animation based on how many hit points are left
	# TODO: CLean this logic layout up maybe
	if true_max_health - true_current_health == 1:
		anim_player_copy.play("damage_hp_3")
		
	if true_max_health - true_current_health == 2:
		anim_player_copy.play("damage_hp_2")
		
	if true_max_health - true_current_health == 3:
		anim_player_copy.play("damage_hp_1")
		
	if true_max_health - true_current_health == 4:
		anim_player_copy.play("damage_hp_0")
	
	# Remove animation when finished
	await anim_player_copy.animation_finished
	anim_player_copy.queue_free()
	
	

# Healing Animation Functions
func _heal_hp_3():
	get_tree().create_tween().tween_property(hp_bar, "value", 4, 1.25)
	
func _heal_hp_2():
	get_tree().create_tween().tween_property(hp_bar, "value", 3, 1.25)
	
func _heal_hp_1():
	get_tree().create_tween().tween_property(hp_bar, "value", 2, 1.25)
	
	
# Healing AnimationPlayer Controls
func _hp_bar_heal():
	# Define & Create duplicate hit point animations
	var anim_player_copy = anim_hit_points.duplicate()
	add_child(anim_player_copy)
	
	# Wait for true hit point values to be captured
	await get_tree().create_timer(.01).timeout
	
	# Play correct animation based on how many hit points are left
	if true_max_health - true_current_health == 0:
		anim_player_copy.play("heal_hp_3")
		
	if true_max_health - true_current_health == 1:
		anim_player_copy.play("heal_hp_2")
		
	if true_max_health - true_current_health == 2:
		anim_player_copy.play("heal_hp_1")
	
	# Remove animation when finished
	await anim_player_copy.animation_finished
	anim_player_copy.queue_free()

	
	
func hp_action_visibility(current_health, max_health):
	# Set "True" health to avoid outdated HP values
	true_current_health = current_health
	true_max_health = max_health
#	print("TRUE", " ", what_is_damaged, " ", true_current_health)
	
	# On damage or heal, show HP bar
	if current_health != max_health or current_health == max_health:
		hp_visibility(true)

func hp_visibility(player_hovered):
	# Show if Hovered
	if hp_bar.self_modulate.a < 1 and player_hovered == true:
		anim_hp_bar.play("hp_bar_show")
		
	# Start hiding if visible and not Hovered
	if hp_bar.self_modulate.a == 1 and player_hovered == false and true_current_health > 1:
		anim_hp_bar.play("hp_bar_hide")
