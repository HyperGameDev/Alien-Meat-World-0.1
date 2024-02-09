extends Area3D

class_name Copter

static var copters_stopped = 0

var copter_pos: Vector3
var copter_x_pos_min = -15
var copter_x_pos_max = 15 	

var copter_spawn_z_pos = -130

var speed = 50

var velocity = Vector3.ZERO

var is_moving = true

var target
var was_grabbed = false

@onready var attacked_duration = get_tree().get_current_scene().get_node("Player").grab_duration
@onready var nav_agent = $NavigationAgent3D

@onready var copter_area = self
@onready var player = get_tree().get_current_scene().get_node("Player/DetectionAreas/Area_Player-Proximity")

# Called when the node enters the scene tree for the first time.
func _ready():
	set_collision_layer_value(1, false)	
	set_collision_layer_value(3, true)
	
	set_collision_mask_value(1, false)
	
	player.area_entered.connect(copter_stop)
	nav_agent.velocity_computed.connect(copter_nav)
	Messenger.grab_target.connect(am_i_grabbed)
	Messenger.something_ungrabbed.connect(got_hit)
	
	$AnimationPlayer.play("propeller_speed-01")

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
		
#	if global_position.y >= 2.3:
#		nav_agent.use_3d_avoidance = false
#		print("A Copter Went Too High! 3D Avoidance is ", nav_agent.use_3d_avoidance)

func am_i_grabbed(grab_target):
#	target = grab_target
#	if grab_target == self:
#		print("Copter Seen (", self.name, ")")
	if grab_target == self and Input.is_action_just_pressed("Grab"):
		was_grabbed = true
		print("Copter Hit (", self.name, ")")
		Messenger.something_grabbed.emit(self)

func got_hit(what_got_hit):
#	print(self.name, " MIGHT be hit...")
	if what_got_hit == self:
		print(self.name, " just got hit!")
		await get_tree().create_timer(attacked_duration).timeout
		queue_free()
	
		
	
func copter_stop(thing_in_player_perimeter):
	if thing_in_player_perimeter == copter_area:
		is_moving = false
		
		# Consider moving copters_stopped calculation to the Area on the Player if this count is needed on a per-copter basis!
		copters_stopped += 1
		Messenger.copter_unit_stopped.emit(copters_stopped)
#		print(copters_stopped)
		
func copter_nav(safe_velocity):
	global_position += safe_velocity * get_physics_process_delta_time()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
