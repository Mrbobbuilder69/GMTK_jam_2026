class_name BrawlerAI extends EnemyAI

#Raycast parameters:
#{
#   position: Vector2 # point in world space for collision
#   normal: Vector2 # normal in world space for collision
#   collider: Object # Object collided or null (if unassociated)
#   collider_id: ObjectID # Object it collided against
#   rid: RID # RID it collided against
#   shape: int # shape index of collider
#  metadata: Variant() # metadata of collider
#}

@export var rayScanDistance := float(20)
@export var moveSpeed := float(20)
@export var rotationVelocity := float(2)
var tween : Tween
var canBounce := true
var newvel:Vector2
func _ready() -> void:
	tween = create_tween()
	rb.linear_velocity = (Vector2.from_angle(rb.rotation))*moveSpeed

##Bounces around a closed room
func onPatrol(delta:float) ->void:
	if ray2D == null:
		print("Ray is null ")
		return
    #
	ray2D.target_position = Vector2(1,0)*rayScanDistance

	if ray2D.is_colliding() and canBounce:

		rb.linear_velocity = Vector2(0,0)
	    var velocity := rb.linear_velocity
		var currentAngle := rb.rotation
        #get raycast hit information 
		var collisionData := RaycastHitData.new(ray2D.get_collider(),
		ray2D.get_collision_normal(),ray2D.get_collision_point())
        #compute bounce, bounce final velocity is inverting the normal component
		var normalComponent := velocity.dot(collisionData.normal)*collisionData.normal
		var tangentialComponent := velocity - normalComponent
		var bounceVelocity := tangentialComponent - normalComponent
		newvel = bounceVelocity.normalized()*moveSpeed
        #tween the rotation to the new bounce position so it doesn't look like a screensaver
		tween = create_tween()
		var diff := angle_difference(currentAngle,newvel.angle()) 
		var targetAngle = currentAngle+diff
		
		tween.tween_property(rb,"rotation",targetAngle,abs(diff)/rotationVelocity)
		canBounce = false
	#wait until the tween is done before setting new velocity and position
	elif not ray2D.is_colliding() and not tween == null:
		if not tween.is_running():
			canBounce = true
			rb.linear_velocity = newvel
		

func onPlayerDetected() ->void:
	print("player detected")
