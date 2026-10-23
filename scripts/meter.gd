extends main_class
func _ready() -> void:
	type = "medidor"


func _process(delta: float) -> void:
	if local_selected:
		self.position = lerp(global_position, get_global_mouse_position(), 25 * delta)
	if parents:
		for parent in parents:
			match parent.type:
					'tuberia':
						if parent:
							getting_in = parent.getting_in
							max_capacity = parent.max_capacity
							$flujo.text = "Flujo: "+str(snapped(getting_in,0.1))+"L/seg"
							flow_status = parent.flow_status/parent.max_capacity
					'source':
						if parent:
							getting_in = parent.getting_in
							max_capacity = parent.max_capacity
							$flujo.text = "Flujo: "+str(snapped(getting_in,0.1))+"L/seg"
							flow_status = parent.flow_status/parent.max_capacity
					_:
						pass
	$signal.text = 'Señal: '+str(snapped(flow_status,0.01)*100)+'%'
	for area in areas_entered:
			if not local_selected and conected:
				self.position = area.get_parent().position
				self.position.x += area.position.x*2
				self.position.y += area.position.y-30.0
				conected = false
