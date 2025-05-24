extends Node2D

var save_path := "user://game_save.json"
var usar_sprite_alternativo=false

func _ready():
	if usar_sprite_alternativo:
		$MenuTitle1.texture=load("res://Assets/UI_ASSETS/menuTitle2.png")
	var flash = create_tween()
	flash.tween_property($ColorRect, "modulate:a", 0.0, 2.5)
	await flash.finished

func _on_salir_pressed() -> void:
	get_tree().quit()


func _on_guardar_pressed() -> void:
	var flash = create_tween()
	flash.tween_property($ColorRect, "modulate:a", 1.0, 5)
	await flash.finished
	var new_scene = load("res://Objects/CuartoAllen/cuarto_allen.tscn").instantiate()
	get_tree().current_scene.queue_free()
	get_tree().root.add_child(new_scene)
	get_tree().current_scene = new_scene
	
func _on_cargar_pressed():
	if not FileAccess.file_exists(save_path):
		print("No hay archivo de guardado.")
		return
	
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

	var flash = create_tween()
	flash.tween_property($ColorRect, "modulate:a", 1, 5)
	await flash.finished
	
	var scene_path = save_data["escena_actual"]
	var new_scene = load(scene_path).instantiate()
	get_tree().current_scene.queue_free()
	get_tree().root.add_child(new_scene)
	get_tree().current_scene = new_scene
