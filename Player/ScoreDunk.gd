extends Area3D

@onready var dunk_target: CharacterBody3D = %Player


@onready var mesh: MeshInstance3D = %MeshInstance3D
@onready var collision: CollisionShape3D = %CollisionShape3D
@onready var score_count: Label3D = %scoreCount

@onready var animation_scoreCount = %Animation_scoreCount
@onready var animation_dunkOrb = %Animation_scoreDunk

# Adjust these together!!
var dunk_y_offset: float = 5.6
const DUNK_Y_OFFSET: float = 5.6


@export var dunk_ascent_distance: float = 1.6

# Cam Movement vars
@export var dunk_lerpspeed: float = .05
@export var dunk_z_offset: float = 0.0
@export var dunk_x_offset: float = 0.0

var is_grabbing: bool = false
var something_in_dunk: bool = false
var dunked_meat: Object = null
var score_update: int = 0
var dunked_meats_in_group: int = 0

@onready var dunk_ascent_timer: Timer = Timer.new()
const DUNK_ASCENT_TIMER_DURATION: float = 2.0
var dunk_ascent_timer_duration: float = 2.0


func _ready():
	set_collision_mask_value(9, true)
	visible = false
	$VisibleOnScreenNotifier3D.screen_exited.connect(on_screen_exited)
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)
	Messenger.grab_begun.connect(on_grab_begun)
	Messenger.grab_ended.connect(on_grab_ended)
	Messenger.meat_in_dunk.connect(on_meat_in_dunk)
	
	dunk_ascent_timer.timeout.connect(on_ascent_timer_timeout)
	dunk_ascent_timer.one_shot = true
	add_child(dunk_ascent_timer)

	
func _physics_process(delta):
#	print(score)
# Beautiful mouse-position-based transparency code that turned out maybe isn't useful here...
#	var mouse_pos = get_viewport().get_mouse_position()
#	var dunk_distance_from_mouse = dunk_2d_pos.distance_to(mouse_pos)
#	var dunk_opacity = clamp(1 - dunk_distance_from_mouse / DUNK_MAX_OPACITY_DISTANCE, 0.3, 0.7)
#	print(dunk_opacity)
#
#	mesh.set_transparency(dunk_opacity)


	dunked_meats_in_group = get_tree().get_nodes_in_group("Dunked").size()
#	print(score_update)
	score_update = dunked_meats_in_group
	score_count.text = str("+",score_update)


		
	
	
	
	# Dunk ascent
	if is_grabbing and dunk_y_offset == DUNK_Y_OFFSET:
		dunk_ascent_timer.start(dunk_ascent_timer_duration)
		dunk_y_offset -= dunk_ascent_distance
		
#	if !is_grabbing and dunk_y_offset < DUNK_Y_OFFSET:
#
		
	# Dunk follow position
	var dunk_follow_pos: Vector3 = dunk_target.position
#	dunk_follow_pos.z += dunk_z_offset
	dunk_follow_pos.y += dunk_y_offset
	dunk_follow_pos.x += dunk_x_offset

	# Dunk Follow Normalize
	var dunk_direction: Vector3 = dunk_follow_pos - self.position

	self.position += dunk_direction * dunk_lerpspeed

	# Dunk visibility
#	print("Dunk: ", "Y offset= ", dunk_y_offset, ". Y const= ", DUNK_Y_OFFSET, ". Y follow pos= ", self.position.y)

		
	var dunk_position = self.global_position
	Messenger.dunk_is_at_position.emit(dunk_position)
		
func on_ascent_timer_timeout():
	dunk_y_offset += dunk_ascent_distance
	dunk_ascent_timer_duration = DUNK_ASCENT_TIMER_DURATION
	
func on_screen_exited():
	if !dunked_meat == null:
		Messenger.abduction.emit(score_update)
		score_update = 0

		for meat in get_tree().get_nodes_in_group("Dunked"):
			meat.queue_free()
			
		
		visible = false
		
		# Does this do anything useful? I added it because it makes sense, but it seems to work without it...
		dunked_meat = null

			

func on_grab_begun(target):
	visible = true
	is_grabbing = true
#	collision.disabled = false
	
func on_grab_ended():
	is_grabbing = false
#	collision.disabled = true

func on_body_entered(body):
	if body.is_in_group("Grabbed"):
		Messenger.meat_entered_dunk.emit(body)
		animation_dunkOrb.play("hover_throb")

func on_body_exited(body):
	if body.is_in_group("Abductee"):
		Messenger.meat_left_dunk.emit(body)
		animation_dunkOrb.play("base_size", .2)
		
func on_meat_in_dunk(dunked):
	# Check dunked meat variables here? Eg:
	if !dunked.empathy_ok:
		pass
	dunked_meat = dunked
	animation_scoreCount.stop()
	animation_scoreCount.play("score_up")
