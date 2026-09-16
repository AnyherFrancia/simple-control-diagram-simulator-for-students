extends Camera2D
var _target_zoom: float = 1.0
const min_zoom: float = 1.0
const max_zoom: float = 1.0
const zoom_increment: float = 0.1
const zoom_rate: float = 8.0
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and not Global.selected:
		if Input.is_action_pressed("left_click"):
			position -= event.relative * (Vector2(1.0,1.0)/zoom)
	if event is InputEventMouseButton and not Global.selected:
		if event.is_pressed():
			if Input.is_action_just_pressed("mouse_wheel_down"):
				zoom_in()
			if Input.is_action_just_pressed("mouse_wheel_up"):
				zoom_out()

func  zoom_in() -> void:
	_target_zoom = max(_target_zoom - zoom_increment, min_zoom)
	set_physics_process(true)
func zoom_out() -> void:
	_target_zoom = max(_target_zoom + zoom_increment, max_zoom)
	set_physics_process(true)

func _physics_process(delta: float) -> void:
	if not Global.selected:
		zoom = lerp(
			zoom,
			_target_zoom * Vector2.ONE,
			zoom_rate * delta
		)
		set_physics_process(
			not is_equal_approx(zoom.x,_target_zoom)
		)
	Global.zoom = self.zoom
