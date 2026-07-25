extends Area2D
var inputVec=Vector2(50,0)
var lastInput=inputVec
signal shoot(posX, posY, velX, velY)
var meleeHit
var enemyHit
var space_state
var result
func _physics_process(delta):
	look_at(get_global_mouse_position())
	space_state=get_world_2d().direct_space_state
	inputVec=Input.get_vector("Left", "Right", "Up", "Down")
	if inputVec!=Vector2(0,0):
		position=Vector2(50, 0)
		lastInput=inputVec

	if Input.get_action_raw_strength("attack"):
		shoot.emit(global_position.x, global_position.y)
	
	if Input.get_action_raw_strength("melee"):
		get_child(2).position=get_child(3).position
		get_child(2).target_position=get_mouse_unit()*50
		result=get_child(2).get_collider()
		if result and result.has_meta("Enemy"):
			result.queue_free()
		
	get_child(3).clear_points()
	get_child(3).add_point(get_child(2).position)
	get_child(3).add_point(get_child(2).target_position)
		
func get_mouse_unit():
	var mouseDir=Vector2(0,0)
	var distX=get_global_mouse_position().x-position.x
	var distY=get_global_mouse_position().y-position.y
	if position.x>get_global_mouse_position().x:
		mouseDir.x=-1
	else:
		mouseDir.x=1
	if position.y>get_global_mouse_position().y:
		mouseDir.y=1
	else:
		mouseDir.y=-1
	var tan=distY/distX
	var unitVecXSquare=1/(tan**2+1)
	var unitVecX=unitVecXSquare**0.5
	return Vector2(unitVecX, unitVecX*tan)

	
