extends Node3D


@onready var player : CharacterBody3D =  get_tree().get_current_scene().get_node("Player")
@onready var camera: Camera3D = %Camera3D
@onready var arm_r: BodyPart = $"../../Alien_V3/DetectionAreas/Area_ArmR"
@onready var arm_l: BodyPart = $"../../Alien_V3/DetectionAreas/Area_ArmL"

@onready var hand_r: Marker3D = get_tree().get_current_scene().get_node("Player/Alien_V3/DetectionAreas/Area_ArmR/Marker_HandR")
@onready var hand_r_hurt: Marker3D = get_tree().get_current_scene().get_node("Player/Alien_V3/DetectionAreas/Area_ArmR/Marker-hurt_HandR")
@onready var hand_l: Marker3D = get_tree().get_current_scene().get_node("Player/Alien_V3/DetectionAreas/Area_ArmL/Marker_HandL")
@onready var hand_l_hurt: Marker3D = get_tree().get_current_scene().get_node("Player/Alien_V3/DetectionAreas/Area_ArmL/Marker-hurt_HandL")


@export var cursor_offset: Vector2 = Vector2(2,0)

var planeToMoveOn : Plane

func _ready() -> void:
	planeToMoveOn = Plane(Vector3(0,0,1), player.global_position.z)

func _process(delta: float) -> void:
	var hand_detected: Vector2 = Vector2(0,0)
	
	if player.arm_r_attacking:
		if arm_r.current_health == 2:
			hand_detected = Vector2(0,2)
		else:
			hand_detected = Vector2(0,1)
	
	if player.arm_l_attacking:
		if arm_l.current_health == 2:
			hand_detected = Vector2(2,0)
		else:
			hand_detected = Vector2(1,0)
			
	hand_offsetting_to(hand_detected)
		
func hand_offsetting_to(hand_detected: Vector2):
	var hand_set: Marker3D = hand_r_hurt
	match hand_detected:
		Vector2(0,1):
			hand_set = hand_r_hurt
		Vector2(0,2):
			hand_set = hand_r
		Vector2(1,0):
			hand_set = hand_l_hurt
		Vector2(2,0):
			hand_set = hand_l
		_:
			pass
	
	var cursorPosition : Vector2 = Vector2(camera.unproject_position(hand_set.global_position))
	var rayStartPoint : Vector3 = camera.project_ray_origin(cursorPosition)
	var rayDirection : Vector3 = camera.project_ray_normal(cursorPosition)
	var goTo = planeToMoveOn.intersects_ray(rayStartPoint, rayDirection)
	
	self.global_position = goTo
