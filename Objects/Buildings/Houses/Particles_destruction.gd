extends GPUParticles3D

class_name ParticlesDestruction

# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_lifetime($"..".hit_particle_lifetime)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
