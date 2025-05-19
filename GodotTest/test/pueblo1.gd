extends Node2D

@onready var menu = load("res://Objects/UI/Menu/menu.tscn").instantiate()
var menu_open = false
var can_leave = false
var ballPlay = true

func _ready():
	$FadeRect.modulate.a = 0.0
	if !MasterAudio.is_playing() or MasterAudio.stream!=load("res://Assets/Audio/SteppingStones.mp3"):
		MasterAudio.stream=load("res://Assets/Audio/SteppingStones.mp3")
		MasterAudio.play()
	ballPlayStart()
	Allen.can_move=false
	Allen.path_history.clear()
	Allen.position = Vector2(24,375)
	$Tulip.position = Vector2(0,375)
	
	if Allen.get_parent() != self:
		Allen.get_parent().call_deferred("remove_child", Allen)
	call_deferred("add_allen_to_scene")
	
	Allen.get_node("Camera2D").enabled=true
	Allen.get_node("Camera2D").limit_bottom=800
	Allen.get_node("Camera2D").limit_right=1500
	Allen.raycastSize = 75
	
	Allen.get_node("AnimatedSprite2D").play("Right")
	$Tulip.inCinematic=true
	$Tulip/AnimatedSprite2D.play("Right")
	$Tulip.mover_a_posicion_objetivo(Vector2(50,375),5.0)
	await Allen.mover_a_posicion_objetivo(Vector2(100,375),5.0)
	ballPlayStop()
	Allen.get_node("AnimatedSprite2D").stop()
	$Tulip/AnimatedSprite2D.stop()
	Allen.y_sort_enabled=true
	$Tulip.y_sort_enabled=true
	var hi = DialogueManager.show_dialogue_balloon(load("res://Dialogue/gameStart.dialogue"), "start")
	hi.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = false
	DialogueManager.dialogue_ended.connect(startGame)
	
	menu.visible = false
func ballPlayStart():
	while ballPlay:
		$n1/AnimatedSprite2D.play("Down")
		await $Pelota.mover_a_posicion_objetivo(Vector2(0,110),2.5)
		$n2/AnimatedSprite2D.play("Up")
		await $Pelota.mover_a_posicion_objetivo(Vector2(0,0),2.5)
	

func ballPlayStop():
	ballPlay=false
	$n1/AnimatedSprite2D.play("Left")
	$n2/AnimatedSprite2D.play("Left")

func _process(_delta):
	pass
		
func add_allen_to_scene():
	add_child(Allen)

func startGame(_resource):
	DialogueManager.dialogue_ended.disconnect(startGame)
	var tween = create_tween()
	tween.tween_property($FadeRect, "modulate:a", 1.0, 3.0)
	await tween.finished
	var current_scene = get_tree().current_scene
	Allen.reparent(get_tree().root)
	get_tree().root.add_child(Allen)
	Allen.visible=false
	Allen.get_node("Camera2D").enabled=false
	current_scene.queue_free()
	var next = load("res://BallTuto.tscn")
	var new_scene = next.instantiate()
	get_tree().root.add_child(new_scene)
	get_tree().current_scene = new_scene
