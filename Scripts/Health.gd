extends Area3D

class_name Health

@export var empathy_ok = false

@onready var meat_mesh = $Meat_Object

var default_material = StandardMaterial3D.new()
var hover_material = StandardMaterial3D.new()
var select_material = StandardMaterial3D.new()


func _ready():
	# Temporary Collidable Healing
	area_entered.connect(check_area)
	
	# Messenger informing sscript that health is hovered
	Messenger.object_hovered.connect(health_hovered)	
	
	# Setting up meat material changes based on cursor behavior
	default_material.set_albedo(Color(.32, .75, .35))
	hover_material.set_albedo(Color(.32, .75, .35))
	select_material.set_albedo(Color(1, 0, .1))
	
func check_area(collided_bodypart):
	# collided_bodypart.mesh.hide()
	# collided_bodypart.mesh
	# print("Health Sees Player")
	Messenger.health_detected.emit(collided_bodypart)
	if empathy_ok == false:
		Messenger.empathy_is_damaged.emit()
	
	
func health_hovered(target):
	var hovered = self
	
	# Meat is Hovered
	if target == hovered and meat_mesh.material_override != hover_material:
		# Show Arrow
		meat_mesh.visible = true
		# Change Material
		meat_mesh.material_override = hover_material
		
	# Meat is NOT Hovered	
	if target != hovered and meat_mesh.material_override == hover_material:
		# Hide Arrow
		meat_mesh.visible = false
		# Change Material
		meat_mesh.material_override = default_material


	# Meat is Selected	
	if target == hovered and meat_mesh.material_override == hover_material and Input.is_action_pressed("Grab"):
		# Hide Arrow
		meat_mesh.visible = false
		# Change Material
		meat_mesh.material_override = select_material
		# Update Variable
		var is_grabbed = true
		# Inform Messesnger
		Messenger.health_grabbed.emit(is_grabbed)
		
		
	# Meat is Unselected (When Not Hovering)	
	if target != hovered and meat_mesh.material_override == select_material:
		# Hide Arrow
		meat_mesh.visible = false
		# Change Material
		meat_mesh.material_override = default_material
