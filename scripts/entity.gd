@tool
extends Area2D

@export_enum("moeda", "inimigo", "checkpoint", "bandeira", "espinhos", "cristal") var kind := 0:
	set(value):
		kind = value
		queue_redraw()
@export var patrol_distance := 70.0
@export var patrol_speed := 35.0

var origin_x := 0.0
var direction := 1.0
var phase := 0.0
var collected := false


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	if kind == 3:
		var portal_shape := RectangleShape2D.new()
		portal_shape.size = Vector2(56, 76)
		$CollisionShape2D.shape = portal_shape
	origin_x = position.x
	body_entered.connect(_on_body_entered)
	set_physics_process(kind == 0 or kind == 1 or kind == 5)


func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	phase += delta
	if kind == 1:
		position.x += direction * patrol_speed * delta
		if absf(position.x - origin_x) >= patrol_distance:
			direction *= -1.0
	if kind == 0 or kind == 5:
		$Visual.position.y = sin(phase * 5.0) * 2.0


func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player") or collected:
		return
	match kind:
		0, 5:
			collected = true
			get_tree().call_group("game", "collect", global_position, kind == 5)
			queue_free()
		1:
			if body.velocity.y > 40.0 and body.global_position.y < global_position.y - 5.0:
				collected = true
				body.stomp()
				get_tree().call_group("game", "defeat_enemy", global_position)
				queue_free()
			else:
				body.take_damage(global_position.x)
		2:
			get_tree().call_group("game", "activate_checkpoint", global_position)
			$Visual.queue_redraw()
		3:
			get_tree().call_group("game", "finish_level")
		4:
			body.take_damage(global_position.x)
