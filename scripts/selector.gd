extends main_class
var greater_than: bool
var state = [preload("res://graficos/functions/selector de alta.png"),preload("res://graficos/functions/selector de baja.png")]

func _ready() -> void:
	add_to_group("save")
	main_dictionary['signal_1st'] = null
	main_dictionary['signal_2nd'] = null
	main_dictionary['signal_3rd'] = null
	main_dictionary['type'] = "selector"
	main_dictionary['max_capacity'] = 0
	greater_than = true
	
func _process(delta: float) -> void:
	if main_dictionary['local_selected']:
			self.position = lerp(global_position, get_global_mouse_position(), 25 * delta)
	if greater_than:
		$sprite.texture = state[0]
		if main_dictionary['signal_1st']:
			if main_dictionary['signal_1st'].main_dictionary['flow_status'] > main_dictionary['max_capacity']: main_dictionary['flow_status'] = main_dictionary['signal_1st'].main_dictionary['flow_status']
		if main_dictionary['signal_2nd']:
			if main_dictionary['signal_2nd'].main_dictionary['flow_status'] > main_dictionary['max_capacity']: main_dictionary['flow_status'] = main_dictionary['signal_2nd'].main_dictionary['flow_status']
		if main_dictionary['signal_3rd']:
			if main_dictionary['signal_3rd'].main_dictionary['flow_status'] > main_dictionary['max_capacity']: main_dictionary['flow_status'] = main_dictionary['signal_3rd'].main_dictionary['flow_status']
	else:
		$sprite.texture = state[1]
		if main_dictionary['signal_1st']:
			if main_dictionary['signal_1st'].main_dictionary['flow_status'] < main_dictionary['max_capacity']: main_dictionary['flow_status'] = main_dictionary['signal_1st'].main_dictionary['flow_status']
		if main_dictionary['signal_2nd']:
			if main_dictionary['signal_2nd'].main_dictionary['flow_status'] < main_dictionary['max_capacity']: main_dictionary['flow_status'] = main_dictionary['signal_2nd'].main_dictionary['flow_status']
		if main_dictionary['signal_3rd']:
			if main_dictionary['signal_3rd'].main_dictionary['flow_status'] < main_dictionary['max_capacity']: main_dictionary['flow_status'] = main_dictionary['signal_3rd'].main_dictionary['flow_status']

func window_handler():
	if greater_than:
		greater_than = false
	elif not greater_than:
		greater_than = true
