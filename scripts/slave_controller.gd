extends main_class
var signal_2nd: Node2D
var signal_3rd: Node2D
var master_signal: Node2D
var dir: bool = true
var set_point: float = 3
func _ready() -> void:
	type = "controlador_esclavo"
	flow_status = 0

func _process(delta: float) -> void:
	if signal_2nd:
		match dir:
			true:
				$mode.text = 'Mode: Dir'
				if master_signal:
					match master_signal.dir:
						true:
							if signal_2nd.flow_status-0.20 > flow_status:
								flow_status = signal_2nd.flow_status
							elif signal_3rd and signal_3rd.flow_status-0.20 > flow_status:
								flow_status = signal_3rd.flow_status
								$nivel_3.text = level_handler(signal_3rd)
						false:
							if signal_2nd:
								if signal_2nd.getting_in > set_point:
									flow_status = signal_2nd.flow_status+(signal_2nd.gettin_in-set_point)*0.10
								else:
									flow_status = signal_2nd.flow_status-(set_point-signal_2nd.getting_in)*0.10
							elif signal_3rd and signal_3rd.flow_status-0.20 > 1-flow_status:
								flow_status = signal_3rd.flow_status
								$nivel_3.text = level_handler(signal_3rd)
					$nivel_1.text = level_handler(master_signal)
				elif not master_signal:
					if signal_2nd and not signal_3rd:
								if signal_2nd.getting_in > set_point:
									flow_status = signal_2nd.flow_status+(signal_2nd.getting_in-set_point)*0.10
								else:
									flow_status = signal_2nd.flow_status-(set_point-signal_2nd.getting_in)*0.10
					elif signal_3rd and signal_3rd.flow_status-0.20 > flow_status:
						flow_status = signal_3rd.flow_status
						$nivel_3.text = level_handler(signal_3rd)
			false:
				$mode.text = 'Mode: Rev'
				if master_signal:
					match master_signal.dir:
						true:
							if signal_2nd.flow_status-0.20 > flow_status:
								flow_status = 1-signal_2nd.flow_status
							elif signal_3rd and signal_3rd.flow_status-0.20 > flow_status:
								flow_status = 1-signal_3rd.flow_status
								$nivel_3.text = level_handler(signal_3rd)
						false:
							if signal_2nd.flow_status:
								if signal_2nd.getting_in > set_point:
									flow_status = 1-signal_2nd.flow_status
								else:
									flow_status = 1-signal_2nd.flow_status
							elif signal_3rd and signal_3rd.flow_status-0.20 > 1-flow_status:
								flow_status = 1-signal_3rd.flow_Status
								$nivel_3.text = level_handler(signal_3rd)
					$nivel_1.text = level_handler(master_signal)
				elif not master_signal:
					if signal_2nd:
						flow_status = 1-signal_2nd.flow_status
					elif signal_3rd and signal_3rd.flow_status-0.20 > flow_status:
						flow_status = 1-signal_3rd.flow_status
						$nivel_3.text = level_handler(signal_3rd)
						
		$nivel_2.text = level_handler(signal_2nd)
		if flow_status > 1: flow_status = 1
		if flow_status < 0: flow_status = 0
	$porcentaje.text = "valvula: "+str(snapped(flow_status,0.01)*100)+"%"
	if local_selected:
		self.position = lerp(global_position, get_global_mouse_position(), 25 * delta)
	if areas_entered:
		for area in areas_entered:
			if not local_selected and conected:
				self.global_position.x = area.global_position.x+1.0
				self. global_position -= areas_entered[area].position*2
				self.global_position.y = area.global_position.y-28.0
				conected = false

func level_handler(nivel: Node2D) -> String:
	return("{string}: ".format({'string': nivel.type}))+str(snapped(nivel.flow_status,0.01)*100)+'%'
