extends Node3D

@onready var player: CharacterBody3D = %Player

@onready var interact_mesh: MeshInstance3D = $"Mesh_Interact-01"
@onready var interact_area: Area3D = $"Area_Interact-01"
@onready var interact_collision: CollisionShape3D = $"Area_Interact-01/CollisionShape3D"
@onready var interact_collision_poly: CollisionPolygon3D = $"Area_Interact-01/CollisionPolygon3D"
@onready var interact_animation: AnimationPlayer = $AnimationPlayer

@onready var arm_l: Area3D = get_tree().get_current_scene().get_node("Player/Alien_V3/DetectionAreas/Area_ArmL")
@onready var arm_r: Area3D = get_tree().get_current_scene().get_node("Player/Alien_V3/DetectionAreas/Area_ArmR")

var collision_poly_l: Array = [
	Vector2(-3.1,10.0),
	Vector2(-1.2,14.3),
	Vector2(-3.4,6.4),
	Vector2(-2.9,2.4),
	Vector2(-1.2,-1.0)
]
var COLLISION_POLY_L: Array = [
	Vector2(-3.1,10.0),
	Vector2(-1.2,14.3),
	Vector2(-3.4,6.4),
	Vector2(-2.9,2.4),
	Vector2(-1.2,-1.0)
]

var collision_poly_r: Array = [
	Vector2(3.1,10.0),
	Vector2(1.2,14.3),
	Vector2(3.4,6.4),
	Vector2(2.9,2.4),
	Vector2(1.2,-1.0)
]
var COLLISION_POLY_R: Array = [
	Vector2(3.1,10.0),
	Vector2(1.2,14.3),
	Vector2(3.4,6.4),
	Vector2(2.9,2.4),
	Vector2(1.2,-1.0)
]


@export var scale_up_2: float = 1.7
@export var powerup_scale_1: float = 1.7
@export var powerup_scale_2: float = 2.55

# Scalar adds
@export var collision_poly_resides: float = 0.0
const COLLISION_POLY_SIDES: float = 0.0

# Scalar add
@export var collision_poly_movemore_R1: Vector2 = Vector2(0.0,0.0)
const COLLISION_POLY_MOVE_R1: Vector2 = Vector2(0.0,0.0)

# Scalar add
@export var collision_poly_movemore_L1: Vector2 = Vector2(0.0,0.0)
const COLLISION_POLY_MOVE_L1: Vector2 = Vector2(0.0,0.0)

# Scalar add
@export var collision_poly_movemore_R0: Vector2 = Vector2(0.0,0.0)
const COLLISION_POLY_MOVE_R0: Vector2 = Vector2(0.0,0.0)

# Scalar add
@export var collision_poly_movemore_L0: Vector2 = Vector2(0.0,0.0)
const COLLISION_POLY_MOVE_L0: Vector2 = Vector2(0.0,0.0)

# Scalar add
@export var collision_poly_movemore_R2: Vector2 = Vector2(0.0,0.0)
const COLLISION_POLY_MOVE_R2: Vector2 = Vector2(0.0,0.0)

# Scalar add
@export var collision_poly_movemore_L2: Vector2 = Vector2(0.0,0.0)
const COLLISION_POLY_MOVE_L2: Vector2 = Vector2(0.0,0.0)

# Scalar multiplies
@export var collision_poly_resize_r: float = 1.0
@export var collision_poly_resize_l: float = 1.0

# Scalar adds
@export var collision_poly_rerotate: float = 0.0
const COLLISION_POLY_ROTATE: float = 0.0

# Scalar mulitiplies
@export var collision_poly_reforward: float = 0.0
const COLLISION_POLY_FORWARD: float = 0.0

# Scalar multiplies
@export var interact_mesh_resize: Vector2 = Vector2(1.0,1.0)
const INTERACT_MESH_SIZE: Vector2 = Vector2(20,46.655)

# Scalar adds
@export var interact_mesh_resides: float = 0.0
const INTERACT_MESH_SIDES: float = 0.0

# Scalar adds
@export var interact_mesh_rerotate: float = 0.0
const INTERACT_MESH_ROTATE: float = 0.0




var debugl: int = 0
var debugr: int = 0


