extends main_class
func _ready() -> void:
	max_capacity = 20
	type = "tuberia"
	config_window = preload("res://scenes/configs_sub_window.tscn")

func _physics_process(delta: float) -> void:
	if local_selected:
		self.position = lerp(global_position, get_global_mouse_position(), 25 * delta)
		$sprite.play("default")
	if auto_fill:
		if flow_status < max_capacity:
			flow_status += snapped(getting_in*delta,0.01)
	else:
		if flow_status < max_capacity and areaa_dic['source']:
			flow_status += getting_in
		if areaa_dic:
			for area in areaa_dic:
				match area:
					'source':
						if areaa_dic[area]:
							if areaa_dic[area].flow_status > 0:
								getting_in = snapped(areaa_dic[area].flow_status*0.001, 0.01) 
								areaa_dic[area].flow_status -= getting_in
							sourcing = true
					_:
						pass
	if parents:
		for parent in parents:
			match parent.type:
				'source':
					if not sourcing:
						areaa_dic['source'] = parent
						if parents[parent].name == 'right':
							$sprite.flip_h = true
					else:
						pass
				'controlador':
					areaa_dic['controlador'] = parent
				'medidor':
					areaa_dic['medidor'] = parent
				'tuberia':
					if parent.sourcing == true and areaa_dic['source'] == null:
						areaa_dic['source'] = parent
						if parents[parent].name == 'right':
							$sprite.flip_h = true
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
	else:
		pass
	if flow_status/max_capacity >= 0 and flow_status/max_capacity <= 0.20 :
		$sprite.play('default')
	elif flow_status/max_capacity > 0.20 and flow_status/max_capacity <= 0.65:
		$sprite.play('start')
	elif flow_status/max_capacity > 0.65:
		$sprite.play('normal')

func window_handler():
	var new_window = global_window.on_new_window()
	var attributes_window = config_window.instantiate() as Control
	attributes_window.parent = self
	$/root/main_scene/sub_windows.add_child(new_window)
	new_window.add_child(attributes_window)
