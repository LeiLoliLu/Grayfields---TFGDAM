extends Node

@onready var music = $AudioStreamPlayer
@onready var label = $Label

var beat_time_ms = 750 
var margin = 200
var counter = 0
var target_beats_ms = []
var max_beat = 48
var delay = 250

func _ready():
	for i in range(1, max_beat + 1): 
		if i % 4 == 0:
			target_beats_ms.append(i * beat_time_ms - 750 + delay)
	music.play()

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		var playback_time_ms = music.get_playback_position() * 1000

		for target_time_ms in target_beats_ms:
			var diff = abs(playback_time_ms - target_time_ms)
			
			if diff <= margin:
				counter += 1
				label.text = "✅ ¡Perfecto! Llevas "+str(counter)
				
				target_beats_ms.erase(target_time_ms)
				if target_beats_ms.is_empty():
					label.text = "¡Fin! Aciertos totales: "+str(counter)+"/12"
				return
			else:
				label.text = "❌ ¡Fallo! :("
