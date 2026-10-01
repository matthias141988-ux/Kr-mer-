extends Node3D
var torch: Node3D
var pool: MeshInstance3D
var bead := []
var welding=false
var heat=0.0
var hud: Label

func mat(c:Color,metal:=0.0,rough:=0.5,emit:=Color.BLACK):
 var m=StandardMaterial3D.new();m.albedo_color=c;m.metallic=metal;m.roughness=rough
 if emit!=Color.BLACK:m.emission_enabled=true;m.emission=emit;m.emission_energy_multiplier=7.0
 return m
func box(n:String,pos:Vector3,size:Vector3,m):
 var x=MeshInstance3D.new();x.name=n;var b=BoxMesh.new();b.size=size;b.material=m;x.mesh=b;x.position=pos;add_child(x);return x
func cyl(n:String,pos:Vector3,r:float,h:float,m):
 var x=MeshInstance3D.new();x.name=n;var b=CylinderMesh.new();b.top_radius=r;b.bottom_radius=r;b.height=h;b.material=m;x.mesh=b;x.position=pos;add_child(x);return x
func _ready():
 var env=WorldEnvironment.new();var e=Environment.new();e.background_mode=Environment.BG_COLOR;e.background_color=Color("#111820");e.ambient_light_source=Environment.AMBIENT_SOURCE_COLOR;e.ambient_light_color=Color("#7690a0");e.ambient_light_energy=0.35;e.glow_enabled=true;env.environment=e;add_child(env)
 var sun=DirectionalLight3D.new();sun.rotation_degrees=Vector3(-55,-25,0);sun.light_energy=1.4;sun.shadow_enabled=true;add_child(sun)
 box("floor",Vector3(0,-.15,0),Vector3(14,.2,12),mat(Color("#171b1d"),.1,.75))
 box("bench",Vector3(0,.65,-1.3),Vector3(6,.25,3),mat(Color("#333b3e"),.75,.28))
 box("plate",Vector3(0,.81,-1.3),Vector3(4.8,.08,2.2),mat(Color("#747d80"),.9,.18))
 for i in range(-5,6): box("wall",Vector3(i*1.2,2.4,-5),Vector3(1.1,4.8,.15),mat(Color("#252a2c"),.2,.7))
 torch=Node3D.new();torch.position=Vector3(1.2,1.8,-.7);add_child(torch)
 var grip=cyl("grip",Vector3.ZERO,.18,1.2,mat(Color("#111315"),.05,.45));grip.rotation_degrees.x=65;torch.add_child(grip)
 var cup=cyl("ceramic",Vector3(0,-.58,.28),.13,.38,mat(Color("#c17bd3"),.05,.3));cup.rotation_degrees.x=65;torch.add_child(cup)
 pool=cyl("pool",Vector3(1.0,.87,-1.25),.11,.025,mat(Color("#ff9b28"),.4,.2,Color("#ff6418")));pool.rotation_degrees.z=90;add_child(pool);pool.visible=false
 var cam=Camera3D.new();cam.position=Vector3(0,2.5,4.1);cam.rotation_degrees=Vector3(-18,0,0);cam.current=true;add_child(cam)
 var ui=CanvasLayer.new();add_child(ui);hud=Label.new();hud.position=Vector2(24,20);hud.add_theme_font_size_override("font_size",24);hud.text="WELDQUEST  •  WIG TRAINING\n85 A   |   8 l/min   |   Edelstahl 1.4301\nFinger ziehen: Brenner führen  •  gedrückt halten: Lichtbogen";ui.add_child(hud)
func _process(d):
 var t=Time.get_ticks_msec()/1000.0
 pool.scale=Vector3.ONE*(1.0+sin(t*20.0)*.12);heat=move_toward(heat,1.0 if welding else 0.0,d*2.5)
 if welding: make_bead()
func make_bead():
 var p=Vector3(torch.position.x,.87,-1.25);pool.position=p
 if bead.is_empty() or bead[-1].distance_to(p)>.055:
  var b=cyl("bead",p,.055,.075,mat(Color("#d9b083"),.8,.22,Color("#8b2b08")));b.rotation_degrees.z=90;bead.append(p)
func _unhandled_input(ev):
 if ev is InputEventScreenTouch:welding=ev.pressed;pool.visible=welding
 if ev is InputEventScreenDrag:
  torch.position.x=clamp(torch.position.x+ev.relative.x*.003,-2.1,2.1);torch.position.z=clamp(torch.position.z+ev.relative.y*.002,-1.6,-.65);pool.position.x=torch.position.x
 if ev is InputEventMouseButton and ev.button_index==MOUSE_BUTTON_LEFT:welding=ev.pressed;pool.visible=welding
 if ev is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):torch.position.x=clamp(torch.position.x+ev.relative.x*.003,-2.1,2.1)
