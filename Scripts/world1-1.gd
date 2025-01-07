extends Node2D

var coins=0
var score=0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var timer_scene# Ruta del nodo Control
var player_scene 

# Called when the node enters the scene tree for the first time.
func _ready():
	player_scene = $mario
	timer_scene = $PlayerIntreface
	timer_scene.connect("EndGame", self, "_on_EndGame") # Conectar la señal personalizada
	player_scene.connect("killEnemy", self, "_on_kill_enemy")
	player_scene.connect("playerDead", self, "_on_EndGame")	
	player_scene.connect("coinBlock", self, "_on_CoinBlock")	
	player_scene.connect("brickBlock", self, "_on_BrickBlock")	
	player_scene.connect("win", self, "_on_Win")	
	



func _on_EndGame():
	print("Se recibió la señal EndGame")
	get_tree().quit()

func _on_kill_enemy(enemy):
	print("Enemigo eliminado:", enemy.name)
	score=score+1000
	$PlayerIntreface/CanvasLayer/points/pointsCont.text=str(score)
	enemy.queue_free()
	
func _on_CoinBlock(block):
	if block.is_in_group("coinBlock"):  # Asegúrate de que el bloque tenga un AnimatedSprite
		coins=coins+1
		score=score+1000
		$PlayerIntreface/CanvasLayer/coins/coinsCont.text= str(coins)
		$PlayerIntreface/CanvasLayer/points/pointsCont.text=str(score)
		if block.has_node("AnimatedSprite"):  # Asegúrate de que el bloque tenga un AnimatedSprite
			var sprite = block.get_node("AnimatedSprite")
			sprite.play("used")  # Cambia a la animación "used"
			block.remove_from_group("coinBlock")

func _on_BrickBlock(block):
	if block.is_in_group("brickBlock"):  # Asegúrate de que el bloque tenga un AnimatedSprite
		block.queue_free()

func _on_Win(flag):
	$Win.show()
	yield(get_tree().create_timer(3.0), "timeout")
	_on_EndGame()


