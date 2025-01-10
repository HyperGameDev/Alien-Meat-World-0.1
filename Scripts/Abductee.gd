extends RigidBody3D

class_name Abductee

# Don't add onreadys because of Herbivore


@export var main_group: String = "Abductee"

var last_hovered_abductee_was_me : bool = false
var last_hovered_thing_not_abductee : bool = false

var is_interactable: bool = false
var clothing_top: StandardMaterial3D = null
var clothing_bottom: StandardMaterial3D = null
	
@export var is_type: is_types
enum is_types {COW, HUMAN, TREE1}

@export var indicator_color: Color = Color(.5, .5, 1.0, 1.0)

@export var always_spawn: bool = false
@export var is_empathy_event: bool = false
@export var is_enemy: bool = false
@export var is_military: bool = false
@export var is_armed: bool = false

var head_name: String
var heads_innocent: Array = [
	"Human_Head",
	"Human_Head_Afro",
	"Human_Head_Long-Hair-1"
	]
var head_military: String = "Human_Head_Army"
var heads_all: Array = []

@export var has_weapon: has_weapons
enum has_weapons {PISTOL,STUN,SEMI,AR,SHOTG,SHOTG2,SNIPER,RL}

var current_weapon: String
var bullet_pos1: Marker3D
var bullet_pos2: Marker3D

var shoot_points: Array = []


@export var dialogue_box_on_right: bool = false
@export var abduction_offset: Vector3 = Vector3(0,.5,0)

# If we decide on different meats having different values, use this (or another) value to add the meat to a different dunked group that can then be calculated differently by the score dunk.
#@export var score_value = 1


@onready var detect_surface: RayCast3D = $RayCast_surfaceDetect
@onready var interactable_indicator: MeshInstance3D = $Mesh_Interactable

@onready var interact_zone: Node3D = get_tree().get_current_scene().get_node("UI_Interaction")

@onready var camera : Camera3D =  get_tree().get_current_scene().get_node("Camera3D")
@onready var player : CharacterBody3D =  get_tree().get_current_scene().get_node("Player")
@onready var player_target : Area3D = get_tree().get_current_scene().get_node("Player/Alien_V3/DetectionAreas/Area_Feed")
@onready var collision : CollisionShape3D = $CollisionShape3D
#@onready var grab_target: Node3D = get_tree().get_current_scene().get_node("Player/Grab_Target/Grab_Target_offset")
@onready var grab_target: Node3D = get_tree().get_current_scene().get_node("Player/Grab_Target")

var aim_bone_index: int = 3
var has_skeleton: bool = false
@export var skeleton: Skeleton3D
@export var parachute: MeshInstance3D
@export var human_arm_l: MeshInstance3D
@export var human_arm_r: MeshInstance3D
@export var human_body: MeshInstance3D
@export var human_leg_l: MeshInstance3D
@export var human_leg_r: MeshInstance3D 

@export var military_boot: StandardMaterial3D = load("res://NPCs/Humans/textures/human_shoes_brwn_01.tres") as StandardMaterial3D

var head_string: String

@export var velocity : int = 60
@export var grab_distance_offset : float = 14.0

var has_been_grabbed : bool = false

var is_in_dunk : bool = false
var has_been_dunked : bool = false

var default_material := StandardMaterial3D.new()
var hover_material := StandardMaterial3D.new()
var select_material := StandardMaterial3D.new()

var is_available : bool = false
var is_clone : bool = false
var spawned : bool = false
var is_parachuting: bool = false


var fell : bool = false

@onready var hand_pos : Marker3D =  get_tree().get_current_scene().get_node("Player/Alien_V3/DetectionAreas/Area_ArmR/Marker_HandR")

