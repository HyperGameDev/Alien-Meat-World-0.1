extends Node

var debug_hp_Player = true

signal swap_game_state

signal game_intro # Cutscene
signal game_menu # Main Menu
signal game_postmenu # Teleporting to earth
signal game_prebegin
signal game_begin
signal game_play
signal game_pause

signal game_over

signal debug_nodes

signal button_action
signal button_chosen
signal button_hovered

signal powerup_menu_begin
signal powerup_chosen
signal powerup_hovered

signal add_powerup

signal player_hover
signal player_head_hover

signal area_damaged
signal area_undamaged

signal movement_start
signal movement_stop

signal instant_death
signal limb_is_damaged

signal head_is_damaged
signal head_is_healed
signal head_health

signal empathy_consumed

signal empathy_is_damaged
signal empathy_is_healed
signal empathy_health

signal limbs_is_damaged
signal limbs_is_healed
signal limbs_health
signal arm_health_update

signal amount_damaged
signal amount_slowed

signal health_hovered
signal abductee_detected

signal hover_pos

signal spawn_npc

signal copter_unit_stopped

# Raycast results
signal attack_target
signal mouse_pos_3d
signal anything_seen

# Obstacle reports
signal something_hit
signal something_attacked

signal something_hovered

signal interactable_hovered

# Actual grabbing
signal grab_begun
signal grab_ended

signal grab_point_offset

signal grab_attempted
signal dunk_is_at_position
signal meat_entered_dunk
signal meat_left_dunk
signal meat_in_dunk

signal abduction
signal eating_begun
signal eating_finished

signal hitpoint_update

signal level_update

func _ready() -> void:
	level_update.connect(on_level_update)
	
func on_level_update():
	pass
