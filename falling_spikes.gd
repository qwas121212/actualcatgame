extends Node2D
@onready var game_manager = %GameManager
@onready var animation_player = $AnimationPlayer
@export var speed = 160.0
var current_speed = 0.0

func _physics_process(delta):
	position.y += current_speed * delta
	
	
func _on_plauerdetection_body_entered(body):
	if (body.name == "CharacterBody2D"):
		print("decrease player health")
		game_manager.decrease_health()


func _on_hitbox_body_entered(body):
	if (body.name == "CharacterBody2D"):
		animation_player.play("fallingspikes")
	else:
		animation_player.play("still")

func fall():
	current_speed = speed
	await get_tree().create_timer(5).timeout
	queue_free()
