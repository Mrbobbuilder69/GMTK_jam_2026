# provides functions with parameters to easily spawn particles and audio
extends Node

# just spawns particles at the position given, keep auto_despawn true if the particle doesnt loop, if it loops you can set it to false
func spawn_particles(file_path : String, global_position : Vector2, parent : Node, auto_despawn : bool = true) -> void:
	var particles_node = load(file_path).instantiate()
	parent.add_child(particles_node)
	particles_node.global_position = global_position
	particles_node.emitting = true
	
	if auto_despawn:
		var duration = particles_node.lifetime
		await get_tree().create_timer(duration).timeout
		if particles_node:
			particles_node.queue_free()

# if global_position is given as null audio is played without position info, this is recommended for ui
func spawn_sfx(file_path : String, parent: Node, volume : float = 0.0, base_pitch : float = 1.0, global_position : Variant = null) -> void:
	
	var audio_node
	if global_position == null:
		audio_node = AudioStreamPlayer2D.new()
	else:
		audio_node = AudioStreamPlayer.new()
	parent.add_child(audio_node)
	audio_node.stream = load(file_path)
	audio_node.volume_db = volume
	audio_node.pitch_scale = max (0.001, base_pitch + randf_range(-0.1,0.1))
	audio_node.play()
	
	await audio_node.finished
	if audio_node:
		audio_node.queue_free()
