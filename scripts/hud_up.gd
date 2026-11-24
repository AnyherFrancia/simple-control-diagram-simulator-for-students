extends Control
var count: int
func _process(_delta: float) -> void:
	%position_text.text = "x."+str(get_global_mouse_position().x)+", y."+str(get_global_mouse_position().y)
	%zoom_text.text = "Zoom: ("+str(snapped(Global.zoom.x,0.1))+","+str(snapped(Global.zoom.y,0.1))+")"


func _on_save_button_pressed() -> void:
	%save_dialog.visible = true
	%save_dialog.popup_centered()


func _on_load_button_pressed() -> void:
	%load_dialog.visible = true
	%load_dialog.popup_centered()


func _on_save_dialog_file_selected(path: String) -> void:
	SaveManager.save_file(path+'.json')


func _on_load_dialog_file_selected(path: String) -> void:
	var file := FileAccess.open(path,FileAccess.READ)
	if file:
		var content: String = file.get_as_text()
		var data =  JSON.parse_string(content)
		if data is Dictionary:
			SaveManager.load_state(data)
