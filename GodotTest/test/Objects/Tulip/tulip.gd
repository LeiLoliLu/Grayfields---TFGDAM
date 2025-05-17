extends CharacterBody2D

var siguiendo = true
var index_offset = 5
var speed = 90.0
var min_distance = 2.0

func _ready() -> void:
	pass

func interactuar():
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
	var hi = DialogueManager.show_dialogue_balloon(load("res://Dialogue/area1.dialogue"), "tulip")
	hi.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
	DialogueManager.dialogue_ended.connect(_unpause)

func _process(_delta):
	if Allen.seguimiento_activo:
		set_collision_layer_value(1, false)
		set_collision_layer_value(4, true)
	if Allen.seguimiento_activo:
		var path = Allen.path_history
		if path.size() > index_offset:
			var target_pos = path[index_offset]
			var direction = (target_pos - global_position).normalized()
			var distance_to_target = global_position.distance_to(target_pos)

			if distance_to_target > min_distance:
				velocity = direction * speed
				move_and_slide()

				if Allen.velocity.length() == 0:
					$AnimatedSprite2D.stop()
				else:
					if abs(direction.x) > abs(direction.y):
						$AnimatedSprite2D.play("Right" if direction.x > 0 else "Left")
					else:
						$AnimatedSprite2D.play("Down" if direction.y > 0 else "Up")
			else:
				velocity = Vector2.ZERO
				$AnimatedSprite2D.stop()
		else:
			velocity = Vector2.ZERO
			$AnimatedSprite2D.stop()
	else:
		velocity = Vector2.ZERO
		$AnimatedSprite2D.stop()

func _unpause(_resource):
	get_tree().paused = false
	DialogueManager.dialogue_ended.disconnect(_unpause)
	
