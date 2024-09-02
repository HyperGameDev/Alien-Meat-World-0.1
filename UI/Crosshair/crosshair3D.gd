extends MeshInstance3D


@onready var player : CharacterBody3D =  get_tree().get_current_scene().get_node("Player")
@onready var camera: Camera3D = %Camera3D
#@onready var animation: AnimationPlayer = $AnimationPlayer

var planeToMoveOn : Plane

func _ready() -> void:
	planeToMoveOn = Plane(Vector3(0,0,1), 5.5)

func _process(delta: float) -> void:
	print(get_parent().get_parent().name)
	var cursorPosition : Vector2 = get_viewport().get_mouse_position()
	#print(cursorPosition_offset)
	var rayStartPoint : Vector3 = camera.project_ray_origin(cursorPosition)
	var rayDirection : Vector3 = camera.project_ray_normal(cursorPosition)
	var goTo = planeToMoveOn.intersects_ray(rayStartPoint, rayDirection)
	
	
	self.global_position = goTo
