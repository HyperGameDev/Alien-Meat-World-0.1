extends CanvasLayer

var show_fps = false
var old_player = true
var biped = true
@onready var debug_menu = %Menu
@onready var terrain_controller = %TerrainController_inScene
@onready var player = %Player
	
# Called when the node enters the scene tree for the first time.
func _process(delta):
	if OS.is_debug_build():
		if show_fps:
			%Label_showFPS.visible = true
			%Label_showFPS.text = "FPS: " + str(Engine.get_frames_per_second())
		else:
			%Label_showFPS.visible = false
	else:
		pass

func _input(event):
	#region devControls
	if OS.is_debug_build():
		if event.is_action_pressed("Debug 1"):
			Messenger.abduction.emit(1)
		if event.is_action_pressed("Debug 2"):
			for dmg_label in get_tree().get_nodes_in_group("Dmg_Labels_Player"):
				dmg_label.visible = !dmg_label.visible
		if event.is_action_pressed("Debug 3"): # Show/Hide FPS
			show_fps = !show_fps
		if event.is_action_pressed("Debug 4"):
			old_player = !old_player
			if old_player:
				Globals.is_player_version = Globals.is_player_versions.V1
			else:
				if biped:
					Globals.is_player_version = Globals.is_player_versions.V2_BIPED
				else: 
					Globals.is_player_version = Globals.is_player_versions.V2_QUADRUPED
			Messenger.swap_player.emit()
		if event.is_action_pressed("Debug 5"): # Pause the terrain movement
			terrain_controller.terrain_velocity = 0
			player.terrain_slowdown = true
		if event.is_action_pressed("Debug 6"): # Play the terrain movement
			terrain_controller.terrain_velocity = terrain_controller.TERRAIN_VELOCITY
			player.terrain_slowdown = false
		if event.is_action_pressed("Debug 7"):
			pass
		if event.is_action_pressed("Debug 8"):
			pass
		if event.is_action_pressed("Debug 9"):
			biped = !biped
			if biped:
				Globals.is_player_version = Globals.is_player_versions.V2_BIPED
			else:
				Globals.is_player_version = Globals.is_player_versions.V2_QUADRUPED
			Messenger.swap_player.emit()
		if event.is_action_pressed("Debug 0"):
			debug_menu.visible = !debug_menu.visible
			
		#endregion
