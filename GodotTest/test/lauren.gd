extends CharacterBody2D

var first_time_interaction = true
var coco_given = false
var idle_loop_active = false

func _ready() -> void:
	start_idle()

func start_idle() -> void:
	idle_loop_active = true
	_run_idle_loop()

func stop_idle() -> void:
	idle_loop_active = false
	$AnimatedSprite2D.stop()

func _run_idle_loop() -> void:
	# Inicia la corutina asincrónica
	await _idle_animation_loop()

func _idle_animation_loop() -> void:
	var directions = ["Up", "Right", "Up", "Left"]
	while idle_loop_active and not coco_given:
		for dir in directions:
			if not idle_loop_active or coco_given:
				break
			$AnimatedSprite2D.play(dir)
			await get_tree().create_timer(4.0, false).timeout
	
	# Al salir del bucle por haber entregado el coco
	if coco_given:
		$AnimatedSprite2D.play("Right")

func showInteraction(_player):
	stop_idle()  # Detener animación mientras está en diálogo

	if coco_given:
		var interaction = DialogueManager.show_dialogue_balloon(load("res://Dialogue/pueblo_real.dialogue"), "cocogiven")
		interaction.process_mode = Node.PROCESS_MODE_ALWAYS
		get_tree().paused = true
		DialogueManager.dialogue_ended.connect(_regularUnpause)
		return

	# Mirar hacia el jugador (opcional)
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

	# Primer encuentro
	if first_time_interaction:
		var interaction = DialogueManager.show_dialogue_balloon(load("res://Dialogue/pueblo_real.dialogue"), "lauren1")
		interaction.process_mode = Node.PROCESS_MODE_ALWAYS
		get_tree().paused = true
		DialogueManager.dialogue_ended.connect(_unpause1)

	# Ya habló pero no tiene a Mr Coconut
	elif not Allen.inventario.has("Mr Coconut"):
		var interaction = DialogueManager.show_dialogue_balloon(load("res://Dialogue/pueblo_real.dialogue"), "lauren2")
		interaction.process_mode = Node.PROCESS_MODE_ALWAYS
		get_tree().paused = true
		DialogueManager.dialogue_ended.connect(_unpause2)

	# Tiene el coco
	else:
		resolveCoco()

func resolveCoco():
	coco_given = true
	var interaction = DialogueManager.show_dialogue_balloon(load("res://Dialogue/pueblo_real.dialogue"), "lauren3")
	interaction.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
	DialogueManager.dialogue_ended.connect(_unpause3)

# -------- Unpause handlers --------

func _unpause1(_resource):
	get_tree().paused = false
	DialogueManager.dialogue_ended.disconnect(_unpause1)
	first_time_interaction = false
	Allen.agregar_al_diario("Lauren")
	if Allen.inventario.has("Mr Coconut"):
		resolveCoco()
	else:
		start_idle()

func _unpause2(_resource):
	get_tree().paused = false
	DialogueManager.dialogue_ended.disconnect(_unpause2)
	Allen.agregar_mision("Encuentra al gato de Lauren")
	start_idle()

func _unpause3(_resource):
	$"../mrCoconut".position = self.position + Vector2(30, 20)
	$"../mrCoconut".visible = true
	$"../mrCoconut".z_index = 0
	$"../mrCoconut/Area2D/CollisionShape2D".disabled=false
	get_tree().paused = false
	DialogueManager.dialogue_ended.disconnect(_unpause3)
	Allen.misiones.erase("Devuélvele el gato a Lauren")
	Allen.inventario.erase("Mr Coconut")
	$AnimatedSprite2D.play("Right")  # Coco entregado, queda mirando a la derecha

func _regularUnpause(_resource):
	get_tree().paused = false
	DialogueManager.dialogue_ended.disconnect(_regularUnpause)
	$AnimatedSprite2D.play("Right")  # En caso de diálogos post-coco
