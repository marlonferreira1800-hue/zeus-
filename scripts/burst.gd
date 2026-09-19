extends Node2D

var color := Color.WHITE
var amount := 8
var age := 0.0


func _process(delta: float) -> void:
	age += delta
	queue_redraw()
	if age > 0.45:
		queue_free()


func _draw() -> void:
	for i in range(amount):
		var angle := TAU * float(i) / float(amount)
		var radius := age * 75.0
		var pos := Vector2(cos(angle), sin(angle)) * radius + Vector2(0, age * age * 50.0)
		draw_rect(Rect2(pos, Vector2(3, 3)), Color(color, 1.0 - age / 0.45))
