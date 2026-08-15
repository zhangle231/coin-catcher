extends CharacterBody2D

@export var speed: float = 300.0
@export var player_size: Vector2 = Vector2(32, 32)

var is_dead: bool = false

func _ready():
	add_to_group('player')

func _physics_process(delta):
	if is_dead:
		return

	var input_dir = Vector2.ZERO
	if Input.is_key_pressed(KEY_RIGHT) or Input.is_key_pressed(KEY_D):
		input_dir.x += 1
	if Input.is_key_pressed(KEY_LEFT) or Input.is_key_pressed(KEY_A):
		input_dir.x -= 1
	if Input.is_key_pressed(KEY_DOWN) or Input.is_key_pressed(KEY_S):
		input_dir.y += 1
	if Input.is_key_pressed(KEY_UP) or Input.is_key_pressed(KEY_W):
		input_dir.y -= 1
	input_dir = input_dir.normalized()

	velocity = input_dir * speed
	move_and_slide()

	position.x = clamp(position.x, player_size.x/2, 800 - player_size.x/2)
	position.y = clamp(position.y, player_size.y/2, 600 - player_size.y/2)
