extends Control

@export var default_radius: float = 3.0
@export var default_color: Color = Color.WHITE
@export var default_focus_radius: float = 8.0
@export var default_focus_color: Color = Color.WHITE

var focused: bool = false:
	set(value):
		if focused != value:
			focused = value
			queue_redraw()


func display_dot_reticle(radius: float = default_radius, color: Color = default_color) -> void:
	draw_circle(Vector2.ZERO, radius, color)


func display_focus_reticle(radius: float = default_focus_radius, color: Color = default_focus_color) -> void:
	draw_arc(Vector2.ZERO, radius, 0, TAU, 20,  color)


func _draw() -> void:
	if focused:
		display_focus_reticle()
	else:
		display_dot_reticle()
