extends main_class
var cable: PackedScene = preload("res://scenes/cable.tscn")
var position_a: Vector2
var position_b: Vector2

func _ready() -> void:
	type = "cable_transmision"
	areaa_dic["punto a"] = null
	areaa_dic["punto b"] = null
func _process(_delta: float) -> void:
	Global.selected = true
	self.position = get_global_mouse_position() 
	if Input.is_action_just_pressed("left_click") and parents:
		match parents[0].type:
			'controlador_esclavo':
				areaa_dic['punto b'] = parents[0].position
			'medidor':
				areaa_dic['punto a'] = parents[0].position
			'controlador_maestro':
				if not areaa_dic['punto a']:
					areaa_dic['punto a'] = parents[0].position
				elif not areaa_dic['punto b'] and not areaa_dic['punto a'] == parents[0].position:
					areaa_dic['punto b'] = parents[0].position
			"cable":
				areaa_dic['punto a'] = get_global_mouse_position()
	if Input.is_action_just_pressed("right_click"):
		queue_free()
	if areaa_dic['punto a'] and areaa_dic['punto b']:
		position_a = areaa_dic["punto a"]
		position_b = areaa_dic["punto b"]
		var cable_nuevo = cable.instantiate() as Node2D
		$/root/main_scene/objects/cables.add_child(cable_nuevo)
		cable_nuevo.get_child(1).shape.a = Vector2(position_a.x,position_a.y)
		cable_nuevo.get_child(1).shape.b = Vector2(position_a.x,position_b.y)
		cable_nuevo.get_child(2).shape.a = Vector2(position_a.x,position_b.y)
		cable_nuevo.get_child(2).shape.b = Vector2(position_b.x,position_b.y)
		cable_nuevo = cable_nuevo.get_child(0)
		cable_nuevo.set_point_position(0,Vector2(position_a.x,position_a.y))
		cable_nuevo.set_point_position(1,Vector2(position_a.x,position_b.y)) 
		cable_nuevo.set_point_position(2,Vector2(position_b.x,position_b.y))
		Global.selected = false
		queue_free()
