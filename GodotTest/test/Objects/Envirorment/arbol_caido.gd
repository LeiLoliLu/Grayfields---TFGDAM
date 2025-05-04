extends StaticBody2D
var interactedWith = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DialogueManager.process_mode = Node.PROCESS_MODE_ALWAYS


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func showInteraction(player):
	var interaction = DialogueManager.show_dialogue_balloon(load("res://Dialogue/area1.dialogue"), "arbolCaido")
	interaction.process_mode=Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
		
	DialogueManager.dialogue_ended.connect(_unpause)
	if !interactedWith:
		player.agregar_al_diario("El árbol caído")
	
	
func _unpause(resource):
	get_tree().paused = false
	DialogueManager.dialogue_ended.disconnect(_unpause)
	
	var notificador = get_tree().get_current_scene().get_node("CanvasLayer/Notificador")
	if notificador && !interactedWith:
		notificador.mostrar_mensaje("¡Diario Actualizado!")
		interactedWith = true
	
