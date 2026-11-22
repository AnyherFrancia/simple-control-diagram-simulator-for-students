extends main_class

func _ready() -> void:
	add_to_group("save")
	main_dictionary['signal_1st'] = null
	main_dictionary['type'] = "convertidor"
	main_dictionary['unit'] = 'R'
	main_dictionary['max_capacity'] = 850
	main_dictionary['config_window'] = preload("res://scenes/frecuency_configs_sub_window.tscn")

func _process(delta: float) -> void:
	if main_dictionary['local_selected']:
			self.position = lerp(global_position, get_global_mouse_position(), 25 * delta)
	if main_dictionary['signal_1st']:
		main_dictionary['flow_status'] = main_dictionary['max_capacity']*main_dictionary['signal_1st'].main_dictionary['flow_status']

func window_handler():
	var new_window = global_window.on_new_window()
	var attributes_window = main_dictionary['config_window'].instantiate() as Control
	attributes_window.parent = self
	$/root/main_scene/sub_windows.add_child(new_window)
	new_window.add_child(attributes_window)
