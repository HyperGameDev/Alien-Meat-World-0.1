extends Node

# @onready var mesh = player.get_node("Alien/Armature/Skeleton3D/Alien_Heart")

var max_health = 4
var current_health = 4

var empathy_damage_amount = 1

var dmg_timer_end = false

@onready var dmg_flash_timer : Timer = Timer.new()
@onready var material_reset : Timer = Timer.new()


func _ready():
	Messenger.empathy_consumed.connect(on_empathy_consumed)
	
func on_empathy_consumed():
#	print("empathy damage detected")
	Messenger.empathy_is_damaged.emit()

	# Start Mesh Flash
	var flash_length = 0
	flash_length += 4
#	$Timer_Heart_Dmg_Flash.start(flash_length)
	dmg_timer_end = false
		
	if current_health >= 0:
#		print("OG", " ", "empathy current health", " ", current_health)
		# Inform Messenger of damage, e.g. so UI_FX can flash the screen
		Messenger.empathy_health.emit(current_health, max_health)
		# Ensure limb is visible
#		mesh.show()
		# Apply damage
		current_health -= empathy_damage_amount
		# Update the Damage Label
#		player.get_node("Alien/Armature/Skeleton3D/Alien_Heart/Dmg_Label").text = str(current_health)

			
	# Damaged with <=0 Health	
	if current_health <= 0:
#		mesh.hide()
		pass
