extends CharacterBody2D

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Posiciones en coordenadas LOCALES (no globales)
var target_pos = Vector2(462, 293)
const SPEED = 65.0

func _ready():
	$Hitbox.disabled=true
	$TulipInteractionZone/CollisionShape2D.disabled=true
	go_bridge()


func go_bridge() -> void:
		await move_to_position(target_pos)
		await look_down()
		$TulipInteractionZone/CollisionShape2D.disabled=false

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

func look_down():
	anim_sprite.play("Down")
	anim_sprite.stop()
	
func interactuar():
	var hi = DialogueManager.show_dialogue_balloon(load("res://Dialogue/area2.dialogue"), "tulip")
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
	$"..".reload_tulip()
	$"..".can_leave=true
