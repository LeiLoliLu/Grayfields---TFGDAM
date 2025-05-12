extends Node2D

@onready var menu = preload("res://Objects/UI/menu.tscn").instantiate()
var menu_open = false



func _ready():
	if Allen.get_parent() != self:
		Allen.get_parent().call_deferred("remove_child", Allen)
	call_deferred("add_allen_to_scene")
	Allen.global_position = Vector2(176, 200)
	Allen.get_node("Camera2D").enabled=false
	Allen.raycastSize = 45
	Allen.can_move=true
	
	menu.visible = false
	$CanvasLayer.add_child(menu)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
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
