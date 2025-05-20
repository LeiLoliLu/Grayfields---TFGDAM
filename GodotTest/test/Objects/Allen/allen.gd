extends CharacterBody2D

const speed = 90.0
var last_direction = "Down"
var can_move = false

var misiones: Array = []
var diario: Array = []
var inventario: Array = []
var raycastSize = 70
var comesFrom: String 

var path_history: Array[Vector2] = []
const history_spacing = 5.0
const max_history_length = 200

var seguimiento_activo := false
@onready var AllenRay: RayCast2D = $RayCast2D

func _ready():
	if not Notificador.is_inside_tree():
		$NotificadorLayer.add_child(Notificador)
	DialogueManager.process_mode = Node.PROCESS_MODE_ALWAYS
	$AnimatedSprite2D.play("Down")
	$AnimatedSprite2D.stop()
	seguimiento_activo = false 
	$CanvasLayer.visible = false
	


func _input(_event):
	if Input.is_key_pressed(KEY_SPACE):
		if AllenRay.is_colliding() and can_move:
			var obj = AllenRay.get_collider().get_parent()
			if obj.has_method("interactuar"):
				obj.interactuar()
			else:
				if obj.has_method("showInteraction"):
					obj.showInteraction(self)


func _process(_delta):
	if can_move:
		if AllenRay.is_colliding():
			var obj = AllenRay.get_collider().get_parent()
			if obj.has_method("showInteraction") or obj.has_method("interactuar"):
				$CanvasLayer.visible = true
		else:
			$CanvasLayer.visible = false
		
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
				AllenRay.target_position = Vector2(1 if input_vector.x > 0 else -1, 0) * raycastSize
			else:
				last_direction = "Down" if input_vector.y > 0 else "Up"
				$AnimatedSprite2D.play(last_direction)
				AllenRay.target_position = Vector2(0, 1 if input_vector.y > 0 else -1) * raycastSize
		else:
			$AnimatedSprite2D.stop()

		if seguimiento_activo:
			if path_history.is_empty() or path_history[0].distance_to(global_position) > history_spacing:
				path_history.push_front(global_position)
				if path_history.size() > max_history_length:
					path_history.pop_back()

func agregar_mision(nombre: String):
	if not misiones.has(nombre):
		misiones.append(nombre)
		Notificador.mostrar_mensaje("Nueva misión añadida")

func agregar_al_inventario(item: String):
	if not inventario.has(item):
		inventario.append(item)
		Notificador.mostrar_mensaje("Inventario actualizado")

func agregar_al_diario(entrada: String):
	if not diario.has(entrada):
		diario.append(entrada)
		Notificador.mostrar_mensaje("Nueva entrada de diario")
		
func wakeUp():
	MasterAudio.stop()
	$AnimatedSprite2D.play("Up")
	$AnimatedSprite2D.stop()
	await get_tree().create_timer(5).timeout
	$AnimatedSprite2D.play("Left")
	$AnimatedSprite2D.stop()
	await get_tree().create_timer(5).timeout
	$AnimatedSprite2D.play("Down")
	$AnimatedSprite2D.stop()
	
	var interaction = DialogueManager.show_dialogue_balloon(load("res://Dialogue/cuartoAllen.dialogue"), "wakeUp")
	interaction.process_mode=Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
		
	DialogueManager.dialogue_ended.connect(end_wakeup)
	
func end_wakeup(_resource):
	get_tree().paused = false
	DialogueManager.dialogue_ended.disconnect(end_wakeup)
	$AnimatedSprite2D.play("Right")
	await mover_a_posicion_objetivo(Vector2(292, 204), 2.0)
	$AnimatedSprite2D.stop()
	agregar_al_diario("Allen")
	agregar_al_diario("Mi cuarto")
	MasterAudio.stream=load("res://Assets/Audio/Home.mp3")
	MasterAudio.play()
	can_move=true
	
func mover_a_posicion_objetivo(destino: Vector2, duracion: float) -> void:
	var tween := create_tween()
	tween.tween_property(self, "global_position", destino, duracion).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
