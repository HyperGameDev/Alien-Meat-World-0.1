extends Node3D

class_name HitPoints

const HIT_DELAY = 0 # Just needs to be small

var is_dead = false
var health_percent_lost: float = 0.0

@export var hit_particle_lifetime: float = 2.0


# Getting attacked
var target
var was_grabbed = false
@onready var attacked_duration = get_tree().get_current_scene().get_node("Player").grab_duration

func _ready():
	$"..".update_hitpoints.connect(health_effects)
	if $"..".has_signal("must_explode"):
		$"..".must_explode.connect(on_must_explode)
	
	# Getting Attacked
	Messenger.grab_target.connect(am_i_grabbed)
	Messenger.something_ungrabbed.connect(got_hit)

func health_effects():
	# Update Health Debug
	$Dmg_Label.text = str($"..".health_current)
	
	if $"..".health_current <= 0: # Is Dead
		$Dmg_Label.visible = false
	
func am_i_grabbed(grab_target):
	#	target = grab_target
#	if grab_target == $"..":
#		print("Copter Seen (", $"..".name, ")")
	if grab_target == $".." and Input.is_action_just_pressed("Grab"):
		was_grabbed = true
#		print("Copter Hit (", $"..".name, ")")
		Messenger.something_grabbed.emit($"..")

func got_hit(what_got_hit):
	#	print($"..".name, " MIGHT be hit...")
	if what_got_hit == $".." and $"..".health_current > 0:
#		print($"..".name, " just got hit!")
#		await get_tree().create_timer(attacked_duration).timeout
		$"..".health_current -= $"..".damage_taken
		$"..".update_hitpoints.emit()
		var health_current_float: float = $"..".health_current * 1.0
		var health_max_float: float = $"..".health_max * 1.0
		var health_lost: float = health_max_float - health_current_float
		health_percent_lost = health_lost / health_max_float
#		print("Current: ", health_current_float, "; Lost: ", health_lost, "; %: ", health_percent_lost)
		
		await get_tree().create_timer(attacked_duration).timeout
		$Animation_Degrade.play("degrade")
		$Animation_Degrade.seek(health_percent_lost, true)
		$Animation_Degrade.pause()
		
		
		if $"..".health_current <= 0:
			if !$"..".has_signal("must_explode"):
				await get_tree().create_timer(hit_particle_lifetime).timeout
				get_owner().queue_free()
			
func on_must_explode():
	$Particles_Explode.set_emitting(true)
	await get_tree().create_timer(hit_particle_lifetime).timeout
	get_owner().queue_free()
