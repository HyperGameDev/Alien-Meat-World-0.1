extends Node

@export var skins_unlocked: bool = false
@export var level_current = 0

var run_begun : bool = false

var level_label : Array = [
	"0-0",
	"1-1",
	"1-2",
	"1-3",
	"2-1",
	"2-2",
	"2-3",
	"3-1",
	"3-2",
	"3-3",
	"4-1",
	"4-2",
	"4-3"
]

var is_game_state: is_game_states
enum is_game_states {PREINTRO,INTRO,PREMENU,MENU,CONFIRM,POSTMENU,PREBEGIN,BEGIN,PLAY,PAUSE,OVER}

var is_playing: bool = false

var flying_formation_z_pos: Array =[
	-11.,
	-16.,
	-21.,
	-28.,
	-33.
]

var human_enemy_clothes_paths: Array = [
	"res://NPCs/Humans/textures/human_clothes_camo_01.tres"
]

var human_tops_paths: Array = [
	"res://NPCs/Humans/textures/human_clothes_grn_01.tres",
	"res://NPCs/Humans/textures/human_clothes_wht_01.tres"
]
var human_bottoms_paths: Array = [
	"res://NPCs/Humans/textures/human_clothes_denim_01.tres"
]

var human_enemy_tops: Array = [
]
var human_enemy_bottoms: Array = [
]

var human_tops: Array = [
]
var human_bottoms: Array = [
]

var powerups_available: Array = []
var powerups_chosen: Array = []
var powerups := {
	Drone = {
		powerupName = "Drone",
		powerupDescription = "Spawns a drone that attacks enemies.",
		powerupIcon = "res://UI/Powerups/Icons/powerup_icons_temp/powerup_icon_temp_01.png",
		powerupLevel = 0
	},
	Fantastic = {
		powerupName = "Fantastic Arms",
		powerupDescription = "Arms stretch further.",
		powerupIcon = "res://UI/Powerups/Icons/powerup_icons_temp/powerup_icon_temp_02.png",
		powerupLevel = 0
	},
	Powerup3 = {
		powerupName = "PowerUp No. Three",
		powerupDescription = "It might be strong.",
		powerupIcon = "res://UI/Powerups/Icons/powerup_icons_temp/powerup_icon_temp_03.png",
		powerupLevel = 0
	},
	Powerup4 = {
		powerupName = "PowerUp 4th",
		powerupDescription = "Just works.",
		powerupIcon = "res://UI/Powerups/Icons/powerup_icons_temp/powerup_icon_temp_04.png",
		powerupLevel = 0
	},
	Powerup5 = {
		powerupName = "5th Powerup",
		powerupDescription = "Really great, not the worst; you like it.",
		powerupIcon = "res://UI/Powerups/Icons/powerup_icons_temp/powerup_icon_temp_05.png",
		powerupLevel = 0
	},
	Powerup6 = {
		powerupName = "Number Six Powerup",
		powerupDescription = "It does SO many things. WOW. We just LOVE IT!!!",
		powerupIcon = "res://UI/Powerups/Icons/powerup_icons_temp/powerup_icon_temp_06.png",
		powerupLevel = 0
	},
	Powerup7 = {
		powerupName = "Seventh Powerup!",
		powerupDescription = "GOOD.",
		powerupIcon = "res://UI/Powerups/Icons/powerup_icons_temp/powerup_icon_temp_07.png",
		powerupLevel = 0
	},
	Powerup8 = {
		powerupName = "Of all, this is 8th",
		powerupDescription = "You're gonna love this one because it will make you so strong, that you won't have any fun anymore, in a GOOD way tho.",
		powerupIcon = "res://UI/Powerups/Icons/powerup_icons_temp/powerup_icon_temp_08.png",
		powerupLevel = 0
	},
	Powerup9 = { 
		powerupName = "Powerup 8 + 1",
		powerupDescription = "This amazing powerup will help you be better.",
		powerupIcon = "res://UI/Powerups/Icons/powerup_icons_temp/powerup_icon_temp_09.png",
		powerupLevel = 0
	},
	Powerup10 = {
		powerupName = "The tenth Powerup",
		powerupDescription = "Use this when playing.",
		powerupIcon = "res://UI/Powerups/Icons/powerup_icons_temp/powerup_icon_temp_10.png",
		powerupLevel = 0
	},
	Powerup11 = {
		powerupName = "11th Powerup",
		powerupDescription = "Have a good time making yourself Strong. Or not.",
		powerupIcon = "res://UI/Powerups/Icons/powerup_icons_temp/powerup_icon_temp_11.png",
		powerupLevel = 0
	},
	Powerup12 = {
		powerupName = "Uncle Ben Powerup",
		powerupDescription = "With great power, comes great responsibility.",
		powerupIcon = "res://UI/Powerups/Icons/powerup_icons_temp/powerup_icon_temp_12.png",
		powerupLevel = 0
	},
	Powerup13 = {
		powerupName = "Unlucky",
		powerupDescription = "Don't get this one. Don't use it. You've been warned.",
		powerupIcon = "res://UI/Powerups/Icons/powerup_icons_temp/powerup_icon_temp_13.png",
		powerupLevel = 0
	},
	Powerup14 = {
		powerupName = "P.U. #14",
		powerupDescription = "This is Final Placeholder powerup FOR NOW... until it's not. Maybe add a way to get a fourth powerup loading in (as the player)?",
		powerupIcon = "res://UI/Powerups/Icons/powerup_icons_temp/powerup_icon_temp_14.png",
		powerupLevel = 0
	}
}
		
