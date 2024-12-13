extends Node3D

@onready var dialogue_box: Sprite3D = $Sprite3D
@onready var canvas_dialogue: CanvasLayer = $Sprite3D/SubViewport/Canvas_speechRegular


@export var dialogue_offset_pos: float = 1.55
var is_right: bool = false
