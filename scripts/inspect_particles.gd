extends Node

func _ready():
	var node = GPUParticles2D.new()
	var props = []
	for key in node.get_property_list():
		props.append(key.get("name"))
	props.sort()
	print("GPUParticles2D properties:")
	for p in props:
		print(" ", p)
	get_tree().quit()
