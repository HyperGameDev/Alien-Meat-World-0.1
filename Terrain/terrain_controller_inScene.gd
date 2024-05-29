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
var chunks_path_safes : StringName
var chunks_path_obstacles : StringName
var chunks_path_points : StringName

## Likelihood that certain chunks will spawn
@export var chunk_likelihood_safes = .3
@export var chunk_likelihood_obstacles = .2
@export var chunk_likelihood_points = .5

## Level Chunk Setup
var chunks_list_current = []
@onready var chunk_to_add = collector_safes.get_children().pick_random()
var chunk_wait = false

## Level Chunks Playlists
@onready var chunks_list_various_01 = [
	collector_safes,
	collector_safes,
	collector_points,
	collector_obstacles,
	collector_safes,
	collector_points,
	collector_safes,
	collector_points,
	collector_safes,
	collector_safes,
	collector_points,
	collector_safes,
	collector_safes,
	collector_points,
	collector_points,
	collector_obstacles,
	collector_points,
	collector_safes,
	collector_points,
	collector_safes,
	collector_safes
	]
@onready var chunks_list_various_02 = [
	collector_safes,
	collector_safes,
	collector_points,
	collector_points,
	collector_safes,
	collector_obstacles,
	collector_safes,
	collector_points,
	collector_points,
	collector_safes,
	collector_safes,
	collector_safes,
	collector_points,
	collector_safes,
	collector_obstacles,
	collector_points,
	collector_safes,
	collector_safes,
	collector_safes,
	collector_points,
	collector_safes,
	]
@onready var chunks_list_safes = [
	collector_safes,
	collector_safes,
	collector_safes,
	collector_safes,
	collector_safes,
	collector_safes,
	collector_safes,
	collector_safes,
	collector_safes
	]


func _ready() -> void:
	Messenger.level_update.connect(on_level_update)
	
	chunks_path_safes = Globals.current_safe_chunks
	chunks_path_obstacles = Globals.current_obstacle_chunks
	chunks_path_points = Globals.current_points_chunks
	_load_terrain_scenes(chunks_path_safes,chunks_path_obstacles,chunks_path_points)
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
		
		
func chunks_update():
	for LevelChunk in Chunks_Safes:
		var chunk =  LevelChunk.instantiate()
		collector_safes.add_child(chunk)
	
	for LevelChunk in Chunks_Obstacles:
		var chunk =  LevelChunk.instantiate()
		collector_obstacles.add_child(chunk)
			
	for LevelChunk in Chunks_Points:
		var chunk =  LevelChunk.instantiate()
		collector_points.add_child(chunk)


func chunk_chosen_to_add():
	if chunks_list_current.size() == 0:
		chunks_list_current = [chunks_list_various_01].pick_random().duplicate()
	
	chunk_to_add = chunks_list_current.pop_front()
	#print("Popped chunk: ", chunk_to_add)

func _progress_terrain(delta: float) -> void:
	
	# Advance chunks towards the player
	for chunk in self.get_children():
		chunk.position.z += terrain_velocity * delta
		
	# If the first chunk passes a certain spot
	if get_child(0).position.z >= get_child(0).mesh.size.y *2:
		
		# Assign the last chunk in the array (-1) to this var
		var last_terrain = get_child(-1)
		
		# Assign the first chunk to this var, and remove the chunk
		var first_terrain = get_children().pop_front()

		if first_terrain.is_type == 0:
			#print("Returned a SAFE chunk")
			# Reparent the removed chunk to the collector(s)
			first_terrain.reparent(collector_safes)
			# Move removed chunk to the collectors' position
			first_terrain.position.z = 0.0
			# Make sure chunk has reset potential (temporary logic)
			if first_terrain.has_method("reset_block_objects"):
			# Run the reset function to check if objects need resetting.
				first_terrain.reset_block_objects()
			
		if first_terrain.is_type == 1:
			#print("Returned an OBSTACLE chunk")
			first_terrain.reparent(collector_obstacles)
			first_terrain.position.z = 0.0
			if first_terrain.has_method("reset_block_objects"):
				first_terrain.reset_block_objects()
				
		if first_terrain.is_type == 2:
			#print("Returned a POINTS chunk")
			first_terrain.reparent(collector_points)
			first_terrain.position.z = 0.0
			if first_terrain.has_method("reset_block_objects"):
				first_terrain.reset_block_objects()
			
		var rng = randf()
		var chunk_add = collector_safes.get_children().pick_random()
		
		chunk_chosen_to_add()
		
		if collector_obstacles.get_children().size() > 0 and collector_points.get_children().size() > 0:
			
			chunk_add = chunk_to_add.get_children().pick_random()
			#match chunk_add.is_type:
				#0: 
					#print("SAFE")
				#1:
					#print("OBSTACLE")
				#2:
					#print("POINTS")
		
		#if rng >= .75:
			#if collector_obstacles.get_children().size() > 0 :
				#chunk_add = collector_obstacles.get_children().pick_random()
		#elif rng > .5: 
			#if collector_points.get_children().size() > 0:
				#chunk_add = collector_points.get_children().pick_random()
		
		# Choose a chunk to add in to the level
		chunk_add.reparent(self) 
		# Add the new chunk to the end of the level
		_append_to_far_edge(last_terrain, chunk_add)



func _append_to_far_edge(target_block: MeshInstance3D, appending_block: MeshInstance3D) -> void:
	appending_block.position.z = target_block.position.z - target_block.mesh.size.y/2 - appending_block.mesh.size.y/2
	


func _load_terrain_scenes(chunks_path_safes: String, chunks_path_obstacles: String, chunks_path_points: String) -> void:
	
	var dir_safes = DirAccess.open(chunks_path_safes)
	for safes_path in dir_safes.get_files():
		# Adds files as nodes to the Terrain Controller
		Chunks_Safes.append(load(chunks_path_safes + "/" + safes_path.trim_suffix(".remap")))
		
	var dir_obstacles = DirAccess.open(chunks_path_obstacles)
	for obstacles_path in dir_obstacles.get_files():
		Chunks_Obstacles.append(load(chunks_path_obstacles + "/" + obstacles_path.trim_suffix(".remap")))
		
	var dir_points = DirAccess.open(chunks_path_points)
	for points_path in dir_points.get_files():
		Chunks_Points.append(load(chunks_path_points + "/" + points_path.trim_suffix(".remap")))
		
func on_level_update(level):
	print("controller tried updating paths")
	chunks_path_safes = Globals.current_safe_chunks
	chunks_path_obstacles = Globals.current_obstacle_chunks
	chunks_path_points = Globals.current_points_chunks
	
	_load_terrain_scenes(chunks_path_safes,chunks_path_obstacles,chunks_path_points)
	chunks_update()
