extends CharacterBody2D


const speed = 130.0


func _process(delta):
	# Vector de entrada
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	# Normalizamos para evitar velocidad más alta en movimiento diagonal
	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized()

	# Aplicamos movimiento al CharacterBody2D
	velocity = input_vector * speed
	move_and_slide()

	# Cambiamos la animación del sprite según la dirección del movimiento
	if input_vector != Vector2.ZERO:
		if abs(input_vector.x) > abs(input_vector.y):
			if input_vector.x > 0:
				$AnimatedSprite2D.play("Right")
			else:
				$AnimatedSprite2D.play("Left")
		else:
			if input_vector.y > 0:
				$AnimatedSprite2D.play("Down")
			else:
				$AnimatedSprite2D.play("Up")
	else:
		$AnimatedSprite2D.stop()  # Detenemos la animación si no hay movimiento
