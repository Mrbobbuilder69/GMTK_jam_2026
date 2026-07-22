extends Node2D

@export var rb : RigidBody2D
@export var speed := float(1.2)
func _physics_process(delta: float) -> void:
	var inputVec := Input.get_vector("Left","Right","Down","Up")
	rb.linear_velocity = speed*inputVec
