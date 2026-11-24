extends main_class

func _ready() -> void:
	main_dictionary['type'] = "cable"
	var areaa_dic = main_dictionary['areaa_dic']
	if areaa_dic['controlador_esclavo'] and areaa_dic['medidor']:
		if areaa_dic["controlador_esclavo"].main_dictionary['type'] == "controlador_esclavo":
			areaa_dic['controlador_esclavo'].main_dictionary['unit'] = areaa_dic['medidor'].main_dictionary['unit']
			if not areaa_dic["controlador_esclavo"].main_dictionary['signal_2nd']:
				areaa_dic['controlador_esclavo'].main_dictionary['signal_2nd'] = areaa_dic['medidor']
			elif not areaa_dic['controlador_esclavo'].main_dictionary['signal_3rd']:
				areaa_dic["controlador_esclavo"].main_dictionary['signal_3rd'] = areaa_dic['medidor']
	elif areaa_dic["controlador_maestro"] and areaa_dic["medidor"]:
		areaa_dic['controlador_maestro'].main_dictionary['unit'] = areaa_dic['medidor'].main_dictionary['unit']
		if areaa_dic["controlador_maestro"].main_dictionary['type'] == "controlador_maestro":
			areaa_dic["controlador_maestro"].main_dictionary['sign_cable'] = areaa_dic['medidor']
	elif areaa_dic["controlador_esclavo"] and areaa_dic["controlador_maestro"]:
		areaa_dic['controlador_maestro'].main_dictionary['unit'] = areaa_dic['controlador_esclavo'].main_dictionary['unit']
		if areaa_dic["controlador_esclavo"].main_dictionary['type'] == "controlador_esclavo":
			areaa_dic['controlador_esclavo'].main_dictionary['master_signal'] = areaa_dic['controlador_maestro']
	elif areaa_dic['funcion'] and areaa_dic['medidor']:
		areaa_dic['funcion'].main_dictionary['unit'] = areaa_dic['medidor'].main_dictionary['unit']
		areaa_dic['funcion'].main_dictionary['signal_1st'] = areaa_dic['medidor']
		areaa_dic['funcion'].main_dictionary['unit'] = areaa_dic['medidor'].main_dictionary['unit']
	elif areaa_dic['funcion'] and areaa_dic['controlador_maestro']:
		areaa_dic['funcion'].main_dictionary['unit'] = areaa_dic['controlador_maestro'].main_dictionary['unit']
		if areaa_dic["controlador_maestro"].main_dictionary['type'] == "controlador_maestro":
			main_dictionary['flow_status'] = areaa_dic["controlador_maestro"].main_dictionary['flow_status']
		areaa_dic['funcion'].main_dictionary['flow_status'] = main_dictionary['flow_status']
	elif areaa_dic['funcion'] and areaa_dic['controlador_esclavo']:
		if areaa_dic["controlador_esclavo"].main_dictionary['type'] == "controlador_esclavo":
			areaa_dic['controlador_esclavo'].main_dictionary['unit'] = areaa_dic['funcion'].main_dictionary['unit']
			if not areaa_dic["controlador_esclavo"].main_dictionary['signal_2nd']:
				areaa_dic['controlador_esclavo'].main_dictionary['signal_2nd'] = areaa_dic['funcion']
			elif not areaa_dic['controlador_esclavo'].main_dictionary['signal_3rd']:
				areaa_dic["controlador_esclavo"].main_dictionary['signal_3rd'] = areaa_dic['funcion']
	elif areaa_dic['convertidor'] and areaa_dic['medidor']:
		areaa_dic['convertidor'].main_dictionary['signal_1st'] = areaa_dic['medidor']
	elif areaa_dic['convertidor'] and areaa_dic['controlador_maestro']:
		areaa_dic['convertidor'].main_dictionary['signal_1st'] = areaa_dic['controlador_maestro']
	elif areaa_dic['convertidor'] and areaa_dic['controlador_esclavo']:
		areaa_dic['convertidor'].main_dictionary['signal_1st'] = areaa_dic['controlador_esclavo']
	elif areaa_dic['convertidor'] and areaa_dic['bomba']:
		if areaa_dic['bomba'].main_dictionary['type'] == 'bomba':
			areaa_dic['bomba'].main_dictionary['sign_cable'] = areaa_dic['convertidor']
	elif areaa_dic['selector'] and areaa_dic['medidor']:
		if not areaa_dic['selector'].main_dictionary['signal_1st']:
			areaa_dic['selector'].main_dictionary['signal_1st'] = areaa_dic['medidor']
			print(areaa_dic['selector'].main_dictionary['signal_1st'])
		elif not areaa_dic['selector'].main_dictionary['signal_2nd']:
			areaa_dic['selector'].main_dictionary['signal_2nd'] = areaa_dic['medidor']
			print(areaa_dic['selector'].main_dictionary['signal_2nd'])
		elif not areaa_dic['selector'].main_dictionary['signal_3rd']:
			areaa_dic['selector'].main_dictionary['signal_3rd'] = areaa_dic['medidor']
			print(areaa_dic['selector'].main_dictionary['signal_3rd'])
	elif areaa_dic['selector'] and areaa_dic['controlador_maestro']:
		if not areaa_dic['selector'].main_dictionary['signal_1st']:
			areaa_dic['selector'].main_dictionary['signal_1st'] = areaa_dic['controlador_maestro']
			print(areaa_dic['selector'].main_dictionary['signal_1st'])
		elif not areaa_dic['selector'].main_dictionary['signal_2nd']:
			areaa_dic['selector'].main_dictionary['signal_2nd'] = areaa_dic['controlador_maestro']
			print(areaa_dic['selector'].main_dictionary['signal_2nd'])
		elif not areaa_dic['selector'].main_dictionary['signal_3rd']:
			areaa_dic['selector'].main_dictionary['signal_3rd'] = areaa_dic['controlador_maestro']
			print(areaa_dic['selector'].main_dictionary['signal_3rd'])
	elif areaa_dic['selector'] and areaa_dic['controlador_esclavo']:
		if areaa_dic["controlador_esclavo"].main_dictionary['type'] == "controlador_esclavo":
			if not areaa_dic["controlador_esclavo"].main_dictionary['signal_2nd']:
				areaa_dic['controlador_esclavo'].main_dictionary['signal_2nd'] = areaa_dic['selector']
			elif not areaa_dic['controlador_esclavo'].main_dictionary['signal_3rd']:
				areaa_dic["controlador_esclavo"].main_dictionary['signal_3rd'] = areaa_dic['selector']
	$segment1.shape.a = Vector2(areaa_dic['punto a'].x,areaa_dic['punto a'].y)
	$segment1.shape.b = Vector2(areaa_dic['punto a'].x,areaa_dic['punto b'].y)
	$segment2.shape.a = Vector2(areaa_dic['punto a'].x,areaa_dic['punto b'].y)
	$segment2.shape.b = Vector2(areaa_dic['punto b'].x,areaa_dic['punto b'].y)

func window_handler():
	queue_free()
