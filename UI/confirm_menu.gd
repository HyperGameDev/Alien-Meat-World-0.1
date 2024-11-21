extends CanvasLayer

@onready var button_yes: Button = %Button_Yes
@onready var button_no: Button = %Button_No

func _ready() -> void:
	button_yes.focus_entered.connect(on_button_yes_hovered)
	button_no.focus_entered.connect(on_button_no_hovered)
	
	button_yes.focus_exited.connect(on_button_yes_unhovered)
	button_no.focus_exited.connect(on_button_no_unhovered)
	
	button_yes.pressed.connect(on_button_yes_pressed)
	button_no.pressed.connect(on_button_no_pressed)
	
func on_button_yes_hovered():
	button_yes.get_node("Animation").play("hilite")
func on_button_yes_unhovered():
	button_yes.get_node("Animation").play("unhilite")
func on_button_yes_pressed():
	#Messenger.swap_game_state.emit(Globals.is_game_states.POSTMENU)
	print("YES")
	
func on_button_no_hovered():
	button_no.get_node("Animation").play("hilite")
func on_button_no_unhovered():
	button_no.get_node("Animation").play("unhilite")
func on_button_no_pressed():
	#Messenger.swap_game_state.emit(Globals.is_game_states.MENU)
	print("NO")
