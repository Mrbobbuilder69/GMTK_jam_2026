extends Node2D

@export var activation_distance : float
@export var boss_change_pos_interval : float

var player
var boss_battle_started := false
var boss_pos_points : Array[Vector2]
var enemy_spawners : Array[Node2D]
var boss_spawner : Node2D
var boss_move_timer : float
var boss_target_position : Vector2

func _ready() -> void:
	player = get_node("/root/Node2D/player")
	boss_move_timer = boss_change_pos_interval
	
	for child in find_child("boss_points").get_children():
		boss_pos_points.append(child.global_position)
	boss_target_position = boss_pos_points.pick_random()
	
	for child in find_child("enemy_spawners").get_children():
		if child.name == "boss_spawner":
			boss_spawner = child
		else:
			enemy_spawners.append(child)

func _process(delta : float) -> void:
	
	# setup boss fight
	if global_position.distance_to(player.global_position) < activation_distance and !boss_battle_started:
		
		Effects.spawn_sfx("res://Sound/invalid.wav", self)
		if get_node("/root/Node2D/cam"):
			get_node("/root/Node2D/cam").shake (20.0)
		
		boss_battle_started = true
		
		# ** set up boss_battle **
		
		# spawn boss
		boss_spawner.spawning = true
		
		# activate_spawners
		for spawner in enemy_spawners:
			spawner.spawning = true
		
	
	# move boss at fixed intervals
	boss_spawner.global_position = lerp (boss_spawner.global_position, boss_target_position, min(20.0 * delta, 1.0))
	
	if boss_battle_started:
		boss_move_timer -= delta
		
		if boss_move_timer <= 0.0:
			boss_target_position = boss_pos_points.pick_random()
			boss_move_timer = boss_change_pos_interval
			if get_node("/root/Node2D/cam"):
				get_node("/root/Node2D/cam").shake (20.0)
				Effects.spawn_sfx("res://Sound/invalid.wav", self)
			
	
