extends Node2D

const LEVELS := [
	"res://scenes/levels/greenbyte_valley_site.tscn",
	"res://scenes/levels/crystal_caves.tscn",
	"res://scenes/levels/gear_fortress.tscn",
	"res://scenes/levels/emerald_canopy.tscn",
	"res://scenes/levels/ember_chasm.tscn",
	"res://scenes/levels/sky_citadel.tscn"
]
const NAMES := ["Vale Greenbyte", "Cavernas de Cristal", "Fortaleza das Engrenagens", "Copa Esmeralda", "Abismo de Brasa", "Cidadela Celeste"]
const ITEM_NAMES := ["Fragmentos", "Cristais", "Engrenagens", "Folhas", "Brasas", "Estrelas"]
const REQUIRED_ITEMS := [12, 8, 8, 8, 10, 10]
const REQUIRED_ENEMIES := [4, 2, 3, 3, 3, 4]

var level_index := 0
var lives := 3
var coins := 0
var score := 0
var fragments := 0
var slimes_defeated := 0
var checkpoint := Vector2.ZERO
var active_level: Node2D
var current_player: CharacterBody2D
var portal_visual: CanvasItem
var finished := false
var level_start_score := 0
var level_start_coins := 0


func _ready() -> void:
	add_to_group("game")
	process_mode = Node.PROCESS_MODE_ALWAYS
	$UI/Menu/VBox/Play.pressed.connect(start_game)
	$UI/Menu/VBox/Controls.pressed.connect(show_controls)
	$UI/Menu/VBox/Quit.pressed.connect(func(): get_tree().quit())
	$UI/ControlsPanel/VBox/Back.pressed.connect(show_menu)
	$UI/Pause/VBox/Resume.pressed.connect(resume_game)
	$UI/Pause/VBox/MenuButton.pressed.connect(return_to_menu)
	$UI/Defeat/VBox/Retry.pressed.connect(retry_level)
	$UI/Defeat/VBox/MenuButton.pressed.connect(return_to_menu)
	$UI/Win/VBox/MenuButton.pressed.connect(return_to_menu)
	show_menu()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and active_level != null and not finished:
		if get_tree().paused:
			resume_game()
		else:
			get_tree().paused = true
			$UI/Pause.visible = true
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("restart") and $UI/Defeat.visible:
		retry_level()


func hide_screens() -> void:
	for screen in [$UI/Menu, $UI/ControlsPanel, $UI/Pause, $UI/Defeat, $UI/Win]:
		screen.visible = false


func show_menu() -> void:
	get_tree().paused = false
	hide_screens()
	$UI/MenuBackdrop.visible = true
	$UI/Menu.visible = true
	$UI/HUD.visible = false
	$UI/Objectives.visible = false
	$UI/WorldSign.visible = false
	$UI/PortalHint.visible = false


func show_controls() -> void:
	hide_screens()
	$UI/MenuBackdrop.visible = true
	$UI/ControlsPanel.visible = true


func start_game() -> void:
	get_tree().paused = false
	level_index = 0
	lives = 3
	coins = 0
	score = 0
	fragments = 0
	slimes_defeated = 0
	finished = false
	load_level()


func retry_level() -> void:
	get_tree().paused = false
	lives = 3
	coins = level_start_coins
	score = level_start_score
	finished = false
	load_level()


func load_level() -> void:
	hide_screens()
	$UI/MenuBackdrop.visible = false
	level_start_score = score
	level_start_coins = coins
	fragments = 0
	slimes_defeated = 0
	if active_level != null:
		active_level.queue_free()
		active_level = null
	active_level = load(LEVELS[level_index]).instantiate()
	$World.add_child(active_level)
	portal_visual = null
	var item_tints := [Color("fff0ab"), Color("9ff6ff"), Color("ffd091"), Color("b8ffae"), Color("ffb083"), Color("e5c2ff")]
	var enemy_index := 0
	for child in active_level.get_children():
		if child is Area2D:
			match int(child.get("kind")):
				0, 5:
					child.get_node("Visual").modulate = item_tints[level_index]
				1:
					if enemy_index % 2 == 1:
						child.set_meta("red_variant", true)
						child.get_node("Visual").queue_redraw()
					enemy_index += 1
				3:
					portal_visual = child.get_node("Visual")
	current_player = active_level.get_node("Player")
	checkpoint = current_player.global_position
	current_player.get_node("Camera2D").limit_right = int(active_level.get_meta("world_width", 2500))
	$UI/HUD.visible = true
	$UI/Objectives.visible = true
	$UI/WorldSign.visible = true
	$UI/WorldSign/Label.text = "FASE %d/6\n%s" % [level_index + 1, NAMES[level_index]]
	$UI/PortalHint.visible = false
	update_hud()