func _ready():
	prepare_heads()
	visible = false
	if !has_node("RayCast_surfaceDetect"):
		print("ERROR: Somewhere, a surface detecting child is missing!")
		breakpoint
		
	if !has_node("Mesh_Interactable"):
		print("ERROR: Somewhere, a Mesh interactable child is missing!")
		breakpoint

	
	camera = get_viewport().get_camera_3d()

	set_collision_mask_value(Globals.collision.GROUND, true)
	set_collision_mask_value(Globals.collision.PLAYER, false)
	
	add_to_group(main_group)
	
	Messenger.abductee_hovered.connect(on_abductee_hovered)
	Messenger.grab_begun.connect(on_grab_begun)
	Messenger.grab_ended.connect(on_grab_ended)
	
	Messenger.meat_entered_dunk.connect(on_meat_entered_dunk)
	Messenger.meat_left_dunk.connect(on_meat_left_dunk)
	Messenger.dunk_is_at_position.connect(on_dunk_is_at_position)
	
	
	# Setting up meat material changes based on cursor behavior
	default_material.set_albedo(Color(.32, .75, .35))
	hover_material.set_albedo(Color(.32, .75, .35))
	select_material.set_albedo(Color(1.0, .0, .1))
	
	
	interactable_indicator.get_node("AnimationPlayer").play("interactable")
	interactable_indicator.visible = false
	
	
	if is_empathy_event:
		var dialogue = preload("res://UI/Dialogue/dialogue_in_scene.tscn").instantiate()
		add_child(dialogue)
		dialogue.global_position = %Marker_Dialogue.global_position
		dialogue.global_rotation = %Marker_Dialogue.global_rotation
		if dialogue_box_on_right:
			
			var right_offset: float = %Marker_Dialogue.global_position.x + dialogue.dialogue_offset_pos
			dialogue.is_right = true
			dialogue.global_position.x = right_offset
		else:
			var left_offset: float = %Marker_Dialogue.global_position.x - dialogue.dialogue_offset_pos
			dialogue.is_right = false
			dialogue.global_position.x = left_offset	
	
	
	
func _process(_delta: float) -> void:
	if is_enemy:
		look_at_player()
	if is_in_dunk:
		Messenger.meat_in_dunk.emit(self)
		has_been_dunked = true
		
		
func look_at_player():
	if !is_parachuting:
		aim_bone_at_target(aim_bone_index,player_target,1.0,false)
		
func aim_bone_at_target(bone_index:int, target:Node3D, amount:float, reset:bool):
	
	if !has_skeleton:
		return
	
	# Sets the local transform of the bone, local to its skeleton
	var bone_transform = skeleton.get_bone_global_pose_no_override(bone_index)
	
	if reset:
		skeleton.set_bone_global_pose_override(aim_bone_index,bone_transform,amount,false)
		
		return

	var target_pos: Vector3 = skeleton.to_local(target.global_position)
		
	var direction = (target_pos - bone_transform.origin).normalized()

	
	# Defining a "new transform"
	var new_transform: Transform3D = bone_transform
	
	# Running transform look at
	new_transform = transform_look_at(new_transform, direction)
	
	skeleton.set_bone_global_pose_override(bone_index,new_transform,amount,true)


func transform_look_at(_transform: Transform3D, direction: Vector3) -> Transform3D:
	var xform: Transform3D = _transform
	xform.basis.z = direction
	
	xform.basis.x = xform.basis.y.cross(direction).normalized()
	
	xform.basis.y = xform.basis.z.cross(xform.basis.x).normalized()
	
	xform.basis = xform.basis.orthonormalized()
	return xform
	

func _physics_process(_delta: float) -> void:
	interactable_indicator.global_position.x = global_position.x
	interactable_indicator.global_position.z = global_position.z
	
	grabbed_check()
	spawn_check()
	availability_check()
	y_axis_removal_check()
	z_axis_removal_check()
	dropping_to_dropped()
		
		
func grabbed_check():
	if has_been_grabbed:
		_be_held()
		
