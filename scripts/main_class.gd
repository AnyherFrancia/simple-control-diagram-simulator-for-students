extends Area2D
class_name main_class
var getting_in: float
var max_capacity: float
var flow_status: float
var local_selected: bool = false
var sourcing: bool = false
var conected: bool = false
var auto_fill: bool = false
var areas_entered: Dictionary = {}
var parents: Dictionary = {}
var areaa_dic: Dictionary[String,Variant] = {
	'source': null, 
	'tuberia': null, 
	'cable': null,
	'controlador_maestro': null,
	"controlador_esclavo": null,
	'medidor': null,
	"cable_transmision": null
}
var type: String
var config_window: PackedScene

func _on_area_shape_entered(_area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if area:
		var owner_id = area.shape_find_owner(area_shape_index)
		var shape_node = area.shape_owner_get_owner(owner_id)
		var local_owner_id = shape_find_owner(local_shape_index)
		var local_shape = shape_owner_get_owner(local_owner_id)
		var parent = shape_node.get_parent()
		parents[parent] = local_shape
		areas_entered[shape_node] = local_shape
	else:
		pass

func _on_area_shape_exited(_area_rid: RID, area: Area2D, area_shape_index: int, _local_shape_index: int) -> void:
	if area:
		var owner_id = area.shape_find_owner(area_shape_index)
		var shape_node = area.shape_owner_get_owner(owner_id)
		areas_entered.erase(shape_node)
		parents.erase(shape_node.get_parent())
	else:
		pass

func _on_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	if Input.is_action_just_pressed("left_click") and not Global.selected:
		local_selected = true
		Global.selected = true
		conected = true
	elif Input.is_action_just_pressed("right_click"):
		window_handler()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if Input.is_action_just_released("left_click"):
			local_selected = false
			Global.selected = false

func window_handler():
	pass
