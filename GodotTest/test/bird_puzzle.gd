extends Node2D

@onready var confirm_button = $ConfirmButton


@onready var buttons = {
	"A": $SpriteA/ButtonA,
	"B": $SpriteB/ButtonB,
	"C": $SpriteC/ButtonC,
	"D": $SpriteD/ButtonD
}

@onready var dialogs = {
	"A": $SpriteA/DialogA,
	"B": $SpriteB/DialogB,
	"C": $SpriteC/DialogC,
	"D": $SpriteD/DialogD
}

@onready var sprites = {
	"A": $SpriteA,
	"B": $SpriteB,
	"C": $SpriteC,
	"D": $SpriteD
}

var failed_attempts := 0
var culprit_revealed := false
signal finished

@onready var culprit = $Culprit
@onready var culprit_label = $Culprit/CulpritLabel


# Guardamos la posición original de cada nodo
var original_positions := {}
var current_tween: Tween = null
var selected_option: String = ""


func _ready():
	confirm_button.disabled = true
	culprit.visible = false
	culprit_label.visible = false
	for key in buttons:
		buttons[key].pressed.connect(func(): _on_option_selected(key))
		original_positions[key] = {
			"sprite": sprites[key].position,
			"dialog": dialogs[key].position
		}
		dialogs[key].visible = false

	confirm_button.pressed.connect(_on_confirm_pressed)
	$FadeRect.visible=true
	if !MasterAudio.is_playing() or MasterAudio.stream!=load("res://Assets/Audio/ThisRemindsMeOfAPuzzle.mp3"):
		MasterAudio.stream=load("res://Assets/Audio/ThisRemindsMeOfAPuzzle.mp3")
		MasterAudio.play()
	var tween = create_tween()
	tween.tween_property($FadeRect, "modulate:a", 0.0, 3.0)
	await tween.finished
	
	

	

func _on_option_selected(option_key: String):
	# Detener animación anterior y resetear posiciones
	if selected_option != "":
		if current_tween:
			current_tween.kill()
		_reset_position(selected_option)
		dialogs[selected_option].visible = false

	selected_option = option_key
	confirm_button.disabled = false
	dialogs[option_key].visible = true

	# Iniciar nueva animación de movimiento vertical
	var sprite = sprites[option_key]
	var dialog = dialogs[option_key]
	current_tween = create_tween()
	_animate_bounce_loop(sprite, dialog, current_tween, option_key)

func _reset_position(key: String):
	sprites[key].position = original_positions[key]["sprite"]
	dialogs[key].position = original_positions[key]["dialog"]

func _animate_bounce_loop(sprite: Node2D, dialog: Label, tween: Tween, key: String):
	var original_y_sprite = original_positions[key]["sprite"].y
	var original_y_dialog = original_positions[key]["dialog"].y

	tween.tween_property(sprite, "position:y", original_y_sprite + 2, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(dialog, "position:y", original_y_dialog + 2, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(sprite, "position:y", original_y_sprite, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(dialog, "position:y", original_y_dialog, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	tween.chain().tween_callback(func(): 
		# Solo vuelve a crear el loop si sigue siendo el seleccionado
		if selected_option == key:
			_animate_bounce_loop(sprite, dialog, create_tween(), key)
	)

func _on_confirm_pressed():
	if current_tween:
		current_tween.kill()
	_reset_position(selected_option)

	var success := selected_option == "C"
	if success:
		print("Correcto!")
		SoundEffectPlayer.stream = load("res://Assets/Audio/correct.mp3")
		SoundEffectPlayer.play()
	else:
		print("Opción seleccionada:", selected_option)
		failed_attempts += 1
		SoundEffectPlayer.stream = load("res://Assets/Audio/wrong.mp3")
		SoundEffectPlayer.play()

	# Si acierta o falla 3 veces → desactivar botones, mostrar culpable
	if success or failed_attempts >= 3:
		for key in buttons:
			buttons[key].disabled = true
		confirm_button.disabled = true

		await _fade_to_black()
		_reveal_culprit()
		await _fade_back_out()
	else:
		# Solo desactivar el botón confirmar temporalmente
		confirm_button.disabled = true


func _fade_to_black() -> void:
	var fade = create_tween()
	$FadeRect.modulate.a = 0.0
	fade.tween_property($FadeRect, "modulate:a", 1.0, 2.0)
	await fade.finished

func _fade_back_out()->void:
	var fade = create_tween()
	$FadeRect.modulate.a = 1.0
	fade.tween_property($FadeRect, "modulate:a", 0.0, 2.0)
	await fade.finished

func _reveal_culprit():
	if culprit_revealed:
		return
	culprit_revealed = true

	culprit.visible = true
	culprit_label.visible = true

	_start_label_bounce_loop()

	await get_tree().create_timer(5.0).timeout

	# Segundo fundido a negro (no se reinicia modulate.a porque ya es 1)
	var fade = create_tween()
	fade.tween_property($FadeRect, "modulate:a", 1.0, 2.0)
	await fade.finished
	terminar_puzzle()

func _start_label_bounce_loop():
	var original_y = culprit_label.position.y
	var tween = create_tween()
	tween.tween_property(culprit_label, "position:y", original_y - 10, 0.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(culprit_label, "position:y", original_y, 0.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.chain().tween_callback(_start_label_bounce_loop)

func terminar_puzzle():
	finished.emit()
