extends Control
var containers: Array = []
var graph_points: Array = [null,null,null,null,null,null,null,null,null,null]
var graph_points_2: Array = [null,null,null,null,null,null,null,null,null,null]
var point_position: Vector2
var parent: Node
	
func _ready() -> void:
	%auto_fill_button.button_pressed = parent.auto_fill

func _process(_delta: float) -> void:
	if not self.get_parent():
		self.queue_free()
	%inflow_edit.placeholder_text = str(snapped(parent.flow_status,0.01))

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
		parent.dir = true
	else:
		%auto_fill_button.text = "Rev"
		parent.dir = false

func _on_inflow_edit_text_submitted(new_text: String) -> void:
	parent.flow_status = float(new_text)
