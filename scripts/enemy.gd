extends CharacterBody2D

const CHASE_SPEED = 10.0
const SIZE = 32
const WORLD_WIDTH = 800
const WORLD_HEIGHT = 600

var _game_manager = null

func _ready():
	_game_manager = get_node_or_null("/root/Main")
	if _game_manager == null:
		# Test environment: try to find Main as a sibling or parent
		var parent = get_parent()
		if parent != null:
			_game_manager = parent.get_node_or_null("Main")
		if _game_manager == null:
			var grandparent = get_parent()
			if grandparent != null:
				grandparent = grandparent.get_parent()
			if grandparent != null:
				_game_manager = grandparent.get_node_or_null("Main")
	$DetectionArea.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group('player'):
		if _game_manager and not _game_manager.game_over:
			_game_manager._end_game()
		queue_free()

func _physics_process(delta):
	if _game_manager and _game_manager.game_over:
		return
	var player = _game_manager.get_node_or_null("Player")
	if player:
		var dir = (player.position - position).normalized()
		velocity = dir * CHASE_SPEED
		move_and_slide()

	# Clamp to screen bounds
	position.x = clamp(position.x, SIZE/2.0, WORLD_WIDTH - SIZE/2.0)
	position.y = clamp(position.y, SIZE/2.0, WORLD_HEIGHT - SIZE/2.0)
