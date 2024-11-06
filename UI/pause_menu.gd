extends CanvasLayer

var modulate_invisible: Color = Color(1.0,1.0,1.0,0.0)
var modulate_visible: Color = Color(1.0,1.0,1.0,1.0)

#region Game_Over Parent Nodes
@onready var game_over_menu_bg: Panel = %"GameOver_menu-BG"
@onready var game_over_progress_stats: MarginContainer = %"GameOver_progress-stats"
@onready var game_over_h_separator_1: HSeparator = %GameOver_HSeparator1
@onready var game_over_progress_bar_box: VBoxContainer = %"GameOver_progress-bar-box"
@onready var game_over_h_separator_2: HSeparator = %GameOver_HSeparator2
@onready var game_over_progress_bar: MarginContainer = %"GameOver_progress-bar"
@onready var game_over_h_separator_3: HSeparator = %GameOver_HSeparator3
#endregion

#region Game_Over Stat OnReadies
@onready var game_over_level_stat: Label = %"GameOver_level-stat"
@onready var game_over_abduct_stat: Label = %"GameOver_abduct-stat"
@onready var game_over_empathy_stat: Label = %"GameOver_empathy-stat"
@onready var game_over_time_stat: Label = %"GameOver_time-stat"

@onready var game_over_progress_current: Label = %"GameOver_progress-current"
@onready var game_over_progress_target: Label = %"GameOver_progress-target"
@onready var progress_explanation: Label = %Progress_explanation


@onready var game_over_progress_skins: ProgressBar = %"GameOver_progress-skins"
@onready var game_over_progress_last: HSlider = %"GameOver_progress-last"


@onready var animation_progress_stats: AnimationPlayer = %"Animation_progress-stats"
#endregion

var skin_progress_old : int = 0
var skin_progress_current : int = 0
var skin_progress_target : int = 0

var skin_progress_bar_begin: int = 0
var skin_progress_bar_current: int = 0

@export var empathy_base_value: float = .7
@export var empathy_impact: float = .3
@export var time_impact: float = 0.0506
@export var abduction_impact: float = 1.345

#region Continue Button Declaration
@onready var button_continue: Button = %Button_Continue
@onready var animation_continue: AnimationPlayer = %Animation_Continue
var hilite_continue: bool = false
#endregion

#region Settings Button Declaration
@onready var button_settings: Button = %Button_Settings
@onready var animation_settings: AnimationPlayer = %Animation_Settings
var hilite_settings: bool = false
#endregion

#region Retry Button Declaration
@onready var button_retry: Button = %Button_Retry
@onready var animation_retry: AnimationPlayer = %Animation_Retry
var hilite_retry: bool = false
#endregion

#region Main Menu Button Declaration
@onready var button_main_menu: Button = %Button_MainMenu
@onready var animation_main_menu: AnimationPlayer = %Animation_MainMenu
var hilite_main_menu: bool = false
#endregion



# Ready Function
func _ready() -> void:
	visible = false
	
	Messenger.game_over.connect(on_game_over)
	game_over_progress_skins.value_changed.connect(on_progress_changed)
	

#region Game_Over UI = Un-Visible
	game_over_menu_bg.visible = false
	game_over_progress_stats.visible = false
	game_over_h_separator_1.visible = false
	game_over_progress_bar_box.visible = false
	game_over_h_separator_2.visible = false
	game_over_progress_bar.visible = false
	game_over_h_separator_3.visible = false
	
	game_over_level_stat.modulate = modulate_invisible
	game_over_abduct_stat.modulate = modulate_invisible
	game_over_empathy_stat.modulate = modulate_invisible
	game_over_time_stat.modulate = modulate_invisible
	game_over_progress_bar_box.modulate = modulate_invisible
	game_over_progress_bar.modulate = modulate_invisible
#endregion
	
#region Continue Button Setup
	button_continue.pressed.connect(on_button_continue)
	button_continue.focus_entered.connect(on_button_continue_focus)
	button_continue.mouse_entered.connect(on_button_continue_hover)
	button_continue.focus_exited.connect(on_button_continue_unfocus)
	button_continue.mouse_exited.connect(on_button_continue_unhover)
#endregion
	
