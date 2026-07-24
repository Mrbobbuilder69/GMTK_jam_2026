extends Control

@onready var label: Label = $Label

var blood = 0
var rand
const MIN_BLD = 0
const MAX_BLD = 200

func _input(event):
	if Input.is_action_just_pressed("f"):
		blood = clamp(blood + 5, MIN_BLD, MAX_BLD)

func _process(delta):
	label.text = str(blood)
	
	rand = randf_range(0.00, 5.00)
	if rand >= 4.95:
		blood = clamp(blood - rand, MIN_BLD, MAX_BLD)
