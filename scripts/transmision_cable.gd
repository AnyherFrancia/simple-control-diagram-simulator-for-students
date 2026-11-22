extends main_class
var cable: PackedScene = preload("res://scenes/cable.tscn")
var position_a: Vector2
var position_b: Vector2

func _ready() -> void:
	main_dictionary['type'] = "cable_transmision"
	main_dictionary['areaa_dic']["punto a"] = null
	main_dictionary['areaa_dic']["punto b"] = null
func _physics_process(_delta: float) -> void:
	Global.selected = true
	self.position = get_global_mouse_position() 
	if Input.is_action_just_pressed("left_click") and main_dictionary['parents']:
		for parent in main_dictionary['parents']:
			match parent.main_dictionary['type']:
				'controlador_esclavo':
					main_dictionary['areaa_dic']['controlador_esclavo'] = parent
					main_dictionary['areaa_dic']['punto b'] = parent.position
				'medidor':
					main_dictionary['areaa_dic']['medidor'] = parent
					main_dictionary['areaa_dic']['punto a'] = parent.position
				'controlador_maestro':
					main_dictionary['areaa_dic']['controlador_maestro'] = parent
					if not main_dictionary['areaa_dic']['punto a']:
						main_dictionary['areaa_dic']['punto a'] = parent.position
					elif not main_dictionary['areaa_dic']['punto b'] and not main_dictionary['areaa_dic']['punto a'] == parent.position:
						main_dictionary['areaa_dic']['punto b'] = parent.position
				"cable":
					if not main_dictionary['areaa_dic']['medidor']:
						main_dictionary['areaa_dic']['medidor'] = parent
					main_dictionary['areaa_dic']['punto a'] = get_global_mouse_position()
				"funcion":
					if not main_dictionary['areaa_dic']['funcion']:
						main_dictionary['areaa_dic']['funcion'] = parent
					if not main_dictionary['areaa_dic']['punto b']:
						main_dictionary['areaa_dic']['punto b'] = parent.position
					elif not main_dictionary['areaa_dic']['punto a']:
						main_dictionary['areaa_dic']['punto a'] = parent.position
				"bomba":
					if not main_dictionary['areaa_dic']['bomba']:
						main_dictionary['areaa_dic']['bomba'] = parent
					if not main_dictionary['areaa_dic']['punto b']:
						main_dictionary['areaa_dic']['punto b'] = parent.position
					elif not main_dictionary['areaa_dic']['punto a']:
						main_dictionary['areaa_dic']['punto a'] = parent.position
				'convertidor':
					if not main_dictionary['areaa_dic']['convertidor']:
						main_dictionary['areaa_dic']['convertidor'] = parent
					if not main_dictionary['areaa_dic']['punto b']:
						main_dictionary['areaa_dic']['punto b'] = parent.position
					elif not main_dictionary['areaa_dic']['punto a']:
						main_dictionary['areaa_dic']['punto a'] = parent.position
				"selector":
					if not main_dictionary['areaa_dic']['selector']:
						main_dictionary['areaa_dic']['selector'] = parent
					if not main_dictionary['areaa_dic']['punto b']:
						main_dictionary['areaa_dic']['punto b'] = parent.position
					elif not main_dictionary['areaa_dic']['punto a']:
						main_dictionary['areaa_dic']['punto a'] = parent.position
	if Input.is_action_just_pressed("right_click"):
		queue_free()
	if main_dictionary['areaa_dic']['punto a'] and main_dictionary['areaa_dic']['punto b']:
		position_a = main_dictionary['areaa_dic']["punto a"]
		position_b = main_dictionary['areaa_dic']["punto b"]
		var cable_nuevo = cable.instantiate() as Node2D
		cable_nuevo.main_dictionary['areaa_dic']['medidor'] = main_dictionary['areaa_dic']['medidor']
		cable_nuevo.main_dictionary['areaa_dic']['controlador_maestro'] = main_dictionary['areaa_dic']['controlador_maestro']
		cable_nuevo.main_dictionary['areaa_dic']['controlador_esclavo'] = main_dictionary['areaa_dic']['controlador_esclavo']
		cable_nuevo.main_dictionary['areaa_dic']['funcion'] = main_dictionary['areaa_dic']['funcion']
		cable_nuevo.main_dictionary['areaa_dic']['convertidor'] = main_dictionary['areaa_dic']['convertidor']
		cable_nuevo.main_dictionary['areaa_dic']['selector'] = main_dictionary['areaa_dic']['selector']
		cable_nuevo.main_dictionary['areaa_dic']['bomba'] = main_dictionary['areaa_dic']['bomba']
		cable_nuevo.main_dictionary['areaa_dic']['punto a'] = position_a
		cable_nuevo.main_dictionary['areaa_dic']['punto b'] = position_b
		$/root/main_scene/objects/cables.add_child(cable_nuevo)
		cable_nuevo = cable_nuevo.get_child(0)
		cable_nuevo.set_point_position(0,Vector2(position_a.x,position_a.y))
		cable_nuevo.set_point_position(1,Vector2(position_a.x,position_b.y)) 
		cable_nuevo.set_point_position(2,Vector2(position_b.x,position_b.y))
		Global.selected = false
		queue_free()
