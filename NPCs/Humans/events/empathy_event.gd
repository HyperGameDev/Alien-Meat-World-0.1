extends Node3D

@onready var human_left: RigidBody3D = %Human_Left
@onready var human_right: RigidBody3D = %Human_Right
@onready var animation: AnimationPlayer = %AnimationPlayer

var dialogue_left: CanvasLayer
var dialogue_right: CanvasLayer

var left_dialogueLabels: VBoxContainer
var right_dialogueLabels: VBoxContainer


var chosen_event: String


var empathy_events: Dictionary = Globals.empathy_events

func _ready() -> void:
	Messenger.empathy_event_ready.connect(on_empathy_event_ready)
	var empathy_event: String =  empathy_events.keys().pick_random()
	chosen_event = empathy_event
	
	if empathy_events[empathy_event]["right_is_enemy"]:
		human_right.is_enemy = true
		#animation.play(empathy_event)
		
func on_empathy_event_ready():
	var dialogue_left = human_left.get_node("%Canvas_Layer")
	var dialogue_right = human_right.get_node("%Canvas_Layer")

	var left_dialogueLabels = dialogue_left.get_node("%VBox_dialogueLabels")
	var right_dialogueLabels = dialogue_right.get_node("%VBox_dialogueLabels")
		
		
func update_dialogue(line,is_right):
	dialogue_right.visible = is_right
	dialogue_left.visible = not is_right
	
	var dialogue_labels: VBoxContainer
	if is_right:
		dialogue_labels = right_dialogueLabels
	else:
		dialogue_labels = left_dialogueLabels
		
	var is_enemy: bool = empathy_events[chosen_event]["right_is_enemy"]
	var dialogue_type: String
	if is_enemy:
		dialogue_type = "enemy_dialogue"
	else:
		dialogue_type = "innocent_dialogue"
	
	var labels_array: Array = empathy_events[chosen_event][dialogue_type][line]["labels"].keys()
	
	for label: Label in dialogue_labels.get_children():
		for label_name: String in labels_array:
			if label.name == label_name:
				label.visible = empathy_events[chosen_event][dialogue_type][line]["labels"][label_name]
	
	var dialogue_Top: String = empathy_events[chosen_event][dialogue_type][line]["dialogue_Top"]
	var dialogue_Bottom: String = empathy_events[chosen_event][dialogue_type][line]["dialogue_Bottom"]
	
	if empathy_events[chosen_event][dialogue_type][line]["labels"]["Multi_Small"]:
		dialogue_labels.get_node("Multi_Small").text = dialogue_Top
	else:
		var on_top: bool
		if empathy_events[chosen_event][dialogue_type][line]["labels"]["Top_Large"] or empathy_events[chosen_event][dialogue_type][line]["labels"]["Top_Small"]:
			on_top = true
			
		var on_bottom: bool
		if empathy_events[chosen_event][dialogue_type][line]["labels"]["Bottom_Large"] or empathy_events[chosen_event][dialogue_type][line]["labels"]["Bottom_Small"]:
			on_bottom = true
		
		if on_top:
			dialogue_labels.get_node("Top_Large").text = dialogue_Top
			dialogue_labels.get_node("Top_Small").text = dialogue_Top
			
			
		if on_bottom:
			dialogue_labels.get_node("Bottom_Large").text = dialogue_Bottom
			dialogue_labels.get_node("Bottom_Small").text = dialogue_Bottom
		
	
		
func dialogue_left_01():
	var line: String = "Line_01"
	var is_right: bool = false
	update_dialogue(line,is_right)
	
func dialogue_left_02():
	var line: String = "Line_02"
	var is_right: bool = false
	update_dialogue(line,is_right)

func dialogue_left_03():
	var line: String = "Line_03"
	var is_right: bool = false
	update_dialogue(line,is_right)


func dialogue_right_01():
	var line: String = "Line_01"
	var is_right: bool = true
	update_dialogue(line,is_right)
	
func dialogue_right_02():
	var line: String = "Line_02"
	var is_right: bool = true
	update_dialogue(line,is_right)

func dialogue_right_03():
	var line: String = "Line_03"
	var is_right: bool = true
	update_dialogue(line,is_right)
