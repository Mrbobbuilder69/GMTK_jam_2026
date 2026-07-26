extends Node2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_meta("Player"):
		Global.blood = clamp(Global.blood + 50, 0, 200)
	
	self.queue_free()
