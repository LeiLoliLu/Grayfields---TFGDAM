extends Node2D

func _ready():
	$FadeRect.visible = true

	if !MasterAudio.is_playing() or MasterAudio.stream != load("res://Assets/Audio/RedWaves.mp3"):
		MasterAudio.stream = load("res://Assets/Audio/RedWaves.mp3")
		MasterAudio.play()

	if Allen.get_parent() != self:
		Allen.get_parent().call_deferred("remove_child", Allen)
	call_deferred("add_allen_to_scene")

	Allen.visible = true
	Allen.seguimiento_activo = false
	Allen.path_history.clear()
	Allen.position = Vector2(1265, 240)
	$Tulip.position = Vector2(1309, 236)
	$Tulip.inCinematic=true
	Allen.get_node("Camera2D").limit_bottom = 800
	Allen.get_node("Camera2D").limit_right = 1500
	Allen.get_node("Camera2D").enabled = true
	Allen.raycastSize = 50
	Allen.can_move = false
	Allen.y_sort_enabled = true
	Allen.get_node("AnimatedSprite2D").play("Down")
	Allen.get_node("AnimatedSprite2D").stop()
	$Tulip/AnimatedSprite2D.play("Down")
	$Tulip/AnimatedSprite2D.stop()
	$Lauren/AnimatedSprite2D.play("Down")
	$Lauren/AnimatedSprite2D.stop()
	$Fred/AnimatedSprite2D.play("Up")
	$Fred/AnimatedSprite2D.stop()
	$Tulip.y_sort_enabled = false
	Allen.get_node("CanvasLayer").visible=false

	if not MasterAudio.is_inside_tree():
		get_tree().root.add_child(MasterAudio)

	var tween = create_tween()
	tween.tween_property($FadeRect, "modulate:a", 0.0, 3.0)
	await tween.finished

	# ==== DIÁLOGO + MOVIMIENTO ====

	await mostrar_dialogo($Tulip, "…..Per-pero-", 2.5)
	Allen.get_node("AnimatedSprite2D").play("Left")
	Allen.get_node("AnimatedSprite2D").stop()
	$Tulip/AnimatedSprite2D.play("Left")
	$Tulip/AnimatedSprite2D.stop()
	await mostrar_dialogo($Tulip, "¿Qu- Qué es esa cosa?", 3.0)
	await mostrar_dialogo(Allen, "(...)", 2.0)

	mover_animado(Vector2(1020, 343), 20, "Left", Allen.get_node("AnimatedSprite2D"))
	await mostrar_dialogo($Tulip, "Allen-.", 2.0)
	mover_animado(Vector2(1038, 400), 20, "Left", $Tulip/AnimatedSprite2D)
	await mostrar_dialogo(Allen, "(¿Qué es esto?)", 2.5)
	await mostrar_dialogo(Allen, "(No es como lo demás.)", 3.0)
	await mostrar_dialogo(Allen, "(Es completamente diferente. ¿Qué demonios?)", 3.5)

	
	var cam = Allen.get_node("Camera2D")
	cam.position_smoothing_enabled = false
	cam.enabled = false # Detiene el seguimiento automático de Allen

	# Creamos una cámara manual si Allen no puede soltar la suya
	var manual_camera := Camera2D.new()
	manual_camera.make_current()
	manual_camera.global_position = cam.global_position
	add_child(manual_camera)
	manual_camera.zoom=Vector2(1.5,1.5)
# Tween a Fuente
	var cam_tween = create_tween()
	cam_tween.tween_property(
		manual_camera,
		"global_position",
		$Fuente.global_position,
		1.0
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	await cam_tween.finished

 
	$Lauren/AnimatedSprite2D.play("Right")
	$Lauren/AnimatedSprite2D.stop()
	$Fred/AnimatedSprite2D.play("Right")
	$Fred/AnimatedSprite2D.stop()
	await mostrar_dialogo($Lauren, "¡Allen! ¡Ten cuidado!", 3.0)
	await mostrar_dialogo($Fred, "¿Qué-? Allen, puede ser peligroso, ¡aléjate de eso!", 4.0)
	await mostrar_dialogo(Allen, "¿Estáis bien?", 2.5)
	await mostrar_dialogo($Fred, "Todo bien, solo me he arañado un poco al caerme.", 4.0)

	# Allen se acerca aún más
	mover_animado(Vector2(991, 340), 1.5, "Left", Allen.get_node("AnimatedSprite2D"))

	await mostrar_dialogo($Tulip, "¡Allen!", 1.5)

	# Poner el color rojo (sin transparencia)
	$FadeRect.color = Color(1, 0, 0, 1)
	$FadeRect.modulate = Color(1, 1, 1, 0) # modulate.a = 0 (transparente)
	$FadeRect.visible = true

# Tween para hacer fade-in del rojo (modulate.a de 0 a 1)
	var flash = create_tween()
	flash.tween_property($FadeRect, "modulate:a", 1.0, 2.5)
	await flash.finished

	var white = create_tween()
	white.tween_property($FadeRect, "color", Color(0, 0, 0, 0), 2.5)
	await white.finished
	
	var new_scene = load("res://titlescreen.tscn").instantiate()
	new_scene.usar_sprite_alternativo = true
	get_tree().current_scene.queue_free()
	get_tree().root.add_child(new_scene)
	get_tree().current_scene = new_scene

func _process(_delta):
	pass

func add_allen_to_scene():
	add_child(Allen)

func mostrar_dialogo(personaje: Node2D, texto: String, duracion: float = 3.5):
	var label = Label.new()
	label.text = texto
	label.add_theme_font_size_override("font_size", 14)
	label.modulate = Color(1, 1, 1, 0)
	label.z_index = 100

	# Tamaño fijo o máximo
	label.size = Vector2(160, 40) # Ajusta según lo que necesites
	label.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

	# Fondo semitransparente (opcional)
	label.add_theme_stylebox_override("normal", StyleBoxFlat.new())
	label.get_theme_stylebox("normal").bg_color = Color(0, 0, 0, 0.5)
	label.get_theme_stylebox("normal").border_color = Color(1, 1, 1, 0.3)

	# Añadir al sprite y posicionar
	var sprite := personaje.get_node("AnimatedSprite2D")
	sprite.add_child(label)
	label.position = Vector2(-label.size.x / 2, -60) # Centrado horizontal, 50px arriba

	# Fade in
	var tween = create_tween()
	tween.tween_property(label, "modulate:a", 1.0, 0.3)

	await get_tree().create_timer(duracion).timeout

	# Fade out
	var tween_out = create_tween()
	tween_out.tween_property(label, "modulate:a", 0.0, 0.3)
	await tween_out.finished

	label.queue_free()



func mover_animado(destino: Vector2, duracion: float, animacion: String, subject: AnimatedSprite2D):
	subject.play(animacion)
	await subject.get_parent().mover_a_posicion_objetivo(destino, duracion)
	subject.stop()
