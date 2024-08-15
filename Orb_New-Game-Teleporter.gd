extends MeshInstance3D

func animation_teleport_finished():
	Messenger.swap_game_state.emit(Globals.is_game_states.PLAY)
