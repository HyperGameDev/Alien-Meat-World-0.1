extends ProgressBar

var hover_played_once = false
@onready var anim_hp_bar = $"Animation_HP-Bar"

func hover_animation():						
	anim_hp_bar.play("hp_bar_hide")
