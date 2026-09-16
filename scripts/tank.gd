extends main_class

func _ready() -> void:
	sourcing = true
	max_capacity = 80
	type = "source"
	getting_in = 5
	auto_fill = true

func _physics_process(delta: float) -> void:
	if flow_status < max_capacity and not areaa_dic["source"]:
		flow_status += snapped(getting_in*delta, 0.01) 
	if local_selected:
		self.position = lerp(global_position, get_global_mouse_position(), 25 * delta)
	if not auto_fill:
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
				'medidor':
					areaa_dic['medidor'] = parent
				'tuberia':
					if parent.sourcing == true and sourcing == false:
						areaa_dic['source'] = parent
					else:
						pass
				_:
					pass
	if flow_status/max_capacity <= 0:
		$Tanque.play('default')
	elif flow_status/max_capacity > 0 and flow_status/max_capacity <= 0.25:
		$Tanque.play('below_25')
	elif flow_status/max_capacity > 0.25 and flow_status/max_capacity <= 0.50 :
		$Tanque.play('below_50')
	elif flow_status/max_capacity > 0.50 and flow_status/max_capacity <= 0.75:
		$Tanque.play('below_75')
	elif flow_status/max_capacity > 0.75:
		$Tanque.play('below_100')
	elif flow_status/max_capacity == 100:
		$Tanque.play("100")
