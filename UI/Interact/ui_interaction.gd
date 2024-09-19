extends Node3D

@onready var player: CharacterBody3D = %Player

@onready var interact_mesh: MeshInstance3D = $"Mesh_Interact-01"
@onready var interact_area: Area3D = $"Area_Interact-01"
@onready var interact_collision: CollisionShape3D = $"Area_Interact-01/CollisionShape3D"
@onready var interact_animation: AnimationPlayer = $AnimationPlayer

@onready var arm_l: Area3D = get_tree().get_current_scene().get_node("Player/Alien_V3/DetectionAreas/Area_ArmL")
@onready var arm_r: Area3D = get_tree().get_current_scene().get_node("Player/Alien_V3/DetectionAreas/Area_ArmR")

# Scalar multiplies
@export var interact_mesh_resize: Vector2 = Vector2(1.0,1.0)
const INTERACT_MESH_SIZE: Vector2 = Vector2(20,46.655)

# Scalar adds
@export var interact_mesh_resides: float = 0.0
const INTERACT_MESH_SIDES: float = 0.0

# Scalar adds
@export var interact_mesh_rerotate: float = 0.0
const INTERACT_MESH_ROTATE: float = 0.0

# Scalar multiplies
@export var interact_collision_resize: float = 1.0
const INTERACT_COLLISION_SIZE: Vector3 = Vector3(2.87,6.515,1.73)

# Scalar multiplies
@export var interact_collision_reheight: float = 1.0
const INTERACT_COLLISION_HEIGHT: float = 0.865

# Scalar mulitiplies
@export var interact_collision_reforward: float = 1.0
const INTERACT_COLLISION_FORWARD: float = 1.75

# Scalar adds
@export var interact_collision_resides: float = 0.0
const INTERACT_COLLISION_SIDES: float = 0.0

# Scalar adds
@export var interact_collision_rerotate: float = 0.0
const INTERACT_COLLISION_ROTATE: float = 0.0




var debugl: int = 0
var debugr: int = 0


func _ready() -> void:
	Messenger.game_play.connect(on_game_play)
	Messenger.arm_health_update.connect(on_arm_health_update)
	interact_area.set_collision_layer_value(1,false)
	interact_area.set_collision_mask_value(1,false)
	interact_area.set_collision_mask_value(9,true)
	interact_area.body_entered.connect(on_body_entered)
	interact_area.body_exited.connect(on_body_exited)
	interact_mesh.get_surface_override_material(0).next_pass.set_shader_parameter("alpha",0.0)
	
func on_game_play():
	Messenger.arm_health_update.emit()
	interact_animation.play("interact_show")
	
func _physics_process(delta: float) -> void:
	global_position.x = player.global_position.x

			

