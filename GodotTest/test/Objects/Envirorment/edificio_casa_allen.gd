extends StaticBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DialogueManager.process_mode = Node.PROCESS_MODE_ALWAYS


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func showInteraction():
	var interaction = DialogueManager.show_dialogue_balloon(load("res://Dialogue/area1.dialogue"), "puertaCasaAllen")
	interaction.process_mode=Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
		
	DialogueManager.dialogue_ended.connect(_unpause)
	
	
func _unpause(resource):
	get_tree().paused = false
	DialogueManager.dialogue_ended.disconnect(_unpause)
	
