extends StaticBody2D
var end_trigger=false
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
		end_trigger=true;
		var interaction = DialogueManager.show_dialogue_balloon(load("res://Dialogue/tienda.dialogue"), "something_happened")
		interaction.process_mode=Node.PROCESS_MODE_ALWAYS
		get_tree().paused = true
		DialogueManager.dialogue_ended.connect(shaking)
		
func shaking(_resource):
	get_tree().paused = false
	await shake()
	DialogueManager.dialogue_ended.disconnect(shaking)
	var interaction = DialogueManager.show_dialogue_balloon(load("res://Dialogue/tienda.dialogue"), "something_happened2")
	interaction.process_mode=Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
	DialogueManager.dialogue_ended.connect(_unpause)
		
func _unpause(_resource):
	get_tree().paused = false
	DialogueManager.dialogue_ended.disconnect(_unpause)
	if end_trigger:
		$"..".goNextArea()

func shake() -> void:
	var camera = $"../Camera2D"
	var original_position = camera.position
	var shake_amount = 10  # La distancia del movimiento a los lados
	var shake_count = 6    # Número de movimientos (3 a cada lado)
	var shake_duration = 0.05  # Duración de cada movimiento

	# Detener el audio maestro
	MasterAudio.stop()

	# Creamos un Tween para animar
	var tween = create_tween()
	tween.set_parallel(false)  # Ejecutamos en secuencia

	for i in range(shake_count):
		var direction = 1 if i % 2 == 0 else -1
		var new_pos = original_position + Vector2(shake_amount * direction, 0)
		tween.tween_property(camera, "position", new_pos, shake_duration).as_relative()
		tween.tween_property(camera, "position", original_position, shake_duration)

	await tween.finished
