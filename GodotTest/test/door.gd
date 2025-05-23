extends StaticBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DialogueManager.process_mode = Node.PROCESS_MODE_ALWAYS

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
	
func showInteraction(player):
	if not $"..".has_bought and not Allen.shopping_cart.is_empty():
		var interaction = DialogueManager.show_dialogue_balloon(load("res://Dialogue/tienda.dialogue"), "intento_salida_sin_pagar")
		interaction.process_mode=Node.PROCESS_MODE_ALWAYS
		get_tree().paused = true
		DialogueManager.dialogue_ended.connect(_unpause)
	elif not $"..".has_bought:
		var interaction = DialogueManager.show_dialogue_balloon(load("res://Dialogue/tienda.dialogue"), "we_gotta_buy")
		interaction.process_mode=Node.PROCESS_MODE_ALWAYS
		get_tree().paused = true
		DialogueManager.dialogue_ended.connect(_unpause)
	else:
		$"..".goNextArea()
		
		
func _unpause(_resource):
	get_tree().paused = false
	DialogueManager.dialogue_ended.disconnect(_unpause)
	

	
