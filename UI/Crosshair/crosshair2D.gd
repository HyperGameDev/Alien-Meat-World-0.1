extends Control

@onready var animation_player: AnimationPlayer = $PanelContainer/AnimationPlayer
@onready var panel_container: PanelContainer = $PanelContainer
var offset := Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("grow")
	offset = panel_container.size/2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = get_viewport().get_mouse_position() - offset
