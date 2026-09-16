extends Control
var cable: PackedScene = preload("res://scenes/transmision_cable.tscn")
var tuberia: PackedScene = preload("res://scenes/pipe.tscn")
var tanque: PackedScene = preload("res://scenes/tank.tscn")
#var atc : PackedScene = preload("res://tuberia_ato.tscn")
var controlador_de_flujo: PackedScene = preload("res://scenes/master_controller.tscn")
var medidor: PackedScene = preload("res://scenes/meter.tscn")
var controlador_esclavo: PackedScene = preload("res://scenes/slave_controller.tscn")
var position_a: Vector2 = Vector2.ZERO
var position_b: Vector2 = Vector2.ZERO
var local_selected: bool = false
var containers: Array = []
var time_passed : int 
func _ready() -> void:
	containers = %center_container.get_children()

func _on_meter_button_pressed() -> void:
	for area in containers:
		if area.visible:
			area.visible = false
	if %vertical_controllers.visible:
		$%vertical_controllers.visible = false
	elif not %vertical_controllers.visible:
		%vertical_controllers.visible = true

func _on_cable_button_pressed() -> void:
	var cable_nuevo = cable.instantiate() as Node2D
	$/root/main_scene/objects/cables.add_child(cable_nuevo)

func _on_valve_button_button_up() -> void:
	for area in containers:
		if area.visible:
			area.visible = false
	if %vertical_valves.visible:
		%vertical_valves.visible = false
	elif not %vertical_valves.visible:
		%vertical_valves.visible = true

func _on_tank_button_pressed() -> void:
	for area in containers:
		if area.visible:
			area.visible = false
	if %vertical_tanks.visible:
		%vertical_tanks.visible = false
	elif not %vertical_tanks.visible:
		%vertical_tanks.visible = true

func _on_pipe_button_pressed() -> void:
	for area in containers:
		if area.visible:
			area.visible = false
	if %vertical_pipes.visible:
		%vertical_pipes.visible = false
	elif not %vertical_pipes.visible:
		%vertical_pipes.visible = true

func _on_vertical_pipe_button_pressed() -> void:
	position_a = $/root/main_scene/camera.position + Vector2(30,20)
	var tuberia_nueva = tuberia.instantiate() as Area2D
	$/root/main_scene/objects/pipes.add_child(tuberia_nueva)
	tuberia_nueva.position = position_a

func _on_vertical_tanks_button_pressed() -> void:
	position_a = $/root/main_scene/camera.position + Vector2(30,20)
	var tanque_nuevo = tanque.instantiate() as Area2D
	$/root/main_scene/objects/sources.add_child(tanque_nuevo)
	tanque_nuevo.position = position_a

func _on_vertical_valve_button_pressed() -> void:
	#position_a = $/root/main_scene/camera.position + Vector2(30,20)
	#var tuberia_nueva = atc.instantiate() as Area2D
	#$/root/main_scene/objects/pipes.add_child(tuberia_nueva)
	#tuberia_nueva.position = position_a
	pass

func _on_vertical_meter_button_pressed() -> void:
	position_a = $/root/main_scene/camera.position + Vector2(30,20)
	var medidor_nuevo = medidor.instantiate() as Area2D
	$/root/main_scene/objects/controllers.add_child(medidor_nuevo)
	medidor_nuevo.position = position_a

func _on_slave_controller_button_pressed() -> void:
	position_a = $/root/main_scene/camera.position + Vector2(30,20)
	var controlador_esclavo_nuevo = controlador_esclavo.instantiate() as Area2D
	$/root/main_scene/objects/controllers.add_child(controlador_esclavo_nuevo)
	controlador_esclavo_nuevo.position = position_a

func _on_master_controller_button_pressed() -> void:
	position_a = $/root/main_scene/camera.position + Vector2(30,20)
	var controlador_nuevo = controlador_de_flujo.instantiate() as Area2D
	$/root/main_scene/objects/controllers.add_child(controlador_nuevo)
	controlador_nuevo.position = position_a


func _on_timer_timeout() -> void:
	time_passed += 1
	%timer.text = "%02d:%02d" % [time_passed/60,time_passed%60]
	
	
	
