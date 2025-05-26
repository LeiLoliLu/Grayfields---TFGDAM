extends Node2D

var has_empty_cart = false
var no_soap = true
var only_soap = false
@onready var menu = load("res://Objects/UI/Menu/menu.tscn").instantiate()
@onready var Datos = load("res://datos.gd").new()
var menu_open = false
var has_bought = false


func _ready():
	if !MasterAudio.is_playing() or MasterAudio.stream!=load("res://Assets/Audio/Shopping.mp3"):
		MasterAudio.stream=load("res://Assets/Audio/Shopping.mp3")
		MasterAudio.play()
	Allen.seguimiento_activo=true
	Allen.path_history.clear()
	Allen.position = Vector2(15,162)
	if Allen.get_parent() != self:
		Allen.get_parent().call_deferred("remove_child", Allen)
	call_deferred("add_allen_to_scene")
	Allen.get_node("Camera2D").enabled=false
	Allen.raycastSize = 45
	Allen.can_move=true
	Allen.get_node("AnimatedSprite2D").play("Up")
	Allen.get_node("AnimatedSprite2D").stop()
	Allen.y_sort_enabled=false
	$Tulip.y_sort_enabled=false
	$Tulip/AnimatedSprite2D.play("Up")
	$Tulip/AnimatedSprite2D.stop()
		
	menu.visible = false
	$CanvasLayer.add_child(menu)

func put_in_cart(obj:String):
	Allen.put_in_cart(obj)
	var index = Datos.objetos.find(obj)
	var boton = TextureButton.new()
	boton.custom_minimum_size = Vector2(50, 50)
	boton.stretch_mode = TextureButton.STRETCH_SCALE
	var texture_path = "res://Assets/Items/%03d.png" % index
	boton.texture_normal = load(texture_path)
	boton.tooltip_text = obj
	$CanvasLayer/VBoxContainer.add_child(boton)

func _process(_delta):
	if Allen.shopping_cart.is_empty():
		has_empty_cart= true;
	else:
		has_empty_cart=false;
	if Allen.shopping_cart == ["Jabón"]:
		only_soap= true;
	else:
		only_soap=false;
	if !Allen.shopping_cart.has("Jabón"):
		no_soap= true;
	else:
		no_soap=false;
	if Input.is_action_just_pressed("ui_tab") && Allen.can_move:
		menu_open = !menu_open
		menu.visible = menu_open
		menu.actualizar_misiones(Allen)
		menu.actualizar_inventario(Allen)
		menu.actualizar_diario(Allen)
		get_tree().paused = menu_open
	if has_bought:
		$Counter/Area2D/CollisionShape2D.disabled=true
		$Crates/Area2D/CollisionShape2D.disabled=true
		$Crates2/Area2D/CollisionShape2D.disabled=true
		$Tables2/Area2D/CollisionShape2D.disabled=true
		$Tables/Area2D/CollisionShape2D.disabled=true
		$Fridges/Area2D/CollisionShape2D.disabled=true
		$Fridges2/Area2D/CollisionShape2D.disabled=true
		$Fridges3/Area2D/CollisionShape2D.disabled=true
func add_allen_to_scene():
	add_child(Allen)

func fin_compra():
	for e in Allen.shopping_cart:
		Allen.agregar_al_inventario(e)
	Allen.shopping_cart=[]
	$Counter/Area2D/CollisionShape2D.disabled=true
	for child in $CanvasLayer/VBoxContainer.get_children():
		child.free()
	Allen.misiones.erase("Hacer la compra")
	has_bought=true
	
func goNextArea():
	SoundEffectPlayer.stream=load("res://Assets/Audio/OpenDoor.mp3")
	SoundEffectPlayer.play()
	Allen.comesFrom ="Shop"
	var current_scene = get_tree().current_scene
	Allen.owner = null
	get_tree().root.add_child(Allen)
	var next = load("res://red_village.tscn")
	var new_scene = next.instantiate()
	get_tree().root.add_child(new_scene)
	get_tree().current_scene = new_scene
	current_scene.queue_free()
