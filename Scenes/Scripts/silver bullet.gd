extends RigidBody2D
var hit
func _physics_process(delta: float) -> void:
	if move_and_collide(delta*linear_velocity):
		hit=true
