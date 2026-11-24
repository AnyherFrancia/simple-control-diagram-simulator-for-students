extends Node
var cable: PackedScene = preload("res://scenes/transmision_cable.tscn")
var tuberia: PackedScene = preload("res://scenes/pipe.tscn")
var tanque: PackedScene = preload("res://scenes/tank.tscn")
var valve : PackedScene = preload("res://scenes/valve.tscn")
var controlador_de_flujo: PackedScene = preload("res://scenes/master_controller.tscn")
var medidor: PackedScene = preload("res://scenes/meter.tscn")
var controlador_esclavo: PackedScene = preload("res://scenes/slave_controller.tscn")
var funcion: PackedScene = preload("res://scenes/funtion.tscn")
var frecuency: PackedScene = preload("res://scenes/frecuency.tscn")
var selector: PackedScene = preload("res://scenes/selector.tscn")
var pump: PackedScene = preload("res://scenes/pump.tscn")

func save_state() -> Dictionary:
	var state = {}
	for node in get_tree().get_nodes_in_group('save'):
		if node.has_method('save_state'):
			state[str(node)] = {}
			node.save_state(state[str(node)])
		node.remove_from_group('save')
	return state

func load_state(state: Dictionary) -> void:
	for node in state:
		match state[node]['type']:
			'tuberia':
				var tuberia_nueva = tuberia.instantiate() as Area2D
				$/root/main_scene/objects/pipes.add_child(tuberia_nueva)
				tuberia_nueva.load_state(state[node])
			'tanque':
				var tanque_nuevo = tanque.instantiate() as Area2D
				$/root/main_scene/objects/sources.add_child(tanque_nuevo)
				tanque_nuevo.load_state(state[node])
			'medidor':
				var medidor_nuevo = medidor.instantiate() as Area2D
				$/root/main_scene/objects/controllers.add_child(medidor_nuevo)
				medidor_nuevo.load_state(state[node])
			'valvula':
				var tuberia_nueva = valve.instantiate() as Area2D
				$/root/main_scene/objects/pipes.add_child(tuberia_nueva)
				tuberia_nueva.load_state(state[node])
			'convertidor':
				var cambiador_nuevo = frecuency.instantiate() as Area2D
				$/root/main_scene/objects/controllers.add_child(cambiador_nuevo)
				cambiador_nuevo.load_state(state[node])
			'funcion':
				var function_nueva = funcion.instantiate() as Area2D
				$/root/main_scene/objects/controllers.add_child(function_nueva)
				function_nueva.load_state(state[node])
			'controlador_maestro':
				var controlador_nuevo = controlador_de_flujo.instantiate() as Area2D
				$/root/main_scene/objects/controllers.add_child(controlador_nuevo)
				controlador_nuevo.load_state(state[node])
			'bomba':
				var bomba_nueva = pump.instantiate() as Area2D
				$/root/main_scene/objects/controllers.add_child(bomba_nueva)
				bomba_nueva.load_state(state[node])
			'selector':
				var selector_nuevo = selector.instantiate() as Area2D
				$/root/main_scene/objects/controllers.add_child(selector_nuevo)
				selector_nuevo.load_state(state[node])
			'controlador_esclavo':
				var controlador_esclavo_nuevo = controlador_esclavo.instantiate() as Area2D
				$/root/main_scene/objects/controllers.add_child(controlador_esclavo_nuevo)
				controlador_esclavo_nuevo.load_state(state[node])
			
func save_file(path: String) -> void:
	var file := FileAccess.open(path,FileAccess.WRITE)
	if file:
		var data := save_state()
		file.store_string(JSON.stringify(data,'\t'))
