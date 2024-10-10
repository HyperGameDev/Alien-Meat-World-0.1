extends Node3D


@onready var player : CharacterBody3D =  get_tree().get_current_scene().get_node("Player")
@onready var camera: Camera3D = %Camera3D

@onready var hand_r: Marker3D = get_tree().get_current_scene().get_node("Player/Alien_V3/DetectionAreas/Area_ArmR/Marker_HandR")


var arm_r2_center: Vector2 = Vector2(750,400)
#@onready var wrist_position = %Grab_Target.cursorPosition
var cursor_position: Vector2

#@export var cursor_offset: Vector2 = Vector2(2,0)
@export var offset_offset_scale: float = 100.0

var planeToMoveOn : Plane

var cursor_pos_old : Vector2 = Vector2(0,0)

func _ready() -> void:
	planeToMoveOn = Plane(Vector3(0,0,1), player.global_position.z)

func capture_old_cursor_pos(cursor):
	await get_tree().create_timer(.1).timeout
	cursor_pos_old = cursor

func _process(delta: float) -> void:
#region Rogi's Code


	#step 2 defining the offset (this must happen in process to keep updating the offset)

	var cursor_pos : Vector2 = get_viewport().get_mouse_position()
	#var cursor_offset: Vector2 = Vector2(-40,-50)
	#
	#cursor_offset = camera.unproject_position(hand_r.global_position) - arm_r2_center

	#step 3 centering the cursor on the wrist and adding the offset (this must happen in process to keep updating the offset)

	#cursor_pos = arm_r2_center + cursor_offset
	#var cursor_pos : Vector2 = cursor_offset + get_viewport().get_mouse_position()
		
#endregion
	
	#capture_old_cursor_pos(cursor_pos)
	
	
	#if cursor_pos != cursor_pos_old:
		#cursor_pos = cursor_pos + cursor_offset
		#
	#else:
		#cursor_pos = get_viewport().get_mouse_position()
	#cursor_pos = cursor_pos + cursor_offset
	
	#cursor_offset = cursor_offset + Vector2(pow(cursor_offset.x,(cursor_pos.x/offset_offset_scale)),pow(cursor_offset.y,(cursor_pos.y/offset_offset_scale)))
	
	
#region Joe's Code
	#cursor_offset = cursor_offset + Vector2(offset_offset_scale,offset_offset_scale) * (10/cursor_pos.y)
	
	
#endregion
	
	
	var rayStartPoint : Vector3 = camera.project_ray_origin(cursor_pos)
	var rayDirection : Vector3 = camera.project_ray_normal(cursor_pos)
	var goTo = planeToMoveOn.intersects_ray(rayStartPoint, rayDirection)
	
	
	self.global_position = goTo
