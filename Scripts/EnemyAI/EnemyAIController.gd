@abstract class_name EnemyAI extends RigidBody2D
##classes and enums
signal death(deathPos)
enum AIState {patrol,detected}
class RaycastHitData:
	var collider
	var normal:Vector2
	var point:Vector2
	func _init(icollider, inormal, ipoint) -> void:
		collider = icollider
		normal = inormal
		point = ipoint

##Editor vars
@export var rb :RigidBody2D
@export var maxBlood := float(100) #maybe set this up as a percentage
@export var ray2D :RayCast2D
@export var detectionDistance := float(100)
##degrees
@export var fov := float(120)

##Private vars
var playerref : RigidBody2D
var currentState := AIState.patrol
var blood : float
var speedModifier = 1
var tween : Tween
var dead = false

##Functions
@abstract func detectedBehaviour(delta:float) ->void
@abstract func patrolBehaviour(delta:float) ->void
@abstract func onDetected() -> void
@abstract func onUnDetect() -> void


func tweenToAngle(target:float, angVel:float) ->void:
		tween = create_tween()
		var currentAngle = rb.rotation
		var diff := angle_difference(currentAngle,target) 
		var targetAngle = currentAngle+diff
		tween.tween_property(rb,"rotation",targetAngle,abs(diff)/angVel)

func _ready() -> void:
	blood = maxBlood
	setState(AIState.patrol)
	playerref = get_node("%player")

func onDeath():
	print("summon corpse and blood stuff here and do other death things")
	freeze=true
	death.emit(position)

func onDamage(damangeAmount:float):
	print("particles and other damage effect stuff")
	blood -= damangeAmount

#Returns if the player is visible or not, to check state change
func checkPlayerVisible(playerPosition :Vector2) ->bool:
	#first check if the player is in range
	var displacementVector = playerPosition-rb.position
	var distance = displacementVector.length()
	if distance > detectionDistance:
		return false
	#then find the forward vector and using the dot product identity see if it is within a half fov angular distance
	var forwardVector = Vector2.from_angle(rb.rotation)
	var dp = (forwardVector).dot(displacementVector.normalized())
	if dp <= cos(deg_to_rad(fov)/2):
		return false
	
	#run the raycast to check if the player is blocked by terrain
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(rb.position,playerPosition)
	#BIT MASK, needs to be set via the bitwise operations(check the docks)
	#change this to whatever the terrain is on
	query.collision_mask = 1
	var result = space_state.intersect_ray(query)
	if result and result.collider!=playerref:
		print(result)
		return false
	
	return true
	

func setState(state:AIState) ->void:
	currentState = state

func _physics_process(delta: float) -> void:
	#Handle death
	if blood <= 0 and !dead:
		onDeath()
		dead = true
	if dead:
		return
	#State machine
	match currentState:
		AIState.patrol:
			patrolBehaviour(delta)
		AIState.detected:
			detectedBehaviour(delta)
	
	#State switching logic
	if playerref != null:
		var playervisible := checkPlayerVisible(playerref.position)
		if playervisible and currentState != AIState.detected:
			print("player detected")
			onDetected()
			setState(AIState.detected)
		elif !playervisible and currentState == AIState.detected:
			onUnDetect()
			setState(AIState.patrol)
			print("Nothing to see here")
	else:
		print("Enemy AI player reference not set")
