extends Area3D

class_name Meat

# Called when the node enters the scene tree for the first time.
func _ready():
	set_collision_layer_value(3, true)
	set_collision_layer_value(4, true)
	
	set_collision_mask_value(1, false)
	set_collision_mask_value(16, true)
	
	self.add_to_group("Meat")
	
	Messenger.grab_target.connect(detected)

func detected(target):
	var position = self.global_position
	print(target)
	if target == self:
		Messenger.on_meat_hovered.emit(position)
