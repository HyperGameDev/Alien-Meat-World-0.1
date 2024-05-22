extends Node3D

@onready var collector_safes = %Collector_Safes
@onready var collector_obstacles = %Collector_Obstacles
@onready var collector_points = %Collector_Points

## Holds the catalog of loaded terrian block scenes
var Chunks_Safes: Array = []
var Chunks_Obstacles: Array = []
var Chunks_Points: Array = []

## The set of terrian chunks which are currently rendered to viewport
var terrain_belt: Array[MeshInstance3D] = []
@export var terrain_velocity: float = 11.0
const TERRAIN_VELOCITY: float = 11.0

## The number of chunks to keep rendered to the viewport
@export var num_terrain_chunks = 9

## Paths to directories holding the terrain chunks scenes
var safe_chunks_path : StringName
var obstacle_chunks_path : StringName
var points_chunks_path : StringName


func _ready() -> void:
	safe_chunks_path = Globals.current_safe_chunks
	obstacle_chunks_path = Globals.current_obstacle_chunks
	points_chunks_path = Globals.current_points_chunks
	_load_terrain_scenes(safe_chunks_path,obstacle_chunks_path,points_chunks_path)
	_init_chunks(num_terrain_chunks)
	

func _physics_process(delta: float) -> void:
	_progress_terrain(delta)


func _init_chunks(num_terrain_chunks: int) -> void: ## Adds files to the correct nodes at game start
	# GETTING AN ERROR? You probably added a non-scene file into your level folder. You're welcome.
	for LevelChunk in Chunks_Safes:
		var chunk =  LevelChunk.instantiate()
		collector_safes.add_child(chunk)
	
	for LevelChunk in Chunks_Obstacles:
		var chunk =  LevelChunk.instantiate()
		collector_obstacles.add_child(chunk)
			
	for LevelChunk in Chunks_Points:
		var chunk =  LevelChunk.instantiate()
		collector_points.add_child(chunk)
		
	# Setup first chunks to spawn in
	for i in range(num_terrain_chunks):
		var chunk = collector_safes.get_children().pick_random()
		chunk.reparent(self)


func _progress_terrain(delta: float) -> void:
	for block in self.get_children():
		block.position.z += terrain_velocity * delta
		
	# Remove first block if it passes a certain spot
	if get_child(0).position.z >= get_child(0).mesh.size.y *2:
		
		# -1 means "the last block in the array
		# i.e. the highest number"
		var last_terrain = get_child(-1)
		
		# Pop_front removes the first block from the array only,
		# and then returns the name of that removed block.
		var first_terrain = get_children().pop_front()

		first_terrain.reparent(collector_safes)
		first_terrain.position.z = 0.0
		if first_terrain.has_method("reset_block_objects"):
			first_terrain.reset_block_objects(first_terrain)
		
		var block = collector_safes.get_children().pick_random()
		block.reparent(self)
		_append_to_far_edge(last_terrain, block)



func _append_to_far_edge(target_block: MeshInstance3D, appending_block: MeshInstance3D) -> void:
	appending_block.position.z = target_block.position.z - target_block.mesh.size.y/2 - appending_block.mesh.size.y/2
	


func _load_terrain_scenes(safe_chunks_path: String, obstacle_chunks_path: String, points_chunks_path: String) -> void:
	
	var dir_safes = DirAccess.open(safe_chunks_path)
	for safes_path in dir_safes.get_files():
		# Adds files as nodes to the Terrain Controller
		Chunks_Safes.append(load(safe_chunks_path + "/" + safes_path.trim_suffix(".remap")))
		
	var dir_obstacles = DirAccess.open(obstacle_chunks_path)
	for obstacles_path in dir_obstacles.get_files():
		Chunks_Obstacles.append(load(obstacle_chunks_path + "/" + obstacles_path.trim_suffix(".remap")))
		
	var dir_points = DirAccess.open(points_chunks_path)
	for points_path in dir_points.get_files():
		Chunks_Points.append(load(points_chunks_path + "/" + points_path.trim_suffix(".remap")))
