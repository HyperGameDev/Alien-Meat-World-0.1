extends CanvasLayer

class_name HUD

#region onreadys
@onready var terrain_controller: Node3D = %TerrainController_inScene
@onready var player: CharacterBody3D = %Player

@onready var container_score: MarginContainer = %MarginContainer_Score
@onready var label_score: Label = %Score_Number
@onready var label_scoreMinimum: Label = %Score_Number_Minimum

@onready var levelup_message: MarginContainer = %MarginContainer_LevelUp
@onready var loading_text: MarginContainer = %MarginContainer_Loading


@onready var orb_1: Area3D = %PowerUp_Orb_1
@onready var orb_2: Area3D = %PowerUp_Orb_2
@onready var orb_3: Area3D = %PowerUp_Orb_3

@onready var powerup_name: Control = %PowerUp_Name
@onready var powerup_name_label: Label = %PowerUp_Name_Text
@onready var powerup_description: MarginContainer = %"MarginContainer_PowerUp-Description"
@onready var powerup_description_label: Label = %Powerup_Description_Text




@onready var animation_score: AnimationPlayer = %"Animation_HUD-Score"
@onready var animation_levelup: AnimationPlayer = %"Animation_HUD-LevelUp"
@onready var animation_loading: AnimationPlayer = %Animation_Loading
#endregion

var score: int = 0
var score_minimum: int = -1
var score_minimum_met: bool = false


func _ready():
	
	#region Hiding Elements Outside of Editor
	powerup_name.visible = false
	powerup_description.visible = false
	loading_text.visible = false
	levelup_message.visible = false
	#endregion
	
	# Update current level's minimum score
	on_level_update(Globals.level_current)
	score_minimum_play_animation()
	
	Messenger.powerup_hovered.connect(on_powerup_hovered)
	Messenger.level_update.connect(on_level_update)
	Messenger.abduction.connect(on_abduction)
	on_level_update(Globals.level_current)
	Messenger.powerup_chosen.connect(on_powerup_chosen)
	Messenger.game_play.connect(on_game_play)
	
func _process(delta):
	label_score.text = str(score)
	if score >= score_minimum and !score_minimum_met:
		on_score_minimum_met()
	
func on_game_play():
	score_minimum_text_update()
	score_minimum_play_animation()
	container_score.visible = true

func on_powerup_unhovered():
	powerup_name.visible = false
	powerup_description.visible = false

func on_powerup_hovered(orb):
	match orb:
		1:
			powerup_name.visible = true
			#print("Orb 1 HUD name, visible = ",powerup_name.visible)
			powerup_description.visible = true
			powerup_name.position = get_viewport().get_camera_3d().unproject_position(orb_1.global_position)
			
			powerup_name_label.text = Globals.powerups[orb_1.powerup_key].powerupName
			powerup_description_label.text = Globals.powerups[orb_1.powerup_key].powerupDescription
			 
		2:
			powerup_name.visible = true
			powerup_description.visible = true
			powerup_name.position = get_viewport().get_camera_3d().unproject_position(orb_2.global_position)
			powerup_name_label.text = Globals.powerups[orb_2.powerup_key].powerupName
			powerup_description_label.text = Globals.powerups[orb_2.powerup_key].powerupDescription
		3:
			powerup_name.visible = true
			powerup_description.visible = true
			powerup_name.position = get_viewport().get_camera_3d().unproject_position(orb_3.global_position)
			powerup_name_label.text = Globals.powerups[orb_3.powerup_key].powerupName
			powerup_description_label.text = Globals.powerups[orb_3.powerup_key].powerupDescription
		_:
			pass
	
func on_powerup_chosen(orb):
	score_minimum_met = false
	score_minimum_play_animation()
	Messenger.movement_start.emit(true)
		
func on_score_minimum_met():
	score_minimum_met = true
	animation_score.play("score_minimum_met")
	
func score_minimum_met_animation_finished():
	animation_levelup.play("levelup_text_in")
	levelup_message.visible = true
	
	
	Messenger.movement_stop.emit(true)
	
	
	animation_loading.play("loading_text")
	loading_text.visible = true
	
func levelup_text_animation_finished():
	
	Messenger.level_update.emit(Globals.level_current + 1)
	animation_levelup.play("levelup_text_out")

	#print("HUD emitted powerup_menu_begun")
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
	if level == 0:
		container_score.visible = false
		
		
	
	# CONSIDER making this a dictionary to save some performance
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
