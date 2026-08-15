extends Node

func _ready():
	var node = CPUParticles2D.new()
	var props = []
	for key in node.get_property_list():
		props.append(key.get("name"))
	props.sort()
	print("CPUParticles2D properties:")
	for p in props:
		print(" ", p)
	get_tree().quit()