var obstacles_hilited := []
var score: int = 0
var time: float = 0.0

static var EMPATHY: int = 0
var empathy: int = 0
static var EMPATHY_UNLOCKED: bool = false
var empathy_unlocked: bool = false
static var EMPATHY_POSSIBLE: bool = true
var empathy_possible: bool = true
@onready var empathy_event_interval_timer : Timer = Timer.new()

var empathy_events := {
	Scene_01 = {
		right_is_military = true,
		right_is_first = false,
		innocent_dialogue = {    
			Line_01 = {
				dialogue_Top = "I did nothing wrong!",
				dialogue_Bottom = "",
				labels = {
					Multi_Small = true,
					Top_Large = false,
					Top_Small = false,
					Bottom_Large = false,
					Bottom_Small = false
				}
			},
			Line_02 = {
				dialogue_Top = "Somebody",
				dialogue_Bottom = "Help",
				labels = {
					Multi_Small = false,
					Top_Large = false,
					Top_Small = true,
					Bottom_Large = true,
					Bottom_Small = false
				}
			},
			Line_03 = {
				dialogue_Top = "I'm innocent",
				dialogue_Bottom = "",
				labels = {
					Multi_Small = true,
					Top_Large = false,
					Top_Small = false,
					Bottom_Large = false,
					Bottom_Small = false
				}
			}
		},
		enemy_dialogue = {
			Line_01 = {
				dialogue_Top = "Stop\n Resisting!",
				dialogue_Bottom = "",
				labels = {
					Multi_Small = true,
					Top_Large = false,
					Top_Small = false,
					Bottom_Large = false,
					Bottom_Small = false
				}
			},
			Line_02 = {
				dialogue_Top = "Quit whining",
				dialogue_Bottom = "",
				labels = {
					Multi_Small = true,
					Top_Large = false,
					Top_Small = false,
					Bottom_Large = false,
					Bottom_Small = false
				}
			},
			Line_03 = {
				dialogue_Top = "you belong to us",
				dialogue_Bottom = "",
				labels = {
					Multi_Small = true,
					Top_Large = false,
					Top_Small = false,
					Bottom_Large = false,
					Bottom_Small = false
				}
			}
		}
	},
	Scene_02 = {
		right_is_military = false,
		right_is_first = true,
		innocent_dialogue = {    
			Line_01 = {
				dialogue_Top = "Who are you people?",
				dialogue_Bottom = "",
				labels = {
					Multi_Small = true,
					Top_Large = false,
					Top_Small = false,
					Bottom_Large = false,
					Bottom_Small = false
				}
			},
			Line_02 = {
				dialogue_Top = "Don't hurt me",
				dialogue_Bottom = "",
				labels = {
					Multi_Small = true,
					Top_Large = false,
					Top_Small = false,
					Bottom_Large = false,
					Bottom_Small = false
				}
			},
			Line_03 = {
				dialogue_Top = "Fight the power",
				dialogue_Bottom = "",
				labels = {
					Multi_Small = true,
					Top_Large = false,
					Top_Small = false,
					Bottom_Large = false,
					Bottom_Small = false
				}
			}
		},
		enemy_dialogue = {
			Line_01 = {
				dialogue_Top = "We are\n in charge now",
				dialogue_Bottom = "",
				labels = {
					Multi_Small = true,
					Top_Large = false,
					Top_Small = false,
					Bottom_Large = false,
					Bottom_Small = false
				}
			},
			Line_02 = {
				dialogue_Top = "You must",
				dialogue_Bottom = "obey!",
				labels = {
					Multi_Small = false,
					Top_Large = false,
					Top_Small = true,
					Bottom_Large = true,
					Bottom_Small = false
				}
			},
			Line_03 = {
				dialogue_Top = "Eat lead\n weakling",
				dialogue_Bottom = "",
				labels = {
					Multi_Small = true,
					Top_Large = false,
					Top_Small = false,
					Bottom_Large = false,
					Bottom_Small = false
				}
			}
		}
	},
	Scene_03 = {
		right_is_military = true,
		right_is_first = true,
		innocent_dialogue = {    
			Line_01 = {
				dialogue_Top = "Please",
				dialogue_Bottom = "Help",
				labels = {
					Multi_Small = false,
					Top_Large = false,
					Top_Small = true,
					Bottom_Large = true,
					Bottom_Small = false
				}
			},
			Line_02 = {
				dialogue_Top = "I'm too scared",
				dialogue_Bottom = "",
				labels = {
					Multi_Small = true,
					Top_Large = false,
					Top_Small = false,
					Bottom_Large = false,
					Bottom_Small = false
				}
			},
			Line_03 = {
				dialogue_Top = "I have\na family",
				dialogue_Bottom = "",
				labels = {
					Multi_Small = true,
					Top_Large = false,
					Top_Small = false,
					Bottom_Large = false,
					Bottom_Small = false
				}
			}
		},
		enemy_dialogue = {
			Line_01 = {
				dialogue_Top = "Get back here",
				dialogue_Bottom = "",
				labels = {
					Multi_Small = true,
					Top_Large = false,
					Top_Small = false,
					Bottom_Large = false,
					Bottom_Small = false
				}
			},
			Line_02 = {
				dialogue_Top = "Obey",
				dialogue_Bottom = "or die",
				labels = {
					Multi_Small = false,
					Top_Large = true,
					Top_Small = false,
					Bottom_Large = true,
					Bottom_Small = false
				}
			},
			Line_03 = {
				dialogue_Top = "Eat",
				dialogue_Bottom = "Lead",
				labels = {
					Multi_Small = false,
					Top_Large = true,
					Top_Small = false,
					Bottom_Large = true,
					Bottom_Small = false
				}
			}
		}
	},
	Scene_04 = {
		right_is_military = false,
		right_is_first = true,
		innocent_dialogue = {    
			Line_01 = {
				dialogue_Top = "Please don't hurt me",
				dialogue_Bottom = "",
				labels = {
					Multi_Small = true,
					Top_Large = false,
					Top_Small = false,
					Bottom_Large = false,
					Bottom_Small = false
				}
			},
			Line_02 = {
				dialogue_Top = "I have nothing left",
				dialogue_Bottom = "",
				labels = {
					Multi_Small = true,
					Top_Large = false,
					Top_Small = false,
					Bottom_Large = false,
					Bottom_Small = false
				}
			},
			Line_03 = {
				dialogue_Top = "HELP",
				dialogue_Bottom = "ME",
				labels = {
					Multi_Small = false,
					Top_Large = true,
					Top_Small = false,
					Bottom_Large = true,
					Bottom_Small = false
				}
			}
		},
		enemy_dialogue = {
			Line_01 = {
				dialogue_Top = "Give up",
				dialogue_Bottom = "now",
				labels = {
					Multi_Small = false,
					Top_Large = true,
					Top_Small = false,
					Bottom_Large = true,
					Bottom_Small = false
				}
			},
			Line_02 = {
				dialogue_Top = "Comply",
				dialogue_Bottom = "or die",
				labels = {
					Multi_Small = false,
					Top_Large = false,
					Top_Small = true,
					Bottom_Large = true,
					Bottom_Small = false
				}
			},
			Line_03 = {
				dialogue_Top = "We own you now",
				dialogue_Bottom = "",
				labels = {
					Multi_Small = true,
					Top_Large = false,
					Top_Small = false,
					Bottom_Large = false,
					Bottom_Small = false
				}
			}
		}
	}
}

