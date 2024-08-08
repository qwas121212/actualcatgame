extends CharacterBody2D
@onready var game_manager = %GameManager

	
func _on_area_2d_body_entered(body):
	if (body.name == "CharacterBody2D"):
		var y_delta = position.y - body.position.y
		var x_delta = body.position.x - position.x
		print(x_delta)
		if (y_delta > 190):
			print("destroy enemy")
			queue_free()
			body.jumpp()
		else:
			print("decrease player health")
			game_manager.decrease_health()
			if (x_delta > 0):
				body.jump_side(500)
			else:
				body.jump_side(-500)
