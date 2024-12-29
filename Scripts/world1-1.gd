extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var timer_scene# Ruta del nodo Control
var player_scene 

# Called when the node enters the scene tree for the first time.
func _ready():
	player_scene = $mario
	timer_scene = $Control
	timer_scene.connect("EndGame", self, "_on_EndGame") # Conectar la señal personalizada
	player_scene.connect("PlayerMoved", self, "_on_PlayerMoved") # Conectar la señal personalizada


func _on_EndGame():
	print("Se recibió la señal EndGame")

func _on_PlayerMoved():
	$Control.position.x = player_scene.camara.position.x
	# Aquí puedes cambiar de escena, mostrar un mensaje, etc.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
