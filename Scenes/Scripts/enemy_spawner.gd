extends Node2D

@export var spawn_count : int = 1.0 # set to 9999 for inf
@export var spawn_interval : float = 1.0
@export var enemies : Array[PackedScene]
@export var spawning = false

var spawn_timer := spawn_interval



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	spawn_timer -= delta
	
	if spawn_timer <= 0.0 and spawning and spawn_count > 0:
		spawn_timer = spawn_interval
		spawn_count -= 1
		
		# instantiate enemy
		var enemy = enemies.pick_random().instantiate()
		add_child(enemy)
		enemy.global_position = global_position
		