var skin_progress: int = 0
var skin_max_progress: int = 2000
var skin_level: int = 1
var skin_max_level: int = 38

var skins := {
	Skin_01 = {
		skin_name = "Green Alien",
		skin_material = null,
		eyes_material = null,
		mouth_material = null,
		teeth_material = null,
		heart_outer_material = null,
		heart_inner_material = null,
		has_head_piece = false,
		head_piece = null,
		has_mullet = false,
		is_unlocked = true
		},
	Skin_02 = {
		skin_name = "Grey Alien",
		skin_material = null,
		eyes_material = null,
		mouth_material = null,
		teeth_material = null,
		heart_outer_material = null,
		heart_inner_material = null,
		has_head_piece = false,
		head_piece = null,
		has_mullet = false,
		is_unlocked = false
		},
	Skin_03 = {
		skin_name = "Orange Alien",
		skin_material = null,
		eyes_material = null,
		mouth_material = null,
		teeth_material = null,
		heart_outer_material = null,
		heart_inner_material = null,
		has_head_piece = false,
		head_piece = null,
		has_mullet = false,
		is_unlocked = false
		},
	Skin_04 = {
		skin_name = "Blue Alien",
		skin_material = null,
		eyes_material = null,
		mouth_material = null,
		teeth_material = null,
		heart_outer_material = null,
		heart_inner_material = null,
		has_head_piece = false,
		head_piece = null,
		has_mullet = false,
		is_unlocked = false
		},
	Skin_05 = {
		skin_name = "Yellow Alien",
		skin_material = null,
		eyes_material = null,
		mouth_material = null,
		teeth_material = null,
		heart_outer_material = null,
		heart_inner_material = null,
		has_head_piece = false,
		head_piece = null,
		has_mullet = false,
		is_unlocked = false
		},
	Skin_06 = {
		skin_name = "Cyan Alien",
		skin_material = null,
		eyes_material = null,
		mouth_material = null,
		teeth_material = null,
		heart_outer_material = null,
		heart_inner_material = null,
		has_head_piece = false,
		head_piece = null,
		has_mullet = false,
		is_unlocked = false
		},
	Skin_07 = {
		skin_name = "Purple Alien",
		skin_material = null,
		eyes_material = null,
		mouth_material = null,
		teeth_material = null,
		heart_outer_material = null,
		heart_inner_material = null,
		has_head_piece = false,
		head_piece = null,
		has_mullet = false,
		is_unlocked = false
		},
	Skin_08 = {
		skin_name = "Albino Alien",
		skin_material = null,
		eyes_material = null,
		mouth_material = null,
		teeth_material = null,
		heart_outer_material = null,
		heart_inner_material = null,
		has_head_piece = false,
		head_piece = null,
		has_mullet = false,
		is_unlocked = false
		},
	Skin_09 = {
		skin_name = "Tailypo Alien",
		skin_material = null,
		eyes_material = null,
		mouth_material = null,
		teeth_material = null,
		heart_outer_material = null,
		heart_inner_material = null,
		has_head_piece = false,
		head_piece = null,
		has_mullet = false,
		is_unlocked = false
		},
	Skin_10 = {
		skin_name = "Marshmallow Alien",
		skin_material = null,
		eyes_material = null,
		mouth_material = null,
		teeth_material = null,
		heart_outer_material = null,
		heart_inner_material = null,
		has_head_piece = true,
		head_piece = "marshmallow",
		has_mullet = false,
		is_unlocked = false
		},
	Skin_11 = {
		skin_name = "Chrome Alien",
		skin_material = null,
		eyes_material = null,
		mouth_material = null,
		teeth_material = null,
		heart_outer_material = null,
		heart_inner_material = null,
		has_head_piece = false,
		head_piece = null,
		has_mullet = false,
		is_unlocked = false
		},
	Skin_12 = {
		skin_name = "Demon Alien",
		skin_material = null,
		eyes_material = null,
		mouth_material = null,
		teeth_material = null,
		heart_outer_material = null,
		heart_inner_material = null,
		has_head_piece = true,
		head_piece = "devil_horns",
		has_mullet = false,
		is_unlocked = false
		},
	Skin_13 = {
		skin_name = "Chocolate Alien",
		skin_material = null,
		eyes_material = null,
		mouth_material = null,
		teeth_material = null,
		heart_outer_material = null,
		heart_inner_material = null,
		has_head_piece = true,
		head_piece = "chocolate",
		has_mullet = false,
		is_unlocked = false
		},
	Skin_14 = {
		skin_name = "Sponge Alien",
		skin_material = null,
		eyes_material = null,
		mouth_material = null,
		teeth_material = null,
		heart_outer_material = null,
		heart_inner_material = null,
		has_head_piece = false,
		head_piece = null,
		has_mullet = false,
		is_unlocked = false
		},
	Skin_15 = {
		skin_name = "Tartan Alien",
		skin_material = null,
		eyes_material = null,
		mouth_material = null,
		teeth_material = null,
		heart_outer_material = null,
		heart_inner_material = null,
		has_head_piece = false,
		head_piece = null,
		has_mullet = false,
		is_unlocked = false
		},
	Skin_16 = {
		skin_name = "Leopard Alien",
		skin_material = null,
		eyes_material = null,
		mouth_material = null,
		teeth_material = null,
		heart_outer_material = null,
		heart_inner_material = null,
		has_head_piece = true,
		head_piece = "leopard_ears",
		has_mullet = false,
		is_unlocked = false
		},
	Skin_17 = {
		skin_name = "Pink Leopard Alien",
		skin_material = null,
		eyes_material = null,
		mouth_material = null,
		teeth_material = null,
		heart_outer_material = null,
		heart_inner_material = null,
		has_head_piece = true,
		head_piece = "leopard_ears_pink",
		has_mullet = false,
		is_unlocked = false
		},
	Skin_18 = {
		skin_name = "Camo Alien",
		skin_material = null,
		eyes_material = null,
		mouth_material = null,
		teeth_material = null,
		heart_outer_material = null,
		heart_inner_material = null,
		has_head_piece = true,
		head_piece = "camo_helmet",
		has_mullet = false,
		is_unlocked = false
		},
	Skin_19 = {
		skin_name = "Longhorn Alien",
		skin_material = null,
		eyes_material = null,
		mouth_material = null,
		teeth_material = null,
		heart_outer_material = null,
		heart_inner_material = null,
		has_head_piece = true,
		head_piece = "cow_horns",
		has_mullet = false,
		is_unlocked = false
		},
	Skin_20 = {
		skin_name = "Polka Alien",
		skin_material = null,
		eyes_material = null,
		mouth_material = null,
		teeth_material = null,
		heart_outer_material = null,
		heart_inner_material = null,
		has_head_piece = false,
		head_piece = null,
		has_mullet = false,
		is_unlocked = false
		},
	Skin_21 = {
		skin_name = "Glitched Alien",
		skin_material = null,
		eyes_material = null,
		mouth_material = null,
		teeth_material = null,
		heart_outer_material = null,
		heart_inner_material = null,
		has_head_piece = false,
		head_piece = null,
		has_mullet = false,
		is_unlocked = false
		},
	Skin_22 = {
		skin_name = "Lava Alien",
		skin_material = null,
		eyes_material = null,
		mouth_material = null,
		teeth_material = null,
		heart_outer_material = null,
		heart_inner_material = null,
		has_head_piece = false,
		head_piece = "fire_particles",
		has_mullet = false,
		is_unlocked = false
		},
	Skin_23 = {
		skin_name = "Icy Alien",
		skin_material = null,
		eyes_material = null,
		mouth_material = null,
		teeth_material = null,
		heart_outer_material = null,
		heart_inner_material = null,
		has_head_piece = true,
		head_piece = "ice_spikes",
		has_mullet = false,
		is_unlocked = false
		},
	Skin_24 = {
		skin_name = "Marble Alien",
		skin_material = null,
		eyes_material = null,
		mouth_material = null,
		teeth_material = null,
		heart_outer_material = null,
		heart_inner_material = null,
		has_head_piece = false,
		head_piece = null,
		has_mullet = false,
		is_unlocked = false
		},
	Skin_25 = {
		skin_name = "Starbreaker",
		skin_material = null,
		eyes_material = null,
		mouth_material = null,
		teeth_material = null,
		heart_outer_material = null,
		heart_inner_material = null,
		has_head_piece = false,
		head_piece = "star_crown",
		has_mullet = false,
		is_unlocked = false
		},
	Skin_26 = {
		skin_name = "Nuclear Alien",
		skin_material = null,
		eyes_material = null,
		mouth_material = null,
		teeth_material = null,
		heart_outer_material = null,
		heart_inner_material = null,
		has_head_piece = false,
		head_piece = null,
		has_mullet = false,
		is_unlocked = false
		},
	Skin_27 = {
		skin_name = "Glactick",
		skin_material = null,
		eyes_material = null,
		mouth_material = null,
		teeth_material = null,
		heart_outer_material = null,
		heart_inner_material = null,
		has_head_piece = true,
		head_piece = "antenna",
		has_mullet = false,
		is_unlocked = false
		},
	Skin_28 = {
		skin_name = "Earth Alien",
		skin_material = null,
		eyes_material = null,
		mouth_material = null,
		teeth_material = null,
		heart_outer_material = null,
		heart_inner_material = null,
		has_head_piece = false,
		head_piece = null,
		has_mullet = false,
		is_unlocked = false
		}
	}
	
