extends CharacterBody2D

@export var allen_gs: SpriteFrames
@export var allen_c: SpriteFrames

var is_color = false
const speed = 90.0
var last_direction = "Down"

var path_history: Array[Vector2] = []
const history_spacing = 5.0
const max_history_length = 200

var seguimiento_activo := false  # SOLO registrar pasos si está activo

func _ready():
	$AnimatedSprite2D.sprite_frames = allen_gs
	$AnimatedSprite2D.play("Down")
	seguimiento_activo = true  # ← ACTIVAMOS la grabación de pasos al arrancar


func _input(event):
	if Input.is_key_pressed(KEY_SPACE):
		if $RayCast2D.is_colliding():
			var obj = $RayCast2D.get_collider().get_parent()
			if obj is CharacterBody2D and obj.name == "Tulip":
				obj.interactuar()  # ← SOLO hablas, no alteras el seguimiento
			else:
				if obj.has_method("showInteraction"):
					obj.showInteraction()


func _process(delta):
	var input_vector = Vector2.ZERO

	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	if Input.is_key_pressed(KEY_D):
		input_vector.x += 1
	elif Input.is_key_pressed(KEY_A):
		input_vector.x -= 1
	if Input.is_key_pressed(KEY_S):
		input_vector.y += 1
	elif Input.is_key_pressed(KEY_W):
		input_vector.y -= 1

	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized()

	velocity = input_vector * speed
	move_and_slide()

	# Dirección y animación
	if input_vector != Vector2.ZERO:
		if abs(input_vector.x) > abs(input_vector.y):
			last_direction = "Right" if input_vector.x > 0 else "Left"
			$AnimatedSprite2D.play(last_direction)
			$RayCast2D.target_position = Vector2(1 if input_vector.x > 0 else -1, 0) * 70
		else:
			last_direction = "Down" if input_vector.y > 0 else "Up"
			$AnimatedSprite2D.play(last_direction)
			$RayCast2D.target_position = Vector2(0, 1 if input_vector.y > 0 else -1) * 70
	else:
		$AnimatedSprite2D.stop()

	# Guardar posiciones SOLO si seguimiento está activo
	if seguimiento_activo:
		if path_history.is_empty() or path_history[0].distance_to(global_position) > history_spacing:
			path_history.push_front(global_position)
			if path_history.size() > max_history_length:
				path_history.pop_back()
