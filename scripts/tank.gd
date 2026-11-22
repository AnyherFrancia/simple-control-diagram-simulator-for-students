extends main_class

func _ready() -> void:
	add_to_group("save")
	main_dictionary['unit'] = "L"
	main_dictionary['sourcing'] = true
	main_dictionary['max_capacity'] = 80
	main_dictionary['type'] = "source"
	main_dictionary['getting_in'] = 5
	main_dictionary['auto_fill'] = true
	main_dictionary['config_window'] = preload("res://scenes/configs_sub_window.tscn")

func _physics_process(delta: float) -> void:
	if main_dictionary['local_selected']:
		self.position = lerp(global_position, get_global_mouse_position(), 25 * delta)
	if main_dictionary['auto_fill']:
		if main_dictionary['flow_status'] < main_dictionary['max_capacity']:
			main_dictionary['flow_status'] += snapped(main_dictionary['getting_in']*delta,0.01)
	else:
		if main_dictionary['areaa_dic']:
			for area in main_dictionary['areaa_dic']:
				match area:
					'source':
						if main_dictionary['areaa_dic'][area]:
							if main_dictionary['areaa_dic'][area].main_dictionary['flow_status'] > 0:
								match main_dictionary['manual']:
									true:
										if main_dictionary['areaa_dic'][area].main_dictionary['flow_status'] > main_dictionary['getting_in']:
											if main_dictionary['flow_status'] < main_dictionary['max_capacity'] and main_dictionary['areaa_dic']['source']:
												main_dictionary['flow_status'] += snapped(main_dictionary['getting_in']*delta,0.01)
												main_dictionary['areaa_dic'][area].main_dictionary['flow_status'] -= snapped(main_dictionary['getting_in']*delta,0.01)
										else:
											main_dictionary['flow_status'] = snapped(((main_dictionary['max_capacity']+main_dictionary['areaa_dic'][area].main_dictionary['flow_status'])/main_dictionary['max_capacity'])*delta, 0.01)
											main_dictionary['areaa_dic'][area].main_dictionary['flow_status'] -= snapped(((main_dictionary['max_capacity']+main_dictionary['areaa_dic'][area].main_dictionary['flow_status'])/main_dictionary['max_capacity'])*delta, 0.01)
									false:
										main_dictionary['flow_status'] += main_dictionary['getting_in']
										main_dictionary['getting_in'] = snapped(((main_dictionary['max_capacity']+main_dictionary['areaa_dic'][area].main_dictionary['flow_status'])/main_dictionary['max_capacity'])*delta, 0.01) 
										main_dictionary['areaa_dic'][area].main_dictionary['flow_status'] -= main_dictionary['getting_in']
							main_dictionary['sourcing'] = true
					_:
						pass
	if main_dictionary['parents']:
		for parent in main_dictionary['parents']:
			match parent.main_dictionary['type']:
				'medidor':
					main_dictionary['areaa_dic']['medidor'] = parent
				'tuberia':
					if parent.main_dictionary['sourcing'] == true and main_dictionary['sourcing'] == false:
						main_dictionary['areaa_dic']['source'] = parent
					else:
						pass
				_:
					pass
	$water_level.set_point_position(1,Vector2(-2.0,21.0-(56.0*(main_dictionary['flow_status']/main_dictionary['max_capacity']))))

func window_handler():
	var new_window = global_window.on_new_window()
	var attributes_window = main_dictionary['config_window'].instantiate() as Control
	attributes_window.parent = self
	$/root/main_scene/sub_windows.add_child(new_window)
	new_window.add_child(attributes_window)
