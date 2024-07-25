extends CanvasLayer

@onready var animation_message: AnimationPlayer = $Blackout_BG/Container_Message/AnimationPlayer
@onready var container_message: MarginContainer = %Container_Message


func _ready() -> void:
	Messenger.game_intro.connect(on_game_intro)
	Messenger.game_menu.connect(on_game_menu)

func on_game_intro():
	animation_message.play("message_flash")
	container_message.visible = true
	
func on_game_menu():
	animation_message.stop()
	container_message.visible = false
	
