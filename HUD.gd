extends Control


func _ready():		Messenger.body_damaged.connect(damage_detected)
	
func damage_detected(collided_bodypart):
	pass
#	print(collided_bodypart)
#	print(collided_bodypart.player)
		# Assigning input integer to enum array
#	match collided_bodypart:
#		_:
#			msg_type_hover_state = Msg_Meta_Hover.EAGER
#		_:
#			msg_type_hover_state = Msg_Meta_Hover.EVEN
#		_:
#			msg_type_hover_state = Msg_Meta_Hover.DISTANT
#
#	# Applying enum array to button sizes	
##	match msg_type_hover_state:
#		Msg_Meta_Hover["EAGER"]:
#			%"Button Eager".scale = Vector2(1.5,1.5)
#			%"Button Even".scale = Vector2(1,1)
#			%"Button Distant".scale = Vector2(1,1)
##			%"Meta Responses".position.x = %"Button Eager".global_position.x - 65
#		Msg_Meta_Hover["EVEN"]:
#			%"Button Eager".scale = Vector2(1,1)
#			%"Button Even".scale = Vector2(1.5,1.5)
#			%"Button Distant".scale = Vector2(1,1)
##			%"Meta Responses".position.x = %"Button Even".global_position.x - 65
#		Msg_Meta_Hover["DISTANT"]:
#			%"Button Eager".scale = Vector2(1,1)
#			%"Button Even".scale = Vector2(1,1)
#			%"Button Distant".scale = Vector2(1.5,1.5)
##			%"Meta Responses".position.x = %"Button Distant".global_position.x - 65
