extends RigidBody2D
var hit
var collision
func _physics_process(delta: float) -> void:
	collision=move_and_collide(delta*linear_velocity)
	if collision:
		hit=true
		if collision.get_collider().has_meta("Enemy"):
			collision.get_collider().blood=0
