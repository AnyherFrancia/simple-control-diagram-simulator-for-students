extends main_class
var dir: bool = true
var set_point: float = 12
func _ready() -> void:
	type = "controlador_maestro"
	manual = false


func _process(delta: float) -> void:
	if local_selected:
		self.position = lerp(global_position, get_global_mouse_position(), 25 * delta)
	match dir:
		true:
			$mode.text = 'Mode: Dir'
			$in.text = "Entrada: "+str(snapped(flow_status,0.1))+"%"
			$out.text = 'Salida: '+str(snapped(flow_status,0.01)*100)+"%"
		false:
			$mode.text = 'Mode: Rev'
			$in.text = "Entrada: "+str(snapped(flow_status,0.1))+"%"
			$out.text = 'Salida: '+str(1-(snapped(flow_status,0.01)*100))+"%"
			flow_status = 1-flow_status
		_:
			pass
