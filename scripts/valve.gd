extends main_class

func _ready() -> void:
	add_to_group("save")
	main_dictionary['flow_status_1st'] = 0.0
	main_dictionary['flow_status_2nd'] = 0.0
	main_dictionary['max_capacity'] = 20
	main_dictionary['type'] = "valvula"
	main_dictionary['auto_fill'] = false
	main_dictionary['fail_state'] = false
	main_dictionary['ato'] = false
	if main_dictionary['ato']:
		main_dictionary['flow_status'] = 1
	main_dictionary['config_window'] = preload("res://scenes/valve_sub_window.tscn")
var state = [preload("res://graficos/valvula/valvula_0%.png"),
preload("res://graficos/valvula/valvula_10%.png"),
preload("res://graficos/valvula/valvula_20%.png"),
preload("res://graficos/valvula/valvula_30%.png"),
preload("res://graficos/valvula/valvula_40%.png"),
preload("res://graficos/valvula/valvula_50%.png"),
preload("res://graficos/valvula/valvula_60%.png"),
preload("res://graficos/valvula/valvula_80%.png")]

func _physics_process(delta: float) -> void:
	if main_dictionary['local_selected']:
			self.position = lerp(global_position, get_global_mouse_position(), 25 * delta)
			$sprite_left.play("default_0%")
			$sprite_right.play("default_0%")
	match main_dictionary['ato']:
		true:
			$type.text = "ATO"
			if main_dictionary['fail_state']:
				main_dictionary['flow_status'] = 0
		false:
			$type.text = "ATC"
			if main_dictionary['fail_state']:
				main_dictionary['flow_status'] = 1
	if main_dictionary['auto_fill']:
		if main_dictionary['flow_status_1st'] < main_dictionary['max_capacity']:
			main_dictionary['flow_status_1st'] += snapped(main_dictionary['getting_in']*delta,0.01)
		if main_dictionary['flow_status_2nd'] < main_dictionary['max_capacity']:
			main_dictionary['flow_status_2nd'] += snapped(((main_dictionary['max_capacity']+main_dictionary['flow_status_1st'])/main_dictionary['max_capacity'])*delta,0.01)
			main_dictionary['flow_status_1st'] -= snapped(((main_dictionary['max_capacity']+main_dictionary['flow_status_1st'])/main_dictionary['max_capacity'])*delta,0.01)
	else:
		if main_dictionary['flow_status_1st'] < main_dictionary['max_capacity'] and main_dictionary['areaa_dic']['source']:
			main_dictionary['flow_status_1st'] += main_dictionary['getting_in']
		if main_dictionary['areaa_dic']:
			for area in main_dictionary['areaa_dic']:
				match area:
					'source':
						if main_dictionary['areaa_dic'][area]:
							if main_dictionary['areaa_dic'][area].main_dictionary['flow_status'] > 0:
								main_dictionary['getting_in'] = snapped(((main_dictionary['max_capacity']+main_dictionary['areaa_dic'][area].main_dictionary['flow_status'])/main_dictionary['max_capacity'])*delta, 0.01) 
								main_dictionary['areaa_dic'][area].main_dictionary['flow_status'] -= main_dictionary['getting_in']
							main_dictionary['sourcing'] = true
					"controlador_esclavo":
						if main_dictionary['areaa_dic'][area]:
							match main_dictionary['ato']:
								true:
									if not main_dictionary['fail_state']:
										main_dictionary['flow_status'] = main_dictionary['areaa_dic'][area].main_dictionary['flow_status']
								false:
									if not main_dictionary['fail_state']:
										main_dictionary['flow_status'] = 1-main_dictionary['areaa_dic'][area].main_dictionary['flow_status']
					_:
						pass
		if main_dictionary['flow_status_2nd'] < main_dictionary['max_capacity'] and main_dictionary['flow_status_1st'] > 0:
			main_dictionary['flow_status_2nd'] += snapped(((main_dictionary['max_capacity']+main_dictionary['flow_status_1st'])/main_dictionary['max_capacity'])*delta*main_dictionary['flow_status'],0.01)
			main_dictionary['flow_status_1st'] -= snapped(((main_dictionary['max_capacity']+main_dictionary['flow_status_1st'])/main_dictionary['max_capacity'])*delta*main_dictionary['flow_status'],0.01)
	if main_dictionary['parents']:
		for parent in main_dictionary['parents']:
			match parent.main_dictionary['type']:
				'source':
					if not main_dictionary['sourcing']:
						main_dictionary['areaa_dic']['source'] = parent
						if main_dictionary['parents'][parent].name == 'right':
							pass
					else:
						pass
				'controlador':
					main_dictionary['areaa_dic']['controlador'] = parent
				"controlador_esclavo":
					main_dictionary['areaa_dic']["controlador_esclavo"] = parent
				'medidor':
					main_dictionary['areaa_dic']['medidor'] = parent
				'tuberia':
					if parent.main_dictionary['sourcing'] == true and main_dictionary['areaa_dic']['source'] == null:
						main_dictionary['areaa_dic']['source'] = parent
						if main_dictionary['parents'][parent].name == 'right':
							#$sprite.flip_h = true 
							pass
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
				self. global_position -= main_dictionary['areas_entered'][area].position*2.5
				self.global_position.y = area.global_position.y-1
				main_dictionary['conected'] = false
	if 1-main_dictionary['flow_status'] == 0:
		$Sprite.texture = state[0]
	elif 1-main_dictionary['flow_status'] < 0.10:
		$Sprite.texture = state[1]
	elif 1-main_dictionary['flow_status'] < 0.20:
		$Sprite.texture = state[2]
	elif 1-main_dictionary['flow_status'] < 0.40:
		$Sprite.texture = state[3]
	elif 1-main_dictionary['flow_status'] < 0.50:
		$Sprite.texture = state[4]
	elif 1-main_dictionary['flow_status'] < 0.60:
		$Sprite.texture = state[5]
	elif 1-main_dictionary['flow_status'] < 0.80:
		$Sprite.texture = state[6]
	elif 1-main_dictionary['flow_status'] < 0.90:
		$Sprite.texture = state[7]
	elif 1-main_dictionary['flow_status'] > 90:
		$Sprite.texture = state[8]
	
	if main_dictionary['flow_status_1st']/main_dictionary['max_capacity'] >= 0 and main_dictionary['flow_status_1st']/main_dictionary['max_capacity'] <= 0.05 :
		$sprite_left.play('default')
	elif main_dictionary['flow_status_1st']/main_dictionary['max_capacity'] > 0.05 and main_dictionary['flow_status_1st']/main_dictionary['max_capacity'] <= 0.25:
		$sprite_left.play('start')
	elif main_dictionary['flow_status_1st']/main_dictionary['max_capacity'] > 0.25:
		$sprite_left.play('normal')
	if main_dictionary['flow_status_2nd']/main_dictionary['max_capacity'] >= 0 and main_dictionary['flow_status_2nd']/main_dictionary['max_capacity'] <= 0.05 :
		$sprite_right.play('default')
	elif main_dictionary['flow_status_2nd']/main_dictionary['max_capacity'] > 0.05 and main_dictionary['flow_status_2nd']/main_dictionary['max_capacity'] <= 0.25:
		$sprite_right.play('start')
	elif main_dictionary['flow_status_2nd']/main_dictionary['max_capacity'] > 0.25:
		$sprite_right.play('normal')

func window_handler():
	var new_window = global_window.on_new_window()
	var attributes_window = main_dictionary['config_window'].instantiate() as Control
	attributes_window.parent = self
	$/root/main_scene/sub_windows.add_child(new_window)
	new_window.add_child(attributes_window)
