extends GutTest

func test_main_scene_loads():
	var scene = load("res://scenes/main.tscn")
	assert_not_null(scene, "Main scene should load")

func test_all_scenes_load():
	var scenes = [
		"res://scenes/player.tscn",
		"res://scenes/enemy.tscn",
        "res://scenes/coin.tscn"
	]
	for s in scenes:
		var loaded = load(s)
		assert_not_null(loaded, s + " should load")

func test_all_scripts_exist():
	var scripts = [
		"res://scripts/game_manager.gd",
		"res://scripts/player.gd",
		"res://scripts/enemy.gd",
        "res://scripts/coin.gd"
	]
	for s in scripts:
		assert_true(FileAccess.file_exists(s), s + " should exist")
