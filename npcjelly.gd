extends CharacterBody2D


func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("next"):
		DialogueManager.show_example_dialogue_balloon(load("res://dialogues/main.dialogue"), "start")
		return
