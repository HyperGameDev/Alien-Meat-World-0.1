extends CanvasLayer

@onready var terrain_controller: Node3D = %TerrainController_inScene
@onready var player: CharacterBody3D = %Player

@onready var label_score: Label = %Score_Number
@onready var label_scoreMinimum: Label = %Score_Number_Minimum

@onready var levelup_message: MarginContainer = %MarginContainer_LevelUp
@onready var loading_text: MarginContainer = %MarginContainer_Loading

@onready var animation_score: AnimationPlayer = %"Animation_HUD-Score"
@onready var animation_levelup: AnimationPlayer = %"Animation_HUD-LevelUp"
@onready var animation_loading: AnimationPlayer = %Animation_Loading

var score: int = 0
var score_minimum: int = -1
var score_minimum_met: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	loading_text.visible = false
	levelup_message.visible = false
	# Update current level's minimum score
	on_level_update(Globals.level_current)
	score_minimum_play_animation()
	
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
	score_minimum_play_animation()
	terrain_controller.terrain_velocity = terrain_controller.TERRAIN_VELOCITY
	player.terrain_slowdown = false
	player.controls_locked = false
		
func on_score_minimum_met():
	score_minimum_met = true
	animation_score.play("score_minimum_met")
	
func score_minimum_met_animation_finished():
	animation_levelup.play("levelup_text_in")
	levelup_message.visible = true
	
	#region Pause Movement
	terrain_controller.terrain_velocity = 0
	player.terrain_slowdown = true
	player.controls_locked = true
	player.velocity = Vector3(0,0,0)
	#endregion
	
	animation_loading.play("loading_text")
	loading_text.visible = true
	
func levelup_text_animation_finished():
	
	Messenger.level_update.emit(Globals.level_current + 1)
	animation_levelup.play("levelup_text_out")

	Messenger.powerup_menu_begin.emit()
	
	await get_tree().create_timer(2.5).timeout
	animation_loading.stop()
	loading_text.visible = false

func on_abduction(score_value):
	score = Globals.score
	
func score_minimum_play_animation():
	animation_score.play("score_minimum_updated")

func score_minimum_text_update():
	label_scoreMinimum.text = str(score_minimum)
	
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
