extends Node

func _ready():
	var mat = ParticleProcessMaterial.new()
	var props = []
	for key in mat.get_property_list():
		props.append(key.get("name"))
	props.sort()
	print("ParticleProcessMaterial properties:")
	for p in props:
		print(" ", p)
	get_tree().quit()
