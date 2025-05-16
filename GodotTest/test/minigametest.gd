extends Node
#TODO: Clean Assets
#TODO: Add inbetween beat sprite change
#TODO: find out why the fuck it moves

@onready var music = $AudioStreamPlayer

var beat_time_ms = 750 
var margin = 200
var counter = 0
var target_beats_ms = []
var max_beat = 48
var delay = 0

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
				$AllenDibujo.texture=load("res://Assets/BallGame/allen2.png")	
				$KidsDibujo.texture=load("res://Assets/BallGame/kids4.png")
				target_beats_ms.erase(target_time_ms)
				return
			else:
				$AllenDibujo.texture=load("res://Assets/BallGame/allen3.png")
				$KidsDibujo.texture=load("res://Assets/BallGame/kids5.png")
