extends CanvasLayer

@onready var terrain_controller = %TerrainController_inScene
@onready var player = %Player

@onready var label_score = %Score_Number
@onready var label_scoreMinimum = %Score_Number_Minimum
@onready var animation_score = %"Animation_HUD-Score"
var score = 0
var score_minimum = -1
var score_minimum_met = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Messenger.level_update.connect(on_level_update)
	Messenger.abduction.connect(on_abduction)
	on_level_update(Globals.level_current)
	Messenger.powerup_chosen.connect(on_powerup_chosen)
	
func _process(delta):
	label_score.text = str(score)
	if score >= score_minimum and !score_minimum_met:
		on_score_minimum_met()
		
func on_powerup_chosen(orb):
	score_minimum_met = false
	terrain_controller.terrain_velocity = terrain_controller.TERRAIN_VELOCITY
	player.terrain_slowdown = false
	player.controls_locked = false
		
func on_score_minimum_met():
	score_minimum_met = true
	Messenger.level_update.emit(Globals.level_current + 1)
	animation_score.play("score_minimum_met")
	terrain_controller.terrain_velocity = 0
	player.terrain_slowdown = true
	player.controls_locked = true
	player.velocity = Vector3(0,0,0)
	
func score_minimum_met_animation_finished():
	Messenger.score_minimum_met.emit()

func on_abduction(score_value):
	score = Globals.score
	
func on_level_update(level):
	match level:
		0:
			score_minimum = 1
		1:
			score_minimum = 10
		2:
			score_minimum = 20
		3:
			score_minimum = 30
		4:
			score_minimum = 40
		5:
			score_minimum = 50
		6:
			score_minimum = 60
		7:
			score_minimum = 70
		8:
			score_minimum = 80
		9:
			score_minimum = 90
		10:
			score_minimum = 100
		11:
			score_minimum = 110
		12:
			score_minimum = 120

			
	label_scoreMinimum.text = str(score_minimum)
