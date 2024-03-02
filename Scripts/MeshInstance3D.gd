extends MeshInstance3D

signal update_hitpoints
var damage_taken = 1
@export var health_max: int
@onready var health_current = health_max

func _ready():
	update_hitpoints.emit()
