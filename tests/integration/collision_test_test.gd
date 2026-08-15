extends GutTest

func test_enemy_has_detection_area():
	var enemy_scene = load("res://scenes/enemy.tscn").instantiate()
	add_child(enemy_scene)

	var det_area = enemy_scene.get_node_or_null("DetectionArea")
	assert_not_null(det_area, "Enemy should have DetectionArea child")
	assert_true(det_area is Area2D, "DetectionArea should be Area2D")

	enemy_scene.queue_free()

func test_enemy_has_collision_shape():
	var enemy_scene = load("res://scenes/enemy.tscn").instantiate()
	add_child(enemy_scene)
	
	var collision = enemy_scene.get_node_or_null("CollisionShape2D")
	assert_not_null(collision, "Enemy should have CollisionShape2D")
	
	enemy_scene.queue_free()

func test_player_collision_shape():
	var player_scene = load("res://scenes/player.tscn").instantiate()
	add_child(player_scene)
	
	var collision = player_scene.get_node_or_null("CollisionShape2D")
	assert_not_null(collision, "Player should have CollisionShape2D")
	
	player_scene.queue_free()
