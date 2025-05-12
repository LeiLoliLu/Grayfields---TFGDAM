extends Node2D

@onready var menu = load("res://Objects/UI/Menu/menu.tscn").instantiate()
var menu_open = false

func _ready():
	if Allen.get_parent() != self:
		Allen.get_parent().call_deferred("remove_child", Allen)
	call_deferred("add_allen_to_scene")
	Allen.global_position = Vector2(346,454)
	Allen.get_node("Camera2D").enabled=true
	Allen.raycastSize = 75
	Allen.can_move=true
	Allen.seguimiento_activo=true
	
	if not MasterAudio.is_inside_tree():
		get_tree().root.add_child(MasterAudio)
		
	MasterAudio.stream=load("res://Assets/Audio/JustAForest.mp3")
	MasterAudio.play()
	menu.visible = false
	$CanvasLayer.add_child(menu)

func _process(_delta):
	if Input.is_action_just_pressed("ui_tab"):
		menu_open = !menu_open
		menu.visible = menu_open
		menu.actualizar_misiones(Allen)
		menu.actualizar_inventario(Allen)
		menu.actualizar_diario(Allen)
		get_tree().paused = menu_open
		
func add_allen_to_scene():
	add_child(Allen)
