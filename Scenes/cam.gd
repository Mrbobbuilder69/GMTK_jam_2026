extends Camera2D

@export var target : Node
@export var follow_speed : float

func _process(delta: float) -> void:
	global_position = lerp(global_position, target.global_position, follow_speed * delta)
