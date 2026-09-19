extends SceneTree

func _initialize() -> void:
	call_deferred("run_checks")

func fail(message: String) -> void:
	printerr(message)
	quit(1)

func run_checks() -> void:
	var game_scene := load("res://scenes/game.tscn") as PackedScene
	if game_scene == null:
		fail("Game scene failed to load")
		return
	var game := game_scene.instantiate()
	root.add_child(game)
	await process_frame
	if not game.get_node("UI/MenuBackdrop").visible:
		fail("Menu background is hidden")
		return
	game.start_game()
	if game.get_node("UI/MenuBackdrop").visible:
		fail("Menu background covers gameplay")
		return
	await physics_frame
	await physics_frame
	if not game.current_player.is_on_floor():
		fail("Player did not land on starting ground")
		return
	var starting_y: float = game.current_player.global_position.y
	Input.action_press("move_right")
	Input.action_press("jump")
	for i in range(28):
		await physics_frame
	Input.action_release("move_right")
	Input.action_release("jump")
	for i in range(30):
		await physics_frame
	if not game.current_player.is_on_floor() or game.current_player.global_position.y > starting_y - 40.0:
		fail("Player could not jump onto first platform")
		return
	var safe_checkpoint: Vector2 = game.checkpoint
	game.current_player.global_position = Vector2(342, 268)
	game.current_player.velocity = Vector2.ZERO
	for i in range(50):
		await physics_frame
	if game.lives != 2 or game.current_player.global_position.distance_to(safe_checkpoint) > 30.0:
		fail("Falling into a gap did not restore a safe checkpoint")
		return
	for stage in range(6):
		if game.level_index != stage or game.active_level == null:
			fail("Wrong stage loaded: %d" % stage)
			return
		var item_count := 0
		var enemy_count := 0
		var portal_count := 0
		var portal: Area2D
		for child in game.active_level.get_children():
			if child is Area2D:
				match int(child.get("kind")):
					0, 5: item_count += 1
					1: enemy_count += 1
					3:
						portal_count += 1
						portal = child
		if item_count < game.REQUIRED_ITEMS[stage] or enemy_count < game.REQUIRED_ENEMIES[stage] or portal_count != 1:
			fail("Missing objectives or portal in stage %d" % (stage + 1))
			return
		if not game.get_node("UI/Objectives").visible:
			fail("Objectives are hidden in stage %d" % (stage + 1))
			return
		if stage >= 3:
			game.current_player.global_position = Vector2(170, 268)
			game.current_player.velocity = Vector2.ZERO
			for i in range(3):
				await physics_frame
			Input.action_press("move_right")
			Input.action_press("jump")
			for i in range(28):
				await physics_frame
			Input.action_release("move_right")
			Input.action_release("jump")
			for i in range(30):
				await physics_frame
			if not game.current_player.is_on_floor() or game.current_player.global_position.y > 215.0:
				fail("First platform is unreachable in stage %d" % (stage + 1))
				return
		var portal_position := portal.global_position + Vector2(0, 16)
		game.current_player.global_position = portal_position
		game.current_player.velocity = Vector2.ZERO
		for i in range(4):
			await physics_frame
		if game.level_index != stage:
			fail("Portal opened before objectives in stage %d" % (stage + 1))
			return
		if not game.get_node("UI/PortalHint").visible:
			fail("Locked portal did not explain objectives")
			return
		game.current_player.global_position = Vector2(70, 268)
		for i in range(3):
			await physics_frame
		for i in range(game.REQUIRED_ITEMS[stage]):
			game.collect(Vector2(50, 50), true)
		for i in range(game.REQUIRED_ENEMIES[stage]):
			game.defeat_enemy(Vector2(50, 50))
		if game.fragments < game.REQUIRED_ITEMS[stage] or game.slimes_defeated < game.REQUIRED_ENEMIES[stage]:
			fail("Objectives did not count in stage %d" % (stage + 1))
			return
		game.current_player.global_position = portal_position
		game.current_player.velocity = Vector2.ZERO
		for i in range(6):
			await physics_frame
			await process_frame
		if stage < 5 and game.level_index != stage + 1:
			fail("Portal failed to advance from stage %d" % (stage + 1))
			return
	if not game.get_node("UI/Win").visible or game.level_index != 6:
		fail("Final victory screen missing")
		return
	game.start_game()
	await physics_frame
	await physics_frame
	game.current_player.take_damage(0.0)
	if game.lives != 2:
		fail("Damage did not reduce lives")
		return
	game.current_player.take_damage(0.0)
	if game.lives != 2:
		fail("Invulnerability failed")
		return
	for i in range(2):
		game.current_player.invulnerable = 0.0
		game.current_player.take_damage(0.0)
	if game.lives != 0 or not game.get_node("UI/Defeat").visible:
		fail("Defeat screen missing")
		return
	game.retry_level()
	if game.level_index != 0 or game.lives != 3 or game.get_node("UI/Defeat").visible:
		fail("Retry did not restore current stage")
		return
	print("Six-stage smoke test passed")
	quit(0)
