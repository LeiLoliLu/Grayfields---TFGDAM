extends CharacterBody2D

func mover_a_posicion_objetivo(destino: Vector2, duracion: float) -> void:
	var tween := create_tween()
	tween.tween_property(self, "position", destino, duracion).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
