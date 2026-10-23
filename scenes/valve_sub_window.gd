extends Control
var containers: Array = []
var graph_points_flow: Array = [null,null,null,null,null,null,null,null,null,null]
var graph_points_door: Array = [null,null,null,null,null,null,null,null,null,null]
var point_position: Vector2
var parent: Node
	
func _ready() -> void:
	%auto_fill_button.button_pressed = parent.auto_fill

func _on_timer_timeout() -> void:
	if graph_points_flow.size() <= 10 and parent:
		graph_points_flow.append(snapped(parent.flow_status_1st/parent.max_capacity,0.01))
	else:
		if parent:
			graph_constructor(0,graph_points_flow)
			graph_points_flow[9] = snapped(parent.flow_status_1st/parent.max_capacity,0.01)
	for point in range(10):
			if graph_points_flow[point]!= null:
				point_position = %graph_line_flow.get_point_position(point)
				point_position.y = 172.0-(graph_points_flow[point]*172.0)
				%graph_line_door.set_point_position(point,point_position)
	if graph_points_door.size() <= 10 and parent:
		graph_points_door.append(snapped(parent.flow_status,0.01))
	else:
		if parent:
			graph_constructor(0,graph_points_door)
			graph_points_door[9] = snapped(parent.flow_status,0.01)
	for point in range(10):
			if graph_points_door[point]!= null:
				point_position = %graph_line_door.get_point_position(point)
				point_position.y = 172.0-(graph_points_door[point]*172.0)
				%graph_line_door.set_point_position(point,point_position)

func _process(_delta: float) -> void:
	if not self.get_parent():
		self.queue_free()
	if %watch_attributes.visible and parent:
		%max_capacity_text.text = str(parent.max_capacity)
		%flow_text.text = str(snapped(parent.flow_status_1st,0.01))+'/'+str(snapped(parent.max_capacity,0.01))
		%inflow_text.text = str(snapped(parent.getting_in,0.01))+'L seg'
	elif %edit_attributes.visible and parent:
		%max_capacity_edit.placeholder_text = str(parent.max_capacity)
		%flow_edit.placeholder_text = str(snapped(parent.flow_status_1st,0.01))
		%inflow_edit.placeholder_text = str(snapped(parent.getting_in,0.01))

func graph_constructor(point: int, graph: Array) -> void:
	if point == 9:
		return
	else:
		graph[point] = graph[point+1]
		graph_constructor(point+1,graph)

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
		%auto_fill_button.text = "Si"
		parent.auto_fill = true
		parent.sourcing = true
	else:
		%auto_fill_button.text = "No"
		parent.auto_fill = false

func _on_max_capacity_edit_text_submitted(new_text: String) -> void:
	parent.max_capacity = float(new_text)

func _on_flow_edit_text_submitted(new_text: String) -> void:
	parent.flow_status = float(new_text)

func _on_inflow_edit_text_submitted(new_text: String) -> void:
	parent.getting_in = float(new_text)


func _on_manual_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		%manual_button.text = "Si"
		parent.manual = true
		parent.sourcing = true
	else:
		%manual_button.text = "No"
		parent.manual = false
		parent.sourcing = false

func _on_fail_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		%fail_button.text = "Si"
		parent.fail_state = true
	else:
		%fail_button.text = "No"
		parent.fail_state = false
		match parent.ato:
			true:
				parent.flow_status = 1
			false:
				parent.flow_status = 0
