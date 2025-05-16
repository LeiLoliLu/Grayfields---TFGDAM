extends Node2D
var can_leave=false


@onready var menu = preload("res://Objects/UI/Menu/menu.tscn").instantiate()
var menu_open = false

func _ready():
	if Allen.get_parent() != self:
		Allen.get_parent().call_deferred("remove_child", Allen)
	call_deferred("add_allen_to_scene")
	Allen.global_position = Vector2(-149, -41)
	Allen.y_sort_enabled=true
	
	Allen.can_move=true
	Allen.get_node("Camera2D").enabled=false
	Allen.raycastSize = 45
	
	menu.visible = false
	$CanvasLayer.add_child(menu)
	$Tulip/Hitbox.disabled=true
	
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


func goOutside():
	Allen.comesFrom ="PlantaBaja"
	SoundEffectPlayer.stream = load("res://Assets/Audio/OpenDoor.mp3")
	SoundEffectPlayer.play()
	var current_scene = get_tree().current_scene
	Allen.owner = null
	get_tree().root.add_child(Allen)
	current_scene.queue_free()
	var next = load("res://mundo.tscn")
	var new_scene = next.instantiate()
	get_tree().root.add_child(new_scene)
	get_tree().current_scene = new_scene

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
	Allen.misiones.erase("Dale el lazo a Tulip")
	Allen.inventario.erase("Lazo")
	Allen.agregar_al_diario("El lazo perdido")
	await get_tree().create_timer(1.5).timeout
	Allen.agregar_mision("Hacer la compra")
	
	
	
