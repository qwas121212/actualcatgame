extends Node
@onready var pointslabel = %pointslabel
@export var hearts : Array[Node]
@onready var character_body_2d = $"."
@onready var animation_player = $AnimationPlayer

var points = 0
var lives = 8

func decrease_health():
	lives -= 1 
	print(lives)
	for h in 8:
		if (h < lives):
			hearts[h].show()
		else:
			hearts[h].hide()
	if (lives == 0):
		get_tree().reload_current_scene()
	

func add_point():
	points += 1
	print(points)
	pointslabel.text = "Points: " + str(points)
