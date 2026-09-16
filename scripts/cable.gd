extends main_class

func _ready() -> void:
	type = "cable"

func _physics_process(_delta: float) -> void:
	if parents:
		for area in parents:
			match area.type:
				"controlador_maestro":
					areaa_dic['controlador_maestro'] = area
				"medidor":
					areaa_dic['medidor'] = area
				'controlador_esclavo':
					areaa_dic["controlador_esclavo"] = area
				'cable':
					if not areaa_dic['medidor']:
						areaa_dic['medidor'] = area
				'cable_transmision':
					pass
				_:
					pass
			if areaa_dic['controlador_esclavo'] and areaa_dic['medidor']:
				flow_status = areaa_dic['medidor'].flow_status
				if areaa_dic["controlador_esclavo"].type == "controlador_esclavo":
					areaa_dic["controlador_esclavo"].flow_status_b = flow_status
			elif areaa_dic["controlador_maestro"] and areaa_dic["medidor"]:
				flow_status = areaa_dic['medidor'].flow_status
				if areaa_dic["controlador_maestro"].type == "controlador_maestro":
					areaa_dic["controlador_maestro"].flow_status = flow_status
			elif areaa_dic["controlador_esclavo"] and areaa_dic["controlador_maestro"]:
				flow_status = areaa_dic['controlador_maestro'].flow_status
				if areaa_dic["controlador_esclavo"].type == "controlador_esclavo":
					areaa_dic["controlador_esclavo"].flow_status_a = flow_status
