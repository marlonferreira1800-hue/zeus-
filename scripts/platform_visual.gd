@tool
extends Node2D

@export var width: float = 180.0:
	set(value):
		width = value
		queue_redraw()


func _draw() -> void:
	var left := -width / 2.0
	draw_rect(Rect2(left, -12, width, 24), Color("172936"))
	draw_rect(Rect2(left + 4, -8, width - 8, 17), Color("586477"))
	draw_rect(Rect2(left, -14, width, 8), Color("65b887"))
	draw_rect(Rect2(left + 4, -14, width - 8, 3), Color("b1dfa0"))
	for i in range(int(width / 30.0)):
		var x := left + 17.0 + float(i * 30)
		draw_line(Vector2(x, 0), Vector2(x + 8, 6), Color("344a5d"), 2.0)
		draw_line(Vector2(x + 10, -14), Vector2(x + 12, -18), Color("b1dfa0"), 2.0)