func _ready() -> void:
	#print(interact_collision_poly.polygon)
	Messenger.game_play.connect(on_game_play)
	Messenger.arm_health_update.connect(on_arm_health_update)
	interact_area.set_collision_layer_value(1,false)
	interact_area.set_collision_mask_value(1,false)
	interact_area.set_collision_mask_value(9,true)
	interact_area.set_collision_mask_value(10,true)
	interact_area.set_collision_mask_value(Globals.collision.NPC_INTERACT,true)
	interact_area.body_entered.connect(on_body_entered)
	interact_area.body_exited.connect(on_body_exited)
	interact_area.area_entered.connect(on_area_entered)
	interact_area.area_exited.connect(on_area_exited)
	
	interact_mesh.get_surface_override_material(0).next_pass.set_shader_parameter("alpha",0.0)
	
	
func _physics_process(delta: float) -> void:
	global_position.x = player.global_position.x
	

func on_game_play():
	Messenger.arm_health_update.emit()
	interact_animation.play("interact_show")
	

			

func on_arm_health_update():
	var arm_l_match: float = floorf(arm_l.current_health)
	var arm_r_match: float = floorf(arm_r.current_health)
	
	match Globals.powerups["Fantastic"].powerupLevel:
		0:
			arm_l_match = floorf(arm_l.current_health)
			arm_r_match = floorf(arm_r.current_health)
		1:
			if not floorf(arm_l.current_health) <= 0.0:
				arm_l_match = floorf(arm_l.current_health) + 1.0
			if not floorf(arm_r.current_health) <= 0.0:
				arm_r_match = floorf(arm_r.current_health) + 1.0
		2:
			if not floorf(arm_l.current_health) <= 0.0:
				arm_l_match = floorf(arm_l.current_health) + 2.0
			if not floorf(arm_r.current_health) <= 0.0:
				arm_r_match = arm_r.current_health + 2.0
		_:
			pass
	#print("Match checks for: ",arm_l_match,",",arm_r_match)
	#print("Limbs set to: ",floorf(arm_l.current_health),",",floorf(arm_r.current_health))
	match [arm_l_match,arm_r_match]:
		[0.0,0.0]:
			collision_poly_resize_l = 0.385
			collision_poly_resize_r = 0.385
			collision_poly_reforward = -.75
			collision_poly_resides = 0.0
			collision_poly_rerotate = 0.0
			collision_poly_movemore_R1 =  Vector2(0.0,0.0)
			collision_poly_movemore_L1 =  Vector2(0.0,0.0)
			collision_poly_movemore_R0 =  Vector2(0.0,0.0)
			collision_poly_movemore_L0 =  Vector2(0.0,0.0)
			collision_poly_movemore_R2 =  Vector2(0.0,0.0)
			collision_poly_movemore_L2 =  Vector2(0.0,0.0)
			interact_mesh_resize = Vector2(1.0,1.0)
			interact_mesh.position.y = 1.8
			interact_mesh_resides = 0.0
			interact_mesh_rerotate = 0.0
			interact_mesh.get_surface_override_material(0).next_pass.set_shader_parameter("width",.01)
			
		[0.0,1.0]:
			collision_poly_resize_l = 0.42
			collision_poly_resize_r = 1.1
			collision_poly_reforward = 0.0
			collision_poly_resides = 0.0
			collision_poly_rerotate = 0.0
			collision_poly_movemore_R1 =  Vector2(1.7,-4.8)
			collision_poly_movemore_L1 =  Vector2(1.8,5.1)
			collision_poly_movemore_R0 =  Vector2(.3,-2.7)
			collision_poly_movemore_L0 =  Vector2(.6,3.5)
			collision_poly_movemore_R2 =  Vector2(0.0,0.0)
			collision_poly_movemore_L2 =  Vector2(0.0,0.0)
			interact_mesh_resize = Vector2(1.8,2.0)
			interact_mesh.position.y = 5.0
			interact_mesh_resides = 1.15
			interact_mesh_rerotate = -10
			interact_mesh.get_surface_override_material(0).next_pass.set_shader_parameter("width",.007)
			
		[1.0,0.0]:
			collision_poly_resize_l = 1.1
			collision_poly_resize_r = 0.42
			collision_poly_reforward = 0.0
			collision_poly_resides = 0.0
			collision_poly_rerotate = 0.0
			collision_poly_movemore_R1 =  Vector2(-1.8,5.1)
			collision_poly_movemore_L1 =  Vector2(-1.7,-4.8)
			collision_poly_movemore_R0 =  Vector2(-.6,3.5)
			collision_poly_movemore_L0 =  Vector2(-.3,-2.7)
			collision_poly_movemore_R2 =  Vector2(0.0,0.0)
			collision_poly_movemore_L2 =  Vector2(0.0,0.0)
			interact_mesh_resize = Vector2(1.8,2.0)
			interact_mesh.position.y = 5.0
			interact_mesh_resides = -1.15
			interact_mesh_rerotate = 10
			interact_mesh.get_surface_override_material(0).next_pass.set_shader_parameter("width",.007)
			
		[0.0,2.0]:
			collision_poly_resize_l = 0.1
			collision_poly_resize_r = 1.2 * scale_up_2
			collision_poly_reforward = 0.0
			collision_poly_resides = -1.0
			collision_poly_rerotate = 0.0
			collision_poly_movemore_R1 =  Vector2(2.1,-5.5) * scale_up_2
			collision_poly_movemore_L1 =  Vector2(2.5,11.0) * scale_up_2
			collision_poly_movemore_R0 =  Vector2(.3,-2.7) * scale_up_2
			collision_poly_movemore_L0 =  Vector2(0.6,7.5) * scale_up_2
			collision_poly_movemore_R2 =  Vector2(0.0,0.0)
			collision_poly_movemore_L2 =  Vector2(-.2,3.0)
			interact_mesh_resize = Vector2(2.5,3.4)
			interact_mesh.position.y = 9.5
			interact_mesh_resides = 2.3
			interact_mesh_rerotate = -10
			interact_mesh.get_surface_override_material(0).next_pass.set_shader_parameter("width",.004)
			
		[2.0,0.0]:
			collision_poly_resize_l = 1.2 * scale_up_2
			collision_poly_resize_r = 0.1
			collision_poly_reforward = 0.0
			collision_poly_resides = 1.0
			collision_poly_rerotate = 0.0
			collision_poly_movemore_R1 =  Vector2(-2.5,11.0) * scale_up_2
			collision_poly_movemore_L1 =  Vector2(-2.1,-5.5) * scale_up_2
			collision_poly_movemore_R0 =  Vector2(-0.6,7.5) * scale_up_2
			collision_poly_movemore_L0 =  Vector2(-0.3,-2.7) * scale_up_2
			collision_poly_movemore_R2 =  Vector2(0.2,3.0)
			collision_poly_movemore_L2 =  Vector2(0.0,0.0)
			interact_mesh_resize = Vector2(2.5,3.4)
			interact_mesh.position.y = 9.5
			interact_mesh_resides = -2.3
			interact_mesh_rerotate = 10
			interact_mesh.get_surface_override_material(0).next_pass.set_shader_parameter("width",.004)
			
		[1.0,1.0]:
			collision_poly_resize_l = 1.0
			collision_poly_resize_r = 1.0
			collision_poly_reforward = 0.0
			collision_poly_resides = 0.0
			collision_poly_rerotate = 0.0
			collision_poly_movemore_R1 =  Vector2(0.0,0.0)
			collision_poly_movemore_L1 =  Vector2(0.0,0.0)
			collision_poly_movemore_R0 =  Vector2(0.0,0.0)
			collision_poly_movemore_L0 =  Vector2(0.0,0.0)
			collision_poly_movemore_R2 =  Vector2(0.0,0.0)
			collision_poly_movemore_L2 =  Vector2(0.0,0.0)
			interact_mesh_resize = Vector2(2.5,2.5)
			interact_mesh.position.y = 6.6
			interact_mesh_resides = 0.0
			interact_mesh_rerotate = 0.0
			
			
			interact_mesh.get_surface_override_material(0).next_pass.set_shader_parameter("width",.005)
			
		[1.0,2.0]:
			collision_poly_resize_l = 0.42 * scale_up_2
			collision_poly_resize_r = 1.2 * scale_up_2
			collision_poly_reforward = 0.0
			collision_poly_resides = -1.0
			collision_poly_rerotate = 0.0
			collision_poly_movemore_R1 =  Vector2(1.7,-6.0) * scale_up_2
			collision_poly_movemore_L1 =  Vector2(2.0,5.3) * scale_up_2
			collision_poly_movemore_R0 =  Vector2(.3,-2.7) * scale_up_2
			collision_poly_movemore_L0 =  Vector2(.8,4.0) * scale_up_2
			collision_poly_movemore_R2 =  Vector2(0.0,0.0)
			collision_poly_movemore_L2 =  Vector2(0.0,0.0)
			interact_mesh_resize = Vector2(3.2,3.3)
			interact_mesh.position.y = 9
			interact_mesh_resides = 1.4
			interact_mesh_rerotate = -10
			interact_mesh.get_surface_override_material(0).next_pass.set_shader_parameter("width",.00375)
			
		[2.0,1.0]:
			collision_poly_resize_l = 1.2 * scale_up_2
			collision_poly_resize_r = 0.42 * scale_up_2
			collision_poly_reforward = 0.0
			collision_poly_resides = 1.0
			collision_poly_rerotate = 0.0
			collision_poly_movemore_R1 =  Vector2(-2.0,5.3) * scale_up_2
			collision_poly_movemore_L1 =  Vector2(-1.7,-6.0) * scale_up_2
			collision_poly_movemore_R0 =  Vector2(-.8,4.0) * scale_up_2
			collision_poly_movemore_L0 =  Vector2(-.3,-2.7) * scale_up_2
			collision_poly_movemore_R2 =  Vector2(0.0,0.0)
			collision_poly_movemore_L2 =  Vector2(0.0,0.0)
			interact_mesh_resize = Vector2(3.2,3.3)
			interact_mesh.position.y = 9
			interact_mesh_resides = -1.4
			interact_mesh_rerotate = 10
			interact_mesh.get_surface_override_material(0).next_pass.set_shader_parameter("width",.00375)
			
		[2.0,2.0]:
			collision_poly_resize_l = 1.625
			collision_poly_resize_r = 1.625
			collision_poly_reforward = 0.75
			collision_poly_resides = 0.0
			collision_poly_rerotate = 0.0
			collision_poly_movemore_R1 =  Vector2(0.0,0.0)
			collision_poly_movemore_L1 =  Vector2(0.0,0.0)
			collision_poly_movemore_R0 =  Vector2(0.0,0.0)
			collision_poly_movemore_L0 =  Vector2(0.0,0.0)
			collision_poly_movemore_R2 =  Vector2(0.0,0.0)
			collision_poly_movemore_L2 =  Vector2(0.0,0.0)
			interact_mesh_resize = Vector2(4.0,4.0)
			interact_mesh.position.y = 11.5
			interact_mesh_resides = 0.0
			interact_mesh_rerotate = 0.0
			interact_mesh.get_surface_override_material(0).next_pass.set_shader_parameter("width",.00325)

		[2.0,3.0]:
			collision_poly_resize_l = (0.42 * scale_up_2) * powerup_scale_1
			collision_poly_resize_r = (1.2 * scale_up_2) * powerup_scale_1
			collision_poly_reforward = 0.0
			collision_poly_resides = (-1.0) * powerup_scale_1
			collision_poly_rerotate = 0.0
			collision_poly_movemore_R1 =  (Vector2(1.7,-6.0) * scale_up_2) * powerup_scale_1
			collision_poly_movemore_L1 =  (Vector2(2.0,5.3) * scale_up_2) * powerup_scale_1
			collision_poly_movemore_R0 =  (Vector2(.3,-2.7) * scale_up_2) * powerup_scale_1
			collision_poly_movemore_L0 =  (Vector2(.8,4.0) * scale_up_2) * powerup_scale_1
			collision_poly_movemore_R2 =  Vector2(0.0,0.0)
			collision_poly_movemore_L2 =  Vector2(0.0,0.0)
			interact_mesh_resize = (Vector2(3.2,3.3)) * powerup_scale_1
			interact_mesh.position.y = (9) * powerup_scale_1
			interact_mesh_resides = (1.3) * powerup_scale_1
			interact_mesh_rerotate = (-6) * powerup_scale_1
			interact_mesh.get_surface_override_material(0).next_pass.set_shader_parameter("width",.00375)
			
		[3.0,2.0]:
			collision_poly_resize_l = (1.2 * scale_up_2) * powerup_scale_1
			collision_poly_resize_r = (0.42 * scale_up_2) * powerup_scale_1
			collision_poly_reforward = 0.0
			collision_poly_resides = (1.0) * powerup_scale_1
			collision_poly_rerotate = 0.0
			collision_poly_movemore_R1 =  (Vector2(-2.0,5.3) * scale_up_2) * powerup_scale_1
			collision_poly_movemore_L1 =  (Vector2(-1.7,-6.0) * scale_up_2) * powerup_scale_1
			collision_poly_movemore_R0 =  (Vector2(-.8,4.0) * scale_up_2) * powerup_scale_1
			collision_poly_movemore_L0 =  (Vector2(-.3,-2.7) * scale_up_2) * powerup_scale_1
			collision_poly_movemore_R2 =  Vector2(0.0,0.0)
			collision_poly_movemore_L2 =  Vector2(0.0,0.0)
			interact_mesh_resize = (Vector2(3.2,3.3)) * powerup_scale_1
			interact_mesh.position.y = (9) * powerup_scale_1
			interact_mesh_resides = (-1.3) * powerup_scale_1
			interact_mesh_rerotate = (6) * powerup_scale_1
			interact_mesh.get_surface_override_material(0).next_pass.set_shader_parameter("width",.00375)
			
		[0.0,3.0]:
			collision_poly_resize_l = (0.1) * powerup_scale_1
			collision_poly_resize_r = (1.2 * scale_up_2) * powerup_scale_1
			collision_poly_reforward = 0.0
			collision_poly_resides = (-1.0) * powerup_scale_1
			collision_poly_rerotate = 0.0
			collision_poly_movemore_R1 =  (Vector2(2.1,-5.5) * scale_up_2) * powerup_scale_1
			collision_poly_movemore_L1 =  (Vector2(2.5,11.0) * scale_up_2) * powerup_scale_1
			collision_poly_movemore_R0 =  (Vector2(.3,-2.7) * scale_up_2) * powerup_scale_1
			collision_poly_movemore_L0 =  (Vector2(0.6,7.5) * scale_up_2) * powerup_scale_1
			collision_poly_movemore_R2 =  Vector2(0.0,0.0)
			collision_poly_movemore_L2 =  (Vector2(-.2,3.0)) * powerup_scale_1
			interact_mesh_resize = (Vector2(2.5,3.4)) * powerup_scale_1
			interact_mesh.position.y = (9.5) * powerup_scale_1
			interact_mesh_resides = (2.3) * powerup_scale_1
			interact_mesh_rerotate = (-6) * powerup_scale_1
			interact_mesh.get_surface_override_material(0).next_pass.set_shader_parameter("width",.004)
			
		[3.0,0.0]:
			collision_poly_resize_l = (1.2 * scale_up_2) * powerup_scale_1
			collision_poly_resize_r = (0.1) * powerup_scale_1
			collision_poly_reforward = 0.0
			collision_poly_resides = (1.0) * powerup_scale_1
			collision_poly_rerotate = 0.0
			collision_poly_movemore_R1 =  (Vector2(-2.5,11.0) * scale_up_2) * powerup_scale_1
			collision_poly_movemore_L1 =  (Vector2(-2.1,-5.5) * scale_up_2) * powerup_scale_1
			collision_poly_movemore_R0 =  (Vector2(-0.6,7.5) * scale_up_2) * powerup_scale_1
			collision_poly_movemore_L0 =  (Vector2(-.3,-2.7) * scale_up_2) * powerup_scale_1
			collision_poly_movemore_R2 =  (Vector2(.2,3.0)) * powerup_scale_1
			collision_poly_movemore_L2 =  Vector2(0.0,0.0)
			interact_mesh_resize = (Vector2(2.5,3.4)) * powerup_scale_1
			interact_mesh.position.y = (9.5) * powerup_scale_1
			interact_mesh_resides = (-2.3) * powerup_scale_1
			interact_mesh_rerotate = (6) * powerup_scale_1
			interact_mesh.get_surface_override_material(0).next_pass.set_shader_parameter("width",.004)
			
		[0.0,4.0]:
			collision_poly_resize_l = (0.1) * powerup_scale_2
			collision_poly_resize_r = (1.2 * scale_up_2) * powerup_scale_2
			collision_poly_reforward = 0.0
			collision_poly_resides = (-1.0) * powerup_scale_2
			collision_poly_rerotate = 0.0
			collision_poly_movemore_R1 =  (Vector2(2.1,-5.5) * scale_up_2) * powerup_scale_2
			collision_poly_movemore_L1 =  (Vector2(2.5,11.0) * scale_up_2) * powerup_scale_2
			collision_poly_movemore_R0 =  (Vector2(.3,-2.7) * scale_up_2) * powerup_scale_2
			collision_poly_movemore_L0 =  (Vector2(0.6,7.5) * scale_up_2) * powerup_scale_2
			collision_poly_movemore_R2 =  Vector2(0.0,0.0)
			collision_poly_movemore_L2 =  (Vector2(-.2,3.0)) * powerup_scale_2
			interact_mesh_resize = (Vector2(2.5,3.4)) * powerup_scale_2
			interact_mesh.position.y = (9.5) * powerup_scale_2
			interact_mesh_resides = (2.3) * powerup_scale_2
			interact_mesh_rerotate = (-4) * powerup_scale_2
			interact_mesh.get_surface_override_material(0).next_pass.set_shader_parameter("width",.004)
			
		[4.0,0.0]:
			collision_poly_resize_l = (1.2 * scale_up_2) * powerup_scale_2
			collision_poly_resize_r = (0.1) * powerup_scale_2
			collision_poly_reforward = 0.0
			collision_poly_resides = (1.0) * powerup_scale_2
			collision_poly_rerotate = 0.0
			collision_poly_movemore_R1 =  (Vector2(-2.5,11.0) * scale_up_2) * powerup_scale_2
			collision_poly_movemore_L1 =  (Vector2(-2.1,-5.5) * scale_up_2) * powerup_scale_2
			collision_poly_movemore_R0 =  (Vector2(-0.6,7.5) * scale_up_2) * powerup_scale_2
			collision_poly_movemore_L0 =  (Vector2(-.3,-2.7) * scale_up_2) * powerup_scale_2
			collision_poly_movemore_R2 =  (Vector2(.2,3.0)) * powerup_scale_2
			collision_poly_movemore_L2 =  Vector2(0.0,0.0)
			interact_mesh_resize = (Vector2(2.5,3.4)) * powerup_scale_2
			interact_mesh.position.y = (9.5) * powerup_scale_2
			interact_mesh_resides = (-2.3) * powerup_scale_2
			interact_mesh_rerotate = (4) * powerup_scale_2
			interact_mesh.get_surface_override_material(0).next_pass.set_shader_parameter("width",.004)
			
		[3.0,3.0]:
			collision_poly_resize_l = (1.625) * powerup_scale_1
			collision_poly_resize_r = (1.625) * powerup_scale_1
			collision_poly_reforward = (0.75) * powerup_scale_1
			collision_poly_resides = 0.0
			collision_poly_rerotate = 0.0
			collision_poly_movemore_R1 =  Vector2(0.0,0.0)
			collision_poly_movemore_L1 =  Vector2(0.0,0.0)
			collision_poly_movemore_R0 =  Vector2(0.0,0.0)
			collision_poly_movemore_L0 =  Vector2(0.0,0.0)
			collision_poly_movemore_R2 =  Vector2(0.0,0.0)
			collision_poly_movemore_L2 =  Vector2(0.0,0.0)
			interact_mesh_resize = (Vector2(4.0,4.0)) * powerup_scale_1
			interact_mesh.position.y = (11.5) * powerup_scale_1
			interact_mesh_resides = 0.0
			interact_mesh_rerotate = 0.0
			interact_mesh.get_surface_override_material(0).next_pass.set_shader_parameter("width",.00375)
			
		[4.0,4.0]:
			collision_poly_resize_l = (1.625) * powerup_scale_2
			collision_poly_resize_r = (1.625) * powerup_scale_2
			collision_poly_reforward = (0.75) * powerup_scale_2
			collision_poly_resides = 0.0
			collision_poly_rerotate = 0.0
			collision_poly_movemore_R1 =  Vector2(0.0,0.0)
			collision_poly_movemore_L1 =  Vector2(0.0,0.0)
			collision_poly_movemore_R0 =  Vector2(0.0,0.0)
			collision_poly_movemore_L0 =  Vector2(0.0,0.0)
			collision_poly_movemore_R2 =  Vector2(0.0,0.0)
			collision_poly_movemore_L2 =  Vector2(0.0,0.0)
			interact_mesh_resize = (Vector2(4.0,4.0)) * powerup_scale_2
			interact_mesh.position.y = (11.5) * powerup_scale_2
			interact_mesh_resides = 0.0
			interact_mesh_rerotate = 0.0
			interact_mesh.get_surface_override_material(0).next_pass.set_shader_parameter("width",.00375)
			
		[3.0,4.0]:
			collision_poly_resize_l = (0.42 * scale_up_2) * powerup_scale_2
			collision_poly_resize_r = (1.2 * scale_up_2) * powerup_scale_2
			collision_poly_reforward = 0.0
			collision_poly_resides = (-1.0) * powerup_scale_2
			collision_poly_rerotate = 0.0
			collision_poly_movemore_R1 =  (Vector2(1.7,-6.0) * scale_up_2) * powerup_scale_2
			collision_poly_movemore_L1 =  (Vector2(2.0,5.3) * scale_up_2) * powerup_scale_2
			collision_poly_movemore_R0 =  (Vector2(.3,-2.7) * scale_up_2) * powerup_scale_2
			collision_poly_movemore_L0 =  (Vector2(.8,4.0) * scale_up_2) * powerup_scale_2
			collision_poly_movemore_R2 =  Vector2(0.0,0.0)
			collision_poly_movemore_L2 =  Vector2(0.0,0.0)
			interact_mesh_resize = (Vector2(3.2,3.3)) * powerup_scale_2
			interact_mesh.position.y = (9) * powerup_scale_2
			interact_mesh_resides = (1.3) * powerup_scale_2
			interact_mesh_rerotate = (-4) * powerup_scale_2
			interact_mesh.get_surface_override_material(0).next_pass.set_shader_parameter("width",.00375)
			
		[4.0,3.0]:
			collision_poly_resize_l = (1.2 * scale_up_2) * powerup_scale_2
			collision_poly_resize_r = (0.42 * scale_up_2) * powerup_scale_2
			collision_poly_reforward = 0.0
			collision_poly_resides = (1.0) * powerup_scale_2
			collision_poly_rerotate = 0.0
			collision_poly_movemore_R1 =  (Vector2(-2.0,5.3) * scale_up_2) * powerup_scale_2
			collision_poly_movemore_L1 =  (Vector2(-1.7,-6.0) * scale_up_2) * powerup_scale_2
			collision_poly_movemore_R0 =  (Vector2(-.8,4.0) * scale_up_2) * powerup_scale_2
			collision_poly_movemore_L0 =  (Vector2(-.3,-2.7) * scale_up_2) * powerup_scale_2
			collision_poly_movemore_R2 =  Vector2(0.0,0.0)
			collision_poly_movemore_L2 =  Vector2(0.0,0.0)
			interact_mesh_resize = (Vector2(3.2,3.3)) * powerup_scale_2
			interact_mesh.position.y = (9) * powerup_scale_2
			interact_mesh_resides = (-1.3) * powerup_scale_2
			interact_mesh_rerotate = (4) * powerup_scale_2
			interact_mesh.get_surface_override_material(0).next_pass.set_shader_parameter("width",.00375)

		_:
			pass
			
		


	
