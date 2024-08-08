extends Node2D
@onready var character_body_2d = $"../CharacterBody2D"
@onready var animation_player = $AnimationPlayer

@export var force = -1000.0


func _on_area_2d_body_entered(body):
	if (body == character_body_2d):
		character_body_2d.velocity.y = force
		animation_player.play("jumppadd")
	else:
		animation_player.play("RESET")
