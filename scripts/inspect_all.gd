extends Node

func _ready():
	# GPUParticles2D properties
	var p = GPUParticles2D.new()
	var f = FileAccess.open("user://gpu_props.txt", FileAccess.WRITE)
	f.store_line("=== GPUParticles2D ===")
	for key in p.get_property_list():
		var name = key.get("name")
		f.store_line("  " + name)
	f.close()

	# ParticleProcessMaterial properties
	var m = ParticleProcessMaterial.new()
	f = FileAccess.open("user://mat_props.txt", FileAccess.WRITE)
	f.store_line("=== ParticleProcessMaterial ===")
	for key in m.get_property_list():
		var name = key.get("name")
		f.store_line("  " + name)
	f.close()

	# CPUParticles2D properties
	var c = CPUParticles2D.new()
	f = FileAccess.open("user://cpu_props.txt", FileAccess.WRITE)
	f.store_line("=== CPUParticles2D ===")
	for key in c.get_property_list():
		var name = key.get("name")
		f.store_line("  " + name)
	f.close()

	get_tree().quit()
