extends Node2D

@onready var menu = load("res://Objects/UI/Menu/menu.tscn").instantiate()
var menu_open = false

func _ready():
	if !MasterAudio.is_playing() or MasterAudio.stream!=load("res://Assets/Audio/JustAForest.mp3"):
		MasterAudio.stream=load("res://Assets/Audio/JustAForest.mp3")
		MasterAudio.play()
	Allen.seguimiento_activo=true
	Allen.path_history.clear()
	Allen.position = Vector2(346,454)
	if Allen.get_parent() != self:
		Allen.get_parent().call_deferred("remove_child", Allen)
	call_deferred("add_allen_to_scene")
	Allen.get_node("Camera2D").enabled=true
	Allen.raycastSize = 75
	Allen.can_move=true
	Allen.y_sort_enabled=false
	$Tulip.y_sort_enabled=false
	
	if not MasterAudio.is_inside_tree():
		get_tree().root.add_child(MasterAudio)
		
	menu.visible = false
	$CanvasLayer.add_child(menu)

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
	
func goNextArea():
	Allen.comesFrom ="Area1Bosque"
	var current_scene = get_tree().current_scene
	Allen.owner = null
	get_tree().root.add_child(Allen)
	
	var next = load("res://bosque_2.tscn")
	var new_scene = next.instantiate()
	get_tree().root.add_child(new_scene)
	get_tree().current_scene = new_scene
	current_scene.queue_free()
