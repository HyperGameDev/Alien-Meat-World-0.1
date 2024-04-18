extends Node3D

@onready var terrain_collector = %TerrainCollector

var debug_counter = 0

## Holds the catalog of loaded terrian block scenes
var TerrainBlocks: Array = []

## The set of terrian blocks which are currently rendered to viewport
var terrain_belt: Array[MeshInstance3D] = []
@export var terrain_velocity: float = 5.0
const TERRAIN_VELOCITY: float = 5.0

## The number of blocks to keep rendered to the viewport
@export var num_terrain_blocks = 7

## Path to directory holding the terrain block scenes
@onready var debug_menu = %Menu
var terrain_blocks_path : StringName

func _ready() -> void:
	terrain_blocks_path = Globals.current_level
	_load_terrain_scenes(terrain_blocks_path)
	_init_blocks(num_terrain_blocks)
	#_first_blocks()

#func _first_blocks():
	#await get_tree().create_timer(.2).timeout
	#terrain_blocks_path = "res://Terrain/terrain_debug/"
	#print("Blocks path changed")
	#_load_terrain_scenes(terrain_blocks_path)

func _physics_process(delta: float) -> void:
	_progress_terrain(delta)
#	print(terrain_velocity)


func _init_blocks(number_of_blocks: int) -> void:
	for TerrainBlock in TerrainBlocks:
		var block =  TerrainBlock.instantiate()
		terrain_collector.add_child(block)
		
	for i in range(num_terrain_blocks):
		var block = terrain_collector.get_children().pick_random()
		block.reparent(self)
		
	
		
		#if TerrainBlock == 0:
			#
			## Push first block forward by half its distance (so that player is at the far edge of the first block)
			#block.position.z = block.mesh.size.y/2 
			#
		#else:
			#
			## If not the first block, append it to the far edge of the belt.
			#_append_to_far_edge(terrain_belt[block_index-1], block)
		#add_child(block)
		#terrain_belt.append(block)


func _progress_terrain(delta: float) -> void:
	for block in self.get_children():
		block.position.z += terrain_velocity * delta
	
	if get_child(0).position.z >= get_child(0).mesh.size.y/2:
		
		# -1 here means "the last block in the array i.e. the highest number"
		var last_terrain = get_child(-1)
		
		# Pop_front removes the first block from the array only, and then returns the name of that removed block.
		var first_terrain = get_children().pop_front()

		first_terrain.reparent(terrain_collector)
		first_terrain.position.z = 0.0
		if first_terrain.has_method("reset_block_objects"):
			first_terrain.reset_block_objects()
			
		
		#var block_instance = first_terrain.get_node_or_null("Block_Instance")
		#if is_instance_valid(block_instance):
			#print(block_instance.hello)
			#pass
		
		var block = terrain_collector.get_children().pick_random()
		block.reparent(self)
		_append_to_far_edge(last_terrain, block)



func _append_to_far_edge(target_block: MeshInstance3D, appending_block: MeshInstance3D) -> void:
	appending_block.position.z = target_block.position.z - target_block.mesh.size.y/2 - appending_block.mesh.size.y/2


func _load_terrain_scenes(target_path: String) -> void:
	var dir = DirAccess.open(target_path)
	for scene_path in dir.get_files():
#		print("Loading terrian block scene: " + target_path + "/" + scene_path)
		TerrainBlocks.append(load(target_path + "/" + scene_path.trim_suffix(".remap")))
