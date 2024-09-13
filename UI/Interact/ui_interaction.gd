extends Node3D

@onready var player: CharacterBody3D = %Player

@onready var interact_mesh: MeshInstance3D = $"Mesh_Interact-01"

@onready var interact_area: Area3D = $"Area_Interact-01"

func _ready() -> void:
	interact_area.set_collision_layer_value(1,false)
	interact_area.set_collision_mask_value(1,false)
	interact_area.set_collision_mask_value(9,true)
	interact_area.body_entered.connect(on_body_entered)
	interact_area.body_exited.connect(on_body_exited)
	#interact_mesh.get_surface_override_material(0).next_pass.set_shader_parameter("inner_color", Color(1.0,.5,.0,1.0))
	

func _physics_process(delta: float) -> void:
	global_position.x = player.global_position.x

func on_body_entered(body):
	if body.is_in_group("Abductee"):
		body.is_interactable = true
		
func on_body_exited(body):
	if body.is_in_group("Abductee"):
		body.is_interactable = false