func on_arm_health_update():
	match [debugl,debugr]:
		[0,0]:
			interact_collision_resize = 1.0
			interact_collision_reheight = 1.0
			interact_collision_reforward = 1.0
			interact_collision_resides = 0.0
			interact_collision_rerotate = 0.0
			interact_mesh_resize = Vector2(1.0,1.0)
			interact_mesh.position.y = 1.8
			interact_mesh_resides = 0.0
			interact_mesh_rerotate = 0.0
			interact_mesh.get_surface_override_material(0).next_pass.set_shader_parameter("width",.01)
			
		[0,1]:
			interact_collision_resize = 1.0
			interact_collision_reheight = 1.0
			interact_collision_reforward = 1.0
			interact_collision_resides = 0.0
			interact_collision_rerotate = 0.0
			interact_mesh_resize = Vector2(1.8,2.0)
			interact_mesh.position.y = 5.0
			interact_mesh_resides = 1.15
			interact_mesh_rerotate = -10
			interact_mesh.get_surface_override_material(0).next_pass.set_shader_parameter("width",.007)
			
		[1,0]:
			interact_collision_resize = 1.0
			interact_collision_reheight = 1.0
			interact_collision_reforward = 1.0
			interact_collision_resides = 0.0
			interact_collision_rerotate = 0.0
			interact_mesh_resize = Vector2(1.8,2.0)
			interact_mesh.position.y = 5.0
			interact_mesh_resides = -1.15
			interact_mesh_rerotate = 10
			interact_mesh.get_surface_override_material(0).next_pass.set_shader_parameter("width",.007)
			
		[0,2]:
			interact_collision_resize = 1.0
			interact_collision_reheight = 1.0
			interact_collision_reforward = 1.0
			interact_collision_resides = 0.0
			interact_collision_rerotate = 0.0
			interact_mesh_resize = Vector2(2.5,3.4)
			interact_mesh.position.y = 9.5
			interact_mesh_resides = 2.3
			interact_mesh_rerotate = -10
			interact_mesh.get_surface_override_material(0).next_pass.set_shader_parameter("width",.004)
			
		[2,0]:
			interact_collision_resize = 1.0
			interact_collision_reheight = 1.0
			interact_collision_reforward = 1.0
			interact_collision_resides = 0.0
			interact_collision_rerotate = 0.0
			interact_mesh_resize = Vector2(2.5,3.4)
			interact_mesh.position.y = 9.5
			interact_mesh_resides = -2.3
			interact_mesh_rerotate = 10
			interact_mesh.get_surface_override_material(0).next_pass.set_shader_parameter("width",.004)
			
		[1,1]:
			interact_collision_resize = 2.5
			interact_collision_reheight = 2.5
			interact_collision_reforward = 3.8
			interact_collision_resides = 0.0
			interact_collision_rerotate = 0.0
			interact_mesh_resize = Vector2(2.5,2.5)
			interact_mesh.position.y = 6.6
			interact_mesh_resides = 0.0
			interact_mesh_rerotate = 0.0
			interact_mesh.get_surface_override_material(0).next_pass.set_shader_parameter("width",.005)
			
		[1,2]:
			interact_collision_resize = 2.5
			interact_collision_reheight = 2.5
			interact_collision_reforward = 3.8
			interact_collision_resides = 0.0
			interact_collision_rerotate = 0.0
			interact_mesh_resize = Vector2(3.2,3.3)
			interact_mesh.position.y = 9
			interact_mesh_resides = 1.4
			interact_mesh_rerotate = -10
			interact_mesh.get_surface_override_material(0).next_pass.set_shader_parameter("width",.00375)
			
		[2,1]:
			interact_collision_resize = 2.5
			interact_collision_reheight = 2.5
			interact_collision_reforward = 3.8
			interact_collision_resides = 0.0
			interact_collision_rerotate = 0.0
			interact_mesh_resize = Vector2(3.2,3.3)
			interact_mesh.position.y = 9
			interact_mesh_resides = -1.4
			interact_mesh_rerotate = 10
			interact_mesh.get_surface_override_material(0).next_pass.set_shader_parameter("width",.00375)
			
		[2,2]:
			interact_collision_resize = 4.0
			interact_collision_reheight = 4.0
			interact_collision_reforward = 6.6
			interact_collision_resides = 0.0
			interact_collision_rerotate = 0.0
			interact_mesh_resize = Vector2(4.0,4.0)
			interact_mesh.position.y = 11.5
			interact_mesh_resides = 0.0
			interact_mesh_rerotate = 0.0
			interact_mesh.get_surface_override_material(0).next_pass.set_shader_parameter("width",.00325)

		_:
			pass
			
			
	interact_mesh.mesh.size = (INTERACT_MESH_SIZE * interact_mesh_resize)
	interact_mesh.position.x = (INTERACT_MESH_SIDES + interact_mesh_resides)
	interact_mesh.rotation.z = deg_to_rad((INTERACT_MESH_ROTATE + interact_mesh_rerotate))
	interact_collision.shape.size = (INTERACT_COLLISION_SIZE * interact_collision_resize)
	interact_collision.position.z = (INTERACT_COLLISION_HEIGHT * interact_collision_reheight)
	interact_collision.position.y = (INTERACT_COLLISION_FORWARD * interact_collision_reforward)
	interact_collision.position.x = (INTERACT_COLLISION_SIDES + interact_collision_resides)
	interact_collision.rotation.z = (INTERACT_COLLISION_ROTATE + interact_collision_rerotate)

func on_body_entered(body):
	if body.is_in_group("Abductee"):
		body.is_interactable = true
		
func on_body_exited(body):
	if body.is_in_group("Abductee"):
		body.is_interactable = false