func spawn_check():
	if !spawned:
		spawn_me()	
	else:
		if is_interactable:
			set_collision_layer_value(Globals.collision.ABDUCTEE, true)
		else:
			set_collision_layer_value(Globals.collision.ABDUCTEE, false)
				
func availability_check():
	if is_available:
		set_collision_layer_value(Globals.collision.ABDUCTEE_INTERACT, true)
		visible = true
		
	else:
		set_collision_layer_value(Globals.collision.ABDUCTEE, false)
		visible = false
		
func y_axis_removal_check():
	if self.global_position.y <= -50:
		if is_in_group("Dropped"):
			pass
			#print("Dropped Meat Object deleted by Y")
		else:
			if !fell:
				fell = true
				#print("DEFAULT Meat Object deleted by Y")
		queue_free()

func z_axis_removal_check():
	if self.global_position.z >= Globals.behind_camera_pos:
		if is_in_group("Dropped"):
			#print("Dropped Meat Object deleted by Z")
			queue_free()
			
func dropping_to_dropped():
	if is_in_group("Dropping") and detect_surface.is_colliding():
		#print(name," is colliding")
		remove_from_group("Dropping")
		add_to_group("Dropped")
		if is_parachuting:
			parachuting(false)
		if interact_zone.interact_area.get_overlapping_bodies().has(self):
			is_interactable = true
			interactable_indicator.visible = true
		if !detect_surface.get_collider() == self.get_parent():
			self.reparent(detect_surface.get_collider().get_owner())

func _drop_me():
	is_interactable = false
	has_been_grabbed = false
	add_to_group("Dropping")
	remove_from_group("Grabbed")
	#print(name, " removed from group Grabbed")
	linear_velocity = Vector3.ZERO	

func on_abductee_hovered(target): # Called when ABDUCTEE_INTERACT layer is seen by abduct_ray
	if target == self:
		if has_node("Marker3D"):
			#print("Something hovered emitted! On ",self,"!")
			Messenger.something_hovered.emit(self)
				
func spawn_me():
	spawned = true
	if not is_in_group("Grabbed"):
		if not is_in_group("Dunked"):
			var boolean = pow(-1, randi() % 2)
			if boolean > 0 or always_spawn:
				is_available = true
				if is_type == is_types.HUMAN:
					setup_human_appearance(true)
			else:
				is_available = false

func prepare_heads():
	for head in heads_innocent:
		heads_all.append(head)
	heads_all.append(head_military)

func setup_human_appearance(should_randomize):
	if should_randomize:
		if is_military:
			clothing_bottom = Globals.human_enemy_bottoms.pick_random()
			clothing_top = Globals.human_enemy_tops.pick_random()
			
			head_name = head_military
				
		else: # Not military
			clothing_bottom = Globals.human_bottoms.pick_random()
			clothing_top = Globals.human_tops.pick_random()
			
			var random_head = heads_innocent.pick_random()
			head_name = random_head
	
	apply_human_appearance()
	
func apply_human_appearance():
	if is_armed:
		assign_weapon()
		
	assign_head()
	assign_skeleton()
		
	human_arm_l.set_surface_override_material(0, clothing_top)
	human_arm_r.set_surface_override_material(0, clothing_top)
	human_arm_l.set_surface_override_material(1, clothing_top)
	human_arm_r.set_surface_override_material(1, clothing_top)
	
	human_body.set_surface_override_material(0, clothing_top)
	human_body.set_surface_override_material(1, clothing_top)
	human_body.set_surface_override_material(2, clothing_top)
	
	human_leg_l.set_surface_override_material(0, clothing_bottom)
	human_leg_r.set_surface_override_material(0, clothing_bottom)
	human_leg_l.set_surface_override_material(1, clothing_bottom)
	human_leg_r.set_surface_override_material(1, clothing_bottom)
	
	if is_military:
		human_leg_l.set_surface_override_material(2, military_boot)
		human_leg_r.set_surface_override_material(2, military_boot)
		human_leg_l.set_surface_override_material(3, military_boot)
		human_leg_r.set_surface_override_material(3, military_boot)
		
