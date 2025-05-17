extends Control

var save_path := "user://game_save.json"
@onready var Datos = load("res://datos.gd").new()
@onready var thought_label = $TabContainer/Allen/ColumnaAllen/Columna/ThoughtLabel
@onready var item_thought_label = $TabContainer/Inventario/ColumnaAllen2/Columna/ItemThoughtLabel
@onready var lista_misiones = $TabContainer/Allen/ColumnaMisiones/ListaMisiones
@onready var lista_items = $TabContainer/Inventario/ColumnaInventario/ListaItems
@onready var lista_entradas = $TabContainer/Diario/ColumnaEntradas/ListaEntradas
@onready var entrada_texto = $TabContainer/Diario/ColumnaTexto/Panel/EntradaLabel
@onready var guardar: Button = $TabContainer/Ajustes/Columna/ListaBotones/Guardar
@onready var cargar: Button = $TabContainer/Ajustes/Columna/ListaBotones/Cargar
@onready var salir_2: Button = $TabContainer/Ajustes/Columna/ListaBotones/Salir

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
func unpause():
	visible = false
	get_tree().paused = false
	thought_label.text = "(...)"
	item_thought_label.text = "(...)"
	entrada_texto.text = "(...)"



func _on_salir_pressed() -> void:
	get_tree().quit()


func _on_guardar_pressed() -> void:
	var save_data = {}

	# Guardamos las misiones
	save_data["misiones"] = Allen.misiones

	# Guardamos el inventario
	save_data["inventario"] = Allen.inventario  # Ejemplo de inventario, cámbialo según tus datos reales.

	# Guardamos el diario
	save_data["diario"] = Allen.diario  # Ejemplo de entradas, cámbialo según tus datos reales.

	# Guardamos la escena actual
	save_data["escena_actual"] = get_tree().current_scene.scene_file_path # Cambia a la escena actual

	# Guardar en un archivo JSON
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(save_data))
	file.close()

	print("Juego guardado correctamente.")

# Función para cargar el estado del juego
func _on_cargar_pressed():
	if not FileAccess.file_exists(save_path):
		print("No hay archivo de guardado.")
		return
	
	# Leer el archivo de guardado
	var file = FileAccess.open(save_path, FileAccess.READ)
	var json = JSON.new()
	var result = json.parse(file.get_as_text())

	if result != OK:
		print("Error al parsear el archivo JSON")
		return

	var save_data = json.get_data()

	file.close()
	
	if typeof(save_data) != TYPE_DICTIONARY:
		print("Datos del guardado no válidos.")
		return
	
	# Restaurar misiones, inventario y diario (solo mostrar los datos en la UI, si lo deseas)
	var misiones = save_data["misiones"]
	var inventario = save_data["inventario"]
	var diario = save_data["diario"]
	
	Allen.misiones=misiones
	Allen.inventario=inventario
	Allen.diario=diario

	# Cargar la escena actual
	var scene_path = save_data["escena_actual"]
	var new_scene = load(scene_path).instantiate()
	get_tree().current_scene.queue_free()  # Liberar la escena actual
	get_tree().root.add_child(new_scene)  # Cargar la nueva escena
	get_tree().current_scene = new_scene  # Establecer la nueva escena como actual

	print("Juego cargado correctamente.")
	unpause()
