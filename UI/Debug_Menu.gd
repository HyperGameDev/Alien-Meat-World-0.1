extends Control

@onready var level_current = Globals.current_safe_chunks
@onready var label_levelCurrent = %Label_levelCurrent

# Called when the node enters the scene tree for the first time.
func _ready():
	Messenger.level_update.connect(on_level_update)
	%Button_powerup1.pressed.connect(on_powerup1)
	%Button_powerup2.pressed.connect(on_powerup2)
	%Button_powerup3.pressed.connect(on_powerup3)
	%Button_scoreClear.pressed.connect(on_scoreClear)
	%Button_scoreUp.pressed.connect(on_scoreUp)
	%Button_levelDebug_01.pressed.connect(on_levelDebug_01)
	%Button_level_01.pressed.connect(on_level_01)
	
	label_levelCurrent.text = str("Current Level: ",Globals.level_current)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

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
	
	

func on_level_update(level):
	label_levelCurrent.text = str("Current Level: ",level)


func on_levelDebug_01():
	Messenger.level_update.emit(0)

func on_level_01():
	Messenger.level_update.emit(1)
