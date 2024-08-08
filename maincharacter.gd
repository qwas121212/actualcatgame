extends CharacterBody2D


var SPEED = 300.0
const JUMP_VELOCITY = -400.0
const JUMP_VELOCITY_HIGHER = -500.0
const DASH_VELOCITY = 3000.0
#jump count
var jump_count = 0

#dash count
var dash_count = 0
var max_dashes = 1

#water
var is_in_water : bool = false
@onready var weapon = $weapon
@onready var weaponfx = $weaponfx
@onready var animation = $AnimationPlayer
@export var current_item : Item:
	set(value):
		current_item = value
		if current_item != null:
			if current_item.animation in ["sword"]:
				set_damage(current_item.damage)
			else:
				set_damage(1)

@onready var actionable_finder = $Direction/ActionableFinder
@onready var timer = $Timer
@export var SWIM_GRAVITY_FACTOR : float = 0.25
@export var SWIM_VELOCITY_CAP : float  = 80
@export var SWIM_JUMP : float = -200
@export var projectile_node : PackedScene

var counter : int = 1
var can_move : bool = true:
	set(value):
		can_move = value
		if value == false:
			SPEED = 0
		else:
			SPEED = 300.0
var time : float = 0


func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("next"):
		var actionables = actionable_finder.get_overlapping_areas()
		if actionables.size() > 0:
			actionables[0].action()
			return

func _ready():
	Global.playerBody = self
	
func jumpp():
	velocity.y = JUMP_VELOCITY
	
func jump_side(x):
	velocity.y = JUMP_VELOCITY
	velocity.x = x
	
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	if time > 0 :
		time -= delta
	# Animations
	if can_move:
		if (is_in_water):
			animation.play("idle")
	
		if (velocity.x > 1 || velocity.x < -1):
			animation.play("run")
		else:
			animation.play("idle")
		
		if not is_on_floor():
			velocity.y += gravity * delta
			animation.play("jump")
		
		if is_on_floor():
			jump_count = 0
		
	#gravity
		if not is_on_floor():
			if(!is_in_water):
				velocity.y += gravity * delta
			else:
				velocity.y = clampf(velocity.y + (gravity * delta * SWIM_GRAVITY_FACTOR), -10000, SWIM_VELOCITY_CAP)

	# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and jump_count == 1:
			velocity.y = JUMP_VELOCITY_HIGHER 
			jump_count += 1

		if Input.is_action_just_pressed("ui_accept") and is_on_floor() and jump_count < 2:
			velocity.y = JUMP_VELOCITY
			jump_count += 1
		
		
	#Handle dash
		if Input.is_action_just_pressed("dash") and dash_count < 2 and not is_on_floor():
			velocity.x = DASH_VELOCITY
			dash_count += 1
		
		if dash_count == 1:
			timer.start()
		
		#jump in water
		if Input.is_action_just_pressed("up") and is_in_water == true:
			velocity.y = SWIM_JUMP
			animation.play("jump")
		
		
	#travelling down in water
		if Input.is_action_pressed("down") and is_in_water:
			velocity.y = 300
			animation.play("idle")
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			
		if Input.is_action_just_pressed("reset"):
			reset()
	move_and_slide()
	
	if velocity.x < 0:
		$Sprite2D.flip_h = true
		$weapon.flip_h = true
	elif velocity.x > 0:
		$Sprite2D.flip_h = false
		$weapon.flip_h = false

#timer for dash cooldown
func _on_timer_timeout():
	print_debug("time")
	dash_count = 0


@warning_ignore("shadowed_variable")
func _on_water_detection_2d_water_state_changed(is_in_water):
	self.is_in_water = is_in_water
	print(is_in_water)
	
func _input(event):
	if event.is_action_pressed("attack") and time <= 0:
		play_animation()

func combo(animation):
	if animation in ["sword"]:
		return "_" + str(counter)
	else:
		return ""
		
func play_animation():
	can_move = false
	time = 0.4
	$weapon.texture = current_item.texture
	weaponfx.play(current_item.animation + combo(current_item.animation))
	animation.play(current_item.animation + combo(current_item.animation))
	counter += 1 
	if counter > 3:
		counter = 1

func _on_animation_finished(anim_name):
	can_move = true
	
func set_damage(amount):
	$Hitbox.damage = amount
	
func shoot_projectile():
	var projectile = projectile_node.instantiate()
	projectile.position = position
	projectile.set_direction($Sprite2D.flip_h, current_item.projectile)
	projectile.damage = current_item.damage
	get_tree().current_scene.add_child(projectile)

func reset():
	get_tree().reload_current_scene()
	

