extends Node2D

const PARTICLE_COUNT = 12
const COIN_TEXTURE = preload("res://assets/sprites/coin.png")
const PARTICLE_SIZE = 8.0

func emit(parent: Node2D, position: Vector2):
	for i in range(PARTICLE_COUNT):
		var sprite = Sprite2D.new()
		sprite.texture = COIN_TEXTURE
		sprite.position = position
		sprite.scale = Vector2(PARTICLE_SIZE / 16.0, PARTICLE_SIZE / 16.0)
		sprite.modulate = Color(1.0, 0.9, 0.2, 1.0)
		parent.add_child(sprite)

		var angle = (TAU / PARTICLE_COUNT) * i + randf() * 0.8
		var distance = 30.0 + randf() * 40.0
		var offset = Vector2.from_angle(angle) * distance
		var tween = parent.create_tween()
		tween.tween_property(sprite, "position", sprite.position + offset, 0.35)
		tween.parallel().tween_property(sprite, "scale", Vector2.ZERO, 0.35)
		tween.parallel().tween_property(sprite, "modulate:a", 0.0, 0.35)
		tween.tween_callback(sprite.queue_free)
