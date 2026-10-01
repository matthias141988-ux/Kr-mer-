extends Node3D

var torch: Node3D
var filler: Node3D
var pool: MeshInstance3D
var hud: Label
var torch_touch := -1
var filler_touch := -1
var torch_target := Vector2.ZERO
var filler_depth := 0.0
var welding := false\nvar weave_phase := 0.0\nvar reference_weave_hz := 1.35\nvar reference_weave_width := 0.16\nvar filler_pulse := 0.0

func material(color: Color, metallic := 0.0, roughness := 0.5, emission := Color.BLACK) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.albedo_color = color
	m.metallic = metallic
	m.roughness = roughness
	if emission != Color.BLACK:
		m.emission_enabled = true
		m.emission = emission
		m.emission_energy_multiplier = 4.0
	return m

func add_box(pos: Vector3, size: Vector3, mat: Material) -> MeshInstance3D:
	var node := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = size
	mesh.material = mat
	node.mesh = mesh
	node.position = pos
	add_child(node)
	return node

func add_cylinder(parent: Node3D, pos: Vector3, radius: float, height: float, mat: Material) -> MeshInstance3D:
	var node := MeshInstance3D.new()
	var mesh := CylinderMesh.new()
	mesh.top_radius = radius
	mesh.bottom_radius = radius
	mesh.height = height
	mesh.material = mat
	node.mesh = mesh
	node.position = pos
	parent.add_child(node)
	return node

func _ready():
	var env := WorldEnvironment.new()
	var e := Environment.new()
	e.background_mode = Environment.BG_COLOR
	e.background_color = Color("#101820")
	e.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	e.ambient_light_color = Color("#91a2aa")
	e.ambient_light_energy = 0.55
	env.environment = e
	add_child(env)

	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-52, -25, 0)
	sun.light_energy = 1.5
	sun.shadow_enabled = true
	add_child(sun)

	add_box(Vector3(0, -0.15, -1.0), Vector3(10, 0.2, 8), material(Color("#171c1f"), 0.1, 0.8))
	add_box(Vector3(0, 0.55, -1.6), Vector3(5.8, 0.25, 2.8), material(Color("#323a3d"), 0.75, 0.3))
	add_box(Vector3(0, 0.72, -1.55), Vector3(4.7, 0.08, 2.0), material(Color("#7a8588"), 0.9, 0.2))

	torch = Node3D.new()
	torch.position = Vector3(0.85, 1.45, -0.65)
	add_child(torch)
	var grip := add_cylinder(torch, Vector3.ZERO, 0.12, 0.85, material(Color("#141719"), 0.05, 0.45))
	grip.rotation_degrees.x = 62
	var cup := add_cylinder(torch, Vector3(0, -0.38, 0.19), 0.095, 0.30, material(Color("#c48ad0"), 0.05, 0.3))
	cup.rotation_degrees.x = 62

	filler = Node3D.new()
	filler.position = Vector3(-0.85, 1.15, -0.75)
	add_child(filler)
	var rod := add_cylinder(filler, Vector3.ZERO, 0.014, 1.55, material(Color("#c6d0d3"), 0.85, 0.18))
	rod.rotation_degrees.z = 78

	pool = add_cylinder(self, Vector3(0.75, 0.79, -1.45), 0.09, 0.025, material(Color("#ff9b2f"), 0.25, 0.2, Color("#ff5b18")))
	pool.rotation_degrees.z = 90
	pool.visible = false

	var cam := Camera3D.new()
	cam.position = Vector3(0, 2.25, 3.55)
	cam.rotation_degrees.x = -19
	cam.current = true
	add_child(cam)

	var layer := CanvasLayer.new()
	add_child(layer)
	hud = Label.new()
	hud.position = Vector2(28, 24)
	hud.add_theme_font_size_override("font_size", 25)
	hud.text = "WELDQUEST 3D  •  WIG\nRECHTS: Brenner bewegen / Lichtbogen\nLINKS: Zusatz eintauchen"
	layer.add_child(hud)

func _process(delta):
	torch.position.x = lerp(torch.position.x, torch_target.x, clamp(delta * 8.0, 0.0, 1.0))
	torch.position.z = lerp(torch.position.z, torch_target.y, clamp(delta * 8.0, 0.0, 1.0))
	weave_phase += delta * TAU * reference_weave_hz\n\tvar weave := sin(weave_phase) * reference_weave_width if welding else 0.0\n\ttorch.rotation_degrees.z = lerp(torch.rotation_degrees.z, weave * 32.0, clamp(delta * 8.0, 0.0, 1.0))\n\tfiller_pulse = (sin(weave_phase - 1.2) * 0.5 + 0.5) if filler_touch >= 0 else 0.0\n\tfiller_depth = move_toward(filler_depth, filler_pulse if filler_touch >= 0 else 0.0, delta * 4.5)
	filler.position = Vector3(-0.85 + filler_depth * 0.35, 1.15 - filler_depth * 0.12, -0.75 - filler_depth * 0.28)
	pool.position.x = torch.position.x
	pool.visible = welding

func _unhandled_input(event):
	if event is InputEventScreenTouch:
		var half := get_viewport().get_visible_rect().size.x * 0.5
		if event.pressed:
			if event.position.x >= half and torch_touch < 0:
				torch_touch = event.index
				welding = true
				torch_target = Vector2(torch.position.x, torch.position.z)
			elif event.position.x < half and filler_touch < 0:
				filler_touch = event.index
		else:
			if event.index == torch_touch:
				torch_touch = -1
				welding = false
			if event.index == filler_touch:
				filler_touch = -1
	if event is InputEventScreenDrag and event.index == torch_touch:
		torch_target.x = clamp(torch_target.x + event.relative.x * 0.003, -1.8, 1.8)
		torch_target.y = clamp(torch_target.y + event.relative.y * 0.003, -1.55, -0.55)