var skins_skin_paths := [
	"res://Player/textures/skins/alien_skin_01.tres",
	"res://Player/textures/skins/alien_skin_02.tres",
	"res://Player/textures/skins/alien_skin_03.tres",
	"res://Player/textures/skins/alien_skin_04.tres",
	"res://Player/textures/skins/alien_skin_05.tres",
	"res://Player/textures/skins/alien_skin_06.tres",
	"res://Player/textures/skins/alien_skin_07.tres",
	"res://Player/textures/skins/alien_skin_08.tres",
	"res://Player/textures/skins/alien_skin_09.tres",
	"res://Player/textures/skins/alien_skin_10.tres",
	"res://Player/textures/skins/alien_skin_11.tres",
	"res://Player/textures/skins/alien_skin_12.tres",
	"res://Player/textures/skins/alien_skin_13.tres",
	"res://Player/textures/skins/alien_skin_14.tres",
	"res://Player/textures/skins/alien_skin_15.tres",
	"res://Player/textures/skins/alien_skin_16.tres",
	"res://Player/textures/skins/alien_skin_17.tres",
	"res://Player/textures/skins/alien_skin_18.tres",
	"res://Player/textures/skins/alien_skin_19.tres",
	"res://Player/textures/skins/alien_skin_20.tres",
	"res://Player/textures/skins/alien_skin_21.tres",
	"res://Player/textures/skins/alien_skin_22.tres",
	"res://Player/textures/skins/alien_skin_23.tres",
	"res://Player/textures/skins/alien_skin_24.tres",
	"res://Player/textures/skins/alien_skin_25.tres",
	"res://Player/textures/skins/alien_skin_26.tres",
	"res://Player/textures/skins/alien_skin_27.tres",
	"res://Player/textures/skins/alien_skin_28.tres"
	]
