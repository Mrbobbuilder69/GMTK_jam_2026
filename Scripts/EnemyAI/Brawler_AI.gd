class_name BrawlerAI extends EnemyAI

#export vars
@export var rayScanDistance := float(20)
@export var patrolSpeed := float(80)
@export var detectedSpeed := float(140)
@export var patrolRotationVelocity := float(2)
@export var detectedRotationVelocity := float(4)
@export var meleeDistance := float(30)
@export var anim:AnimatedSprite2D
#private vars
var canBounce := true
var newvel:Vector2
var hitSmth=false
func _ready() -> void:
	rb.linear_velocity = (Vector2.from_angle(rb.rotation))*patrolSpeed
	super._ready()

##Bounces around a closed room, might pull this up to the enemy controller
func patrolBehaviour(delta:float) ->void:
	anim.play("default")
	if move_and_collide(Vector2.ZERO):
		print("colliding")
	if ray2D == null:
		print("Ray object not set in inspector")
		return
	
	ray2D.target_position = Vector2(1,0)*rayScanDistance

	if ray2D.is_colliding() and canBounce:
		print("now")
		var velocity := rb.linear_velocity
		#get raycast hit information 
		var collisionData := RaycastHitData.new(ray2D.get_collider(),
		ray2D.get_collision_normal(),ray2D.get_collision_point())
		#compute velocity components normal and tangent to the normal vector of the collision
		# then bounce final velocity is inverting the normal component
		var normalComponent := velocity.dot(collisionData.normal)*collisionData.normal
		var tangentialComponent := velocity - normalComponent
		var bounceVelocity := tangentialComponent - normalComponent
		newvel = bounceVelocity.normalized()* patrolSpeed * speedModifier
		#tween the rotation to the new bounce position so it doesn't look like a screensaver
		rb.linear_velocity = Vector2(0,0)
		tweenToAngle(newvel.angle(),patrolRotationVelocity)
		canBounce = false
	#wait until the tween is done before setting new velocity and position
	elif not ray2D.is_colliding() and not tween == null:
		if not tween.is_running():
			canBounce = true
			rb.linear_velocity = newvel

func onDetected() -> void:
	#tween.kill()
	print("player just detected")

##Runs at the player
func detectedBehaviour(delta:float) ->void:
	print("detected")
	#check if the enemy is in melee range, otherwise rotate towards and run at the player
	var distanceTo = (rb.position - playerref.position).length()
	var targetAngle = get_angle_to(playerref.position) + rb.rotation
	rb.rotation = rotate_toward(rb.rotation, targetAngle, detectedRotationVelocity * delta)
	if distanceTo > meleeDistance:
		rb.linear_velocity = Vector2.from_angle(rb.rotation) * detectedSpeed * speedModifier
	else:
		rb.linear_velocity = Vector2(0,0)
		#Insert melee attack and or damage logic here

func onUnDetect() -> void:
	#tween.kill()
	newvel = Vector2.from_angle(rb.rotation)*patrolSpeed * speedModifier
	rb.linear_velocity = newvel
	canBounce = true
