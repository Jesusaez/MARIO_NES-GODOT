extends KinematicBody2D

export var speed = 400
export var jump_speed = 1600
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
signal killEnemy
signal playerDead
signal coinBlock
signal mushBlock
signal brickBlock
signal win

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
	if collision.collider.is_in_group("enemy"):
		var normal = collision.get_normal()
		if normal.y < -0.9:  # Colisión desde arriba
			emit_signal("killEnemy", collision.collider)  # Emite la señal y pasa el enemigo como argumento
			collision.collider.queue_free()  # Elimina al enemigo
			velocity.y = -jump_speed/2
		else:  # Colisión por cualquier otro lado
			morir()

func colisioFlag(collision):
	if collision.collider.is_in_group("flag"):
		emit_signal("win", collision.collider)  # Emite la señal y pasa el enemigo como argumento


func colisioCoinBlock(collision):
	if collision.collider.is_in_group("coinBlock"):  # Comprueba si es un coinBlock
		var normal = collision.get_normal()
		
		if normal.y > 0.9:  # Colisión desde abajo
			emit_signal("coinBlock", collision.collider)  # Emite la señal y pasa el bloque como argumento
		# Si no hay colisión desde abajo, no hace nada

func colisioBrickBlock(collision):
	if collision.collider.is_in_group("brickBlock"):  # Comprueba si es un coinBlock
		var normal = collision.get_normal()
		
		if normal.y > 0.9:  # Colisión desde abajo
			emit_signal("brickBlock", collision.collider)  # Emite la señal y pasa el bloque como argumento
		# Si no hay colisión desde abajo, no hace nada

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
	yield(get_tree().create_timer(3.0), "timeout")
	emit_signal("playerDead") 

func _physics_process(delta):
	velocity.y += gravity * delta
	if die == false:
		animaciones()
		
		if velocity.x <= 5 and velocity.x >= -5:
			velocity.x = 0
		
		velocity = movimiento2(delta, velocity)
		
		# Detectar y manejar colisiones
		for i in range(get_slide_count()):
			var collision = get_slide_collision(i)
			
			# Detectar colisión con enemigos (gomba)
			if collision.collider.name.begins_with("gomba"):
				colisioGoomba(collision)
			
			# Detectar colisión con bloques de monedas
			if collision.collider.is_in_group("coinBlock"):
				colisioCoinBlock(collision)
				
			if collision.collider.is_in_group("brickBlock"):
				colisioBrickBlock(collision)
			
			if collision.collider.is_in_group("flag"):
				colisioFlag(collision)
			
		
		velocity.x = round(velocity.x)
		
		# Control para no salirse del mapa
		if $".".position.x <= 20:
			$".".position.x = 20
			velocity.x = 1
		elif position.y >= 600:
			morir()
	else:
		velocity.x = 0
	
	velocity = move_and_slide(velocity, Vector2.UP)

	



