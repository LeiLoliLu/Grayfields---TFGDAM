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
	DialogueManager.dialogue_ended.connect(_unpause)


func mover_a_posicion_objetivo(destino: Vector2, duracion: float) -> void:
	var tween := create_tween()
	tween.tween_property(self, "global_position", destino, duracion).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	await tween.finished

func _unpause(_resource):
	get_tree().paused = false
	DialogueManager.dialogue_ended.disconnect(_unpause)
	$AnimatedSprite2D.play("Down")
	Allen.agregar_al_diario("Fred")
	interactedWith=true
