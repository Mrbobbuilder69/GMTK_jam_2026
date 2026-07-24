extends RigidBody2D

@export var speed : float = 20000.0
@export var footstep_interval : float = 20.0

var footstep_distance_counter : float = 0.0
var prev_position : Vector2

func _physics_process(delta: float) -> void:
	var inputVec := Input.get_vector("Left","Right","Up","Down")
	var mousePos = get_global_mouse_position()
	linear_velocity = speed*inputVec
	look_at(mousePos)
	
	footstep_distance_counter += global_position.distance_to(prev_position)
	if footstep_distance_counter > footstep_interval and inputVec != Vector2.ZERO:
		Effects.spawn_sfx("res://Sound/footstep.wav", self, 0.0, 1.0, self.global_position)
		Effects.spawn_particles("res://ParticleEffects/footstep_particles.tscn", self.global_position, self, true)
		footstep_distance_counter = 0.0
	
	prev_position = global_position

	#peepeepoopoo
