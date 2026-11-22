extends main_class

func _ready() -> void:
	add_to_group("save")
	main_dictionary['signal_2nd'] = null
	main_dictionary['signal_3rd'] = null
	main_dictionary['master_signal'] = null
	main_dictionary['dir'] = true
	main_dictionary['set_point'] = 3
	main_dictionary['window_signal'] = 0.0
	main_dictionary['type'] = "controlador_esclavo"
	main_dictionary['flow_status'] = 0
	main_dictionary['config_window'] = preload("res://scenes/controller_configs_sub_window.tscn")

func _process(delta: float) -> void:
	$set_point.text = "Set point: "+str(main_dictionary['set_point'])+"L/s"
	if main_dictionary['dir']:
		$mode.text = "Modo: Dir"
	else:
		$mode.text = "Modo: Rev"
	if main_dictionary['signal_2nd']:
		match main_dictionary['dir']:
			true:
				$mode.text = 'Modo: Dir'
				if main_dictionary['master_signal']:
					match main_dictionary['master_signal'].main_dictionary['dir']:
						true:
							if main_dictionary['signal_2nd'].main_dictionary['flow_status']-0.20 > main_dictionary['flow_status']:
								main_dictionary['flow_status'] = main_dictionary['signal_2nd'].main_dictionary['flow_status']
							elif main_dictionary['signal_3rd'] and main_dictionary['signal_3rd'].main_dictionary['flow_status']-0.20 > main_dictionary['flow_status']:
								main_dictionary['flow_status'] = main_dictionary['signal_3rd'].main_dictionary['flow_status']
								$nivel_3.text = level_handler(main_dictionary['signal_3rd'])
						false:
							if main_dictionary['signal_2nd']:
								if main_dictionary['signal_2nd'].main_dictionary['getting_in'] > main_dictionary['set_point']:
									main_dictionary['window_signal'] = main_dictionary['signal_2nd'].main_dictionary['flow_status']
									main_dictionary['flow_status'] = main_dictionary['signal_2nd'].main_dictionary['flow_status']+(main_dictionary['signal_2nd'].gettin_in-main_dictionary['set_point'])*0.05
								else:
									main_dictionary['window_signal'] = main_dictionary['signal_2nd'].main_dictionary['flow_status']
									main_dictionary['flow_status'] = main_dictionary['signal_2nd'].main_dictionary['flow_status']-(main_dictionary['set_point']-main_dictionary['signal_2nd'].main_dictionary['getting_in'])*0.05
							elif main_dictionary['signal_3rd'] and main_dictionary['signal_3rd'].main_dictionary['flow_status']-0.20 > 1-main_dictionary['flow_status']:
								main_dictionary['flow_status'] = main_dictionary['signal_3rd'].main_dictionary['flow_status']
								$nivel_3.text = level_handler(main_dictionary['signal_3rd'])
					$nivel_1.text = level_handler(main_dictionary['master_signal'])
				elif not main_dictionary['master_signal']:
					if main_dictionary['signal_2nd'] and not main_dictionary['signal_3rd']:
								if main_dictionary['signal_2nd'].main_dictionary['getting_in'] > main_dictionary['set_point']:
									main_dictionary['window_signal'] = main_dictionary['signal_2nd'].main_dictionary['flow_status']
									main_dictionary['flow_status'] = main_dictionary['signal_2nd'].main_dictionary['flow_status']+(main_dictionary['signal_2nd'].main_dictionary['getting_in']-main_dictionary['set_point'])*0.05
								else:
									main_dictionary['window_signal'] = main_dictionary['signal_2nd'].main_dictionary['flow_status']
									main_dictionary['flow_status'] = main_dictionary['signal_2nd'].main_dictionary['flow_status']-(main_dictionary['set_point']-main_dictionary['signal_2nd'].main_dictionary['getting_in'])*0.05
					elif main_dictionary['signal_3rd'] and main_dictionary['signal_3rd'].main_dictionary['flow_status']-0.20 > main_dictionary['flow_status']:
						main_dictionary['flow_status'] = main_dictionary['signal_3rd'].main_dictionary['flow_status']
						$nivel_3.text = level_handler(main_dictionary['signal_3rd'])
			false:
				$mode.text = 'Modo: Rev'
				if main_dictionary['master_signal']:
					match main_dictionary['master_signal'].main_dictionary['dir']:
						true:
							if main_dictionary['signal_2nd'].main_dictionary['flow_status']-0.20 > main_dictionary['flow_status']:
								main_dictionary['flow_status'] = 1-main_dictionary['signal_2nd'].main_dictionary['flow_status']
							elif main_dictionary['signal_3rd'] and main_dictionary['signal_3rd'].main_dictionary['flow_status']-0.20 > main_dictionary['flow_status']:
								main_dictionary['flow_status'] = 1-main_dictionary['signal_3rd'].main_dictionary['flow_status']
								$nivel_3.text = level_handler(main_dictionary['signal_3rd'])
						false:
							if main_dictionary['signal_2nd'].main_dictionary['flow_status']:
								if main_dictionary['signal_2nd'].main_dictionary['getting_in'] > main_dictionary['set_point']:
									main_dictionary['flow_status'] = 1-main_dictionary['signal_2nd'].main_dictionary['flow_status']
								else:
									main_dictionary['flow_status'] = 1-main_dictionary['signal_2nd'].main_dictionary['flow_status']
							elif main_dictionary['signal_3rd'] and main_dictionary['signal_3rd'].main_dictionary['flow_status']-0.20 > 1-main_dictionary['flow_status']:
								main_dictionary['flow_status'] = 1-main_dictionary['signal_3rd'].flow_Status
								$nivel_3.text = level_handler(main_dictionary['signal_3rd'])
					$nivel_1.text = level_handler(main_dictionary['master_signal'])
				elif not main_dictionary['master_signal']:
					if main_dictionary['signal_2nd']:
						main_dictionary['flow_status'] = 1-main_dictionary['signal_2nd'].main_dictionary['flow_status']
					elif main_dictionary['signal_3rd'] and main_dictionary['signal_3rd'].main_dictionary['flow_status']-0.20 > main_dictionary['flow_status']:
						main_dictionary['flow_status'] = 1-main_dictionary['signal_3rd'].main_dictionary['flow_status']
						$nivel_3.text = level_handler(main_dictionary['signal_3rd'])
						
		$nivel_2.text = level_handler(main_dictionary['signal_2nd'])
		if main_dictionary['flow_status'] > 1: main_dictionary['flow_status'] = 1
		if main_dictionary['flow_status'] < 0: main_dictionary['flow_status'] = 0
	$porcentaje.text = "valvula: "+str(snapped(main_dictionary['flow_status'],0.01)*100)+"%"
	if main_dictionary['local_selected']:
		self.position = lerp(global_position, get_global_mouse_position(), 25 * delta)
	if main_dictionary['areas_entered']:
		for area in main_dictionary['areas_entered']:
			if not main_dictionary['local_selected'] and main_dictionary['conected']:
				self.global_position.x = area.global_position.x+1.0
				self. global_position -= main_dictionary['areas_entered'][area].position*2
				self.global_position.y = area.global_position.y-28.0
				main_dictionary['conected'] = false

func level_handler(nivel: Node2D) -> String:
	return("{string}: ".format({'string': nivel.main_dictionary['type']}))+str(snapped(nivel.main_dictionary['flow_status'],0.01)*100)+'%'

func window_handler():
	var new_window = global_window.on_new_window()
	var attributes_window = main_dictionary['config_window'].instantiate() as Control
	attributes_window.parent = self
	$/root/main_scene/sub_windows.add_child(new_window)
	new_window.add_child(attributes_window)
	