var skins_eyes_paths := [
	"res://Player/textures/skins/alien_eyes_01.tres",
	"res://Player/textures/skins/alien_eyes_02.tres",
	"res://Player/textures/skins/alien_eyes_03.tres",
	"res://Player/textures/skins/alien_eyes_04.tres",
	"res://Player/textures/skins/alien_eyes_05.tres",
	"res://Player/textures/skins/alien_eyes_06.tres",
	"res://Player/textures/skins/alien_eyes_07.tres",
	"res://Player/textures/skins/alien_eyes_08.tres",
	"res://Player/textures/skins/alien_eyes_09.tres",
	"res://Player/textures/skins/alien_eyes_10.tres",
	"res://Player/textures/skins/alien_eyes_11.tres",
	"res://Player/textures/skins/alien_eyes_12.tres",
	"res://Player/textures/skins/alien_eyes_13.tres",
	"res://Player/textures/skins/alien_eyes_14.tres",
	"res://Player/textures/skins/alien_eyes_15.tres",
	"res://Player/textures/skins/alien_eyes_16.tres",
	"res://Player/textures/skins/alien_eyes_17.tres",
	"res://Player/textures/skins/alien_eyes_18.tres",
	"res://Player/textures/skins/alien_eyes_19.tres",
	"res://Player/textures/skins/alien_eyes_20.tres",
	"res://Player/textures/skins/alien_eyes_21.tres",
	"res://Player/textures/skins/alien_eyes_22.tres",
	"res://Player/textures/skins/alien_eyes_23.tres",
	"res://Player/textures/skins/alien_eyes_24.tres",
	"res://Player/textures/skins/alien_eyes_25.tres",
	"res://Player/textures/skins/alien_eyes_26.tres",
	"res://Player/textures/skins/alien_eyes_27.tres",
	"res://Player/textures/skins/alien_eyes_28.tres"
]
var skins_1 := {}
var skins_2 := {}

