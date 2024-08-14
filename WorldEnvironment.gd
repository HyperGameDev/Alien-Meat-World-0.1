extends WorldEnvironment


@export var environment_visible = true

@onready var environment_empty = preload("res://Environment/enviro-00.tres")
@onready var sun: DirectionalLight3D = %DirectionalLight3D
@onready var fog_left: FogVolume =  %Fog_boundaryLeft
@onready var fog_right: FogVolume =  %Fog_boundaryRight

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !environment_visible:
		environment = environment_empty
	sun.visible = false
	Messenger.level_update.connect(on_level_update)
	Messenger.game_begin.connect(on_game_begin)
		
	on_level_update(Globals.level_current)

func on_level_update(level):
	if level == 0 and environment_visible:
		fog_left.visible = false
		fog_right.visible = false
		environment.set_volumetric_fog_emission_energy(0.0)
		environment.set_fog_light_energy(0.0)
		environment.sky.sky_material.set_sky_energy_multiplier(0.0)
		
func on_game_begin():
	if environment_visible:
		environment.set_volumetric_fog_emission_energy(9.79)
		environment.set_fog_light_energy(0.93)
		environment.sky.sky_material.set_sky_energy_multiplier(1.0)
		fog_left.visible = true
		fog_right.visible = true
	else:
		fog_left.visible = false
		fog_right.visible = false
		
	
  
