@tool

extends Node3D


@onready var target = %"DEBUG_Grab-Target"
@onready var skeleton: Skeleton3D = get_node("Armature/Skeleton3D")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	aim_bone_at_target(6, target)
#	stretch_to_target()

#func stretch_to_target():
#	skeleton.set_bone_pose_scale()

func aim_bone_at_target(bone_index:int, target:Node3D):
	var bone_transform = skeleton.get_bone_global_pose_no_override(bone_index)
	
	var bone_origin = bone_transform.origin
	if(target == null):
		skeleton.set_bone_global_pose_override(bone_index,bone_transform,1.0,false)
		return
		
	
	var target_pos = skeleton.to_local(target.global_position)
	var direction = (target_pos - bone_transform.origin).normalized()
	
	var new_transform:Transform3D = bone_transform
	new_transform.origin = bone_origin
	
	new_transform = transform_look_at(new_transform, direction)

# 1.0 float could be tweened into for gradual rotation?	
	skeleton.set_bone_global_pose_override(bone_index,new_transform,1.0,true)


func transform_look_at(_transform,direction):
	var xform:Transform3D = _transform
	xform.basis.y = direction
	xform.basis.x = -xform.basis.z.cross(direction)
	xform.basis = xform.basis.orthonormalized()
#	stretch_to_target()
	return xform
