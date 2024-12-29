extends Node2D

signal EndGame

var contTemp=400
var interfaz
#var scene_a_packed = preload("res://Scenes/interface/playerInterface.tscn")
var scene_a_packed = preload("res://Scenes/player-npc/mario.tscn")
var mario

func _ready():
	mario = scene_a_packed.instance()
	$".".connect("EndGame", mario, "_on_Timer_EndGame")
	$CanvasLayer/time/Timer.start()
	interfaz=$"."

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	interfaz.position = 
#	pass
func _on_Timer_timeout():
	contTemp -= 1
	$CanvasLayer/time/timeCont.text= str(contTemp)
	if contTemp <= 0:
		contTemp=0
		emit_signal("EndGame") # Emitir la señal personalizada
		yield(get_tree().create_timer(2.0), "timeout")
		print("Fin del juego: señal emitida")
