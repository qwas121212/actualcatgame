extends Node2D


@onready var game_manager = %GameManager





func _on_area_2d_body_entered(body):
	if (body.name == "CharacterBody2D"):
		print("decrease player health")
		game_manager.decrease_health()
