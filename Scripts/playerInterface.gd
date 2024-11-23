extends Node2D

signal EndGame 	

var contTemp=400

func _ready():
	$time/Timer.start()  # Iniciar el temporizador

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _on_Timer_timeout():
	contTemp -= 1
	$time/timeCont.text= str(contTemp)
	if contTemp == 0:
		emit_signal("EndGame") # Emitir la señal personalizada
		print("Fin del juego: señal emitida")
