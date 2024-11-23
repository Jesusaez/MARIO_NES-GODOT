extends KinematicBody2D

signal PlayerMoved

export var speed = 400
export var jump_speed = 900
export var gravity = 1500
var velocity = Vector2.ZERO
var camara
var player
var spritePlayer

func _ready():
	camara = $Camera2D
	player = $"."
	spritePlayer = $AnimatedSprite
	camara.drag_margin_top = 10
	
	if spritePlayer == null:
		print("Error: Nodo AnimationPlayer no encontrado")
		

func _physics_process(delta):
	velocity.y += gravity * delta
	velocity.x = 0
	#print(player.position.x)
	#if camara.limit_left >= camara.get_camera_position().x:
		#camara.limit_left = camara.get_camera_position().x-200
	if player.position.x <= camara.limit_left+30:
		player.position.x = camara.limit_left+30
	
	if Input.is_action_pressed("move_right"):
		if Input.is_action_pressed("run"):
			velocity.x += speed*1.5
			spritePlayer.flip_h = false
			spritePlayer.play("run2")
	
		else: 
			velocity.x += speed
			spritePlayer.flip_h = false
			spritePlayer.play("walk")
		#$Camera2D.limit_left = $".".position.x-600
	elif Input.is_action_pressed("move_left"):
		if Input.is_action_pressed("run"):
			velocity.x -= speed*1.5
			spritePlayer.flip_h = true
			spritePlayer.play("run2")
		else:	
			velocity.x -= speed
			spritePlayer.flip_h = true
			spritePlayer.play("walk")
	
	else:
		if is_on_floor():
			spritePlayer.play("default")
	if velocity.x!=0:
		emit_signal("PlayerMoved")

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_speed
	if !is_on_floor():
		spritePlayer.play("jump")
	
	velocity = move_and_slide(velocity, Vector2.UP)
