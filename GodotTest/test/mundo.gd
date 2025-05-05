extends Node2D

@onready var menu = preload("res://Objects/UI/menu.tscn").instantiate()
@onready var notificador = preload("res://Objects/UI/notification.tscn").instantiate();
@onready var player = $Allen
var menu_open = false

func _ready():
	# Asegúrate de que el menú está visible inicialmente en false.
	$AudioStreamPlayer.process_mode=Node.PROCESS_MODE_ALWAYS
	menu.visible = false
	$CanvasLayer.add_child(menu)
	$CanvasLayer.add_child(notificador)

func _process(delta):
	if Input.is_action_just_pressed("ui_tab"):
		menu_open = !menu_open
		menu.visible = menu_open
		menu.actualizar_misiones(player)
		menu.actualizar_inventario(player)
		menu.actualizar_diario(player)
		get_tree().paused = menu_open
