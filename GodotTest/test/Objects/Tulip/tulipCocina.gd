extends CharacterBody2D

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Posiciones en coordenadas LOCALES (no globales)
const POS_1 = Vector2(175, -15)
const POS_2 = Vector2(-73, -15)
var target_pos = POS_2

const SPEED = 50.0

func _ready():
	position = POS_1  # Asegura que arranca en la posición inicial local
	start_idle_cycle()

func start_idle_cycle() -> void:
	idle_cycle()

func idle_cycle() -> void:
	while true:
		await move_to_position(target_pos)
		await look_up()
		target_pos = POS_2 if target_pos == POS_1 else POS_1
		await get_tree().create_timer(0.5).timeout

func move_to_position(destination: Vector2):
	var distance = position.distance_to(destination)
	var duration = distance / SPEED
	var direction = (destination - position).normalized()

	if direction.x > 0:
		anim_sprite.play("Right")
	elif direction.x < 0:
		anim_sprite.play("Left")

	await mover_a_posicion_objetivo(destination, duration)

func mover_a_posicion_objetivo(destino: Vector2, duracion: float) -> void:
	var tween := create_tween()
	tween.tween_property(self, "position", destino, duracion).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	anim_sprite.stop()

func look_up():
	anim_sprite.play("Up")
	anim_sprite.stop()
	await get_tree().create_timer(5.0).timeout
	
func interactuar():
	var hi = DialogueManager.show_dialogue_balloon(load("res://Dialogue/plantaBaja.dialogue"), "tulipTalk")

	# Ejemplo: Allen.last_direction = "Right" --> tú miras "Left"
	match Allen.last_direction:
		"Right":
			anim_sprite.play("Left")
		"Left":
			anim_sprite.play("Right")
		"Up":
			anim_sprite.play("Down")
		"Down":
			anim_sprite.play("Up")

	anim_sprite.stop()

	hi.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
	DialogueManager.dialogue_ended.connect(_unpause)

	
	
func _unpause(_resource):
	get_tree().paused = false
	DialogueManager.dialogue_ended.disconnect(_unpause)
 #TODO: Arreglar si está mirando hacia arriba que vuelva a mirar hacia arriba
	if target_pos == POS_1:
		anim_sprite.play("Right")
	else:
		anim_sprite.play("Left")
	
	
