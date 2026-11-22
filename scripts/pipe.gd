extends main_class
func _ready() -> void:
	add_to_group("save")
	main_dictionary['unit'] = "F"
	main_dictionary['max_capacity'] = 10
	main_dictionary['max_flow'] = 2
	main_dictionary['type'] = "tuberia"
	main_dictionary['config_window'] = preload("res://scenes/configs_sub_window.tscn")

func _physics_process(delta: float) -> void:
	if main_dictionary['local_selected']:
		self.position = lerp(global_position, get_global_mouse_position(), 25 * delta)
		$sprite.play("default")
	if main_dictionary['getting_in'] > main_dictionary['max_flow']:
		main_dictionary['getting_in'] = main_dictionary['max_flow']
	if main_dictionary['auto_fill']:
		if main_dictionary['flow_status'] < main_dictionary['max_capacity']:
			main_dictionary['flow_status'] += snapped(main_dictionary['getting_in']*delta,0.01)
	else:
		if main_dictionary['areaa_dic']:
			for area in main_dictionary['areaa_dic']:
				match area:
					'source':
						if main_dictionary['areaa_dic'][area]:
							if main_dictionary['areaa_dic'][area].main_dictionary['type'] == "valvula" and main_dictionary['areaa_dic'][area].main_dictionary['flow_status_2nd'] > 0:
								match main_dictionary['manual']:
									true:
										if main_dictionary['areaa_dic'][area].main_dictionary['flow_status'] > main_dictionary['getting_in']:
											if main_dictionary['flow_status'] < main_dictionary['max_capacity'] and main_dictionary['areaa_dic']['source']:
												main_dictionary['flow_status'] += snapped(main_dictionary['getting_in']*delta,0.01)
												main_dictionary['areaa_dic'][area].main_dictionary['flow_status_2nd'] -= snapped(main_dictionary['getting_in']*delta,0.01)
										else:
											main_dictionary['flow_status'] = main_dictionary['getting_in']
											main_dictionary['areaa_dic'][area].main_dictionary['flow_status_2nd'] -= main_dictionary['getting_in']
											main_dictionary['getting_in'] = snapped(((main_dictionary['max_capacity']+main_dictionary['areaa_dic'][area].main_dictionary['flow_status_2nd'])/main_dictionary['max_capacity'])*delta, 0.01)
									false:
										if main_dictionary['areaa_dic'][area].main_dictionary['flow_status'] > 0 and main_dictionary['flow_status'] < main_dictionary['max_capacity']:
											main_dictionary['flow_status'] += main_dictionary['getting_in']
											main_dictionary['areaa_dic'][area].main_dictionary['flow_status_2nd'] -= main_dictionary['getting_in']
											main_dictionary['getting_in'] = snapped(((main_dictionary['max_capacity']+main_dictionary['areaa_dic'][area].main_dictionary['flow_status_2nd'])/main_dictionary['max_capacity'])*delta, 0.01) 
							elif main_dictionary['areaa_dic']['bomba'] and main_dictionary['areaa_dic'][area].main_dictionary['flow_status'] > 0:
								match main_dictionary['manual']:
									true:
										if main_dictionary['areaa_dic'][area].main_dictionary['flow_status'] > main_dictionary['getting_in']:
											if main_dictionary['flow_status'] < main_dictionary['max_capacity'] and main_dictionary['areaa_dic']['source']:
												main_dictionary['flow_status'] += snapped(main_dictionary['getting_in']*delta,0.01)
												main_dictionary['areaa_dic'][area].main_dictionary['flow_status'] -= snapped(main_dictionary['getting_in']*delta,0.01)
										else:
											main_dictionary['flow_status'] =  main_dictionary['getting_in']
											main_dictionary['areaa_dic'][area].main_dictionary['flow_status'] -= main_dictionary['getting_in']
											main_dictionary['getting_in'] = snapped((((main_dictionary['max_capacity']+main_dictionary['areaa_dic'][area].main_dictionary['flow_status'])/main_dictionary['max_capacity'])*delta)+(0.2*(main_dictionary['areaa_dic'][area].rpm/main_dictionary['areaa_dic'][area].max_rpm)), 0.01)
									false:
										if main_dictionary['areaa_dic'][area].main_dictionary['flow_status'] > 0 and main_dictionary['flow_status'] < main_dictionary['max_capacity']:
											main_dictionary['flow_status'] += main_dictionary['getting_in']
											main_dictionary['areaa_dic'][area].main_dictionary['flow_status'] -= main_dictionary['getting_in']
											main_dictionary['getting_in'] = snapped((((main_dictionary['max_capacity']+main_dictionary['areaa_dic'][area].main_dictionary['flow_status'])/main_dictionary['max_capacity'])*delta)+(0.2*(main_dictionary['areaa_dic'][area].rpm/main_dictionary['areaa_dic'][area].max_rpm)), 0.01) 
							elif main_dictionary['areaa_dic'][area].main_dictionary['flow_status'] > 0:
								match main_dictionary['manual']:
									true:
										if main_dictionary['areaa_dic'][area].main_dictionary['flow_status'] > main_dictionary['getting_in']:
											if main_dictionary['flow_status'] < main_dictionary['max_capacity'] and main_dictionary['areaa_dic']['source']:
												main_dictionary['flow_status'] += snapped(main_dictionary['getting_in']*delta,0.01)
												main_dictionary['areaa_dic'][area].main_dictionary['flow_status'] -= snapped(main_dictionary['getting_in']*delta,0.01)
										else:
											main_dictionary['flow_status'] = main_dictionary['getting_in']
											main_dictionary['areaa_dic'][area].main_dictionary['flow_status'] -= main_dictionary['getting_in']
											main_dictionary['getting_in'] = snapped(((main_dictionary['max_capacity']+main_dictionary['areaa_dic'][area].main_dictionary['flow_status'])/main_dictionary['max_capacity'])*delta, 0.01)
									false:
										if main_dictionary['areaa_dic'][area].main_dictionary['flow_status'] > 0 and main_dictionary['flow_status'] < main_dictionary['max_capacity']:
											main_dictionary['flow_status'] += main_dictionary['getting_in']
											main_dictionary['areaa_dic'][area].main_dictionary['flow_status'] -= main_dictionary['getting_in']
											main_dictionary['getting_in'] = snapped(((main_dictionary['max_capacity']+main_dictionary['areaa_dic'][area].main_dictionary['flow_status'])/main_dictionary['max_capacity'])*delta, 0.01) 
							main_dictionary['sourcing'] = true
							$Sprite2D.region_rect = Rect2(127.91,452.991,32.145,22.049)
					_:
						pass
	if main_dictionary['parents']:
		for parent in main_dictionary['parents']:
			match parent.main_dictionary['type']:
				'source':
					if not main_dictionary['sourcing']:
						main_dictionary['areaa_dic']['source'] = parent
						if main_dictionary['parents'][parent].name == 'right':
							$sprite.flip_h = true
					else:
						pass
				'controlador':
					main_dictionary['areaa_dic']['controlador'] = parent
				'medidor':
					main_dictionary['areaa_dic']['medidor'] = parent
				'tuberia':
					if parent.main_dictionary['sourcing'] == true and main_dictionary['areaa_dic']['source'] == null:
						main_dictionary['areaa_dic']['source'] = parent
						if main_dictionary['parents'][parent].name == 'right':
							$sprite.flip_h = true
					else:
						pass
				"valvula":
					if parent.main_dictionary['sourcing'] == true and main_dictionary['areaa_dic']['source'] == null:
						main_dictionary['areaa_dic']['source'] = parent
						if main_dictionary['parents'][parent].name == 'right':
							$sprite.flip_h = true
					else:
						pass
				'bomba':
					if parent.main_dictionary['sourcing'] == true and main_dictionary['areaa_dic']['source'] == null:
						main_dictionary['areaa_dic']['source'] = parent
						if main_dictionary['parents'][parent].name == 'right':
							$sprite.flip_h = true
					else:
						pass
				"cable":
					pass
				_:
					pass
	if main_dictionary['areas_entered']:
		for area in main_dictionary['areas_entered']:
			if not main_dictionary['local_selected'] and main_dictionary['conected']:
				self.global_position.x = area.global_position.x
				self. global_position -= main_dictionary['areas_entered'][area].position*2
				self.global_position.y = area.global_position.y
				main_dictionary['conected'] = false
	else:
		pass
	if main_dictionary['getting_in'] == 0:
		$sprite.play('default')
	elif main_dictionary['getting_in'] > 0 and main_dictionary['getting_in'] <= 0.05:
		$sprite.play('start')
	elif main_dictionary['getting_in'] >= 0.05:
		$sprite.play('normal')

func window_handler():
	var new_window = global_window.on_new_window()
	var attributes_window = main_dictionary['config_window'].instantiate() as Control
	attributes_window.parent = self
	$/root/main_scene/sub_windows.add_child(new_window)
	new_window.add_child(attributes_window)
