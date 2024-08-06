extends Node2D


@export var force = -500


func _on_area_2d_body_entered(body):
	if (body.name == "CharacterBody2D"):
		CharacterBody2D.velocity.y = force
