extends KinematicBody2D

export var speed = 400
export var jump_speed = 1500
export var gravity = 4200
var velocity = Vector2.ZERO
var camara
var player
var spritePlayer
var colision
var colision2
var die=false
var run=false
var max_speed = speed * 1.5
var accel = 365
var decel = 280
var interface


func _ready():
	camara = $Camera2D
	player = $"."
	colision2 = $CollisionShape2D
	spritePlayer = $AnimatedSprite
	#$EmitterNode.connect("EndGame",self, "morir")
	camara.drag_margin_top = 10000
	camara.drag_margin_bottom = 100000
	
	if spritePlayer == null:
		print("Error: Nodo AnimationPlayer no encontrado")
		
func animaciones():
	if velocity.x >=3 && is_on_floor():
		if velocity.x <= speed && velocity.x >= 3:
			spritePlayer.play("walk")
			print("camina")
		elif velocity.x >= speed*1.2 && is_on_floor():
			spritePlayer.play("run2")
			print("corre")
		spritePlayer.flip_h = false
		
	if velocity.x <=-3 && is_on_floor():
		if velocity.x >= -speed && velocity.x <= -3:
			spritePlayer.play("walk")
			print("camina")
		elif velocity.x <= -speed*1.2:
			spritePlayer.play("run2")
			print("corre")
		spritePlayer.flip_h = true
	
	
	if !is_on_floor():
		spritePlayer.play("jump")
		print("saltar")
	if is_on_floor() && !Input.is_action_just_pressed("jump") && velocity.x==0:
		spritePlayer.play("default")

func colisioGoomba(collision):
	var normal = collision.get_normal()
	if normal.y < -0.9:
		normal.spritePlayer.play("die")
		print("mamaguebo glugluglu")
		collision.collider.queue_free()
		velocity.y = 50
	elif abs(normal.x) > 0.5:
		morir()

func accel_deccel():
	if velocity.x>0 && is_on_floor():
	#spritePlayer.play("walk");
		velocity.x-=velocity.x/8
	elif velocity.x<0 && is_on_floor():
		velocity.x-=velocity.x/8
	elif velocity.x==0:
		pass

func movimiento():
	if Input.is_action_pressed("move_right"):
		if Input.is_action_pressed("run"):
			velocity.x = speed*1.5
		else: 
			velocity.x = speed
	elif Input.is_action_pressed("move_left"):
		if Input.is_action_pressed("run"):
			velocity.x = -speed*1.5
		else:
			velocity.x = -speed
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_speed

func movimiento2(delta,velocity):
	if Input.is_action_pressed("move_right"):
		if Input.is_action_pressed("run"):
			velocity.x = min(velocity.x + accel * delta, max_speed)
		else:
			velocity.x = min(velocity.x + accel * delta, speed)
	elif Input.is_action_pressed("move_left"):
		# Movimiento a la izquierda.
		if Input.is_action_pressed("run"):
			velocity.x = max(velocity.x - accel * delta, -max_speed)
		else:
			velocity.x = max(velocity.x - accel * delta, -speed)
	else:
		if velocity.x > 0:
			velocity.x = max(velocity.x - decel * delta, 0)
		elif velocity.x < 0:
			velocity.x = min(velocity.x + decel * delta, 0)
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = -jump_speed
	return velocity
	
	
func colisiones():
	if colision:
		if colision.collider.is_in_group("enemy"):
			if colision.normal.y < 0:
				pass
			else:
				morir()

func _on_Timer_EndGame():
	#morir()
	pass

func morir():
	print("muerto")
	$AnimatedSprite.play("die")
	velocity.y = -jump_speed
	die=true
	remove_child($CollisionShape2D)
	#yield(get_tree().create_timer(2.0), "timeout")
	
func _physics_process(delta):
	velocity.y += gravity * delta
	if die==false:
		
		animaciones()
		
		if velocity.x <=5 && velocity.x >=-5:
			velocity.x=0
		
		velocity=movimiento2(delta,velocity)
		
		#colisiones()
		
		for i in range(get_slide_count()):  # Corregido para iterar correctamente
			var collision = get_slide_collision(i)
			if collision.collider.name.begins_with("gomba"):
				colisioGoomba(collision)
			#if collision.collider.name.begins_with("Box"):
				#collisioCapsa(collision)
			
		velocity.x=round(velocity.x)
		
		#Control para no salirse del mapa
		if $".".position.x <= 20:
			$".".position.x=20
			velocity.x=1
		elif position.y>=600:
			morir()
	else:
		velocity.x=0
	
	
	velocity = move_and_slide(velocity, Vector2.UP)
	#colision = move_and_collide((-Vector2.UP/8)*speed*delta)
	



