extends Area2D

@export var coin_value: int = 10

const PARTICLE_EMITTER = preload("res://scripts/coin_particle_emitter.gd")

func _ready():
	body_entered.connect(_on_body_entered)
	print("[Coin] Ready at ", position)

func _on_body_entered(body):
	print("[Coin] body_entered called, body=", body.name, " is_player=", body.is_in_group('player'))
	if body.is_in_group('player'):
		var gm = get_tree().root.get_node_or_null("Main")
		print("[Coin] gm=", gm)
		if gm:
			gm.add_score(coin_value)
			print("[Coin] score added")
		var emitter = PARTICLE_EMITTER.new()
		add_child(emitter)
		print("[Coin] emitter created, calling emit at ", position)
		emitter.emit(self, position)
		queue_free()
		print("[Coin] queue_free called")
	else:
		print("[Coin] body is not player!")
