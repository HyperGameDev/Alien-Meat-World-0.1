extends Node3D

class_name Copter

var copter_pos: Vector3
var copter_x_pos_min = -15
var copter_x_pos_max = 15

var copter_spawn_z_pos = -130

var speed = 10

var velocity = Vector3.ZERO

var is_moving = true

@onready var copter_area = $Area_Copter
@onready var player = get_tree().get_current_scene().get_node("Player/DetectionAreas/Area_Player-Proximity")

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("propeller_speed-01")
	player.area_entered.connect(copter_stop)
	var copter_x_pos = randf_range(copter_x_pos_min,copter_x_pos_max)
	var copter_x_offset = Vector3(copter_x_pos, 0, 0)
	copter_pos = Vector3(0,2,copter_spawn_z_pos)
	global_position = copter_pos + copter_x_offset
#
#	print("Trying to move copter ", "(", global_position.z, ") ", "to ", "Player at ", player.global_position.z)


func _physics_process(delta):
	look_at(player.global_position)
	if is_moving:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		global_position += velocity * delta 
	
func copter_stop(area):
	if area == copter_area:
		is_moving = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
