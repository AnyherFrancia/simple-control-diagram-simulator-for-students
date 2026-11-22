extends main_class

func _ready() -> void:
	add_to_group("save")
	main_dictionary['type'] = "medidor"

func _process(delta: float) -> void:
	if main_dictionary['local_selected']:
		self.position = lerp(global_position, get_global_mouse_position(), 25 * delta)
	if main_dictionary['parents']:
		for parent in main_dictionary['parents']:
			match parent.main_dictionary['type']:
					'tuberia':
						if parent:
							main_dictionary['unit'] = parent.main_dictionary['unit']
							$body/controller.text = str(main_dictionary['unit'])+"T"
							main_dictionary['getting_in'] = parent.main_dictionary['getting_in']
							main_dictionary['max_flow'] = parent.main_dictionary['max_flow']
							$flujo.text = "Flujo: "+str(snapped(main_dictionary['getting_in'],0.1))+"L/seg"
							main_dictionary['flow_status'] = parent.main_dictionary['getting_in']/parent.main_dictionary['max_flow']
					'source':
						if parent:
							main_dictionary['unit'] = parent.main_dictionary['unit']
							$body/controller.text = str(main_dictionary['unit'])+"T"
							main_dictionary['getting_in'] = parent.main_dictionary['getting_in']
							main_dictionary['max_capacity'] = parent.main_dictionary['max_capacity']
							$flujo.text = "Flujo: "+str(snapped(main_dictionary['getting_in'],0.1))+"L/seg"
							main_dictionary['flow_status'] = parent.main_dictionary['flow_status']/parent.main_dictionary['max_capacity']
					_:
						pass
	$signal.text = 'Señal: '+str(snapped(main_dictionary['flow_status'],0.01)*100)+'%'
	for area in main_dictionary['areas_entered']:
			if not main_dictionary['local_selected'] and main_dictionary['conected']:
				self.position = area.get_parent().position
				self.position.x += area.position.x*2
				self.position.y += area.position.y-30.0
				main_dictionary['conected'] = false

func window_handler():
	self.queue_free()
