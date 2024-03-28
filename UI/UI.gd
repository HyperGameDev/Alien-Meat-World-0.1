extends CanvasLayer

@onready var score_label = %Score_Number
var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	Messenger.abduction.connect(on_abduction)
	
func _process(delta):
	score_label.text = str(score)

func on_abduction(score_value):
	score += score_value
