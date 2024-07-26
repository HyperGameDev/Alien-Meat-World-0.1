extends Area3D

class_name Button3D

@export var is_button: is_buttons
enum is_buttons {STORY, SETTINGS, CREDITS, QUIT}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_collision_layer_value(7,true)
	Messenger.button_hovered.connect(on_button_hovered)
	Messenger.anything_seen.connect(on_anything_seen)
	Messenger.button_chosen.connect(on_button_chosen)

func on_button_hovered(target):
	if target.is_button == is_button:
		#region Handle Animation End
		if get_owner().has_node("Text"):
			var animation = get_owner().get_node("AnimationTree")
			animation.set("parameters/Transition/transition_request", "stopping")
		#endregion

func on_anything_seen(target):
	if !target.is_empty():
		if target["collider"].has_method("on_button_hovered"):
			if !target["collider"].is_button == is_button:
				#region Handle Animation Begin
				if get_owner().has_node("Text"):
					var animation = get_owner().get_node("AnimationTree")
					animation.set("parameters/Transition/transition_request", "idling")
				#endregion

		else:
				#region Handle Animation Begin
				if get_owner().has_node("Text"):
					var animation = get_owner().get_node("AnimationTree")
					animation.set("parameters/Transition/transition_request", "idling")
				#endregion
				
func on_button_chosen(target):
	if target.is_button == is_button:
		Messenger.button_action.emit(is_button)
