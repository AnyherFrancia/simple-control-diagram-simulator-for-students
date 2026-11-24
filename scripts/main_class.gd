extends Area2D
class_name main_class
var main_dictionary: Dictionary = {
	'getting_in': 0.0,
	'max_capacity': 0.0,
	'max_flow': 0.0,
	'flow_status': 0.0,
	'local_selected': false,
	'sourcing': false,
	'conected': false,
	'auto_fill': false,
	'manual': false,
	'fail_state': false,
	'areas_entered': {},
	'parents': {},
	'areaa_dic': {
		'source': null, 
		'tuberia': null, 
		'cable': null,
		'controlador_maestro': null,
		"controlador_esclavo": null,
		'medidor': null,
		"cable_transmision": null,
		"valvula": null,
		"funcion": null,
		"bomba": null,
		"selector": null,
		"convertidor": null
	},
	'unit': '',
	'type': '',
	'config_window': PackedScene
}


func _on_area_shape_entered(_area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if area:
		var owner_id = area.shape_find_owner(area_shape_index)
		var shape_node = area.shape_owner_get_owner(owner_id)
		var local_owner_id = shape_find_owner(local_shape_index)
		var local_shape = shape_owner_get_owner(local_owner_id)
		var parent = shape_node.get_parent()
		if not parent.main_dictionary['type'] == 'cable' and not parent.main_dictionary['type'] == 'cable_transmision':
			main_dictionary['parents'][parent] = local_shape
			main_dictionary['areas_entered'][shape_node] = local_shape
	else:
		pass

func _on_area_shape_exited(_area_rid: RID, area: Area2D, area_shape_index: int, _local_shape_index: int) -> void:
	if area:
		var owner_id = area.shape_find_owner(area_shape_index)
		var shape_node = area.shape_owner_get_owner(owner_id)
		var parent = shape_node.get_parent()
		if not parent.main_dictionary['type'] == 'cable' and not parent.main_dictionary['type'] == 'cable_transmision':
			main_dictionary['areas_entered'].erase(shape_node)
			main_dictionary['parents'].erase(shape_node.get_parent())
	else:
		pass

func _on_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	if Input.is_action_just_pressed("left_click") and not Global.selected:
		main_dictionary['local_selected'] = true
		Global.selected = true
		main_dictionary['conected'] = true
	elif Input.is_action_just_pressed("right_click"):
		window_handler()
	elif Input.is_action_just_released("left_click"):
		main_dictionary['local_selected'] = false
		Global.selected = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if Input.is_action_just_released("left_click"):
			main_dictionary['local_selected'] = false
			Global.selected = false

func window_handler():
	pass

func save_state(data: Dictionary):
	for argument in main_dictionary:
		data[argument] = main_dictionary[argument]
	data['position_y'] = self.position.y
	data['position_x'] = self.position.x

func load_state(data: Dictionary):
	for argument in data:
		match argument:
			'position_y':
				self.position.y = float(data[argument])
			'position_x':
				self.position.x = float(data[argument])
			'config_window':
				pass
			'parents':
				pass
			'areas_entered':
				pass
			'areaa_dic':
				pass
			'signal_1st':
				pass
			'signal_2nd':
				pass
			'signal_3rd':
				pass
			'sign_cable':
				pass
			'master_signal':
				pass
			_:
				main_dictionary[argument] = data[argument]
		
	
