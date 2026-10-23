extends main_class
var flow_status_1st: float
var flow_status_2nd: float
var ato: bool = false
func _ready() -> void:
	max_capacity = 20
	type = "valvula"
	auto_fill = false
	fail_state = false
	if ato:
		flow_status = 1
	config_window = preload("res://scenes/valve_sub_window.tscn")
	$sprite_left.self_modulate = Color(0.352, 0.521, 0.533, 1.0)
	$sprite_right.self_modulate = Color(0.352, 0.521, 0.533, 1.0)


func _physics_process(delta: float) -> void:
	if local_selected:
			self.position = lerp(global_position, get_global_mouse_position(), 25 * delta)
			$sprite_left.play("default_0%")
			$sprite_right.play("default_0%")
	match ato:
		true:
			if fail_state:
				flow_status = 0
		false:
			if fail_state:
				flow_status = 1
	if auto_fill:
		if flow_status_1st < max_capacity:
			flow_status_1st += snapped(getting_in*delta,0.01)
		if flow_status_2nd < max_capacity:
			flow_status_2nd += snapped(((max_capacity+flow_status_1st)/max_capacity)*delta,0.01)
			flow_status_1st -= snapped(((max_capacity+flow_status_1st)/max_capacity)*delta,0.01)
	else:
		if flow_status_1st < max_capacity and areaa_dic['source']:
			flow_status_1st += getting_in
		if areaa_dic:
			for area in areaa_dic:
				match area:
					'source':
						if areaa_dic[area]:
							if areaa_dic[area].flow_status > 0:
								getting_in = snapped(((max_capacity+areaa_dic[area].flow_status)/max_capacity)*delta, 0.01) 
								areaa_dic[area].flow_status -= getting_in
							sourcing = true
							$sprite_left.self_modulate = Color(0.0, 0.663, 0.0, 1.0)
							$sprite_right.self_modulate = Color(0.0, 0.663, 0.0, 1.0)
					"controlador_esclavo":
						if areaa_dic[area]:
							match ato:
								true:
									if not fail_state:
										flow_status = areaa_dic[area].flow_status
								false:
									if not fail_state:
										flow_status = 1-areaa_dic[area].flow_status
					_:
						pass
		if flow_status_2nd < max_capacity and flow_status_1st > 0:
			flow_status_2nd += snapped(((max_capacity+flow_status_1st)/max_capacity)*delta*flow_status,0.01)
			flow_status_1st -= snapped(((max_capacity+flow_status_1st)/max_capacity)*delta*flow_status,0.01)
	if parents:
		for parent in parents:
			match parent.type:
				'source':
					if not sourcing:
						areaa_dic['source'] = parent
						if parents[parent].name == 'right':
							pass
					else:
						pass
				'controlador':
					areaa_dic['controlador'] = parent
				"controlador_esclavo":
					areaa_dic["controlador_esclavo"] = parent
				'medidor':
					areaa_dic['medidor'] = parent
				'tuberia':
					if parent.sourcing == true and areaa_dic['source'] == null:
						areaa_dic['source'] = parent
						if parents[parent].name == 'right':
							#$sprite.flip_h = true 
							pass
					else:
						pass
				"cable":
					pass
				_:
					pass
	if areas_entered:
		for area in areas_entered:
			if not local_selected and conected:
				self.global_position.x = area.global_position.x
				self. global_position -= areas_entered[area].position*2
				self.global_position.y = area.global_position.y
				conected = false
	if 1-flow_status == 0:
		play_animation(0)
	elif 1-flow_status < 0.25:
		play_animation(25)
	elif 1-flow_status < 0.50:
		play_animation(50)
	elif 1-flow_status < 0.75:
		play_animation(75)
	elif 1-flow_status > 0.75:
		play_animation(100)
		
func window_handler():
	var new_window = global_window.on_new_window()
	var attributes_window = config_window.instantiate() as Control
	attributes_window.parent = self
	$/root/main_scene/sub_windows.add_child(new_window)
	new_window.add_child(attributes_window)

func play_animation(close_percentage: int) -> void:
	if flow_status_1st/max_capacity >= 0 and flow_status_1st/max_capacity <= 0.20:
		$sprite_left.play('default_{int}%'.format({'int': close_percentage}))
	elif flow_status_1st/max_capacity > 0.20 and flow_status_1st/max_capacity <= 0.65:
		$sprite_left.play('small_flow_{int}%'.format({'int': close_percentage}))
	elif flow_status_1st/max_capacity > 0.65:
		$sprite_left.play('medium_flow_{int}%'.format({'int': close_percentage}))
	if flow_status_2nd/max_capacity >= 0 and flow_status_2nd/max_capacity <= 0.20:
		$sprite_right.play('default_{int}%'.format({'int': close_percentage}))
	elif flow_status_2nd/max_capacity > 0.20 and flow_status_2nd/max_capacity <= 0.65:
		$sprite_right.play('small_flow_{int}%'.format({'int': close_percentage}))
	elif flow_status_2nd/max_capacity > 0.65:
		$sprite_right.play('medium_flow_{int}%'.format({'int': close_percentage}))
