extends main_class

func _ready() -> void:
	main_dictionary['dir'] = true
	main_dictionary['set_point'] = 12
	main_dictionary['sign_cable'] = null
	add_to_group("save")
	main_dictionary['type'] = "controlador_maestro"
	main_dictionary['manual'] = false

func _process(delta: float) -> void:
	if main_dictionary['local_selected']:
		self.position = lerp(global_position, get_global_mouse_position(), 25 * delta)
	if main_dictionary['sign_cable']:
		match main_dictionary['dir']:
			true:
				$mode.text = 'Mode: Dir'
				$in.text = "Entrada: "+str(snapped(main_dictionary['sign_cable'].main_dictionary['flow_status'],0.01)*100)+"%"
				$out.text = 'Salida: '+str(snapped(main_dictionary['sign_cable'].main_dictionary['flow_status'],0.01)*100)+"%"
			false:
				$mode.text = 'Mode: Rev'
				$in.text = "Entrada: "+str(snapped(main_dictionary['sign_cable'].main_dictionary['flow_status'],0.01)*100)+"%"
				$out.text = 'Salida: '+str(1-(snapped(main_dictionary['sign_cable'].main_dictionary['flow_status'],0.01)*100))+"%"
				main_dictionary['sign_cable'].main_dictionary['flow_status'] = 1-main_dictionary['sign_cable'].main_dictionary['flow_status']
			_:
				pass