#region Settings Button Setup
	button_settings.pressed.connect(on_button_settings)
	button_settings.focus_entered.connect(on_button_settings_focus)
	button_settings.mouse_entered.connect(on_button_settings_hover)
	button_settings.focus_exited.connect(on_button_settings_unfocus)
	button_settings.mouse_exited.connect(on_button_settings_unhover)
#endregion
	
#region Main Menu Button Setup
	button_main_menu.pressed.connect(on_button_main_menu)
	button_main_menu.focus_entered.connect(on_button_main_menu_focus)
	button_main_menu.mouse_entered.connect(on_button_main_menu_hover)
	button_main_menu.focus_exited.connect(on_button_main_menu_unfocus)
	button_main_menu.mouse_exited.connect(on_button_main_menu_unhover)
#endregion
	
#region Retry Button Setup
	button_retry.pressed.connect(on_button_retry)
	button_retry.focus_entered.connect(on_button_retry_focus)
	button_retry.mouse_entered.connect(on_button_retry_hover)
	button_retry.focus_exited.connect(on_button_retry_unfocus)
	button_retry.mouse_exited.connect(on_button_retry_unhover)
#endregion

# Input Function
func _input(event: InputEvent):
	if event.is_action_pressed("Unpause") and Globals.is_game_state == Globals.is_game_states.PAUSE:
		
		get_tree().paused = false
		
	if event.is_action_released("Pause"):
		if Globals.is_game_state == Globals.is_game_states.PAUSE:
			button_continue.grab_focus()
		if Globals.is_game_state == Globals.is_game_states.OVER:
			button_retry.grab_focus()

# Game Over Function
func on_game_over():
	update_progress_target()
	
#region Game_Over UI = Visible
	game_over_menu_bg.visible = true
	game_over_progress_stats.visible = true
	game_over_h_separator_1.visible = true
	game_over_progress_bar_box.visible = true
	game_over_h_separator_2.visible = true
	game_over_progress_bar.visible = true
	game_over_h_separator_3.visible = true
#endregion

#region Button Changes (On Game_Over)
	button_continue.visible = false
	button_settings.visible = false
	button_retry.visible = true
	button_main_menu.get_child(0).text = "Restart"
#endregion

	var level: String = Globals.level_label[Globals.level_current]
	var abductions: int = Globals.score
	var empathy: int = Globals.empathy
	var total_seconds: float = Globals.time
	var total_minutes: float = total_seconds/60
	
	
	var empathy_factor: float = empathy_impact * empathy
	#print("Empathy Factor: ",empathy_factor)
	
	var score_update: float = 0.0
	if empathy >= 1:
		score_update = empathy_factor * abductions
		progress_explanation.visible = true
	else:
		score_update = abductions
		progress_explanation.visible = false
	
	skin_progress_old = Globals.skin_progress
	game_over_progress_skins.value = skin_progress_old
	skin_progress_current = skin_progress_old + score_update
	Globals.skin_progress = skin_progress_current
	print("Update: ",score_update)
	
	
#region Time setup
	var seconds:float = fmod(total_seconds , 60.0)
	var minutes:int   =  int(total_seconds / 60.0) % 60
	var hours:  int   =  int(total_seconds / 3600.0)
	var time:String = str("%02d:%02d:%02d" % [hours, minutes, seconds])
#endregion

	
	game_over_level_stat.text = level
	game_over_abduct_stat.text = str(abductions)
	game_over_empathy_stat.text = str(empathy)	
	game_over_time_stat.text = time
	game_over_progress_current.text = str(skin_progress_old)
	
	animation_progress_stats.play("show_stats")
	
func run_progress_tween():
	if skin_progress_current < skin_progress_target:
		score_number_update(true)
		print("Current prog (",skin_progress_current,") was less than the target (",skin_progress_target,")")
	else:				
		score_number_update(false)
		print("Current prog (",skin_progress_current,") was greater than the target (",skin_progress_target,")")
	

func score_number_update(is_last): # Called first by an animation
	print("Tween updated to go to ",skin_progress_target)
	var tween_number = create_tween()
	
	if is_last:
		tween_number.tween_method(increase_progress_number,int(game_over_progress_skins.value),skin_progress_current,1.0)
	else:
		tween_number.tween_method(increase_progress_number,int(game_over_progress_skins.value),skin_progress_target,1.0)
	
	#update_progress_bar()
	
	
