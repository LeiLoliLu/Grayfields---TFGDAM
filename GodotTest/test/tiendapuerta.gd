extends StaticBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DialogueManager.process_mode = Node.PROCESS_MODE_ALWAYS

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func showInteraction(_player):
	SoundEffectPlayer.stream=load("res://Assets/Audio/OpenDoor.mp3")
	SoundEffectPlayer.play()
	$"..".goNextArea()
	
