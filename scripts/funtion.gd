extends main_class
var signal_2nd: float
var math: String
var expression = Expression.new()
var result 

func _ready() -> void:
	add_to_group("save")
	main_dictionary['signal_1st'] = null
	main_dictionary['type'] = "funcion"
	main_dictionary['config_window'] = preload("res://scenes/function_configs_sub_window.tscn")
	math = '100 - x'

func _process(delta: float) -> void:
	if main_dictionary['local_selected']:
			self.position = lerp(global_position, get_global_mouse_position(), 25 * delta)
	var error = expression.parse(math,["x"])
	if error == OK:
		if main_dictionary['signal_1st']:
			signal_2nd = main_dictionary['signal_1st'].main_dictionary['flow_status']*100
			result = expression.execute([signal_2nd], self)
			
			if signal_2nd and not expression.has_execute_failed():
				main_dictionary['flow_status'] = float(result)/100
	else:
		print(expression.get_error_text())
	%sign_text.text = math

func window_handler():
	var new_window = global_window.on_new_window()
	var attributes_window = main_dictionary['config_window'].instantiate() as Control
	attributes_window.parent = self
	$/root/main_scene/sub_windows.add_child(new_window)
	new_window.add_child(attributes_window)
