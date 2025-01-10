extends Marker3D


@export var main_group: String = "Empathy Event Marker"


func _ready() -> void:
	add_to_group(main_group)
