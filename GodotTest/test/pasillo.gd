extends Node2D

@onready var menu = preload("res://Objects/UI/Menu/menu.tscn").instantiate()
var menu_open = false



func _ready():
	if Allen.get_parent() != self:
		Allen.get_parent().call_deferred("remove_child", Allen)
	call_deferred("add_allen_to_scene")
	if Allen.comesFrom == "AllenBedroom":
		Allen.global_position = Vector2(176, 200)
	elif Allen.comesFrom == "Bathroom":
		Allen.global_position = Vector2(400, 200)
	else:
		Allen.global_position = Vector2(176, 200)
	
	Allen.can_move=true
	Allen.get_node("Camera2D").enabled=false
	Allen.raycastSize = 45
	
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


func goBathroom():
	Allen.comesFrom ="Pasillo"
	SoundEffectPlayer.stream = load("res://Assets/Audio/OpenDoor.mp3")
	SoundEffectPlayer.play()
	var current_scene = get_tree().current_scene
	Allen.owner = null
	get_tree().root.add_child(Allen)
	current_scene.queue_free()
	var next = load("res://Assets/Baño/baño.tscn")
	var new_scene = next.instantiate()
	get_tree().root.add_child(new_scene)
	get_tree().current_scene = new_scene
