extends CharacterBody2D

@export var walk_speed := 145.0
@export var run_speed := 205.0
@export var acceleration := 1200.0
@export var gravity := 700.0
@export var jump_speed := -340.0
@export var coyote_time := 0.11
@export var jump_buffer_time := 0.12

var coyote := 0.0
var jump_buffer := 0.0
var invulnerable := 0.0
var facing := 1.0
var was_on_floor := false
var animation_time := 0.0
var last_safe_reported := Vector2.ZERO


func _physics_process(delta: float) -> void:
	var grounded := is_on_floor()
	coyote = coyote_time if grounded else maxf(0.0, coyote - delta)
	jump_buffer = jump_buffer_time if Input.is_action_just_pressed("jump") else maxf(0.0, jump_buffer - delta)
	invulnerable = maxf(0.0, invulnerable - delta)
	var direction := Input.get_axis("move_left", "move_right")
	var target_speed := direction * (run_speed if Input.is_action_pressed("run") else walk_speed)
	velocity.x = move_toward(velocity.x, target_speed, acceleration * delta)
	if direction != 0.0:
		facing = signf(direction)
	if jump_buffer > 0.0 and coyote > 0.0:
		velocity.y = jump_speed
		jump_buffer = 0.0
		coyote = 0.0
		grounded = false
	if not grounded:
		velocity.y += gravity * delta
	if Input.is_action_just_released("jump") and velocity.y < -110.0:
		velocity.y = -110.0
	move_and_slide()
	if is_on_floor() and not was_on_floor:
		get_tree().call_group("game", "spawn_burst", global_position + Vector2(0, 12), Color("c9e5a3"), 6)
	was_on_floor = is_on_floor()
	remember_safe_floor()
	animation_time += delta
	$Visual.visible = invulnerable <= 0.0 or int(Time.get_ticks_msec() / 90) % 2 == 0
	if global_position.y > 370.0:
		get_tree().call_group("game", "player_hurt", self, true)


func remember_safe_floor() -> void:
	if not is_on_floor() or global_position.distance_to(last_safe_reported) < 12.0:
		return
	for i in range(get_slide_collision_count()):
		var collision := get_slide_collision(i)
		if collision.get_normal().y > -0.7:
			continue
		var floor_node := collision.get_collider() as Node2D
		if floor_node is StaticBody2D:
			var floor_size: Variant = floor_node.get("size")
			if floor_size is Vector2 and floor_size.y >= 35.0:
				var margin := minf(28.0, floor_size.x * 0.2)
				if absf(global_position.x - floor_node.global_position.x) < floor_size.x * 0.5 - margin:
					last_safe_reported = global_position
					get_tree().call_group("game", "remember_safe_ground", global_position)
					return


func take_damage(from_x: float) -> void:
	if invulnerable > 0.0:
		return
	invulnerable = 1.2
	velocity = Vector2(180.0 * signf(global_position.x - from_x), -180.0)
	get_tree().call_group("game", "player_hurt", self, false)


func stomp() -> void:
	velocity.y = -220.0
