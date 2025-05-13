extends CanvasLayer

@onready var panel := $Panel
@onready var mensaje := $Panel/Nuevo
@onready var tween := create_tween()


var duracion := 2.5
var posicion_final := Vector2.ZERO

func _ready():
	hide()
	posicion_final = panel.position  # Guarda la posición donde debe acabar
	panel.modulate.a = 0.0  # Empieza invisible
	panel.position.x += 300  # Empieza fuera de pantalla hacia la derecha

func mostrar_mensaje(texto: String):
	mensaje.text = texto
	show()
	$AudioStreamPlayer.play()

	# Reset por si se llamó otra vez antes de terminar
	tween.kill()
	panel.position.x = posicion_final.x + 300
	panel.modulate.a = 0.0

	tween = create_tween()

	# Entrada: desliza y aparece
	tween.tween_property(panel, "position", posicion_final, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(panel, "modulate:a", 1.0, 0.5)

	# Espera
	tween.tween_interval(duracion)

	# Salida: disolverse
	tween.tween_property(panel, "modulate:a", 0.0, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_callback(hide)