func update_hud() -> void:
	var hearts := "♥".repeat(lives) + "♡".repeat(maxi(0, 3 - lives))
	var required_items: int = REQUIRED_ITEMS[level_index]
	var required_enemies: int = REQUIRED_ENEMIES[level_index]
	var ready := fragments >= required_items and slimes_defeated >= required_enemies
	if portal_visual != null:
		portal_visual.modulate = Color("d5fff0") if ready else Color("89949f")
	$UI/HUD/Row/Label.text = "%s   ◆ %02d/%02d\nPONTOS %06d" % [hearts, fragments, required_items, score]
	$UI/Objectives/VBox/Fragments.text = "%s %s: %d/%d" % ["[x]" if fragments >= required_items else "[ ]", ITEM_NAMES[level_index], fragments, required_items]
	$UI/Objectives/VBox/Slimes.text = "%s Slimes: %d/%d" % ["[x]" if slimes_defeated >= required_enemies else "[ ]", slimes_defeated, required_enemies]
	$UI/Objectives/VBox/Portal.text = "[x] Portal aberto!" if ready else "[ ] Encontre o portal"
	if $UI/PortalHint.visible:
		$UI/PortalHint/Label.text = "Portal aberto! Entre para a próxima fase." if ready else "Portal fechado: faltam %d itens e %d slimes" % [maxi(0, required_items - fragments), maxi(0, required_enemies - slimes_defeated)]

func collect(at: Vector2, crystal: bool) -> void:
	coins += 1
	fragments += 1
	score += 100 if crystal else 25
	spawn_burst(at, Color("7df3e6") if crystal else Color("ffe37c"), 9)
	update_hud()


func defeat_enemy(at: Vector2) -> void:
	slimes_defeated += 1
	score += 250
	spawn_burst(at, Color("ed8b82"), 10)
	update_hud()


func activate_checkpoint(at: Vector2) -> void:
	checkpoint = at + Vector2(0, -22)
	spawn_burst(at, Color("8df3a4"), 10)


func remember_safe_ground(at: Vector2) -> void:
	checkpoint = at


func player_hurt(player: CharacterBody2D, fell: bool) -> void:
	if finished or player != current_player:
		return
	lives -= 1
	update_hud()
	if lives <= 0:
		finished = true
		player.set_physics_process(false)
		$UI/HUD.visible = false
		$UI/Objectives.visible = false
		$UI/WorldSign.visible = false
		$UI/PortalHint.visible = false
		$UI/Defeat.visible = true
		return
	if fell:
		player.global_position = checkpoint
		player.velocity = Vector2.ZERO
		player.invulnerable = 1.2
	else:
		spawn_burst(player.global_position, Color("f49e87"), 8)


func finish_level() -> void:
	if finished:
		return
	if fragments < REQUIRED_ITEMS[level_index] or slimes_defeated < REQUIRED_ENEMIES[level_index]:
		$UI/PortalHint/Label.text = "Portal fechado: faltam %d itens e %d slimes" % [maxi(0, REQUIRED_ITEMS[level_index] - fragments), maxi(0, REQUIRED_ENEMIES[level_index] - slimes_defeated)]
		$UI/PortalHint.visible = true
		return
	finished = true
	call_deferred("_advance_level")


func _advance_level() -> void:
	score += 1000
	level_index += 1
	if level_index >= LEVELS.size():
		current_player.set_physics_process(false)
		$UI/HUD.visible = false
		$UI/Objectives.visible = false
		$UI/WorldSign.visible = false
		$UI/PortalHint.visible = false
		$UI/Win/VBox/Message.text = "O NÚCLEO ESTÁ SALVO!\nSeis mundos concluídos.\nPontuação final: %d" % score
		$UI/Win.visible = true
	else:
		lives = 3
		finished = false
		load_level()


func resume_game() -> void:
	get_tree().paused = false
	$UI/Pause.visible = false


func return_to_menu() -> void:
	get_tree().paused = false
	if active_level != null:
		active_level.queue_free()
		active_level = null
	show_menu()


func spawn_burst(at: Vector2, color: Color, amount: int) -> void:
	if active_level == null:
		return
	var effect := Node2D.new()
	effect.set_script(load("res://scripts/burst.gd"))
	effect.position = at
	effect.color = color
	effect.amount = amount
	active_level.add_child(effect)

