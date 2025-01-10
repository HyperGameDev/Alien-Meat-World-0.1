extends Node3D

var projectile_interval_min : float = .1
var projectile_interval_max : float = 4.0

@onready var projectile_interval_timer : Timer = Timer.new()

var bullet_scene: PackedScene
var shooting_weapon: String
var target: Node
var point_marker: Marker3D
	
func _ready() -> void:
	projectile_interval_timer.timeout.connect(on_projectile_interval_timeout)
	projectile_interval_timer.one_shot = true
	add_child(projectile_interval_timer)
	projectile_interval_timer.start(randf_range(projectile_interval_min,projectile_interval_max))
	
	
func _physics_process(delta: float) -> void:
	global_position = point_marker.global_position
	global_rotation = point_marker.global_rotation
	
	
func on_projectile_interval_timeout():
	print("Shoot Point: Bullet shot attempted from ",self.name," at ",self.global_position," towards ",target)
	projectile_interval_timer.start(randf_range(projectile_interval_min,projectile_interval_max))
	
	var bullet = bullet_scene.instantiate()
	
	add_child(bullet)
	
	bullet.get_node("Projectile").speed = ProjectileHandler.shooting_weapons[shooting_weapon]["speed"]
	
	bullet.get_node("Projectile").direction = (target.global_position - bullet.global_position).normalized()
