extends KinematicBody2D

var velocity = Vector2()
var speed = 100
var gravity = 1500
var gomba
var spriteGomba
var mov

func _ready():
	velocity.x += speed*1.5
	mov = (speed*1.5)*-1
	# Comprueba que el nodo AnimationPlayer esté accesible
	if $AnimatedSprite == null:
		print("Error: Nodo AnimationPlayer no encontrado")
	gomba = $"."
	spriteGomba = $AnimatedSprite
	spriteGomba.play("walk")




func _physics_process(delta):
	# Aplica la gravedad
	velocity.y += gravity * delta
	if is_on_wall():
		pass
	else:
		print("no toca pared")
	# Comprueba si hay colisión lateral (no piso ni techo)
	if is_on_wall() and is_on_floor():
		print("toca pareed")
		velocity.x += mov
		mov = mov*-1
	
	# Mueve al enemigo
	velocity = move_and_slide(velocity, Vector2.UP)
