@tool
extends Node2D


func _draw() -> void:
	draw_rect(Rect2(-1300, -34, 2600, 68), Color("183b46"))
	draw_rect(Rect2(-1300, -34, 2600, 11), Color("5cad78"))
	draw_rect(Rect2(-1300, -34, 2600, 3), Color("bce2a3"))
	for i in range(87):
		var x := -1290.0 + float(i * 30)
		draw_line(Vector2(x, -34), Vector2(x + 3, -40 - i % 3 * 2), Color("9ad296"), 2.0)
		if i % 3 == 0:
			draw_circle(Vector2(x + 12, -10), 2, Color("3b6570"))