#region Collision Poly Indices Resizing
	collision_poly_l[0] = COLLISION_POLY_L[0] * collision_poly_resize_l
	collision_poly_l[1] = COLLISION_POLY_L[1] * collision_poly_resize_l
	collision_poly_l[2] = COLLISION_POLY_L[2] * collision_poly_resize_l
	collision_poly_l[3] = COLLISION_POLY_L[3] * collision_poly_resize_l
	collision_poly_l[4] = COLLISION_POLY_L[4] * collision_poly_resize_l
	
	collision_poly_r[0] = COLLISION_POLY_R[0] * collision_poly_resize_r
	collision_poly_r[1] = COLLISION_POLY_R[1] * collision_poly_resize_r
	collision_poly_r[2] = COLLISION_POLY_R[2] * collision_poly_resize_r
	collision_poly_r[3] = COLLISION_POLY_R[3] * collision_poly_resize_r
	collision_poly_r[4] = COLLISION_POLY_R[4] * collision_poly_resize_r
#endregion
	
	var RESIZED_COLLISION_POLY_R_1: Vector2 = collision_poly_r[1]
	collision_poly_r[1] = RESIZED_COLLISION_POLY_R_1 + (COLLISION_POLY_MOVE_R1 + collision_poly_movemore_R1)
	
	var RESIZED_COLLISION_POLY_L_1: Vector2 = collision_poly_l[1]
	collision_poly_l[1] = RESIZED_COLLISION_POLY_L_1 + (COLLISION_POLY_MOVE_L1 + collision_poly_movemore_L1)
	
	var RESIZED_COLLISION_POLY_R_0: Vector2 = collision_poly_r[0]
	collision_poly_r[0] = RESIZED_COLLISION_POLY_R_0 + (COLLISION_POLY_MOVE_R0 + collision_poly_movemore_R0)
	
	var RESIZED_COLLISION_POLY_L_0: Vector2 = collision_poly_l[0]
	collision_poly_l[0] = RESIZED_COLLISION_POLY_L_0 + (COLLISION_POLY_MOVE_L0 + collision_poly_movemore_L0)
	
	var RESIZED_COLLISION_POLY_R_2: Vector2 = collision_poly_r[2]
	collision_poly_r[2] = RESIZED_COLLISION_POLY_R_2 + (COLLISION_POLY_MOVE_R2 + collision_poly_movemore_R2)
	
	var RESIZED_COLLISION_POLY_L_2: Vector2 = collision_poly_l[2]
	collision_poly_l[2] = RESIZED_COLLISION_POLY_L_2 + (COLLISION_POLY_MOVE_L2 + collision_poly_movemore_L2)
	
	interact_collision_poly.polygon = [
		collision_poly_r[0],
		collision_poly_r[1],
		collision_poly_l[1],
		collision_poly_l[0],
		collision_poly_l[2],
		collision_poly_l[3],
		collision_poly_l[4],
		collision_poly_r[4],
		collision_poly_r[3],
		collision_poly_r[2]
	]
	
	interact_collision_poly.rotation.z = COLLISION_POLY_ROTATE + collision_poly_rerotate
	
	interact_collision_poly.position.y = COLLISION_POLY_FORWARD + collision_poly_reforward
	
	interact_collision_poly.position.x = (COLLISION_POLY_SIDES + collision_poly_resides)
	
	
	
	interact_mesh.mesh.size = (INTERACT_MESH_SIZE * interact_mesh_resize)
	interact_mesh.position.x = (INTERACT_MESH_SIDES + interact_mesh_resides)
	interact_mesh.rotation.z = deg_to_rad((INTERACT_MESH_ROTATE + interact_mesh_rerotate))

func on_body_entered(body): ## Detects abductees
	if body.is_in_group("Abductee"):
		body.is_interactable = true
		body.interactable_indicator.visible = true
		
func on_body_exited(body): ## Detects abductees
	if body.is_in_group("Abductee"):
		body.is_interactable = false
		body.interactable_indicator.visible = false
		if body.is_in_group("Grabbed"):
			body.add_to_group("Dropped")
			body.remove_from_group("Grabbed")
			body.has_been_grabbed = false
			Messenger.grab_ended.emit()
			body.linear_velocity = Vector3.ZERO
			
func on_area_entered(area): ## Detects Obstacles and enemies
	Messenger.interact_obstacle_begin.emit(area)
	Messenger.interact_npc_begin.emit(area)

func on_area_exited(area): ## Detects Obstacles and enemies
	Messenger.interact_obstacle_end.emit(area)
	Messenger.interact_npc_end.emit(area)
