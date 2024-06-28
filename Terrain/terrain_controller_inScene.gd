extends Node3D

var chunk_add_ok = false

var score_minimum_met = false

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

## Number of starting chunks
@export var starting_chunks_max = 7
var starting_chunks_current = 0
var starting_chunks_over = false

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
var chunks_list_01 = []
var chunks_list_02 = []
var chunks_list_03 = []
var chunks_list_04 = []
var chunks_list_05 = []

@onready var chunks_list_01_level01 = [
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
@onready var chunks_list_02_level01 = [
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
	Messenger.score_minimum_met.connect(on_score_minimum_met)
	Messenger.level_update.connect(on_level_update)
	
	chunks_path_safes = Globals.current_safe_chunks
	chunks_path_obstacles = Globals.current_obstacle_chunks
	chunks_path_points = Globals.current_points_chunks
	
	# Establishes all starting "lists" as safe chunks
	chunks_list_01 = chunks_list_safes
	chunks_list_02 = chunks_list_safes
	chunks_list_03 = chunks_list_safes
	chunks_list_04 = chunks_list_safes
	chunks_list_05 = chunks_list_safes

	_load_terrain_scenes(chunks_path_safes,chunks_path_obstacles,chunks_path_points)
	_init_chunks(num_terrain_chunks)
	
func on_score_minimum_met():
	score_minimum_met = true
	

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

func chunks_for_level():
	# Updating lists-of-chunks-to-choose with level-relevant cunks, when starting ones are over.
	if starting_chunks_over:
		if Globals.level_current <= 1:
			chunks_list_01 = chunks_list_01_level01
			chunks_list_02 = chunks_list_02_level01

func chunk_chosen_to_add():			
	if chunks_list_current.size() == 0:
		chunks_list_current = [chunks_list_01,chunks_list_02].pick_random().duplicate()
	
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
		#print("1st popped: ",first_terrain,"; chunk_to_add: ",chunk_to_add)
		print_rich("[font size=15][color=red][b]First popped: [/b][/color]",first_terrain,"; \n \t[i]pos:[/i] ",first_terrain.position,"; \n \t[i]level:[/i] ",first_terrain.is_level,"; \n \t[i]parent:[/i] ",first_terrain.get_parent(),"\n")
		
		
		if !first_terrain.is_level == Globals.level_current:
			#(func():await get_tree().process_frame;first_terrain.queue_free.call_deferred()).call_deferred()
			#first_terrain.queue_free.call_deferred()
			
			first_terrain.queue_free()
		else:
			
			
			

			if first_terrain.is_type == Block.is_types.SAFE:
				# If starting chunks are not done, increase chunk count
				if !starting_chunks_over and !starting_chunks_current == starting_chunks_max:
					starting_chunks_current += 1
				# If starting chunks are done, stop counting and update the level 
				else:
					starting_chunks_over = true
					chunks_for_level()
					
				#print("Returned a SAFE chunk")
				# Reparent the removed chunk to the collector(s)
				first_terrain.reparent(collector_safes)
				# Move removed chunk to the collectors' position
				first_terrain.position.z = 0.0
				# Make sure chunk has reset potential (temporary logic)
				if first_terrain.has_method("reset_block_objects"):
				# Run the reset function to check if objects need resetting.
					first_terrain.reset_block_objects()
				
			if first_terrain.is_type == Block.is_types.OBSTACLE:
				#print("Returned an OBSTACLE chunk")
				first_terrain.reparent(collector_obstacles)
				first_terrain.position.z = 0.0
				if first_terrain.has_method("reset_block_objects"):
					first_terrain.reset_block_objects()
					
			if first_terrain.is_type == Block.is_types.POINTS:
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
		print_rich("[font size=15][color=green][b]Last added: [/b][/color]",chunk_add,"; \n \t[i]pos:[/i] ",chunk_add.position,"; \n \t[i]level:[/i] ",chunk_add.is_level,"; \n \t[i]parent:[/i] ",chunk_add.get_parent(),"\n")
		# Add the new chunk to the end of the level
		_append_to_far_edge(last_terrain, chunk_add)



func _append_to_far_edge(target_block: MeshInstance3D, appending_block: MeshInstance3D) -> void:
	appending_block.position.z = target_block.position.z - target_block.mesh.size.y/2 - appending_block.mesh.size.y/2
	
	#print("Last added: ",target_block, " at ",target_block.position.z,"; chunk_to_add: ",chunk_to_add)
	
	


func _load_terrain_scenes(chunks_path_safes: String, chunks_path_obstacles: String, chunks_path_points: String) -> void:
	
	var dir_safes = DirAccess.open(chunks_path_safes)
	for safes_path in dir_safes.get_files():
		# Adds files as nodes to the Terrain Collector (I think)
		Chunks_Safes.append(load(chunks_path_safes + "/" + safes_path.trim_suffix(".remap")))
		
	var dir_obstacles = DirAccess.open(chunks_path_obstacles)
	for obstacles_path in dir_obstacles.get_files():
		Chunks_Obstacles.append(load(chunks_path_obstacles + "/" + obstacles_path.trim_suffix(".remap")))
		
	var dir_points = DirAccess.open(chunks_path_points)
	for points_path in dir_points.get_files():
		Chunks_Points.append(load(chunks_path_points + "/" + points_path.trim_suffix(".remap")))
		
func on_level_update(level):
	print("Controller tried updating paths")
	chunks_path_safes = Globals.current_safe_chunks
	chunks_path_obstacles = Globals.current_obstacle_chunks
	chunks_path_points = Globals.current_points_chunks
	
	Chunks_Safes.clear()
	Chunks_Obstacles.clear()
	Chunks_Points.clear()
	
	_load_terrain_scenes(Globals.current_safe_chunks,Globals.current_obstacle_chunks,Globals.current_points_chunks)
	chunks_update()
	