func update_progress_target():
	var next_skin_level: int = (Globals.skin_max_progress/Globals.skin_max_level) * Globals.skin_level
	print("Global level: ",Globals.skin_level)
	#skin_progress_target = snapped(next_skin_level,step)
	skin_progress_target = next_skin_level
	game_over_progress_skins.max_value = skin_progress_target
	#print("Max value updated to: ",game_over_progress_skins.max_value)
	game_over_progress_target.text = str(skin_progress_target)
	#print("Progress target: ",skin_progress_target)
	
	
func on_progress_changed(progress):
	if progress >= game_over_progress_skins.max_value:
		print("Max bar value reached!")
		#print("Progress (",progress,") updated max to: ",game_over_progress_skins.max_value)
		if Globals.skin_progress >= skin_progress_target:
			print("Current progress (",skin_progress_current,") was greater than/equal to target!")
			game_over_progress_skins.value = 0
			Globals.skin_progress = skin_progress_current - skin_progress_target
			skin_progress_current = Globals.skin_progress
			Messenger.skin_level_update.emit(1)
			#print("Full progress: ",skin_progress_bar_current,"\nFull target: ",skin_progress_target,"\nGlobal Skin Progress: ",Globals.skin_progress,"\nskin_progress_current: ",skin_progress_current)
			update_progress_target()
			print("Progress updated target to: ",skin_progress_target)
			run_progress_tween()
		

func return_skin_target() -> int:
	return (Globals.skin_max_progress/Globals.skin_max_level) * Globals.skin_level

func increase_progress_number(number_progress):
	#print("Old progress: ",skin_progress_old)
	#print("Current progress: ",skin_progress_current)
	game_over_progress_current.text = str(number_progress)
	game_over_progress_skins.value = number_progress
	
func increase_progress_bar(bar_progress):
	game_over_progress_skins.value = bar_progress
	
# Button Functions
#region Continue Button
func on_button_continue():
	get_tree().paused = false
func on_button_continue_focus():
	if !hilite_continue:
		hilite_continue = true
		animation_continue.play("hilite")
func on_button_continue_hover():
	if !hilite_continue:
		hilite_continue = true
		animation_continue.play("hilite")
func on_button_continue_unfocus():
	if hilite_continue:
		hilite_continue = false
		animation_continue.play("unhilite")
func on_button_continue_unhover():
	if hilite_continue:
		hilite_continue = false
		animation_continue.play("unhilite")
#endregion
	
#region Settings Button
func on_button_settings():
	pass
func on_button_settings_focus():
	if !hilite_settings:
		hilite_settings = true
		animation_settings.play("hilite")
func on_button_settings_hover():
	if !hilite_settings:
		hilite_settings = true
		animation_settings.play("hilite")
func on_button_settings_unfocus():
	if hilite_settings:
		hilite_settings = false
		animation_settings.play("unhilite")
func on_button_settings_unhover():
	if hilite_settings:
		hilite_settings = false
		animation_settings.play("unhilite")
#endregion
	
#region Main Menu Button
func on_button_main_menu():
	Messenger.restart.emit.call_deferred()
func on_button_main_menu_focus():
	if !hilite_main_menu:
		hilite_main_menu = true
		animation_main_menu.play("hilite")
func on_button_main_menu_hover():
	if !hilite_main_menu:
		hilite_main_menu = true
		animation_main_menu.play("hilite")
func on_button_main_menu_unfocus():
	if hilite_main_menu:
		hilite_main_menu = false
		animation_main_menu.play("unhilite")
func on_button_main_menu_unhover():
	if hilite_main_menu:
		hilite_main_menu = false
		animation_main_menu.play("unhilite")
#endregion
	
#region Retry Button
func on_button_retry():
	Messenger.retry.emit(false)
func on_button_retry_focus():
	if !hilite_retry:
		hilite_retry = true
		animation_retry.play("hilite")
func on_button_retry_hover():
	if !hilite_retry:
		hilite_retry = true
		animation_retry.play("hilite")
func on_button_retry_unfocus():
	if hilite_retry:
		hilite_retry = false
		animation_retry.play("unhilite")
func on_button_retry_unhover():
	if hilite_retry:
		hilite_retry = false
		animation_retry.play("unhilite")
#endregion