enum collision {DO_NOT_SET = 0,
				GROUND = 1,
				NPC = 2,
				OBSTACLE = 3,
				ABDUCTEE = 4,
				CURSOR_ZONE = 5,
				POWERUPS = 6,
				MENU_BUTTONS = 7,
				PROJECTILE = 8,
				ABDUCTEE_INTERACT = 9,
				OBSTACLE_INTERACT = 10,
				NPC_INTERACT = 11,
				SCORE_DUNK = 12,
				PLAYER = 16
				}

var level_chunks_safe := [
	"res://Terrain/terrain_level_00/terrain_level_00_safes/",
	"res://Terrain/terrain_level_01/terrain_level_01_safes/",
	"res://Terrain/terrain_level_02/terrain_level_02_safes/",
	"res://Terrain/terrain_level_03/terrain_level_03_safes/",
	"res://Terrain/terrain_level_04/terrain_level_04_safes/",
	"res://Terrain/terrain_level_05/terrain_level_05_safes/",
	"res://Terrain/terrain_level_06/terrain_level_06_safes/",
	"res://Terrain/terrain_level_07/terrain_level_07_safes/",
	"res://Terrain/terrain_level_08/terrain_level_08_safes/",
	"res://Terrain/terrain_level_09/terrain_level_09_safes/",
	"res://Terrain/terrain_level_10/terrain_level_10_safes/",
	"res://Terrain/terrain_level_11/terrain_level_11_safes/",
	"res://Terrain/terrain_level_12/terrain_level_12_safes/"
	
]
var level_chunks_points := [
	"res://Terrain/terrain_level_00/terrain_level_00_points/",
	"res://Terrain/terrain_level_01/terrain_level_01_points/",
	"res://Terrain/terrain_level_02/terrain_level_02_points/",
	"res://Terrain/terrain_level_03/terrain_level_03_points/",
	"res://Terrain/terrain_level_04/terrain_level_04_points/",
	"res://Terrain/terrain_level_05/terrain_level_05_points/",
	"res://Terrain/terrain_level_06/terrain_level_06_points/",
	"res://Terrain/terrain_level_07/terrain_level_07_points/",
	"res://Terrain/terrain_level_08/terrain_level_08_points/",
	"res://Terrain/terrain_level_09/terrain_level_09_points/",
	"res://Terrain/terrain_level_10/terrain_level_10_points/",
	"res://Terrain/terrain_level_11/terrain_level_11_points/",
	"res://Terrain/terrain_level_12/terrain_level_12_points/"
	
]
var level_chunks_obstacles := [
	"res://Terrain/terrain_level_00/terrain_level_00_obstacles/",
	"res://Terrain/terrain_level_01/terrain_level_01_obstacles/",
	"res://Terrain/terrain_level_02/terrain_level_02_obstacles/",
	"res://Terrain/terrain_level_03/terrain_level_03_obstacles/",
	"res://Terrain/terrain_level_04/terrain_level_04_obstacles/",
	"res://Terrain/terrain_level_05/terrain_level_05_obstacles/",
	"res://Terrain/terrain_level_06/terrain_level_06_obstacles/",
	"res://Terrain/terrain_level_07/terrain_level_07_obstacles/",
	"res://Terrain/terrain_level_08/terrain_level_08_obstacles/",
	"res://Terrain/terrain_level_09/terrain_level_09_obstacles/",
	"res://Terrain/terrain_level_10/terrain_level_10_obstacles/",
	"res://Terrain/terrain_level_11/terrain_level_11_obstacles/",
	"res://Terrain/terrain_level_12/terrain_level_12_obstacles/"
]

