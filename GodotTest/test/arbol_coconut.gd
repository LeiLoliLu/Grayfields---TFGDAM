extends StaticBody2D
#TODO: Arreglar esto
var interactedWith = false

func _process(delta: float) -> void:
	pass

func showInteraction(_player):
	var hi
	if interactedWith:
		return
	else:
		hi = DialogueManager.show_dialogue_balloon(load("res://Dialogue/pueblo_real.dialogue"), "coco_intro")
		hi.process_mode = Node.PROCESS_MODE_ALWAYS
		get_tree().paused = true
		DialogueManager.dialogue_ended.connect(end_intro)

func mover_a_posicion_objetivo(destino: Vector2, duracion: float) -> void:
	var tween := create_tween()
	tween.tween_property(self, "global_position", destino, duracion)
	await tween.finished

func end_intro(_resource):
	DialogueManager.dialogue_ended.disconnect(end_intro)
	await move_the_cat()
	SoundEffectPlayer.stream=load("res://Assets/Items/mrcoconutmeow.mp3")
	SoundEffectPlayer.play()
	var hi
	if Allen.misiones.has("Encontrar al gato de Lauren"):
		hi = DialogueManager.show_dialogue_balloon(load("res://Dialogue/pueblo_real.dialogue"), "coco_1")
	else:
		hi = DialogueManager.show_dialogue_balloon(load("res://Dialogue/pueblo_real.dialogue"), "coco_2")
	hi.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
	DialogueManager.dialogue_ended.connect(_unpause)
	$Area2D/CollisionShape2D.disabled=true

func _unpause(_resource):
	get_tree().paused = false
	Allen.can_move = true
	DialogueManager.dialogue_ended.disconnect(_unpause)
	$"../mrCoconut".visible=false
	Allen.agregar_al_diario("Lauren")
	await get_tree().create_timer(1.5).timeout
	Allen.agregar_mision("Devuélvele el gato a Lauren")
	await get_tree().create_timer(1.5).timeout
	Allen.agregar_al_inventario("Mr Coconut")
	interactedWith = true
	

func move_the_cat():
	$AnimatedSprite2D.play("Stop")
	Allen.get_node("AnimatedSprite2D").stop()
	Allen.can_move = false
	get_tree().paused = false
	var mrCoconut = $"../mrCoconut"
	mrCoconut.visible = true
	var destino = Allen.global_position + Vector2(20, 0)  # Desplaza 20 píxeles a la derecha de Allen
	var duracion = 2.5 

	# Calcula la rotación necesaria para que el gato se oriente hacia Allen
	var direccion = mrCoconut.global_position
	var rotacion = direccion.angle()

	# Calcula la rotación final (con giros múltiples)
	var rotacion_final = TAU * 5 # Gira 3 veces y luego vuelve a la posición inicial

	# Crea un tween para mover la posición
	var tween_pos = mrCoconut.create_tween()
	tween_pos.tween_property(mrCoconut, "global_position", destino, duracion)

	var tween_rot = mrCoconut.create_tween()
	tween_rot.tween_property(mrCoconut, "rotation", rotacion_final, duracion)

	await tween_pos.finished
	await tween_rot.finished
