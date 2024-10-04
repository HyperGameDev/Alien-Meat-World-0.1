extends Node

var debug_hp_Player = true

@warning_ignore("unused_signal")
signal swap_game_state

@warning_ignore("unused_signal")
signal game_intro # Cutscene
@warning_ignore("unused_signal")
signal game_menu # Main Menu
@warning_ignore("unused_signal")
signal game_postmenu # Teleporting to earth
@warning_ignore("unused_signal")
signal game_prebegin
@warning_ignore("unused_signal")
signal game_begin
@warning_ignore("unused_signal")
signal game_play
@warning_ignore("unused_signal")
signal game_pause
@warning_ignore("unused_signal")
signal game_over

@warning_ignore("unused_signal")
signal restart
@warning_ignore("unused_signal")
signal retry # 1 argument, is_restart bool true/false

@warning_ignore("unused_signal")
signal debug_nodes

@warning_ignore("unused_signal")
signal button_action
@warning_ignore("unused_signal")
signal button_chosen
@warning_ignore("unused_signal")
signal button_hovered

@warning_ignore("unused_signal")
signal powerup_menu_begin
@warning_ignore("unused_signal")
signal powerup_chosen
@warning_ignore("unused_signal")
signal powerup_hovered

@warning_ignore("unused_signal")
signal add_powerup
@warning_ignore("unused_signal")
signal remove_powerup
@warning_ignore("unused_signal")
signal upgrade_powerup

@warning_ignore("unused_signal")
signal player_hover
@warning_ignore("unused_signal")
signal player_head_hover

@warning_ignore("unused_signal")
signal area_damaged
@warning_ignore("unused_signal")
signal area_undamaged

@warning_ignore("unused_signal")
signal movement_start
@warning_ignore("unused_signal")
signal movement_stop # 1 argument, lock_controls true/false

@warning_ignore("unused_signal")
signal instant_death
@warning_ignore("unused_signal")
signal limb_is_damaged

@warning_ignore("unused_signal")
signal head_is_damaged
@warning_ignore("unused_signal")
signal head_is_healed
@warning_ignore("unused_signal")
signal head_health

@warning_ignore("unused_signal")
signal empathy_consumed

@warning_ignore("unused_signal")
signal empathy_is_damaged
@warning_ignore("unused_signal")
signal empathy_is_healed
@warning_ignore("unused_signal")
signal empathy_health

@warning_ignore("unused_signal")
signal limbs_is_damaged
@warning_ignore("unused_signal")
signal limbs_is_healed
@warning_ignore("unused_signal")
signal limbs_health
@warning_ignore("unused_signal")
signal arm_health_update

@warning_ignore("unused_signal")
signal amount_damaged
@warning_ignore("unused_signal")
signal amount_slowed

@warning_ignore("unused_signal")
signal health_hovered
@warning_ignore("unused_signal")
signal abductee_detected

@warning_ignore("unused_signal")
signal hover_pos

@warning_ignore("unused_signal")
signal interact_obstacle_begin
@warning_ignore("unused_signal")
signal interact_obstacle_end
@warning_ignore("unused_signal")
signal interact_npc_begin
@warning_ignore("unused_signal")
signal interact_npc_end

@warning_ignore("unused_signal")
signal spawn_npc

@warning_ignore("unused_signal")
signal copter_unit_stopped

# Raycast results
@warning_ignore("unused_signal")
signal attack_target
@warning_ignore("unused_signal")
signal mouse_pos_3d
@warning_ignore("unused_signal")
signal anything_seen

# Obstacle reports
@warning_ignore("unused_signal")
signal something_hit
@warning_ignore("unused_signal")
signal something_attacked

@warning_ignore("unused_signal")
signal something_hovered

@warning_ignore("unused_signal")
signal abductee_hovered

# Actual grabbing
@warning_ignore("unused_signal")
signal grab_begun
@warning_ignore("unused_signal")
signal grab_ended

@warning_ignore("unused_signal")
signal grab_point_offset

@warning_ignore("unused_signal")
signal grab_attempted
@warning_ignore("unused_signal")
signal dunk_is_at_position
@warning_ignore("unused_signal")
signal meat_entered_dunk
@warning_ignore("unused_signal")
signal meat_left_dunk
@warning_ignore("unused_signal")
signal meat_in_dunk

@warning_ignore("unused_signal")
signal abduction
@warning_ignore("unused_signal")
signal eating_begun
@warning_ignore("unused_signal")
signal eating_finished

@warning_ignore("unused_signal")
signal hitpoint_update

@warning_ignore("unused_signal")
signal level_update
