extends Control

@onready var player = get_tree().get_root().get_node("Main Scene/Player")
@onready var level_current = Globals.current_safe_chunks
@onready var label_levelCurrent = %Label_levelCurrent
@onready var terrain_controller = get_tree().get_root().get_node("Main Scene/TerrainController_inScene")

@onready var powerup_menu = get_tree().get_root().get_node("Main Scene/PowerUp_Menu")

@onready var leg_r = get_tree().get_root().get_node("Main Scene/Player/Alien_V3/DetectionAreas/Area_LegR")
@onready var leg_l = get_tree().get_root().get_node("Main Scene/Player/Alien_V3/DetectionAreas/Area_LegL")

@onready var interact = get_tree().get_root().get_node("Main Scene/UI_Interaction")


# Called when the node enters the scene tree for the first time.
func _ready():
	# CONSIDER tucking these away in a function then calling them in ready
	Messenger.level_update.connect(on_level_update)
	
	%Button_State_PreIntro.pressed.connect(on_state_PreIntro)
	%Button_State_Intro.pressed.connect(on_state_Intro)
	%Button_State_Menu.pressed.connect(on_state_Menu)
	%Button_State_PostMenu.pressed.connect(on_state_PostMenu)
	%Button_State_PreBegin.pressed.connect(on_state_PreBegin)
	%Button_State_Begin.pressed.connect(on_state_Begin)
	%Button_State_Play.pressed.connect(on_state_Play)
	%Button_State_Pause.pressed.connect(on_state_Pause)
	%Button_Cutscene.pressed.connect(on_Cutscene)
	%Button_Menu.pressed.connect(on_Menu)
	%Button_Game.pressed.connect(on_Game)
	%Button_playerHeight.pressed.connect(on_playerHeight)
	%Button_killLegs.pressed.connect(on_killLegs)
	%Button_hurtLegR.pressed.connect(on_hurtLegR)
	%Button_hurtLegL.pressed.connect(on_hurtLegL)
	%Button_powerup1.pressed.connect(on_powerup1)
	%Button_powerup2.pressed.connect(on_powerup2)
	%Button_powerup3.pressed.connect(on_powerup3)
	%Button_scoreClear.pressed.connect(on_scoreClear)
	%Button_scoreUp.pressed.connect(on_scoreUp)
	%Button_levelDebug_01.pressed.connect(on_levelDebug_01)
	%Button_level_01.pressed.connect(on_level_01)
	%Button_healLegL.pressed.connect(on_healLegL)
	%Button_healLegR.pressed.connect(on_healLegR)
	%Button_22.pressed.connect(on_interact_22)
	%Button_11.pressed.connect(on_interact_11)
	%Button_00.pressed.connect(on_interact_00)
	
	label_levelCurrent.text = str("Current Level: ",Globals.level_current)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func on_Cutscene():
	terrain_controller.is_level_type = 0
func on_Menu():
	terrain_controller.is_level_type = 1
func on_Game():
	terrain_controller.is_level_type = 2
	#Messenger.level_update.emit(1)

func on_scoreUp():
	Messenger.abduction.emit(1)
	
func on_scoreClear():
	Globals.score = 0
	Messenger.abduction.emit(0)
	
func on_powerup1():
	Messenger.powerup_chosen.emit(1)
func on_powerup2():
	Messenger.powerup_chosen.emit(2)
func on_powerup3():
	Messenger.powerup_chosen.emit(3)
	

func on_killLegs():
	Messenger.amount_damaged.emit(1)
	Messenger.area_damaged.emit(leg_r)
	Messenger.area_damaged.emit(leg_l)
	
func on_playerHeight():
	print("Player Height: ", player.position.y, "; Travel Distance: ", powerup_menu.TRAVEL_DISTANCE)

func on_hurtLegR():
	Messenger.amount_damaged.emit(.1)
	Messenger.area_damaged.emit(leg_r)
	
func on_hurtLegL():
	Messenger.amount_damaged.emit(.1)
	Messenger.area_damaged.emit(leg_l)

func on_level_update(level):
	label_levelCurrent.text = str("Current Level: ",level)


func on_levelDebug_01():
	Messenger.level_update.emit(0)
func on_level_01():
	Messenger.level_update.emit(1)


func on_state_PreIntro():
		Messenger.swap_game_state.emit(Globals.is_game_states.PREINTRO)

func on_state_Intro():
	Messenger.swap_game_state.emit(Globals.is_game_states.INTRO)
	
func on_state_Menu():
	Messenger.swap_game_state.emit(Globals.is_game_states.MENU)
	
func on_state_PostMenu():
	Messenger.swap_game_state.emit(Globals.is_game_states.POSTMENU)

func on_state_PreBegin():
	Messenger.swap_game_state.emit(Globals.is_game_states.PREBEGIN)

func on_state_Begin():
	Messenger.swap_game_state.emit(Globals.is_game_states.BEGIN)
	
func on_state_Play():
	Messenger.swap_game_state.emit(Globals.is_game_states.PLAY)
	
func on_state_Pause():
	Messenger.swap_game_state.emit(Globals.is_game_states.PAUSE)

func on_healLegL():
	Messenger.abductee_detected.emit(leg_l,true)
	
func on_healLegR():
	Messenger.abductee_detected.emit(leg_r,true)

func on_interact_22():
	interact.debugr = 2
	interact.debugl = 2
	Messenger.arm_health_update.emit()
	
func on_interact_11():
	interact.debugr = 1
	interact.debugl = 1
	Messenger.arm_health_update.emit()
	
func on_interact_00():
	interact.debugr = 0
	interact.debugl = 0
	Messenger.arm_health_update.emit()
	
