extends CanvasLayer

@export var show_info = false
var old_player = true
var biped = true
@onready var debug_menu = %Menu
@onready var terrain_controller = %TerrainController_inScene
@onready var player = %Player
	
# Called when the node enters the scene tree for the first time.
func _process(delta):
	if show_info:
		%Container_MoreInfo.visible = true
		%Label_showFPS.text = "FPS: " + str(Engine.get_frames_per_second()).pad_zeros(3)
		%Label_showState.text = "State: " + str(Globals.is_game_states.keys()[Globals.is_game_state])
	else:
		%Container_MoreInfo.visible = false

func _input(event):
	#region devControls
	if OS.is_debug_build():
		if event.is_action_pressed("Debug 1"):
			Messenger.abduction.emit(1)
		if event.is_action_pressed("Debug 2"):
			for dmg_label in get_tree().get_nodes_in_group("Dmg_Labels_Player"):
				dmg_label.visible = !dmg_label.visible
		if event.is_action_pressed("Debug 3"): # Show/Hide FPS
			show_info = !show_info
		if event.is_action_pressed("Debug 4"):
			Messenger.spawn_npc.emit("copter")
		if event.is_action_pressed("Debug 5"): # Pause the terrain movement
			Messenger.movement_stop.emit(false)
		if event.is_action_pressed("Debug 6"): # Play the terrain movement
			Messenger.movement_start.emit(false)
		if event.is_action_pressed("Debug 7"):
			Messenger.add_powerup.emit("Fantastic")
			Messenger.arm_health_update.emit()
			print("Fantastic powerup is Level 1! (via debug)")
		if event.is_action_pressed("Debug 8"):
			if Globals.powerups["Drone"].powerupLevel == 1:
				Messenger.upgrade_powerup.emit("Drone")
				print("Drone powerup is Level 2! (via debug)")
			else:
				print("CANNOT upgrade Drone because there is no Drone yet!")
		if event.is_action_pressed("Debug 9"):
			Messenger.remove_powerup.emit("Fantastic")
			Messenger.arm_health_update.emit()
			print("Fantastic powerup is Level 0! (via debug)")
		if event.is_action_pressed("Debug 0"):
			Messenger.arm_health_update.emit()
		if event.is_action_pressed("Debug -"):
			debug_menu.visible = !debug_menu.visible
			
		#endregion
