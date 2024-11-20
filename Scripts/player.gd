extends Sprite

export var speed = 400 # Velocidad de movimiento del jugador.
export var jump_speed = 500 # Velocidad del salto
var gravity = 1000 # Fuerza de gravedad
var jumping = false
var velocity = Vector2.ZERO
var screen_size

func _ready():
	screen_size = get_viewport_rect().size
	$Area2D.connect("area_entered", self, "_on_area_entered")

func _process(delta):
	velocity.x = 0
	
	if Input.is_action_pressed("move_right"):
		velocity.x += speed
		flip_h = false
	if Input.is_action_pressed("move_left"):
		velocity.x -= speed
		flip_h = true


	if Input.is_action_just_pressed("jump") and not jumping:
		jumping = true
		velocity.y = -jump_speed
		yield(get_tree().create_timer(1.0), "timeout") 

	# Aplica la gravedad cuando está en el aire
	if jumping:
		velocity.y += gravity * delta # Aumenta la velocidad en Y por gravedad

	
	if velocity.x != 0 and not jumping:
		$PlayerAnimation.play("walk_right")
	elif jumping:
		$PlayerAnimation.play("jump")
	else:
		$PlayerAnimation.play("Nueva Animación") # Animacon por defecto

	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)


# Función que se activa al detectar una colisión con el suelo u otro objeto

	


func _on_Area2D_body_entered(body):
	#if jumping and area.is_in_group("ground"): # Asegúrate de que los objetos del TileMap estén en un grupo llamado "ground"
	if body.is_in_group("ground") and jumping:
		velocity.y = 0
		jumping = false
	
	else :
		if body.is_in_group("ground"):
			$PlayerAnimation.play("Nueva Animación")
			jumping = false
			velocity.y = 0
