@tool
extends Node2D

const VALLEY_TREE := preload("res://assets/pixelbound/tree.png")
const VALLEY_OBJECTS := preload("res://assets/pixelbound/objects.png")
const BACKGROUNDS := [
	preload("res://assets/pixelbound/valley.jpg"),
	preload("res://assets/backgrounds/crystal_caves.jpg"),
	preload("res://assets/backgrounds/gear_fortress.jpg"),
	preload("res://assets/backgrounds/emerald_canopy.jpg"),
	preload("res://assets/backgrounds/ember_chasm.jpg"),
	preload("res://assets/backgrounds/sky_citadel.jpg")
]

@export_enum("vale", "caverna", "fortaleza", "copa", "abismo", "cidadela") var theme := 0:
	set(value):
		theme = value
		queue_redraw()
@export_enum("céu e montanhas", "detalhes próximos") var art_layer := 0:
	set(value):
		art_layer = value
		queue_redraw()


func _draw() -> void:
	if art_layer == 0:
		draw_far()
	else:
		draw_near()


func draw_far() -> void:
	draw_texture_rect(BACKGROUNDS[theme], Rect2(0, -24, 691, 389), false)


func draw_near() -> void:
	if theme == 0:
		draw_texture_rect(VALLEY_TREE, Rect2(383, 2, 284, 281), false)
		draw_texture_rect(VALLEY_TREE, Rect2(1274, -7, 324, 293), false)
		for x in [45.0, 446.0, 1125.0]:
			draw_texture_rect_region(VALLEY_OBJECTS, Rect2(x, 252, 26, 27), Rect2(829, 120, 277, 287))
		for point in [Vector2(113, 221), Vector2(387, 279), Vector2(612, 279), Vector2(932, 212), Vector2(1215, 279)]:
			draw_texture_rect_region(VALLEY_OBJECTS, Rect2(point.x, point.y, 52, 27), Rect2(1159, 181, 355, 201))
		return
	elif theme == 1:
		for i in range(26):
			var x := i * 106.0 + 20.0
			draw_colored_polygon(PackedVector2Array([Vector2(x - 12, 280), Vector2(x, 232 - i % 3 * 12), Vector2(x + 15, 280)]), Color("53bdd4"))
			draw_line(Vector2(x, 237), Vector2(x + 4, 270), Color("a2f6f0"), 2)
	elif theme == 2:
		for i in range(24):
			var x := i * 116.0 + 40.0
			draw_rect(Rect2(x - 15, 185 - i % 3 * 15, 30, 96), Color("344456"))
			draw_rect(Rect2(x - 10, 196 - i % 3 * 15, 20, 6), Color("e6a96a"))
			draw_circle(Vector2(x + 15, 255), 12, Color("b87568"))
			draw_circle(Vector2(x + 15, 255), 5, Color("344456"))
