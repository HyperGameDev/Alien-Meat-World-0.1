extends Node3D

@onready var terrain_controller: Node3D = %TerrainController_inScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	terrain_controller.terrain_velocity = 6.5
	Messenger.game_begin.connect(on_game_begin)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func on_game_begin():
	terrain_controller.terrain_velocity = terrain_controller.TERRAIN_VELOCITY
