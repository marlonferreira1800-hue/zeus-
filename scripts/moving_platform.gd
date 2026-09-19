@tool
extends AnimatableBody2D

@export var travel := Vector2(80, 0)
@export var speed := 1.4
var start_position := Vector2.ZERO
var elapsed := 0.0


func _ready() -> void:
	start_position = position


func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	elapsed += delta
	position = start_position + travel * (0.5 + 0.5 * sin(elapsed * speed))


func _draw() -> void:
	draw_rect(Rect2(-28, -6, 56, 12), Color("192f3e"))
	draw_rect(Rect2(-26, -5, 52, 8), Color("54bbbd"))
	for i in range(5):
		draw_rect(Rect2(-21 + i * 10, -3, 4, 4), Color("a3f3df"))
