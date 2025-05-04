extends StaticBody2D

# Referencia al DialogueManager para mostrar el diálogo
var dialogue_manager = DialogueManager

# Este método muestra el diálogo
func showInteraction(player):
	var interaction = dialogue_manager.show_dialogue_balloon(load("res://Dialogue/area1.dialogue"), "lago")
	interaction.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true  # Pausamos el juego hasta que termine el diálogo

	# Conectamos la señal para despausar cuando termine el diálogo
	dialogue_manager.dialogue_ended.connect(_unpause)

# Este método despausa el juego cuando termina el diálogo
func _unpause(resource):
	get_tree().paused = false
	dialogue_manager.dialogue_ended.disconnect(_unpause)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Allen":
		showInteraction(body)
