extends Node2D
var bulletSrc=preload("res://Scenes/enemy_bullet.tscn")
var bullet=bulletSrc.instantiate()
var bulletTimer=0
var inputVec
var deltaTime
var mouseNormal

func _physics_process(delta):
	look_at(get_global_mouse_position())
	deltaTime=delta
	if bulletTimer>0:
		bulletTimer-=delta
	elif get_child_count()>0:
		remove_child(get_child(0))
	
	
	if get_child_count()==1 and get_child(0).hit==true:
		get_child(0).hit=false
		remove_child(get_child(0))
		



func weapon_shoot(posX, posY, playerPosX, playerPosY):
	position=Vector2(posX, posY)
	if get_child_count()==0 and bulletTimer<=0:
		bulletTimer=0.5
		print(mouseNormal)
		add_child(bullet)
		get_child(0).position=Vector2(0,0)
		get_child(0).linear_velocity=5000*get_player_unit(playerPosX, playerPosY)*deltaTime

func get_player_unit(playerPosX, playerPosY):
	var mouseDir=Vector2(0,0)
	var distX=global_position.x-playerPosX
	var distY=global_position.y-playerPosY
	if distX<0:
		mouseDir=Vector2(1,1)
	else:
		mouseDir=Vector2(-1,-1)
	var tan=distY/distX
	var unitVecXSquare=1/(tan**2+1)
	var unitVecX=unitVecXSquare**0.5
	return Vector2(unitVecX, unitVecX*tan)*mouseDir
	
	


func _on_cannon_enemy_shoot(pos: Vector2, playerPos: Vector2) -> void:
	weapon_shoot(pos.x, pos.y, playerPos.x, playerPos.y)
