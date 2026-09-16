extends Node2D
var new_window: PackedScene = preload('res://scenes/base_window.tscn')

func on_new_window() -> Node:
	var window = new_window.instantiate() as Window
	$/root/main_scene/sub_windows.add_child(window)
	return(window)