var level_chunks_menu := [
	"res://Terrain/terrain_level_menu/",
	"res://Terrain/terrain_level_menu/",
	"res://Terrain/terrain_level_menu/",
	"res://Terrain/terrain_level_menu/",
	"res://Terrain/terrain_level_menu/",
	"res://Terrain/terrain_level_menu/",
	"res://Terrain/terrain_level_menu/",
	"res://Terrain/terrain_level_menu/",
	"res://Terrain/terrain_level_menu/",
	"res://Terrain/terrain_level_menu/",
	"res://Terrain/terrain_level_menu/",
	"res://Terrain/terrain_level_menu/",
	"res://Terrain/terrain_level_menu/"
]

var current_safe_chunks : StringName
var current_obstacle_chunks : StringName
var current_points_chunks : StringName
var current_menu_chunks : StringName

var meat_objects := {
	Abductee.is_types.COW: load("res://NPCs/Cows/Cow_01-03_00.tscn"),
	Abductee.is_types.HUMAN: load("res://NPCs/Humans/human_02-01_00.tscn"),
	Abductee.is_types.TREE1: load("res://Objects/Foliage/Tree_01/tree_01_02_grabbable.tscn")
}

var save_path: String = "user://data.json"
var save_data: Dictionary = {
	skin_level = 1,
	skin_progress = 0
}


func _ready():
	print("Update file password!")
	Messenger.swap_game_state.connect(on_swap_game_state)
	Messenger.abduction.connect(on_abduction)
	Messenger.level_update.connect(on_level_update)
	Messenger.restart.connect(on_restart)
	Messenger.retry.connect(on_retry)
	Messenger.game_play.connect(on_game_play)
	Messenger.game_over.connect(on_game_over)
	Messenger.skin_level_update.connect(on_skin_level_update)
	
	empathy_event_interval_timer.one_shot = true
	add_child(empathy_event_interval_timer)
	
	if skins_unlocked:
		for skin in skins:
			skins[skin]["is_unlocked"] = true
	
	if FileAccess.file_exists(save_path):
		load_save_data()
	else:
		do_save_data()
		
	on_level_update(level_current)
	
	powerups_available = powerups.keys()
	
	 
	load_materials(human_tops_paths,human_tops)
	load_materials(human_bottoms_paths,human_bottoms)
	load_materials(human_enemy_clothes_paths,human_enemy_tops)
	load_materials(human_enemy_clothes_paths,human_enemy_bottoms)
	
	# CONSIDER consolidating this by making the paths in a single dictionary and all iterated through using one function only... Not necessary functionally but might make the game load quicker if desired.
	load_skins(skins,"skin_material",skins_skin_paths)
	load_skins(skins,"eyes_material",skins_eyes_paths)
	
	split_dictionary(skins)

	
func _process(delta: float) -> void:
	if is_playing:
		time += delta

