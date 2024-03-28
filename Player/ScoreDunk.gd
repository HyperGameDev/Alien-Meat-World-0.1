extends Area3D

@onready var collision = %CollisionShape3D
@onready var dunk_target = %Player
@onready var animation = %Animation_ScoreDunk

# Adjust these together!!
@export var dunk_y_offset: float = 5.0
const DUNK_Y_OFFSET = 5.0

# Cam Movement vars
@export var dunk_lerpspeed = .05
@export var dunk_z_offset = 0.0
@export var dunk_x_offset = 0.0

var is_grabbing = false
var something_in_dunk = false
var dunked_meat

# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)
	Messenger.grab_begun.connect(on_grab_begun)
	Messenger.grab_ended.connect(on_grab_ended)
	Messenger.meat_in_dunk.connect(on_meat_in_dunk)

	
func _physics_process(delta):
	# Dunk descent
	if is_grabbing and dunk_y_offset == DUNK_Y_OFFSET:
		dunk_y_offset -= 1.5
	if !is_grabbing and dunk_y_offset < DUNK_Y_OFFSET:
		dunk_y_offset += 1.5
		
	# Dunk follow position
	var dunk_follow_pos: Vector3 = dunk_target.position
	dunk_follow_pos.z += dunk_z_offset
	dunk_follow_pos.y += dunk_y_offset
	dunk_follow_pos.x += dunk_x_offset

	# Dunk Follow Normalize
	var dunk_direction: Vector3 = dunk_follow_pos - self.position

	self.position += dunk_direction * dunk_lerpspeed

	# Dunk visibility
#	print("Dunk: ", "Y offset= ", dunk_y_offset, ". Y const= ", DUNK_Y_OFFSET, ". Y follow pos= ", self.position.y)
	if self.position.y >= 4.98:
		self.visible = false
		
		# If dunked_meat is not empty:
		if !dunked_meat == null:
			var score = dunked_meat.score_value
			Messenger.abduction.emit(score)
			dunked_meat.queue_free()
			
			# Check dunked meat variables here? Eg:
			if !dunked_meat.empathy_ok:
				pass
	else:
		self.visible = true
		
	var dunk_position = self.global_position
	Messenger.dunk_is_at_position.emit(dunk_position)
		

func on_grab_begun():
	is_grabbing = true
#	collision.disabled = false
	
func on_grab_ended():
	is_grabbing = false
#	collision.disabled = true

func on_body_entered(body):
	if body.is_in_group("Grabbed"):
		Messenger.meat_entered_dunk.emit(body)
		animation.play("hover_throb")

func on_body_exited(body):
	if body.is_in_group("Meat"):
		Messenger.meat_left_dunk.emit(body)
		animation.play("base_size", .2)
		
func on_meat_in_dunk(dunked):
	dunked_meat = dunked
	
