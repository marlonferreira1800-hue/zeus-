@tool
extends StaticBody2D

const VALLEY_OBJECTS := preload("res://assets/pixelbound/objects.png")

@export_enum("vale", "caverna", "fortaleza", "copa", "abismo", "cidadela") var theme := 0:
	set(value):
		theme = value
		queue_redraw()
@export var size := Vector2(160, 44):
	set(value):
		size = value
		update_shape()
		queue_redraw()


func _ready() -> void:
	update_shape()


func update_shape() -> void:
	if has_node("CollisionShape2D"):
		var shape := RectangleShape2D.new()
		shape.size = size
		$CollisionShape2D.shape = shape


func _draw() -> void:
	var left := -size.x / 2.0
	var top := -size.y / 2.0
	if theme == 0:
		_draw_valley(left, top)
		return
	var base: Color = [Color("72513c"), Color("33415c"), Color("46505b"), Color("315d47"), Color("5a3344"), Color("59739a")][theme]
	var trim: Color = [Color("5fcf75"), Color("5bd9df"), Color("e8af5e"), Color("75d988"), Color("f38753"), Color("d0b9ef")][theme]
	var light: Color = [Color("a3e47d"), Color("a5f4ed"), Color("ffd48a"), Color("b7f6a8"), Color("ffd286"), Color("f4e7ff")][theme]
	draw_rect(Rect2(left, top, size.x, size.y), Color("182c37"))
	draw_rect(Rect2(left + 2, top + 5, size.x - 4, size.y - 7), base)
	draw_rect(Rect2(left, top, size.x, 6), trim)
	draw_rect(Rect2(left, top, size.x, 2), light)
	for i in range(int(size.x / 12.0)):
		var x := left + 5.0 + i * 12.0
		draw_rect(Rect2(x, top + 10 + i % 3 * 8, 4, 3), trim.darkened(0.35))
		if theme == 2:
			draw_circle(Vector2(x + 3, top + 16), 1.5, light)


func _draw_valley(left: float, top: float) -> void:
	var width := size.x
	var height := size.y
	if height < 35.0:
		draw_texture_rect_region(VALLEY_OBJECTS, Rect2(left, top - 4, width, height + 8), Rect2(12, 194, 434, 195))
		return
	var y := top + 9.0
	while y < top + height:
		var x := left
		var draw_height := minf(49.0, top + height - y)
		while x < left + width:
			var draw_width := minf(54.0, left + width - x)
			draw_texture_rect_region(VALLEY_OBJECTS, Rect2(x, y, draw_width, draw_height), Rect2(491, 122, 262.0 * draw_width / 54.0, 283.0 * draw_height / 49.0))
			x += 54.0
		y += 49.0
	var grass_x := left
	while grass_x < left + width:
		var grass_width := minf(77.0, left + width - grass_x)
		draw_texture_rect_region(VALLEY_OBJECTS, Rect2(grass_x, top - 4, grass_width, 34), Rect2(12, 194, 434.0 * grass_width / 77.0, 195))
		grass_x += 77.0
