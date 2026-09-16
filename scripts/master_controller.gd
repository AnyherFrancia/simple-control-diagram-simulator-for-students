extends main_class

func _ready() -> void:
	type = "controlador_maestro"


func _process(delta: float) -> void:
	if local_selected:
		self.position = lerp(global_position, get_global_mouse_position(), 25 * delta)
	$porcentaje.text = "Porcentaje: "+str(snapped(flow_status,0.01)*100)+"%"
	$flujo.text = "Flujo: "+str(snapped(flow_status,0.1))+"L"
