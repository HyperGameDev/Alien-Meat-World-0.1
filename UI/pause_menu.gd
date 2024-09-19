extends CanvasLayer

@onready var button_continue: Button = $MarginContainer/VBoxContainer/Button_Continue
@onready var animation_continue: AnimationPlayer = $MarginContainer/VBoxContainer/Button_Continue/Label_Continue/AnimationPlayer
var hilite_continue: bool = false

@onready var button_settings: Button = $MarginContainer/VBoxContainer/Button_Settings
@onready var animation_settings: AnimationPlayer = $MarginContainer/VBoxContainer/Button_Settings/Label_Settings/AnimationPlayer
var hilite_settings: bool = false

@onready var button_main_menu: Button = $MarginContainer/VBoxContainer/Button_MainMenu
@onready var animation_main_menu: AnimationPlayer = $MarginContainer/VBoxContainer/Button_MainMenu/Label_MainMenu/AnimationPlayer
var hilite_main_menu: bool = false

@onready var button_retry: Button = $MarginContainer/VBoxContainer/Button_Retry
@onready var animation_retry: AnimationPlayer = $MarginContainer/VBoxContainer/Button_Retry/Label_Retry/AnimationPlayer
var hilite_retry: bool = false

func _ready() -> void:
	visible = false
	
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


func _input(event: InputEvent):
	if event.is_action_pressed("Unpause") and Globals.is_game_state == Globals.is_game_states.PAUSE:
		
		get_tree().paused = false
	if event.is_action_released("Pause") and Globals.is_game_state == Globals.is_game_states.PAUSE:
		button_continue.grab_focus()

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
		print("Settings Focused")
		animation_settings.play("hilite")
func on_button_settings_hover():
	if !hilite_settings:
		hilite_settings = true
		print("Settings Hovered")
		animation_settings.play("hilite")
func on_button_settings_unfocus():
	if hilite_settings:
		hilite_settings = false
		print("Settings Unfocused")
		animation_settings.play("unhilite")
func on_button_settings_unhover():
	if hilite_settings:
		hilite_settings = false
		print("Settings Unhovered")
		animation_settings.play("unhilite")
#endregion
	
#region Main Menu Button
func on_button_main_menu():
	pass
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
	pass
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
