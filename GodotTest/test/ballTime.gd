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
@onready var fade_rect = $FadeRect

var beat_time_ms = 750 
var margin = 200
var counter = 0
var target_beats_ms = []
var max_beat = 48
var delay = 0

var last_beat_index = -1
var waiting_for_input = false
var current_beat_target_time = 0
var last_kids_sprite : Node = null

func _ready():
	# Start fully black (fade in effect starts here)
	fade_rect.modulate.a = 1.0
	
	# Fade-in the screen
	var color_to = fade_rect.modulate
	color_to.a = 0.0  # Fade to transparent

	var tween = create_tween()
	tween.tween_property(fade_rect, "modulate", color_to, 1.0).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	
	# After fade-in is complete, start the game logic (including music)
	start_game()

	# Connect the music finished signal to fade-out function
	music.finished.connect(on_music_finished)

func start_game():
	# Generate beats dynamically
	for i in range(1, max_beat + 1): 
		if i % 4 == 0:
			target_beats_ms.append(i * beat_time_ms - 750 + delay)
	
	# Initialize sprites
	hide_all_sprites()
	allen_normal.visible = true
	kids1.visible = true
	last_kids_sprite = kids1
	
	# Play music
	music.play()

func _process(_delta):
	# Get playback time in milliseconds
	var playback_time_ms = music.get_playback_position() * 1000
	var current_beat_index = int(playback_time_ms / beat_time_ms) + 1

	# Handle beat visual updates
	if current_beat_index != last_beat_index:
		handle_beat_visual(current_beat_index)
		last_beat_index = current_beat_index

		# Check for input and timeout on the beat
		current_beat_target_time = current_beat_index * beat_time_ms - 750 + delay
		if target_beats_ms.has(current_beat_target_time):
			waiting_for_input = true
			input_timeout_timer(current_beat_target_time)

	# Check for player input
	if Input.is_action_just_pressed("ui_accept") and waiting_for_input:
		var diff = abs(playback_time_ms - current_beat_target_time)
		if diff <= margin:
			counter += 1
			hide_all_sprites()
			allen_acierto.visible = true
			squash_and_stretch(allen_acierto)
			kids_acierto.visible = true
			squash_and_stretch(kids_acierto)
			last_kids_sprite = kids_acierto
			target_beats_ms.erase(current_beat_target_time)
			waiting_for_input = false
		else:
			hide_all_sprites()
			allen_fallo.visible = true
			squash_and_stretch(allen_fallo)
			kids_fallo.visible = true
			squash_and_stretch(kids_fallo)
			last_kids_sprite = kids_fallo
			waiting_for_input = false

# Timeout handler when the input is not pressed in time
func input_timeout_timer(target_time):
	await get_tree().create_timer(margin / 1000.0).timeout

	if waiting_for_input:
		hide_all_sprites()
		allen_fallo.visible = true
		squash_and_stretch(allen_fallo)
		kids_fallo.visible = true
		squash_and_stretch(kids_fallo)
		last_kids_sprite = kids_fallo
		target_beats_ms.erase(target_time)
		waiting_for_input = false

# Handle visual updates for beats
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

# Hide all sprites
func hide_all_sprites():
	allen_normal.visible = false
	allen_acierto.visible = false
	allen_fallo.visible = false
	
	kids1.visible = false
	kids2.visible = false
	kids3.visible = false
	kids_acierto.visible = false
	kids_fallo.visible = false

# Squash and stretch animation for sprites
func squash_and_stretch(node: Node2D, squash_amount := 0.95, duration := 0.1):
	var squash_scale := Vector2(1, squash_amount)
	var normal_scale := Vector2(1, 1)

	node.scale = normal_scale
	
	var tween := create_tween()
	tween.tween_property(node, "scale", squash_scale, duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(node, "scale", normal_scale, duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

# Set the delay for beats
func set_delay(value: int):
	delay = value

# Handle music finishing: fade-out and transition
func on_music_finished():
	# Start fade-out when music finishes
	var color_from = fade_rect.modulate
	color_from.a = 0.0
	fade_rect.modulate = color_from

	var color_to = color_from
	color_to.a = 1.0  # Fade to black

	var tween = create_tween()
	tween.tween_property(fade_rect, "modulate", color_to, 2.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	
	# After the fade-out, transition to the tutorial or another scene
	transition()

# Transition to the tutorial scene (or another scene)
func transition():
	get_tree().current_scene.queue_free()  # Remove the current scene
