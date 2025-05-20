extends CharacterBody2D

var interactedWith = false

func _process(delta: float) -> void:
	pass


func showInteraction(_player):
	match Allen.last_direction:
		"Right":
			$AnimatedSprite2D.play("Left")
		"Left":
			$AnimatedSprite2D.play("Right")
		"Up":
			$AnimatedSprite2D.play("Down")
		"Down":
			$AnimatedSprite2D.play("Up")
	$AnimatedSprite2D.stop()
	var hi
	if interactedWith:
		hi = DialogueManager.show_dialogue_balloon(load("res://Dialogue/pueblo_real.dialogue"), "fred_2")
	else:
		hi = DialogueManager.show_dialogue_balloon(load("res://Dialogue/pueblo_real.dialogue"), "fred_1")
	
	hi.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
	if not interactedWith:
		DialogueManager.dialogue_ended.connect(_mostrar_bird_puzzle)
	else:
		DialogueManager.dialogue_ended.connect(_unpause)

func _mostrar_bird_puzzle(_resource):
	DialogueManager.dialogue_ended.disconnect(_mostrar_bird_puzzle)
	_cargar_bird_puzzle()

func mover_a_posicion_objetivo(destino: Vector2, duracion: float) -> void:
	var tween := create_tween()
	tween.tween_property(self, "global_position", destino, duracion).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	await tween.finished

func _unpause(_resource):
	get_tree().paused = false
	DialogueManager.dialogue_ended.disconnect(_unpause)
	$AnimatedSprite2D.play("Down")

	Allen.can_move = true
	Allen.agregar_al_diario("Fred")
	interactedWith = true



func _cargar_bird_puzzle():
	get_tree().paused = false
	Allen.can_move = false

	# Fundido a negro antes de ocultar la escena
	var fade_rect = get_parent().get_node("FadeRect")
	fade_rect.visible = true
	fade_rect.modulate.a = 0
	var fade_out = create_tween()
	fade_out.tween_property(fade_rect, "modulate:a", 1.0, 1.0)
	await fade_out.finished

	# Ocultar elementos del pueblo
	Allen.get_node("CanvasLayer").visible = false
	Allen.get_node("Camera2D").enabled = false
	get_parent().visible = false

	# Instanciar el minijuego
	var bird_puzzle_scene = load("res://bird_puzzle.tscn")
	var bird_puzzle = bird_puzzle_scene.instantiate()
	bird_puzzle.visible = true
	get_tree().get_root().add_child(bird_puzzle)

	bird_puzzle.finished.connect(func():
		bird_puzzle.queue_free()

		# Mostrar el pueblo de nuevo
		get_parent().visible = true
		Allen.get_node("Camera2D").enabled = true
		Allen.get_node("AnimatedSprite2D").stop()
		Allen.get_node("CanvasLayer").visible = true

		# Música de vuelta
		if !MasterAudio.is_playing() or MasterAudio.stream != load("res://Assets/Audio/SteppingStones.mp3"):
			MasterAudio.stream = load("res://Assets/Audio/SteppingStones.mp3")
			MasterAudio.play()

		# Fundido desde negro
		fade_rect.visible = true
		fade_rect.modulate.a = 1.0
		var fade_in = create_tween()
		fade_in.tween_property(fade_rect, "modulate:a", 0.0, 1.0)
		await fade_in.finished
		fade_rect.visible = false

		_continue_dialogue_fred2()
	)




func _continue_dialogue_fred2():
	var hi = DialogueManager.show_dialogue_balloon(load("res://Dialogue/pueblo_real.dialogue"), "fred_2")
	hi.process_mode = Node.PROCESS_MODE_ALWAYS
	await hi.ready
	get_tree().paused = true
	DialogueManager.dialogue_ended.connect(_unpause)
