extends GutTest

func _get_all_enemies(main: Node2D) -> Array:
	var result = []
	for child in main.get_children():
		if child is CharacterBody2D and child.name == "Enemy":
			result.append(child)
	return result

func _get_player(main: Node2D) -> Node2D:
	return main.get_node_or_null("Player")

func test_enemy_catches_stationary_player():
	"""Enemy should reach and detect player when player doesn't move."""
	var main_scene = load("res://scenes/main.tscn")
	var main = main_scene.instantiate()
	get_tree().root.add_child(main)
	await main.get_tree().process_frame

	var player = _get_player(main)
	var enemies = _get_all_enemies(main)

	assert_not_null(player, "Player should exist")
	assert_true(enemies.size() > 0, "Should have at least one enemy")

	# Place the closest enemy close to player
	var closest = enemies[0]
	var closest_dist = player.position.distance_to(closest.position)
	for e in enemies:
		var d = player.position.distance_to(e.position)
		if d < closest_dist:
			closest_dist = d
			closest = e

	closest.position = player.position + Vector2(50, 0)

	# Let physics run with stationary player
	# At speed 10px/s and 60fps, 50px takes ~300 frames
	for i in range(400):
		if main.game_over:
			break
		await main.get_tree().process_frame

	assert_true(main.game_over, "Game should end when enemy catches stationary player")

	main.queue_free()

func test_enemy_catches_player_from_distance():
	"""Enemy should chase and catch player from across the screen."""
	var main_scene = load("res://scenes/main.tscn")
	var main = main_scene.instantiate()
	get_tree().root.add_child(main)
	await main.get_tree().process_frame

	var player = _get_player(main)
	var enemies = _get_all_enemies(main)

	assert_not_null(player, "Player should exist")
	assert_true(enemies.size() > 0, "Should have at least one enemy")

	# Place all enemies far from player
	var target_pos = Vector2(700, 500)
	player.position = target_pos
	for e in enemies:
		e.position = Vector2(100, 100)

	# Let physics run - enough frames for the distance
	# ~721px at 10px/s = 72 seconds = ~4320 frames at 60fps
	for i in range(5000):
		if main.game_over:
			break
		await main.get_tree().process_frame

	assert_true(main.game_over, "Enemy should catch player from distance")

	main.queue_free()

func test_enemy_collision_mask_allows_chase():
	"""Enemy collision_mask must be 0 so it doesn't physically block on player."""
	var main_scene = load("res://scenes/main.tscn")
	var main = main_scene.instantiate()
	get_tree().root.add_child(main)
	await main.get_tree().process_frame

	var player = _get_player(main)
	var enemies = _get_all_enemies(main)

	assert_true(enemies.size() > 0, "Should have at least one enemy")
	var enemy = enemies[0]

	assert_eq(enemy.collision_mask, 0,
		"Enemy collision_mask should be 0 to prevent physical blocking during chase")

	assert_eq(player.collision_layer, 1,
		"Player should be on collision_layer 1")

	var det_area = enemy.get_node_or_null("DetectionArea")
	assert_not_null(det_area, "Enemy should have DetectionArea")
	assert_ne(det_area.collision_mask, 0,
		"DetectionArea collision_mask must detect player layer")

	main.queue_free()
