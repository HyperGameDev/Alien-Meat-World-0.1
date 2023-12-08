extends Area3D

class_name Health

@onready var meat_mesh = $Meat_Object

var default_material = StandardMaterial3D.new()
var hover_material = StandardMaterial3D.new()
var select_material = StandardMaterial3D.new()


func _ready():
	# Temporary Collidable Healing
	area_entered.connect(check_area)
	
	# Inform Messenger that health is hovered
	Messenger.object_hovered.connect(health_hovered)
	
	# Setting up meat material changes based on cursor behavior
	default_material.set_albedo(Color(1, .2, .36))
	hover_material.set_albedo(Color(1.6, .5, .5))
	select_material.set_albedo(Color(1, 0, .1))
	
func check_area(bodypart_area):
	# bodypart_area.mesh.hide()
	# bodypart_area.mesh
	# print("Health Sees Player")
	Messenger.health_detected.emit(bodypart_area)
	
	
func health_hovered(target):
	var hovered = self
	
	# Meat is Hovered
	if target == hovered and meat_mesh.material_override != hover_material:
		# Change Material
		meat_mesh.material_override = hover_material
		
	# Meat is NOT Hovered	
	if target != hovered and meat_mesh.material_override == hover_material:
		# Change Material
		meat_mesh.material_override = default_material


	# Meat is Selected	
	if target == hovered and meat_mesh.material_override == hover_material and Input.is_action_pressed("Grab"):
		# Change Material
		meat_mesh.material_override = select_material
		# Update Variabled
		var is_grabbed = true
		# Inform Messesnger
		Messenger.health_grabbed.emit(is_grabbed)
		
		
	# Meat is Unsdelected (When Not Hovering)	
	if target != hovered and meat_mesh.material_override == select_material:
		#Change Material
		meat_mesh.material_override = default_material
