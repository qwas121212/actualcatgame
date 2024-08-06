extends Node2D
@onready var game_manager = %GameManager
@onready var character_body_2d = $"../CharacterBody2D"




func _on_area_2d_body_entered(body):
	if (body == character_body_2d):
		print("decrease player health")
		game_manager.decrease_health()
