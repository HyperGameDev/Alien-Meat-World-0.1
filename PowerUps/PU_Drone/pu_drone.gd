extends Node3D

var projectile_interval : float = 2.0

@onready var projectile_interval_timer : Timer = Timer.new()

func _ready() -> void:
	projectile_interval_timer.timeout.connect(on_projectile_interval_timeout)
	projectile_interval_timer.one_shot = true
	add_child(projectile_interval_timer)
	projectile_interval_timer.start(projectile_interval)


func on_projectile_interval_timeout():
	projectile_interval_timer.start(projectile_interval)
	
	var drone_bullet = preload("res://Projectiles/drone_projectile_01.tscn").instantiate()
	get_tree().get_current_scene().add_child(drone_bullet)
	
	drone_bullet.global_position = global_position
	
	drone_bullet.get_node("Projectile").speed = 1
	drone_bullet.get_node("Projectile").shoot_at_player = false
	drone_bullet.get_node("Projectile").direction = -transform.basis.z
