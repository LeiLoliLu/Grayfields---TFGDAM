extends Node2D

@onready var menu = preload("res://Objects/UI/Menu/menu.tscn").instantiate()
var menu_open = false
var interaction_countdown = 6
var tulip_event_executed = false

func add_allen_to_scene():
	add_child(Allen)

func _ready():
	if Allen.get_parent() != self:
		Allen.get_parent().call_deferred("remove_child", Allen)
	call_deferred("add_allen_to_scene")
	Allen.global_position = Vector2(189, 185)
	
	$Tulip.siguiendo=false
	$Tulip.visible=false
	$Tulip/TulipInteractionZone/CollisionShape2D.disabled=true
	
	Allen.get_node("Camera2D").enabled=false
	
	menu.visible = false
	$CanvasLayer.add_child(menu)
	Allen.wakeUp()
	Allen.raycastSize = 45

func _process(_delta):
	if Input.is_action_just_pressed("ui_tab"):
		menu_open = !menu_open
		menu.visible = menu_open
		menu.actualizar_misiones(Allen)
		menu.actualizar_inventario(Allen)
		menu.actualizar_diario(Allen)
		get_tree().paused = menu_open
	if !tulip_event_executed and interaction_countdown<=0:
		tulip_event()

func tulip_event():
	Allen.get_node("CanvasLayer").visible=false
	Allen.can_move = false
	tulip_event_executed = true 
	var parte1 = DialogueManager.show_dialogue_balloon(load("res://Dialogue/cuartoAllen.dialogue"), "tulip_event1")
	parte1.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
	DialogueManager.dialogue_ended.connect(_on_tulip_parte1_end)

func _on_tulip_parte1_end(_resource):
	DialogueManager.dialogue_ended.disconnect(_on_tulip_parte1_end)
	get_tree().paused = false
	
	Allen.can_move = false
	Allen.get_node("AnimatedSprite2D").play("Right")
	await Allen.mover_a_posicion_objetivo(Vector2(292, 204), 5.0)
	Allen.get_node("AnimatedSprite2D").stop()
	
	SoundEffectPlayer.stream= load("res://Assets/Audio/OpenDoor.mp3")
	SoundEffectPlayer.play()
	$Tulip/AnimatedSprite2D.play("Left")
	$Tulip/AnimatedSprite2D.stop()
	$Tulip.visible=true
	
	var parte2 = DialogueManager.show_dialogue_balloon(load("res://Dialogue/cuartoAllen.dialogue"), "tulip_event2")
	parte2.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
	DialogueManager.dialogue_ended.connect(_on_tulip_parte2_end)

func _on_tulip_parte2_end(_resource):
	DialogueManager.dialogue_ended.disconnect(_on_tulip_parte2_end)
	await get_tree().create_timer(0.5).timeout
	$Tulip/AnimatedSprite2D.play("Right")
	$Tulip/AnimatedSprite2D.stop()
	await get_tree().create_timer(0.5).timeout
	$Tulip.visible=false
	SoundEffectPlayer.stream= load("res://Assets/Audio/CloseDoor.mp3")
	SoundEffectPlayer.play()
	
	get_tree().paused = false
	Allen.agregar_mision("Encontrar el lazo")
	Allen.can_move = true

func exit():
	Allen.comesFrom ="AllenBedroom"
	SoundEffectPlayer.stream= load("res://Assets/Audio/OpenDoor.mp3")
	SoundEffectPlayer.play()
	var current_scene = get_tree().current_scene
	Allen.owner = null
	get_tree().root.add_child(Allen)
	current_scene.queue_free()
	var pasillo_scene = load("res://pasillo.tscn")
	var new_scene = pasillo_scene.instantiate()
	get_tree().root.add_child(new_scene)
	get_tree().current_scene = new_scene