func do_save_data():
	var data_to_save = JSON.stringify(save_data, "\t")
	var file = FileAccess.open_encrypted_with_pass(save_path, FileAccess.WRITE,"340583045803485043580348059834095803948509384095830945803948059384095803480598304985093480582307842387402873472304702734028734982730478203480345803975680852768725309786203578602347509283740597820374582734985729034758723094586723094509234785907320958723094578290347590237850982730587203487508274309582730495870923470847350827345092743509734905872048750823709587309275902730945723094750923784580723405702347508247350823740587234057802347502834750837405987230497502938475082734058723047590273508273405823857608735867284507478506705249762745628456728567824596725782458768724724796745768724587724597625487602754078620495721")
	file.store_string(data_to_save)
	#print("Saved! \n",save_data)
	
func load_save_data():
	var file = FileAccess.open_encrypted_with_pass(save_path, FileAccess.READ,"340583045803485043580348059834095803948509384095830945803948059384095803480598304985093480582307842387402873472304702734028734982730478203480345803975680852768725309786203578602347509283740597820374582734985729034758723094586723094509234785907320958723094578290347590237850982730587203487508274309582730495870923470847350827345092743509734905872048750823709587309275902730945723094750923784580723405702347508247350823740587234057802347502834750837405987230497502938475082734058723047590273508273405823857608735867284507478506705249762745628456728567824596725782458768724724796745768724587724597625487602754078620495721")
	if file:
		var content: Dictionary = JSON.parse_string(file.get_as_text())
		skin_level = content["skin_level"]
		skin_progress = content["skin_progress"]
		#print("Progress loaded as: ",content["skin_progress"])
		#print("Level loaded as: ",content["skin_level"])
		update_unlocked_skins()
		#print("Loaded: \n",content)
		
func load_skins(target_dictionary,target_key,paths_array):
	var i = 0
	for entry in target_dictionary.keys():
		if i < len(paths_array):
			target_dictionary[entry][target_key] = load(paths_array[i]) as Material
			i += 1
			
func split_dictionary(dictionary):
	var paths: Array = dictionary.keys()
	for i in range(len(paths)):
		if i < len(paths) / 2:
			skins_1[paths[i]] = dictionary[paths[i]]
		else:
			skins_2[paths[i]] = dictionary[paths[i]]

func load_materials(paths_array,destination_array):
	for path in paths_array:
		var loaded_material: StandardMaterial3D = load(path) as StandardMaterial3D
		destination_array.append(loaded_material)

func on_level_update(level):
	level_current = level
	#print("Globals tried updating paths")
	current_safe_chunks = level_chunks_safe[level]
	current_points_chunks = level_chunks_points[level]
	current_obstacle_chunks = level_chunks_obstacles[level]
	current_menu_chunks = level_chunks_menu[level]
	
	if level > 1:
		empathy_possible = false
	
func on_skin_level_update(increase_level_amount,update_progress):
	skin_level += increase_level_amount
	skin_progress = update_progress
	save_data["skin_level"] = skin_level
	save_data["skin_progress"] = skin_progress
	#print("Progress saved as: ",save_data["skin_progress"])
	#print("Level saved as: ",save_data["skin_level"])
	do_save_data()
	

func update_unlocked_skins():
	var keys: Array = skins.keys()
	for key in range(len(keys)):
		if key < skin_level:
			skins[keys[key]]["is_unlocked"] = true
	
	
func on_retry(is_restart):
	run_begun = false
	Game_States.is_paused = false
	get_tree().paused = false
	powerups_available = powerups.keys()
	obstacles_hilited = [] ## Empties out the last hilighted obstacle arrayd
	score = 0
	time = 0.0
	empathy = EMPATHY
	empathy_unlocked = EMPATHY_UNLOCKED
	empathy_possible = EMPATHY_POSSIBLE
	is_playing = false
	if !is_restart:
		Messenger.level_update.emit(1)
		Messenger.swap_game_state.emit(Globals.is_game_states.PLAY)
		
	
func on_restart():
	#print("Restart attempted")
	Messenger.retry.emit(true)
	Messenger.level_update.emit(0)
	get_tree().call_deferred("reload_current_scene")
	#get_tree().call_deferred("change_scene_to_file","res://main_scene.tscn")
	Messenger.swap_game_state.emit(Globals.is_game_states.PREINTRO)
	load_save_data()
	
func on_abduction(score_value):
	score += score_value
	
#func find_obstacles(to_check: Node) --> Block_Object

func on_swap_game_state(game_state):
	is_game_state = game_state
	#print("Is State #: ",is_game_state)
	
func on_game_play():
	is_playing = true
	
func on_game_over():
	is_playing = false
