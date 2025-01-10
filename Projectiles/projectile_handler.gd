extends Node

# Incoming
signal projectile_request 
	#arg1
		# str = node's group
	#arg2
		# node = actual requesting shooter
	#arg3
		# node = shoot point spawn path ("ProjectileHandler.main_scene" for main scene as parent)
	#arg4
		# str = weapon dictionary entry
	#arg5
		# Marker3D = shoot point pos 1
	#arg6
		# Marker3D = shoot point pos 2
	#arg7
		# node = target to shoot


@onready var main_scene: Node3D = get_tree().get_root().get_node("Main Scene/Spawned/Spawned_MainScene-Bullets")

var global_shooting_conditions := {
	"is_game_state_over": Globals.is_game_state != Globals.is_game_states.OVER,
	"bullets_allowed": Globals.bullets_allowed
}

var shooter_data := {
	"Vehicle": {
		"Conditions": {
			"is_dying": false,
			"is_moving": false,
		},
		"Properties": {
			"bullet_owner": preload("res://Projectiles/copter_projectile_01.tscn"),
		}
	},
	"Abductee": {
		"Conditions": {
			"is_armed": true,
			"is_empathy_event": false,
			"has_been_dunked": false,
			"is_available": true,
		},
		"Properties": {
			"bullet_owner": preload("res://Projectiles/human_projectile_01.tscn"),
		}
	}
}

var shooting_weapons := {
	PISTOL = {
		has_2_meshes = false,
		pose = "Gun_Pistol",
		bullet_pos = "Gun_L_Pistol",
		bullet_pos2 = null,
		mesh = "Gun_Pistol",
		mesh2 = "",
		speed = .5,
	},
	STUN = {
		has_2_meshes = false,
		pose = "Gun_Pistol",
		bullet_pos = "Gun_L_Stun",
		bullet_pos2 = null,
		mesh = "Gun_Stun",
		mesh2 = "",
		speed = .5,
	},
	SEMI = {
		has_2_meshes = false,
		pose = "Gun_AR",
		bullet_pos = "Gun_L_Semi",
		bullet_pos2 = null,
		mesh = "Gun_Semi",
		mesh2 = "",
		speed = .5,
	},
	AR = {
		has_2_meshes = false,
		pose = "Gun_AR",
		bullet_pos = "Gun_L_AR",
		bullet_pos2 = null,
		mesh = "Gun_AR",
		mesh2 = "",
		speed = .5,
	},
	SHOTG = {
		has_2_meshes = false,
		pose = "Gun_AR",
		bullet_pos = "Gun_L_ShotG",
		bullet_pos2 = null,
		mesh = "Gun_ShotG",
		mesh2 = "",
		speed = .5,
	},
	SHOTG2 = {
		has_2_meshes = true,
		pose = "Gun_ShotG_2",
		bullet_pos = "Gun_L_ShotG",
		bullet_pos2 = "Gun_R_ShotG",
		mesh = "Gun_ShotG",
		mesh2 = "Gun_ShotG_2",
		speed = .5,
	},
	SNIPER = {
		has_2_meshes = false,
		pose = "Gun_Snipe",
		bullet_pos = "Gun_L_Snipe",
		bullet_pos2 = null,
		mesh = "Gun_Snipe",
		mesh2 = "",
		speed = .5,
	},
	RL = {
		has_2_meshes = true,
		pose = "Gun_RL",
		bullet_pos = "Gun_L_RL",
		bullet_pos2 = null,
		mesh = "Gun_Rocket",
		mesh2 = "Gun_RL",
		speed = .5,
	}
}


func _ready() -> void:
	Messenger.game_prebegin.connect(on_game_prebegin)
	projectile_request.connect(on_projectile_request)

func on_game_prebegin(): # For updating variables after a Restart
	main_scene = get_tree().get_root().get_node("Main Scene/Spawned/Spawned_MainScene-Bullets")

func on_projectile_request(shooter_group, requesting_shooter, spawn_point_host, weapon, point_1_marker, point_2_marker, target):
	if can_shoot(shooter_group, requesting_shooter):
		set_shoot_properties(shooter_group, requesting_shooter, spawn_point_host, weapon, point_1_marker, point_2_marker, target)
	else:
		print("Projectile Handler: ",requesting_shooter," DENIED to shoot!")

func can_shoot(shooter_group: String, requesting_shooter: Node) -> bool:
	for group_name in shooter_data.keys():
		if shooter_group == group_name:
			return check_conditions(shooter_data[group_name]["Conditions"], global_shooting_conditions, requesting_shooter)
	print("Projectile Handler: Shooter group '", shooter_group, "' not found in shooter_data.")
	return false

func check_conditions(group_conditions: Dictionary, global_shooting_conditions: Dictionary, requesting_shooter: Node) -> bool:
	for key in global_shooting_conditions.keys():
		if not global_shooting_conditions[key]:
			print("Projectile Handler: Global condition '", key, "' is not met.")
			return false

	for key in group_conditions.keys():
		var actual_value = requesting_shooter.get(key)
		var expected_value = group_conditions[key]
		
		if actual_value == null:
			print("Projectile Handler: Requesting shooter does not have property '", key, "'.")
			return false
		
		if actual_value != expected_value:
			print("Projectile Handler: Condition '", key, "' is not met for requesting shooter. Expected: ", expected_value, ", but got: ", actual_value)
			return false

	return true


	

func set_shoot_properties(shooter_group, requesting_shooter, spawn_point_host, weapon, point_1_marker, point_2_marker, target):
	var shooter: Node
	
	if spawn_point_host == main_scene:
		shooter = main_scene
	else:
		shooter = spawn_point_host
		
	var bullet_scene: PackedScene = shooter_data[shooter_group]["Properties"]["bullet_owner"]

	create_shoot_point(shooter,requesting_shooter,weapon,point_1_marker,point_2_marker,bullet_scene,target)
	
	
func create_shoot_point(shooter, requesting_shooter, weapon, point_1_marker, point_2_marker, bullet_scene, target):
	setup_shoot_point(shooter, requesting_shooter, weapon, point_1_marker, bullet_scene, target)

	if shooting_weapons[weapon]["has_2_meshes"]:
		setup_shoot_point(shooter, requesting_shooter, weapon, point_2_marker, bullet_scene, target)
		print("Projectile Handler: Second spawn point detected at ", point_2_marker)


func setup_shoot_point(shooter, requesting_shooter: Node, weapon, marker, bullet_scene, target):

	var shoot_point = preload("res://Projectiles/shoot_point.tscn").instantiate()
	
	shooter.add_child(shoot_point)
	print("Projectile Handler: Shoot Point ",shoot_point," added to ",shooter," for use by ",requesting_shooter)
	requesting_shooter.shoot_points.append(shoot_point)
	
	shoot_point.shooting_weapon = weapon
	shoot_point.point_marker = marker
	shoot_point.bullet_scene = bullet_scene
	shoot_point.target = target
	shoot_point.requesting_shooter = requesting_shooter
