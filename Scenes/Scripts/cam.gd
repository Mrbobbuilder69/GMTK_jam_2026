extends Camera2D

@export var target : Node
@export var follow_speed : float
@export var shake_decay_speed : float
@export var shake_interval : float

var shake_mag := 0.0
var shake_timer := 0.0

func _process(delta: float) -> void:
	global_position = lerp(global_position, target.global_position, follow_speed * delta)
	
	# decay shake mag
	shake_mag = lerpf(shake_mag, 0.0, min(shake_decay_speed * delta, 1.0))
	
	# cam shake
	shake_timer -= delta
	if shake_timer <= 0.0 and shake_mag > 1.0:
		var shake_dir = Vector2(randf_range(-1.0,1.0), randf_range(-1.0,1.0)).normalized()
		global_position += shake_mag * shake_dir
	

func shake(magnitude : float) -> void:
	shake_mag = magnitude
