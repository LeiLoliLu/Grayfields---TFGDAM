extends Node

var beat_time_ms = 750  # milisegundos por beat (equivalente a 0.75 segundos)
var margin = 200  # margen de error en milisegundos (equivalente a 0.2 segundos)
var counter = 0

@onready var music = $AudioStreamPlayer
@onready var label = $Label  # Asumiendo que tienes un Label para mostrar el mensaje

# Array con los tiempos predefinidos de los beats objetivos en milisegundos
var target_beats_ms = []

# Rango de beats que vamos a comprobar (por ejemplo, hasta el beat 48)
var max_beat = 48

func _ready():
	# Generar los tiempos de los beats objetivos (4, 8, 12, etc.) en milisegundos
	for i in range(1, max_beat + 1):  # Podemos ajustar el rango según la cantidad de beats que necesitas
		if i % 4 == 0:  # Solo añadimos el cuarto beat de cada compás
			target_beats_ms.append(i * beat_time_ms - 750)
	print(target_beats_ms)  # Para verificar que los tiempos están correctamente calculados
	music.play()

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		var playback_time_ms = music.get_playback_position() * 1000  # Convertir a milisegundos

		# Comprobar si el tiempo de reproducción está cerca de alguno de los tiempos de los beats objetivos
		for target_time_ms in target_beats_ms:
			var diff = abs(playback_time_ms - target_time_ms)
			
			# Verificar si estamos dentro del margen
			if diff <= margin:
				label.text = "¡Perfecto!"
				counter += 1
				print("Acierto número: " + str(counter))
				
				# Eliminar el beat del array después de acertarlo
				target_beats_ms.erase(target_time_ms)  # Eliminar el beat actual del array
				return  # Terminar la búsqueda después de encontrar un match
		
		label.text = "Whoopsies"  # Si no hay match, mostrar "Whoopsies"
