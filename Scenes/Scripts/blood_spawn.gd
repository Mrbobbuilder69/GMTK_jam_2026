extends Area2D

@export var p1: Vector2 = Vector2(50, 50)
@export var p2: Vector2 = Vector2(1100, 600)

@onready var decal: Resource = preload("res://Scenes/blood_decal.tscn")

func _ready():
	randomize()

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("f"):
		spawn_decal()

func get_random_point_inside(point1: Vector2, point2: Vector2) -> Vector2:
	
	var x_value: float = randf_range(p1.x, p2.x)
	var y_value: float = randf_range(p1.y, p2.y)
	
	var random_point_inside: Vector2 = Vector2(x_value, y_value)
	
	return(random_point_inside)

func spawn_decal():
	
	var decal_instance: Node = decal.instantiate()
	
	add_child(decal_instance)
	
	var spawn_location: Vector2 = get_random_point_inside(p1, p2)
	
	decal_instance.set_position(spawn_location)
