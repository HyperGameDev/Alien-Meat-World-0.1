extends Node

var debug_hp_Player = true

signal debug_nodes

signal player_hover

signal area_damaged
signal area_undamaged

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

signal amount_damaged
signal amount_slowed

signal health_hovered
signal health_detected

signal hover_pos

signal copter_unit_stopped

# Raycast results
signal attack_target
signal mouse_pos_3d
signal anything_seen

# Obstacle reports
signal something_hit
signal something_attacked
signal something_hovered

# Actual grabbing
signal grab_begun
signal grab_ended

signal grab_attempted
signal dunk_is_at_position
signal meat_entered_dunk
signal meat_left_dunk
signal meat_in_dunk

signal abduction

signal hitpoint_update

signal level_update
