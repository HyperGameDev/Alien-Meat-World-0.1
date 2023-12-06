extends Node3D
class_name TerrainController
## This builds and operates the terrain "conveyor belt"
##
## A set of randomly choosen terrain blocks is rendered to the viewport.
## As the game played the terrian is moved in the posative Z direction.
## When a given block passes behind this node it is removed and a new block
## is added to the far end of the conveyor

## Holds the catalog of loaded terrian block scenes
var TerrainBlocks: Array = []
## The set of terrian blocks which are currently rendered to viewport
var terrain_belt: Array[MeshInstance3D] = []
@export var terrain_velocity: float = 10.0
## The number of blocks to keep rendered to the viewport
@export var num_terrain_blocks = 4
## Path to directory holding the terrain block scenes
@export_dir var terrian_blocks_path = "res://terrain_blocks"


func _ready() -> void:
	_load_terrain_scenes(terrian_blocks_path)
	_init_blocks(num_terrain_blocks)


func _physics_process(delta: float) -> void:
	_progress_terrain(delta)


func _init_blocks(number_of_blocks: int) -> void:
	for block_index in number_of_blocks:
		var block = TerrainBlocks.pick_random().instantiate()
		if block_index == 0:
			block.position.z = block.mesh.size.y/2
		else:
			_append_to_far_edge(terrain_belt[block_index-1], block)
		add_child(block)
		terrain_belt.append(block)


func _progress_terrain(delta: float) -> void:
	for block in terrain_belt:
		block.position.z += terrain_velocity * delta

	if terrain_belt[0].position.z >= terrain_belt[0].mesh.size.y/2:
		var last_terrain = terrain_belt[-1]
		var first_terrain = terrain_belt.pop_front()

		var block = TerrainBlocks.pick_random().instantiate()
		_append_to_far_edge(last_terrain, block)
		add_child(block)
		terrain_belt.append(block)
		first_terrain.queue_free()


func _append_to_far_edge(target_block: MeshInstance3D, appending_block: MeshInstance3D) -> void:
	appending_block.position.z = target_block.position.z - target_block.mesh.size.y/2 - appending_block.mesh.size.y/2


func _load_terrain_scenes(target_path: String) -> void:
	var dir = DirAccess.open(target_path)
	for scene_path in dir.get_files():
		print("Loading terrian block scene: " + target_path + "/" + scene_path)
		TerrainBlocks.append(load(target_path + "/" + scene_path))
