extends Node3D

class_name HitPoints


var is_dead = false
var health_percent_lost: float = 0.0

@onready var dmg_label = $Dmg_Label

@export var hit_particle_lifetime: float = 2.0


# Getting attacked
var target
var was_hit = false
@onready var attacked_duration = get_tree().get_current_scene().get_node("Player").grab_duration

func _ready():
	if !has_node("Dmg_Label"):
			print("ERROR: Hit-Points should be added as a SCENE, not a Node!")
			breakpoint
			
	if !has_node("Animation_Degrade"):
			print("ERROR: Add a degrade animation for the obstacle!")
			breakpoint
	
	#if !$Animation_Degrade.get_animation("degrade").find_track(get_path(), Animation.TYPE_METHOD):
		#print("ERROR: Add a 'reset particle fx' method call track to an Obstacle's Hitpoints' Animation Degrade player!")
		#breakpoint
			
# If owner is a flying NPC, then it will be confirmed by the presence of "is_destroyed". Probably should refactor that to be more readable.
	$"..".update_hitpoints.connect(on_update_hitpoints)
	if $"..".has_signal("is_destroyed"):
		$"..".is_destroyed.connect(on_is_destroyed)
	
	# Getting Attacked
	Messenger.grab_target.connect(am_i_hit)
	Messenger.something_hit.connect(on_something_hit)
	
	
func on_update_hitpoints():
	# Update Health Debug
	dmg_label.text = str($"..".health_current)
	
	
func am_i_hit(grab_target):
	#	target = grab_target
#	if grab_target == $"..":
#		print("Copter Seen (", $"..".name, ")")
	if grab_target == $".." and Input.is_action_just_pressed("Grab"):
		was_hit = true
#		print("Copter Hit (", $"..".name, ")")
		Messenger.something_attacked.emit($"..")

func on_something_hit(what_got_hit,is_delayed):
	#print($"..".name, " MIGHT be hit...")
	if what_got_hit == $".." and $"..".health_current > 0:
		#print($"..".name, " just got hit!")
#		await get_tree().create_timer(attacked_duration).timeout
		$"..".health_current -= $"..".damage_taken
		$"..".update_hitpoints.emit()
		var health_current_float: float = $"..".health_current * 1.0
		var health_max_float: float = $"..".health_max * 1.0
		var health_lost: float = health_max_float - health_current_float
		health_percent_lost = health_lost / health_max_float
#		print("Current: ", health_current_float, "; Lost: ", health_lost, "; %: ", health_percent_lost)
		if is_delayed:
			await get_tree().create_timer(attacked_duration).timeout
		#if has_node("AnimationPlayer"):
			#print("contrived example")
			#$AnimationPlayer.play("new_aniwmation")
		$Animation_Degrade.play("degrade")
		$Animation_Degrade.seek(health_percent_lost, true)
		$Animation_Degrade.pause()
		
		if get_owner().has_signal("update_reset_status"):
			get_owner().update_reset_status.emit(self)
			
		

func on_is_destroyed():
	$Obstacle/HitPoints/Particles_Explode.set_emitting(true)
	await get_tree().create_timer(hit_particle_lifetime).timeout
	get_owner().queue_free()

# Called by Sub Obstacle's "Animation_Degrade"
func sub_obstacle_destroyed():
	get_owner().is_destroyed.emit()
	
	
func reset_particle_fx():
	for node in get_children():
		if node is GPUParticles3D:
			node.restart()

func reset_damage():
	#$Animation_Degrade.stop()
	$Animation_Degrade.seek(0.0, true)
	$"..".health_current = $"..".health_max
	$"..".update_hitpoints.emit()
	$"..".restore_collision()
	
func _input(event):
	if event.is_action_pressed("Debug 2"):
		await get_tree().create_timer(1)
		if Messenger.debug_hp_nonPlayer:
			dmg_label.visible = true
		else: 
			dmg_label.visible = false
