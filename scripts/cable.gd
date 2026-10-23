extends main_class

func _ready() -> void:
	type = "cable"
	if areaa_dic['controlador_esclavo'] and areaa_dic['medidor']:
		if areaa_dic["controlador_esclavo"].type == "controlador_esclavo":
			if not areaa_dic["controlador_esclavo"].signal_2nd:
				areaa_dic['controlador_esclavo'].signal_2nd = areaa_dic['medidor']
			elif not areaa_dic['controlador_esclavo'].signal_3rd:
				areaa_dic["controlador_esclavo"].signal_3rd = areaa_dic['medidor']
	elif areaa_dic["controlador_maestro"] and areaa_dic["medidor"]:
		flow_status = areaa_dic['medidor'].flow_status
		if areaa_dic["controlador_maestro"].type == "controlador_maestro":
			areaa_dic["controlador_maestro"].flow_status = flow_status
	elif areaa_dic["controlador_esclavo"] and areaa_dic["controlador_maestro"]:
		flow_status = areaa_dic['controlador_maestro'].flow_status
		if areaa_dic["controlador_esclavo"].type == "controlador_esclavo":
			areaa_dic['controlador_esclavo'].flow_status = flow_status
			areaa_dic['controlador_esclavo'].master_signal = areaa_dic['controlador_maestro']

func window_handler():
	queue_free()
