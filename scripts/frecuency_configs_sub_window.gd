extends Control
var containers: Array = []
var graph_points: Array = [null,null,null,null,null,null,null,null,null,null]
var point_position: Vector2
var parent: Node

func _process(_delta: float) -> void:
	if not self.get_parent():
		self.queue_free()
	if %watch_attributes.visible and parent:
		%in_text.text = '        '+str(snapped(parent.main_dictionary['signal_1st'].main_dictionary['flow_status'],0.01)*100)+"%"
		%out_text.text = ''+str(snapped(parent.main_dictionary['flow_status'],0.01))+"%"
	elif %edit_attributes.visible and parent:
		%sign_edit.placeholder_text = str(parent.main_dictionary['max_capacity'])

func _on_sign_edit_text_submitted(new_text: String) -> void:
	parent.main_dictionary['max_capacity'] = float(new_text)

func _on_watch_attributes_pressed() -> void:
	if %edit_attributes.visible:
		%edit_attributes.visible = false
	%watch_attributes.visible = true

func _on_edit_attributes_pressed() -> void:
	if %watch_attributes.visible:
		%watch_attributes.visible = false
	%edit_attributes.visible = true

func _on_timer_timeout() -> void:
	if graph_points.size() <= 10 and parent.main_dictionary['signal_1st']:
		graph_points.append(snapped(parent.main_dictionary['flow_status'],0.01))
	else:
		if parent.main_dictionary['signal_1st']:
			graph_constructor(0, graph_points)
			graph_points[9] = snapped(parent.main_dictionary['flow_status'],0.01)
	for point in range(10):
			if graph_points[point]!= null:
				point_position = %signal_out.get_point_position(point)
				point_position.y = 172.0-(graph_points[point]*172.0)
				%signal_out.set_point_position(point,point_position)

func graph_constructor(point: int, graph: Array) -> void:
	if point == 9:
		return
	else:
		graph[point] = graph[point+1]
		graph_constructor(point+1, graph)

func _on_rotate_90_right_pressed() -> void:
	parent.rotation += 90.0

func _on_rotate_90_left_pressed() -> void:
	parent.rotation -= 90.0

func _on_delete_object_pressed() -> void:
	parent.queue_free()
	self.get_parent().queue_free()
