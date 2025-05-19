extends Node2D

@onready var menu = load("res://Objects/UI/Menu/menu.tscn").instantiate()
var menu_open = false
var can_leave = false

func _ready():
	if !MasterAudio.is_playing() or MasterAudio.stream!=load("res://Assets/Audio/JustAForest.mp3"):
		MasterAudio.stream=load("res://Assets/Audio/JustAForest.mp3")
		MasterAudio.play()
	Allen.seguimiento_activo=false
	Allen.path_history.clear()
	Allen.position = Vector2(15,295)
	if Allen.get_parent() != self:
		Allen.get_parent().call_deferred("remove_child", Allen)
	call_deferred("add_allen_to_scene")
	Allen.get_node("Camera2D").enabled=true
	Allen.get_node("Camera2D").limit_bottom=543
	Allen.get_node("Camera2D").limit_right=960
	Allen.raycastSize = 75
	Allen.can_move=true
	Allen.y_sort_enabled=true
	$Tulip.y_sort_enabled=true
	
	menu.visible = false
	$CanvasLayer.add_child(menu)
	Allen.get_node("AnimatedSprite2D").play("Right")
	Allen.get_node("AnimatedSprite2D").stop()

func _process(_delta):
	if Input.is_action_just_pressed("ui_tab") && Allen.can_move:
		menu_open = !menu_open
		menu.visible = menu_open
		menu.actualizar_misiones(Allen)
		menu.actualizar_inventario(Allen)
		menu.actualizar_diario(Allen)
		get_tree().paused = menu_open
		
func add_allen_to_scene():
	add_child(Allen)

func reload_tulip():
	Allen.seguimiento_activo=true;
	var tulip_node = $Tulip
	var tulpos = tulip_node.position

	Allen.AllenRay.enabled=false
	tulip_node.queue_free()

	# Instanciar el nuevo nodo
	var new_tulip = load("res://Objects/Tulip/tulip.tscn").instantiate()
	new_tulip.position = tulpos
	new_tulip.y_sort_enabled=true
	add_child(new_tulip)
	Allen.AllenRay.enabled=true
	can_leave=true

func goNextArea():
	if can_leave:
		Allen.comesFrom ="Area2Bosque"
		var current_scene = get_tree().current_scene
		Allen.owner = null
		get_tree().root.add_child(Allen)
		var next = load("res://pueblo_1.tscn")
		var new_scene = next.instantiate()
		get_tree().root.add_child(new_scene)
		get_tree().current_scene = new_scene
		current_scene.queue_free()