func assign_head():
	for head: String in heads_all:
		get_node("human_03_GIANT_00/Armature/Skeleton3D/" + head).visible = false
		
	var current_head_string: String = "human_03_GIANT_00/Armature/Skeleton3D/" + head_name
	
	get_node(current_head_string).visible = true
	
func assign_skeleton():
	skeleton = get_node("human_03_GIANT_00/Armature/Skeleton3D/")
	has_skeleton = true
		
func on_dunk_is_at_position(dunk_position):
	if has_been_dunked:
		self.global_position = dunk_position - abduction_offset
		collision.disabled = true
		aim_bone_at_target(aim_bone_index,player_target,1.0,true)
		self.add_to_group("Dunked")
		

func on_grab_begun(target):
	if target == self:
		has_been_grabbed = true
		
func _be_held():
	interactable_indicator.visible = false

	self.global_position = grab_target.global_position
	look_at_player()
	
func on_grab_ended():
	if not is_enemy:	
		aim_bone_at_target(aim_bone_index,player_target,1.0,true)
		
	if is_in_group("Grabbed"):
		#print(name,": thinks grab ended")
		_drop_me()

func on_meat_entered_dunk(dunked_body):
	if dunked_body == self:
		is_in_dunk = true
		
func on_meat_left_dunk(dunked_body):
	if dunked_body == self:
		is_in_dunk = false
	
func parachuting(make_parachuting):
	if make_parachuting:
		is_parachuting = true
		parachute.visible = true
	else:
		is_parachuting = false
		parachute.visible = false
		
func assign_weapon():
	#Ensures has_weapon is interpreted as a string, not an enum
	for key in ProjectileHandler.shooting_weapons.keys():
		if key == ProjectileHandler.shooting_weapons.keys()[has_weapon]:
			current_weapon = key
	
	var has_2_meshes: bool = ProjectileHandler.shooting_weapons[current_weapon]["has_2_meshes"]
	
	var weapon_mesh1_string: String = "human_03_GIANT_00/Armature/Skeleton3D/" + str(ProjectileHandler.shooting_weapons[current_weapon]["mesh"])
	
	var weapon_mesh2_string: String = "human_03_GIANT_00/Armature/Skeleton3D/" + str(ProjectileHandler.shooting_weapons[current_weapon]["mesh2"])
	
	var bullet_pos1_string: String = "Bullet_Positions/Gun_L/" + str(ProjectileHandler.shooting_weapons[current_weapon]["bullet_pos"])
	
	var bullet_pos2_string: String = "Bullet_Positions/Gun_R/" + str(ProjectileHandler.shooting_weapons[current_weapon]["bullet_pos2"])
	
	
	var weapon_mesh1: MeshInstance3D = get_node(weapon_mesh1_string)
	
	bullet_pos1 = get_node(bullet_pos1_string)
	
	
	weapon_mesh1.visible = true
	
	if has_2_meshes:
		var weapon_mesh2: MeshInstance3D = get_node(weapon_mesh2_string)
		weapon_mesh2.visible = true
		
		bullet_pos2 = get_node(bullet_pos2_string)
	else:
		bullet_pos2 = null
	
	
	var weapon_pose: String = "parameters/" + str(ProjectileHandler.shooting_weapons[current_weapon]["pose"]) + "/blend_amount"
	
	var animation: AnimationTree = get_node("human_03_GIANT_00/AnimationTree")
	animation.set(weapon_pose, 1.0)
	

func attack():
	var shooter: Node
	if is_clone:
		shooter = ProjectileHandler.main_scene
	else:
		shooter = self
		
	var shoot_target: Node
	shoot_target = player_target
	
	ProjectileHandler.projectile_request.emit(main_group,self,shooter,current_weapon,bullet_pos1,bullet_pos2,shoot_target)
