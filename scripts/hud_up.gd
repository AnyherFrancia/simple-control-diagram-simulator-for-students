extends Control
var count: int
func _process(_delta: float) -> void:
	%position_text.text = "x."+str(get_global_mouse_position().x)+", y."+str(get_global_mouse_position().y)
	%zoom_text.text = "Zoom: ("+str(snapped(Global.zoom.x,0.1))+","+str(snapped(Global.zoom.y,0.1))+")"
