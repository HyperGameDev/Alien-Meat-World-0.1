extends CanvasLayer

@onready var button_yes: Button = %Button_Yes
@onready var button_no: Button = %Button_No
@onready var animation: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	Messenger.game_menu.connect(on_game_menu)
	Messenger.game_confirm.connect(on_game_confirm)
	Messenger.game_postmenu.connect(on_game_postmenu)
	
	button_yes.mouse_entered.connect(on_button_yes_hovered)
	button_no.mouse_entered.connect(on_button_no_hovered)
	
	button_yes.mouse_exited.connect(on_button_yes_unhovered)
	button_no.mouse_exited.connect(on_button_no_unhovered)
	
	button_yes.pressed.connect(on_button_yes_pressed)
	button_no.pressed.connect(on_button_no_pressed)
	
func on_button_yes_hovered():
	animation.pause()
	button_yes.get_node("Animation").play("hilite")
func on_button_yes_unhovered():
	animation.play()
	button_yes.get_node("Animation").play("unhilite")
func on_button_yes_pressed():
	Messenger.swap_game_state.emit(Globals.is_game_states.POSTMENU)
	Messenger.skin_confirm.emit(true)
	
func on_button_no_hovered():
	animation.pause()
	button_no.get_node("Animation").play("hilite")
func on_button_no_unhovered():
	animation.play()
	button_no.get_node("Animation").play("unhilite")
func on_button_no_pressed():
	Messenger.swap_game_state.emit(Globals.is_game_states.MENU)
	Messenger.skin_confirm.emit(false)
	
func on_game_menu():
	visible = false
	
func on_game_confirm():
	visible = true

func on_game_postmenu():
	visible = false
