extends main_class

func _ready() -> void:
	type = "medidor"


func _process(delta: float) -> void:
	if local_selected:
		self.position = lerp(global_position, get_global_mouse_position(), 25 * delta)
	for area in parents:
		if area:
			if area.type == 'tuberia' or area.type == "source":
				$porcentaje.text = "Porcentaje: "+str(snapped(area.flow_status/area.max_capacity,0.01)*100)+"%"
				$flujo.text = "Flujo: "+str(snapped(area.flow_status,0.1))+"L"
				flow_status = snapped(area.flow_status/area.max_capacity,0.01)
	for area in areas_entered:
			if not local_selected and conected:
				self.position = area.get_parent().position
				self.position.x += area.position.x*2
				self.position.y += area.position.y
				conected = false
