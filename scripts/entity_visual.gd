@tool
extends Node2D

const OBJECTS := preload("res://assets/pixelbound/objects.png")


func _draw() -> void:
	var entity := get_parent()
	var kind: int = entity.kind
	if kind == 0 or kind == 5:
		draw_texture_rect_region(OBJECTS, Rect2(-8, -12, 16, 24), Rect2(814, 517, 271, 413))
		return
	if kind == 1:
		var source := Rect2(418, 622, 326, 266) if entity.get_meta("red_variant", false) else Rect2(27, 622, 327, 266)
		draw_texture_rect_region(OBJECTS, Rect2(-13, -11, 26, 22), source)
		return
	if kind == 3:
		draw_texture_rect_region(OBJECTS, Rect2(-33, -60, 66, 78), Rect2(1151, 515, 346, 406))
		return
	match kind:
		0, 5:
			var color := Color("ffe074") if kind == 0 else Color("83f4eb")
			draw_rect(Rect2(-5, -7, 10, 14), Color("273547"))
			draw_rect(Rect2(-3, -6, 6, 12), color)
			draw_rect(Rect2(-1, -4, 2, 7), Color("fff4b1") if kind == 0 else Color("e1ffff"))
		1:
			draw_rect(Rect2(-11, -8, 22, 16), Color("1c2935"))
			draw_rect(Rect2(-9, -7, 18, 12), Color("b86870"))
			draw_rect(Rect2(-7, 5, 5, 5), Color("393b52"))
			draw_rect(Rect2(2, 5, 5, 5), Color("393b52"))
			draw_rect(Rect2(-6, -3, 3, 3), Color.WHITE)
			draw_rect(Rect2(3, -3, 3, 3), Color.WHITE)
			draw_rect(Rect2(-5, -2, 1, 2), Color("162b39"))
			draw_rect(Rect2(4, -2, 1, 2), Color("162b39"))
		2, 3:
			draw_rect(Rect2(-2, -22, 4, 44), Color("dde0bd"))
			var color := Color("68dc9c") if kind == 2 else Color("ffc973")
			draw_colored_polygon(PackedVector2Array([Vector2(2, -20), Vector2(22, -15), Vector2(2, -8)]), color)
		4:
			for i in range(3):
				var x := -15 + i * 10
				draw_colored_polygon(PackedVector2Array([Vector2(x, 8), Vector2(x + 5, -8), Vector2(x + 10, 8)]), Color("f4a36e"))
