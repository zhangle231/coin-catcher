extends Node2D

const COIN_TEXTURE = preload("res://assets/sprites/coin.png")

func _ready():
	# Test 1: Just a static sprite to confirm texture loads
	var s1 = Sprite2D.new()
	s1.texture = COIN_TEXTURE
	s1.position = Vector2(400, 250)
	s1.scale = Vector2(1.0, 1.0)
	add_child(s1)

	# Test 2: Animated sprite with tween
	var s2 = Sprite2D.new()
	s2.texture = COIN_TEXTURE
	s2.position = Vector2(400, 350)
	s2.scale = Vector2(1.0, 1.0)
	s2.modulate = Color(1.0, 0.9, 0.2, 1.0)
	add_child(s2)

	var tween = create_tween()
	tween.tween_property(s2, "position", s2.position + Vector2(0, -80), 1.0)
	tween.parallel().tween_property(s2, "scale", Vector2(0.1, 0.1), 1.0)
	tween.parallel().tween_property(s2, "modulate:a", 0.0, 1.0)
	tween.tween_callback(s2.queue_free)
