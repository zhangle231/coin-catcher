extends GutTest

var game_manager = null
var player = null

func before_each():
	game_manager = load("res://scenes/main.tscn").instantiate()
	get_tree().root.add_child(game_manager)
	game_manager.start_game()

func after_each():
	if game_manager != null:
		game_manager.queue_free()
		game_manager = null

func test_player_exists():
	player = game_manager.get_node_or_null("Player")
	assert_not_null(player, "Player node should exist")
	assert_true(player.is_in_group('player'), "Player should be in 'player' group")

func test_enemy_count():
	assert_eq(game_manager.enemies.size(), 3, "Should spawn 3 enemies")

func test_coin_count():
	assert_eq(game_manager.coins.size(), 5, "Should spawn 5 coins")

func test_score_starts_at_zero():
	assert_eq(game_manager.score, 0, "Score should start at 0")

func test_game_over_flag():
	assert_false(game_manager.game_over, "Game should not be over at start")
