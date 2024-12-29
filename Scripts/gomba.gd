extends KinematicBody2D

var velocity = Vector2()
var speed = 100
var gravity = 1500
var gomba
var spriteGomba
var mov
var colision
var paused

func _ready():
	velocity.x += speed*1.5
	mov = (speed*1.5)*-1
	# Comprueba que el nodo AnimationPlayer esté accesible
	if $AnimatedSprite == null:
		print("Error: Nodo AnimationPlayer no encontrado")
	gomba = $"."
	spriteGomba = $AnimatedSprite
	spriteGomba.play("walk")


func colisiones():
	if colision:
		if colision.collider.is_in_group("player"):
			if colision.normal.y > 0:
				print("colision")
				spriteGomba.play("die")
				pause_for(0.5)
				velocity.x = 0
			
func pause_for(seconds):
	paused = true
	velocity = Vector2.ZERO
	yield(get_tree().create_timer(seconds), "timeout")
	paused = false
	velocity = Vector2(100, 0) # Restaura el movimiento

func _physics_process(delta):
	# Aplica la gravedad
	velocity.y += gravity * delta
	if is_on_wall():
		pass
	if is_on_wall() and is_on_floor():
		velocity.x += mov
		mov = mov*-1
	colisiones()
	
	# Mueve al enemigo
	velocity = move_and_slide(velocity, Vector2.UP)
	colision = move_and_collide((-Vector2.UP/8)*speed*delta)
