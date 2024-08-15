extends CanvasLayer

@onready var blackout: Panel = %Blackout_BG

@onready var animation_message: AnimationPlayer = $Blackout_BG/Container_Message/AnimationPlayer
@onready var container_message: MarginContainer = %Container_Message

@onready var loading_text: MarginContainer = %MarginContainer_Loading
@onready var animation_loading: AnimationPlayer = %Animation_Loading


func _ready() -> void:
	blackout.visible = true
	Messenger.game_intro.connect(on_game_intro)
	Messenger.game_menu.connect(on_game_menu)
	Messenger.game_prebegin.connect(on_game_prebegin)
	Messenger.game_begin.connect(on_game_begin)

func on_game_intro():
	animation_message.play("message_flash")
	container_message.visible = true
	
func on_game_menu():
	animation_message.stop()
	container_message.visible = false
	
func on_game_prebegin():
	animation_loading.play("loading_text")
	loading_text.visible = true
		
func on_game_begin():
	await get_tree().create_timer(1.5).timeout
	animation_loading.stop()
	loading_text.visible = false
	
