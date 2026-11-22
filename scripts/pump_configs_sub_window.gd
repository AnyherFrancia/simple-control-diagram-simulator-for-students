extends Control
var containers: Array = []
var graph_points: Array = [null,null,null,null,null,null,null,null,null,null]
var point_position: Vector2
var parent: Node

func _on_timer_timeout() -> void:
	if graph_points.size() <= 10 and parent:
		graph_points.append(snapped(parent.main_dictionary['rpm']/parent.main_dictionary['max_rpm'],0.01))
	else:
		if parent:
			graph_constructor(0)
			graph_points[9] = snapped(parent.main_dictionary['rpm']/parent.main_dictionary['max_rpm'],0.01)
	for point in range(10):
			if graph_points[point]!= null:
				point_position = %graph_line.get_point_position(point)
				point_position.y = 169.0-(graph_points[point]*169.0)
				%graph_line.set_point_position(point,point_position)

func _process(_delta: float) -> void:
	if not self.get_parent():
		self.queue_free()
	if %watch_attributes.visible and parent:
		%max_capacity_text.text = 'Capacidad Máxima: '+str(parent.main_dictionary['max_rpm'])
		%flow_text.text = 'Rpm: '+str(snapped(parent.main_dictionary['rpm'],0.01))+"Rpm"
		if parent.main_dictionary['sign_cable']:
			if parent.main_dictionary['sign_cable'].main_dictionary['flow_status']:
				%inflow_text.text = 'Rpm Entrante: '+str(snapped(parent.main_dictionary['sign_cable'].main_dictionary['flow_status'],0.01))+'Rpm'
	elif %edit_attributes.visible and parent:
		%max_capacity_edit.placeholder_text = str(parent.main_dictionary['max_rpm'])
		%flow_edit.placeholder_text = str(snapped(parent.main_dictionary['rpm'],0.01))

func graph_constructor(point: int) -> void:
	if point == 9:
		return
	else:
		graph_points[point] = graph_points[point+1]
		graph_constructor(point+1)

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

func _on_max_capacity_edit_text_submitted(new_text: String) -> void:
	parent.main_dictionary['max_rpm'] = float(new_text)

func _on_flow_edit_text_submitted(new_text: String) -> void:
	parent.main_dictionary['rpm'] = float(new_text)

func _on_manual_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		%manual_button.text = "Si"
		parent.main_dictionary['manual'] = true
		parent.main_dictionary['sourcing'] = true
	else:
		%manual_button.text = "No"
		parent.main_dictionary['manual'] = false
		parent.main_dictionary['sourcing'] = false
