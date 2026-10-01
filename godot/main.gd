extends Node3D

var status: Label
var phase := 0

func _ready():
	# Android-safe diagnostic boot scene. No 3D effects are created until
	# the UI has rendered at least one frame.
	var bg := ColorRect.new()
	bg.color = Color("#101820")
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	status = Label.new()
	status.text = "WELDQUEST 3D\n\nAndroid-Test startet..."
	status.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	status.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	status.add_theme_font_size_override("font_size", 34)
	add_child(status)

	call_deferred("_boot_test")

func _boot_test():
	await get_tree().process_frame
	status.text = "WELDQUEST 3D\n\nGodot läuft ✓\nRenderer läuft ✓\n\n3D-Test wird geladen..."
	await get_tree().create_timer(1.0).timeout
	_build_safe_3d()

func _build_safe_3d():
	var cam := Camera3D.new()
	cam.position = Vector3(0, 1.6, 4.0)
	cam.current = true
	add_child(cam)

	var light := DirectionalLight3D.new()
	light.rotation_degrees = Vector3(-45, -25, 0)
	light.light_energy = 1.2
	add_child(light)

	var mesh := MeshInstance3D.new()
	var cube := BoxMesh.new()
	cube.size = Vector3(2.8, 0.25, 1.6)
	var material := StandardMaterial3D.new()
	material.albedo_color = Color("#69777c")
	material.metallic = 0.75
	material.roughness = 0.3
	cube.material = material
	mesh.mesh = cube
	mesh.position = Vector3(0, 0, -1.2)
	add_child(mesh)

	status.text = "WELDQUEST 3D - ANDROID DIAGNOSE\n\nGodot ✓   Renderer ✓   3D-Szene ✓\n\nWenn du diesen Text und eine Metallplatte siehst,\nist der Android-Start repariert."
