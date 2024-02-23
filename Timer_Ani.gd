extends Timer

var timer = 0.0

func _on_reach_start():
	%Timer_Ani.start(.1)
	print("Anim Started!")

func _on_reach_end():
	%Timer_Ani.stop()
	print("Anim Stopped! (", str(timer), ")")
	await get_tree().create_timer(.2).timeout
	timer = 0.0


func _on_timeout():
	timer += .1
