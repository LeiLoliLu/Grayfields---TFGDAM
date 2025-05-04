extends Control

@onready var Datos = load("res://datos.gd").new()
@onready var thought_label = $TabContainer/Allen/ColumnaAllen/Columna/ThoughtLabel
@onready var item_thought_label = $TabContainer/Inventario/ColumnaAllen2/Columna/ItemThoughtLabel
@onready var lista_misiones = $TabContainer/Allen/ColumnaMisiones/ListaMisiones
@onready var lista_items = $TabContainer/Inventario/ColumnaInventario/ListaItems
@onready var lista_entradas = $TabContainer/Diario/ColumnaEntradas/ListaEntradas
@onready var entrada_texto = $TabContainer/Diario/ColumnaTexto/Panel/EntradaLabel

func _ready():
	pass

func actualizar_misiones(player):
	for child in lista_misiones.get_children():
		if child is Button:
			child.queue_free()

	for mision in player.misiones:
		var boton = Button.new()
		boton.text = mision
		boton.pressed.connect(_on_mission_pressed.bind(mision))
		lista_misiones.add_child(boton)

func _on_mission_pressed(mision: String):
	thought_label.text = Datos.mission_thoughts.get(mision, "(...)")

func actualizar_inventario(player):
	for child in lista_items.get_children():
		if child is TextureButton:
			child.queue_free()
			
	for item in player.inventario:
		print(item)
		var index = Datos.objetos.find(item)
		if index == -1:
			continue

		var boton = TextureButton.new()
		boton.custom_minimum_size = Vector2(100, 100)
		boton.stretch_mode = TextureButton.STRETCH_SCALE

		var texture_path = "res://Assets/Items/%03d.png" % index
		boton.texture_normal = load(texture_path)

		# Tooltip con el nombre del objeto
		boton.tooltip_text = item

		boton.pressed.connect(_on_item_pressed.bind(item))
		lista_items.add_child(boton)

func _on_item_pressed(item: String):
	item_thought_label.text = Datos.item_thoughts.get(item, "(...)")
	if(item == "Mr Coconut"):
		$AudioStreamPlayer.play()

func actualizar_diario(player):
	for child in lista_entradas.get_children():
		if child is Button:
			child.queue_free()

	for entrada in player.diario:
		var boton = Button.new()
		boton.text = entrada
		boton.pressed.connect(_on_entrada_diario_pressed.bind(entrada))
		lista_entradas.add_child(boton)

func _on_entrada_diario_pressed(nombre: String):
	entrada_texto.text = Datos.diario_contenido.get(nombre, "(...)")

func _unhandled_input(event):
	if event.is_action_pressed("ui_tab"):
		visible = false
		get_tree().paused = false
		thought_label.text = "(...)"
		item_thought_label.text = "(...)"
		entrada_texto.text = "(...)"
