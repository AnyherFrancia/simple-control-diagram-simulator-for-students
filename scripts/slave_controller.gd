extends main_class
var flow_status_a: float = 0
var flow_status_b: float = 0
var set_point: float = 12

func _ready() -> void:
	type = "controlador_esclavo"

func _process(delta: float) -> void:
	if flow_status_a < set_point:
		flow_status = flow_status_a
	elif flow_status_b-0.20 < set_point:
		flow_status = flow_status_b
	if local_selected:
		self.position = lerp(global_position, get_global_mouse_position(), 25 * delta)
	$porcentaje.text = "Porcentaje: "+str(snapped(flow_status,0.01)*100)+"%"
	$flujo.text = "Set Point: "+str(snapped(set_point,0.01))+"L"
