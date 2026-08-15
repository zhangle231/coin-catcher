extends Node2D

var score = 0
var game_over = false
var coins = []
var enemies = []

const COIN_COUNT = 5
const ENEMY_COUNT = 3
const SIZE = 32
const WORLD_WIDTH = 800
const WORLD_HEIGHT = 600

func _ready():
	set_process_input(true)
	randomize()
	_setup_ui()
	start_game()

func start_game():
	score = 0
	game_over = false
	coins.clear()
	enemies.clear()
	for child in get_children():
		if child.name != "CanvasLayer" and child.name != "Background":
			child.free()
	_create_player()
	for i in range(COIN_COUNT):
		_spawn_coin()
	for i in range(ENEMY_COUNT):
		_spawn_enemy()
	_update_score()

func _create_player():
	var player_scene = preload('res://scenes/player.tscn').instantiate()
	player_scene.position = Vector2(WORLD_WIDTH/2.0, WORLD_HEIGHT/2.0)
	add_child(player_scene)

func _get_player_position() -> Vector2:
	var player = get_node_or_null("Player")
	if player:
		return player.position
	return Vector2(WORLD_WIDTH/2.0, WORLD_HEIGHT/2.0)

func _spawn_coin():
	var coin_scene = preload('res://scenes/coin.tscn').instantiate()
	var coin_pos = Vector2(SIZE/2.0 + randf() * (WORLD_WIDTH - SIZE), SIZE/2.0 + randf() * (WORLD_HEIGHT - SIZE))
	coin_scene.position = coin_pos - Vector2(SIZE/2.0, SIZE/2.0)
	add_child(coin_scene)
	coins.append(coin_scene)

func _spawn_enemy():
	var enemy_scene = preload('res://scenes/enemy.tscn').instantiate()
	var enemy_pos = Vector2(SIZE/2.0 + randf() * (WORLD_WIDTH - SIZE), SIZE/2.0 + randf() * (WORLD_HEIGHT - SIZE))
	enemy_scene.position = enemy_pos
	add_child(enemy_scene)
	enemies.append(enemy_scene)

func _physics_process(delta):
	if game_over:
		return
	var player_pos = _get_player_position()
	for i in range(coins.size() - 1, -1, -1):
		var coin = coins[i]
		var coin_center = coin.position + Vector2(SIZE/2.0, SIZE/2.0)
		if player_pos.distance_to(coin_center) < SIZE * 0.8:
			score += 10
			_update_score()
			coin.queue_free()
			coins.remove_at(i)
			_spawn_coin()

func _end_game():
	game_over = true
	_show_game_over()

func _setup_ui():
	var bg = ColorRect.new()
	bg.name = "Background"
	bg.anchor_right = 1.0
	bg.anchor_bottom = 1.0
	bg.color = Color(0.6, 0.75, 1.0)
	add_child(bg)
	var cl = CanvasLayer.new()
	cl.name = "CanvasLayer"
	add_child(cl)
	var score_label = Label.new()
	score_label.name = "Score"
	score_label.position = Vector2(16, 16)
	score_label.add_theme_color_override("font_color", Color(1, 1, 1))
	score_label.add_theme_font_size_override("font_size", 24)
	score_label.text = "Score: 0"
	cl.add_child(score_label)
	var hint = Label.new()
	hint.name = "Hint"
	hint.text = "WASD or Arrow Keys to move, R to restart"
	hint.position = Vector2(16, 560)
	hint.add_theme_color_override("font_color", Color(0.8, 0.8, 0.8))
	hint.add_theme_font_size_override("font_size", 14)
	cl.add_child(hint)
	var overlay = ColorRect.new()
	overlay.name = "Overlay"
	overlay.anchor_right = 1.0
	overlay.anchor_bottom = 1.0
	overlay.visible = false
	overlay.color = Color(0, 0, 0, 0.5)
	cl.add_child(overlay)
	var go_panel = Control.new()
	go_panel.name = "GameOver"
	go_panel.visible = false
	go_panel.position = Vector2(200, 160)
	go_panel.size = Vector2(400, 280)
	go_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	cl.add_child(go_panel)
	var go_bg = ColorRect.new()
	go_bg.name = "Background"
	go_bg.anchor_right = 1.0
	go_bg.anchor_bottom = 1.0
	go_bg.color = Color(1, 1, 1)
	go_panel.add_child(go_bg)
	var go_title = Label.new()
	go_title.name = "Title"
	go_title.text = "GAME OVER"
	go_title.position = Vector2(0, 40)
	go_title.add_theme_color_override("font_color", Color(1, 0, 0))
	go_title.add_theme_font_size_override("font_size", 52)
	go_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	go_panel.add_child(go_title)
	var go_score = Label.new()
	go_score.name = "FinalScore"
	go_score.text = "Score: 0"
	go_score.position = Vector2(0, 130)
	go_score.add_theme_color_override("font_color", Color(0, 0, 0))
	go_score.add_theme_font_size_override("font_size", 28)
	go_score.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	go_panel.add_child(go_score)
	var restart_btn = Button.new()
	restart_btn.name = "RestartBtn"
	restart_btn.text = "Restart (R)"
	restart_btn.position = Vector2(125, 220)
	restart_btn.size = Vector2(150, 44)
	restart_btn.pressed.connect(_on_restart)
	go_panel.add_child(restart_btn)

func add_score(amount: int) -> void:
	score += amount
	_update_score()

func _update_score():
	var score_label = get_node("CanvasLayer/Score")
	if score_label:
		score_label.text = "Score: " + str(score)

func _show_game_over():
	var go_panel = get_node("CanvasLayer/GameOver")
	if go_panel:
		var go_score = go_panel.get_node("FinalScore")
		if go_score:
			go_score.text = "Score: " + str(score)
		go_panel.visible = true
		get_node("CanvasLayer/Overlay").visible = true

func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_R:
		_on_restart()

func _on_restart():
	start_game()
	var go_panel = get_node("CanvasLayer/GameOver")
	if go_panel:
		go_panel.visible = false
		get_node("CanvasLayer/Overlay").visible = false
