@abstract class_name EnemyAI extends RigidBody2D
enum AIState {patrol,detected}

var playerref : RigidBody2D
@export var rb :RigidBody2D
@export var blood := float(100) #maybe set this up as a percentage
var currentState := AIState.patrol

class RaycastHitData:
    var collider
    var normal:Vector2
    var point:Vector2
    func _init(icollider, inormal, ipoint) -> void:
        collider = icollider
        normal = inormal
        point = ipoint

@export var ray2D :RayCast2D
@abstract func onPlayerDetected() ->void

@abstract func onPatrol(delta:float) ->void

func setState(state:AIState) ->void:
    currentState = state

func _physics_process(delta: float) -> void:
    match currentState:
        AIState.patrol:
            onPatrol(delta)
        AIState.detected:
            onPlayerDetected()
