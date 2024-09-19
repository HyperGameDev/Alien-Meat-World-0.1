extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	Messenger.button_action.connect(on_button_action)

func on_button_action(button):
	match button:
		0:
			Messenger.restart.emit()
		1:
			pass
		2:
			pass
		3:
			get_tree().quit()
