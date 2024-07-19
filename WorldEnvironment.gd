extends WorldEnvironment

@onready var fog_left: FogVolume =  %Fog_boundaryLeft
@onready var fog_right: FogVolume =  %Fog_boundaryRight

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
		Messenger.level_update.connect(on_level_update)
		Messenger.game_begin.connect(on_game_begin)
		
		on_level_update(Globals.level_current)

func on_level_update(level):
	if level == 0:
		fog_left.visible = false
		fog_right.visible = false
		environment.set_volumetric_fog_emission_energy(0.0)
		environment.set_fog_light_energy(0.0)
		environment.sky.sky_material.set_sky_energy_multiplier(0.0)
		
func on_game_begin():
	environment.set_volumetric_fog_emission_energy(9.79)
	environment.set_fog_light_energy(0.93)
	environment.sky.sky_material.set_sky_energy_multiplier(1.0)
	
