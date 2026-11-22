extends Control
var containers: Array = []
var graph_points: Array = [null,null,null,null,null,null,null,null,null,null]
var graph_points_2: Array = [null,null,null,null,null,null,null,null,null,null]
var point_position: Vector2
var parent: Node
	
func _ready() -> void:
	%auto_fill_button.button_pressed = parent.main_dictionary['dir']

func _on_timer_timeout() -> void:
	if graph_points.size() <= 10 and parent:
		graph_points.append(snapped(parent.main_dictionary['flow_status'],0.01))
	else:
		if parent:
			graph_constructor(0, graph_points)
			graph_points[9] = snapped(parent.main_dictionary['flow_status'],0.01)
	if graph_points_2.size() <= 10 and parent:
		graph_points_2.append(snapped(parent.main_dictionary['window_signal'],0.01))
	else:
		if parent:
			graph_constructor(0, graph_points_2)
			graph_points_2[9] = snapped(parent.main_dictionary['window_signal'],0.01)
	for point in range(10):
			if graph_points[point]!= null:
				point_position = %signal_out.get_point_position(point)
				point_position.y = 172.0-(graph_points[point]*172.0)
				%signal_out.set_point_position(point,point_position)
			if graph_points_2[point]!= null:
				point_position = %signal_in.get_point_position(point)
				point_position.y = 172.0-(graph_points_2[point]*172.0)
				%signal_in.set_point_position(point,point_position)

func _process(_delta: float) -> void:
	if not self.get_parent():
		self.queue_free()
	if %watch_attributes.visible and parent:
		%set_point_text.text = "        "+str(parent.main_dictionary['set_point'])+"L seg"
		%signal_text.text = str(snapped(parent.main_dictionary['window_signal'],0.01))+'% - '+str(snapped(parent.main_dictionary['flow_status'],0.01))+"%"
		if parent.main_dictionary['dir']:
			%mode_text.text = "DIR"
		else:
			%mode_text.text = "REV"
	elif %edit_attributes.visible and parent:
		%set_point_edit.placeholder_text = str(parent.main_dictionary['set_point'])
		%outflow_edit.placeholder_text = str(snapped(parent.main_dictionary['window_signal'],0.01))
		%inflow_edit.placeholder_text = str(snapped(parent.main_dictionary['flow_status'],0.01))

func graph_constructor(point: int, graph: Array) -> void:
	if point == 9:
		return
	else:
		graph[point] = graph[point+1]
		graph_constructor(point+1, graph)

func _on_watch_attributes_pressed() -> void:
	if %edit_attributes.visible:
		%edit_attributes.visible = false
	%watch_attributes.visible = true

func _on_edit_attributes_pressed() -> void:
	if %watch_attributes.visible:
		%watch_attributes.visible = false
	%edit_attributes.visible = true

func _on_rotate_90_right_pressed() -> void:
	parent.rotation += 90.0

func _on_rotate_90_left_pressed() -> void:
	parent.rotation -= 90.0

func _on_delete_object_pressed() -> void:
	parent.queue_free()
	self.get_parent().queue_free()

func _on_auto_fill_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		%auto_fill_button.text = "Dir"
		parent.main_dictionary['dir'] = true
	else:
		%auto_fill_button.text = "Rev"
		parent.main_dictionary['dir'] = false

func _on_manual_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		%auto_fill_button.text = "On"
		parent.main_dictionary['manual'] = true
	else:
		%auto_fill_button.text = "Off"
		parent.main_dictionary['manual'] = false

func _on_inflow_edit_text_submitted(new_text: String) -> void:
	parent.main_dictionary['signal_2nd'].main_dictionary['flow_status'] = float(new_text)

func _on_outflow_edit_text_submitted(new_text: String) -> void:
	parent.main_dictionary['flow_status'] = float(new_text)

func _on_set_point_edit_text_submitted(new_text: String) -> void:
	parent.main_dictionary['set_point'] = float(new_text)
