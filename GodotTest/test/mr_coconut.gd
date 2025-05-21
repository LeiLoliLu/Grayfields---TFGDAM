extends Sprite2D

func showInteraction(_player):
	SoundEffectPlayer.stream=load("res://Assets/Items/mrcoconutmeow.mp3")
	SoundEffectPlayer.play()
