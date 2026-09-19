@tool
extends Node2D

const WORLD_WIDTH := 2600.0
const WORLD_HEIGHT := 648.0


func _draw() -> void:
	var sky_top := Color("172848")
	var sky_bottom := Color("597fa1")
	for i in range(36):
		var y := i * WORLD_HEIGHT / 36.0
		var color := sky_top.lerp(sky_bottom, float(i) / 35.0)
		draw_rect(Rect2(0, y, WORLD_WIDTH, WORLD_HEIGHT / 36.0 + 1.0), color)

	draw_circle(Vector2(2160, 130), 70, Color("fff0bb"))
	draw_circle(Vector2(2160, 130), 94, Color(1.0, 0.88, 0.62, 0.08))
	for i in range(34):
		var star_x := fmod(float(i * 311 + 71), WORLD_WIDTH)
		var star_y := fmod(float(i * 137 + 44), 340.0)
		draw_circle(Vector2(star_x, star_y), 1.5 + float(i % 3), Color(1, 1, 1, 0.45))

	for i in range(11):
		var x := float(i * 270 - 120)
		draw_colored_polygon(PackedVector2Array([
			Vector2(x - 220, 580), Vector2(x + 65, 250 + i % 3 * 40),
			Vector2(x + 350, 580)
		]), Color("344968"))
	for i in range(12):
		var x := float(i * 245 - 70)
		draw_colored_polygon(PackedVector2Array([
			Vector2(x - 190, 580), Vector2(x + 55, 360 + i % 3 * 24),
			Vector2(x + 300, 580)
		]), Color("273f5b"))

	for i in range(28):
		var x := float(i * 97 + 28)
		var tree_height := float(72 + i % 4 * 15)
		draw_rect(Rect2(x - 4, 550 - tree_height / 2.0, 8, tree_height), Color("203b4b"))
		draw_colored_polygon(PackedVector2Array([
			Vector2(x - 36, 555), Vector2(x, 555 - tree_height),
			Vector2(x + 36, 555)
		]), Color("1e3c4b"))
		draw_colored_polygon(PackedVector2Array([
			Vector2(x - 26, 530), Vector2(x, 530 - tree_height),
			Vector2(x + 26, 530)
		]), Color("2b5260"))
