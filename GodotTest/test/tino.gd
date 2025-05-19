extends CharacterBody2D

var ha_detectado_allen := false
var finished_interaction:=false
@onready var posInicial:= self.position

func _process(delta: float) -> void:
	if ha_detectado_allen:
		return

	var raycast := $RayCast2D

	if raycast.is_colliding():
		if raycast.get_collider() == Allen:
			_on_raycast_detecta_allen()

func _on_raycast_detecta_allen() -> void:
	if ha_detectado_allen:
		return
	
	ha_detectado_allen = true
	
	Allen.can_move = false
	

	var destino_tino = Allen.global_position + Vector2(0, -30)
	Allen.get_node("AnimatedSprite2D").stop()
	$AnimatedSprite2D.play("Down")
	await mover_a_posicion_objetivo(destino_tino, 1.0)
	$AnimatedSprite2D.stop()

	# Tino "empuja" a Allen hacia abajo (unas casillas)
	var offset_empuje := Vector2(0, 30)  # ajusta según tamaño de casilla
	var destino_allen := Allen.global_position + offset_empuje
	
	await Allen.mover_a_posicion_objetivo(destino_allen, 0.1)
	Allen.get_node("AnimatedSprite2D").play("Up")
	Allen.get_node("AnimatedSprite2D").stop()
	
	var hi = DialogueManager.show_dialogue_balloon(load("res://Dialogue/pueblo_real.dialogue"), "tino_start")
	hi.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
	DialogueManager.dialogue_ended.connect(_unpause)

func showInteraction(_player):
	if finished_interaction:
		Allen.can_move=false
		var destino_tino = Allen.global_position + Vector2(0, -30)
		Allen.get_node("AnimatedSprite2D").stop()
		$AnimatedSprite2D.play("Down")
		await mover_a_posicion_objetivo(destino_tino, 1.0)
		$AnimatedSprite2D.stop()

		var offset_empuje := Vector2(0, 30)  
		var destino_allen := Allen.global_position + offset_empuje
	
		await Allen.mover_a_posicion_objetivo(destino_allen, 0.1)
		Allen.get_node("AnimatedSprite2D").play("Up")
		Allen.get_node("AnimatedSprite2D").stop()
	
		var hi = DialogueManager.show_dialogue_balloon(load("res://Dialogue/pueblo_real.dialogue"), "tino_2")
		hi.process_mode = Node.PROCESS_MODE_ALWAYS
		get_tree().paused = true
		DialogueManager.dialogue_ended.connect(_unpause)
	else:
		pass

func mover_a_posicion_objetivo(destino: Vector2, duracion: float) -> void:
	var tween := create_tween()
	tween.tween_property(self, "global_position", destino, duracion).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	await tween.finished

func _unpause(_resource):
	get_tree().paused = false
	Allen.can_move=true
	$AnimatedSprite2D.play("Up")
	Allen.agregar_al_diario("Tino")
	await mover_a_posicion_objetivo(posInicial,3.0)
	$AnimatedSprite2D.play("Down")
	$AnimatedSprite2D.stop()
	finished_interaction=true
	DialogueManager.dialogue_ended.disconnect(_unpause)
