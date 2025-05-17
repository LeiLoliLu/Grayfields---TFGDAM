extends Node

@onready var music = $AudioStreamPlayer

# Sprites de Allen
@onready var allen_normal = $AllenDibujo
@onready var allen_acierto = $AllenDibujo2
@onready var allen_fallo = $AllenDibujo3

# Sprites de Kids
@onready var kids1 = $KidsDibujo
@onready var kids2 = $KidsDibujo2
@onready var kids3 = $KidsDibujo3
@onready var kids_acierto = $KidsDibujo4
@onready var kids_fallo = $KidsDibujo5

@onready var delay_label = $DelayLabel
@onready var decrease_button = $ButtonContainer/DecreaseButton
@onready var increase_button = $ButtonContainer/IncreaseButton

@onready var ready_button = $ReadyButton
@onready var fade_rect = $FadeRect


var beat_time_ms = 750 
var margin = 200
var delay = 0

var last_beat_index = -1
var waiting_for_input = false
var current_beat_target_time = 0
var last_kids_sprite : Node = null

# Ya no usamos una lista fija de beats
# Generamos beats sobre la marcha
func _ready():
	ready_button.pressed.connect(on_ready_pressed)
	fade_rect.modulate.a = 0.0  # Asegura que el fondo está transparente
	
	decrease_button.pressed.connect(on_decrease_pressed)
	increase_button.pressed.connect(on_increase_pressed)
	
	hide_all_sprites()
	allen_normal.visible = true
	kids1.visible = true
	last_kids_sprite = kids1
	
	music.play()
	music.finished.connect(_on_music_finished)

func on_decrease_pressed():
	delay -= 10
	delay = clamp(delay, -500, 500)

func on_increase_pressed():
	delay += 10
	delay = clamp(delay, -500, 500)


func _on_music_finished():
	# Repite la música para que el tutorial nunca termine
	music.play()

func _process(_delta):
	delay_label.text = "Delay: " + str(delay) + " ms"

	var playback_time_ms = music.get_playback_position() * 1000
	var adjusted_time_ms = playback_time_ms + delay
	var current_beat_index = int(adjusted_time_ms / beat_time_ms) + 1

	if current_beat_index != last_beat_index:
		handle_beat_visual(current_beat_index)
		last_beat_index = current_beat_index

		if current_beat_index % 4 == 0:
			current_beat_target_time = current_beat_index * beat_time_ms - 750
			waiting_for_input = true
			input_timeout_timer(current_beat_target_time)

	if Input.is_action_just_pressed("ui_accept") and waiting_for_input:
		var diff = abs(playback_time_ms - current_beat_target_time)
		hide_all_sprites()

		if diff <= margin:
			allen_acierto.visible = true
			squash_and_stretch(allen_acierto)
			kids_acierto.visible = true
			squash_and_stretch(kids_acierto)
			last_kids_sprite = kids_acierto
		else:
			allen_fallo.visible = true
			squash_and_stretch(allen_fallo)
			kids_fallo.visible = true
			squash_and_stretch(kids_fallo)
			last_kids_sprite = kids_fallo

		waiting_for_input = false

func input_timeout_timer(target_time):
	await get_tree().create_timer(margin / 1000.0).timeout

	if waiting_for_input:
		hide_all_sprites()
		allen_fallo.visible = true
		squash_and_stretch(allen_fallo)
		kids_fallo.visible = true
		squash_and_stretch(kids_fallo)
		last_kids_sprite = kids_fallo
		waiting_for_input = false

func handle_beat_visual(beat_number):
	hide_all_sprites()
	allen_normal.visible = true
	squash_and_stretch(allen_normal)

	match beat_number % 4:
		1:
			kids1.visible = true
			squash_and_stretch(kids1)
			last_kids_sprite = kids1
		2:
			kids2.visible = true
			squash_and_stretch(kids2)
			last_kids_sprite = kids2
		3:
			kids3.visible = true
			squash_and_stretch(kids3)
			last_kids_sprite = kids3
		0:
			if last_kids_sprite != null:
				last_kids_sprite.visible = true
				squash_and_stretch(last_kids_sprite)

func hide_all_sprites():
	allen_normal.visible = false
	allen_acierto.visible = false
	allen_fallo.visible = false
	
	kids1.visible = false
	kids2.visible = false
	kids3.visible = false
	kids_acierto.visible = false
	kids_fallo.visible = false

func squash_and_stretch(node: Node2D, squash_amount := 0.95, duration := 0.1):
	var squash_scale := Vector2(1, squash_amount)
	var normal_scale := Vector2(1, 1)

	node.scale = normal_scale
	
	var tween := create_tween()
	tween.tween_property(node, "scale", squash_scale, duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(node, "scale", normal_scale, duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	
func on_ready_pressed():
	ready_button.disabled = true
	fade_rect.move_to_front()

	# Hacer tween a modulate
	var tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 1.0, 3.0)
	await tween.finished

	# Cargar escena nueva
	var scene = preload("res://BallTime.tscn")
	var instance = scene.instantiate()

	if instance.has_method("set_delay"):
		instance.set_delay(delay)
	elif "delay" in instance:
		instance.delay = delay

	get_tree().root.add_child(instance)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = instance
