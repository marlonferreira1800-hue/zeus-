@tool
extends Node2D

const HERO := preload("res://assets/pixelbound/hero.png")
const FRAMES := [
	Rect2(47, 105, 270, 347), Rect2(414, 103, 308, 349),
	Rect2(805, 100, 282, 352), Rect2(1202, 105, 303, 347),
	Rect2(37, 595, 302, 339), Rect2(413, 562, 306, 361),
	Rect2(808, 591, 287, 340), Rect2(1168, 605, 302, 341)
]
var current_frame := 0
var current_facing := 1.0


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	var player := get_parent()
	var next_frame := 0
	if not player.is_on_floor():
		next_frame = 5 if player.velocity.y < 0.0 else 6
	elif absf(player.velocity.x) > 15.0:
		next_frame = 1 + int(player.animation_time * 11.0) % 4
	if next_frame != current_frame or player.facing != current_facing:
		current_frame = next_frame
		current_facing = player.facing
		queue_redraw()


func _draw() -> void:
	draw_set_transform(Vector2.ZERO, 0.0, Vector2(current_facing, 1.0))
	draw_texture_rect_region(HERO, Rect2(-18, -26, 36, 37), FRAMES[current_frame])
	draw_set_transform(Vector2.ZERO)
