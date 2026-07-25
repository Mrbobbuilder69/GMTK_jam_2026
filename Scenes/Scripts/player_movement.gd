extends RigidBody2D

@export var speed : float = 100.0
@export var sprint_speed : float = 150.0
@export var dash_speed : float = 300.0
@export var dash_cooldown : float = 1.0
@export var footstep_interval : float = 30.0
@export var transition_speeds_speed : float = 10.0 # basically how fast speed updates between states

@onready var bloodbar: ProgressBar = $"../cam/UI/PanelContainer/MarginContainer/Blood"


var footstep_distance_counter : float = 0.0
var prev_position : Vector2
var cur_speed : float
var dash_cooldown_timer := 0.0

func _physics_process(delta: float) -> void:
	var inputVec := Input.get_vector("Left","Right","Up","Down")
	var mousePos = get_global_mouse_position()
	
	if Input.is_action_pressed("Sprint"):
		cur_speed = lerpf(cur_speed, sprint_speed, min(transition_speeds_speed * delta, 1.0))
	else:
		cur_speed = lerpf(cur_speed, speed, min(transition_speeds_speed * delta, 1.0))
	linear_velocity = cur_speed*inputVec
	look_at(mousePos)
	
	dash_cooldown_timer -= delta
	if dash_cooldown_timer <= 0.0 and Input.is_action_just_pressed("Dash"):
		cur_speed = dash_speed
		dash_cooldown_timer = dash_cooldown
	
	footstep_distance_counter += global_position.distance_to(prev_position)
	if footstep_distance_counter > footstep_interval * (cur_speed/speed) and inputVec != Vector2.ZERO:
		Effects.spawn_sfx("res://Sound/footstep.wav", self, 0.0, cur_speed/speed, self.global_position)
		Effects.spawn_particles("res://ParticleEffects/footstep_particles.tscn", self.global_position, self, true)
		footstep_distance_counter = 0.0
	
	prev_position = global_position
	
	## Blood Increase
	
	##if Input.is_action_just_pressed("f"):
		##blood = clamp(blood + 5, MIN_BLD, MAX_BLD)

func _process(delta):
	bloodbar.value = Global.blood
