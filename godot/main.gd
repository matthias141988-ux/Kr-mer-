extends Node3D
var torch: Node3D
var pool: MeshInstance3D
var bead := []
var welding=false
var heat=0.0
var hud: Label
var torch_touch := -1
var filler_touch := -1
var filler_amount := 0.0
var weave_distance := 0.0
var weave_reversals := 0
var last_weave_dir := 0
var last_torch_x := 0.0
var weld_time := 0.0
var travel_distance := 0.0
var filler_taps := 0
var filler_was_down := false
var weave_start_ms := 0
var travel_speed := 0.0
var weave_hz := 0.0
var quality := 100.0
var torch_target := Vector2.ZERO
var torch_velocity := Vector2.ZERO
var filler_depth := 0.0
var filler_target := 0.0
var arc_active := false
var helmet_overlay: Control
var visor_tint: ColorRect
var arc_light: OmniLight3D
var arc_energy := 0.0
const TOUCH_DEADZONE := 2.5
const TORCH_SENSITIVITY := 0.0018
const TORCH_SMOOTHING := 14.0

func mat(c:Color,metal:=0.0,rough:=0.5,emit:=Color.BLACK):
 var m=StandardMaterial3D.new();m.albedo_color=c;m.metallic=metal;m.roughness=rough
 if emit!=Color.BLACK:m.emission_enabled=true;m.emission=emit;m.emission_energy_multiplier=7.0
 return m
func box(n:String,pos:Vector3,size:Vector3,m):
 var x=MeshInstance3D.new();x.name=n;var b=BoxMesh.new();b.size=size;b.material=m;x.mesh=b;x.position=pos;add_child(x);return x
func cyl(n:String,pos:Vector3,r:float,h:float,m):
 var x=MeshInstance3D.new();x.name=n;var b=CylinderMesh.new();b.top_radius=r;b.bottom_radius=r;b.height=h;b.material=m;x.mesh=b;x.position=pos;add_child(x);return x
func _ready():
 build_helmet_view()
 build_arc_lighting()
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
func build_arc_lighting():
 arc_light=OmniLight3D.new()
 arc_light.light_color=Color(0.72,0.86,1.0)
 arc_light.light_energy=0.0
 arc_light.omni_range=4.2
 arc_light.shadow_enabled=true
 add_child(arc_light)

func build_helmet_view():
 helmet_overlay=Control.new()
 helmet_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 helmet_overlay.mouse_filter=Control.MOUSE_FILTER_IGNORE
 add_child(helmet_overlay)
 var top=ColorRect.new();top.color=Color(0.015,0.018,0.02,0.92);top.position=Vector2(0,0);top.size=Vector2(1920,115)
 var bottom=ColorRect.new();bottom.color=Color(0.01,0.012,0.014,0.95);bottom.position=Vector2(0,965);bottom.size=Vector2(1920,115)
 var left=ColorRect.new();left.color=Color(0.012,0.014,0.016,0.90);left.position=Vector2(0,110);left.size=Vector2(155,860)
 var right=ColorRect.new();right.color=Color(0.012,0.014,0.016,0.90);right.position=Vector2(1765,110);right.size=Vector2(155,860)
 helmet_overlay.add_child(top);helmet_overlay.add_child(bottom);helmet_overlay.add_child(left);helmet_overlay.add_child(right)
 visor_tint=ColorRect.new()
 visor_tint.color=Color(0.03,0.055,0.045,0.10)
 visor_tint.position=Vector2(155,115);visor_tint.size=Vector2(1610,850)
 visor_tint.mouse_filter=Control.MOUSE_FILTER_IGNORE
 helmet_overlay.add_child(visor_tint)

func _process(d):
 var t=Time.get_ticks_msec()/1000.0
 pool.scale=Vector3.ONE*(1.0+sin(t*20.0)*.12);heat=move_toward(heat,1.0 if welding else 0.0,d*2.5)
 # Human-centered controls: damp hand jitter, preserve deliberate weaving, and make filler progressive.
 torch_velocity=torch_velocity.lerp(torch_target,clamp(d*TORCH_SMOOTHING,0.0,1.0))
 torch.position.x=clamp(torch.position.x+torch_velocity.x,-2.1,2.1)
 torch.position.z=clamp(torch.position.z+torch_velocity.y,-1.6,-.65)
 torch_target=torch_target.lerp(Vector2.ZERO,clamp(d*18.0,0.0,1.0))
 pool.position.x=torch.position.x
 if arc_light:
  arc_light.position=pool.global_position+Vector3(0,0.08,0)
  arc_energy=lerp(arc_energy,9.0 if arc_active else 0.0,clamp(d*22.0,0.0,1.0))
  arc_light.light_energy=arc_energy
 filler_target=1.0 if filler_touch>=0 else 0.0
 filler_depth=move_toward(filler_depth,filler_target,d*3.2)
 filler_amount=filler_depth
 arc_active=welding
 pool.visible=arc_active
 if visor_tint:
  # Auto-darkening helmet simulation: visor reacts immediately to the arc.
  visor_tint.color=Color(0.018,0.032,0.026,0.48) if arc_active else Color(0.03,0.055,0.045,0.10)
 if welding:
  weld_time+=d
  make_bead()
 travel_speed=(travel_distance/max(weld_time,0.01))*60000.0
 var elapsed=max((Time.get_ticks_msec()-weave_start_ms)/1000.0,0.01) if weave_start_ms>0 else 1.0
 weave_hz=(weave_reversals*0.5)/elapsed
 quality=clamp(100.0-abs(travel_speed-75.0)*0.22-abs(weave_hz-1.5)*8.0-max(0.0,filler_amount-.85)*15.0,0.0,100.0)
 hud.text="WELDQUEST  •  WIG TRAINING\n85 A   |   8 l/min   |   Edelstahl 1.4301\nRECHTS: Brenner führen/pendeln   LINKS: Zusatz dosieren\nTempo %.0f mm/min | Pendeln %.1f Hz | Weg %.1f mm\nZusatz %d%% · Tupfer %d | Analyse %.0f%%" % [travel_speed,weave_hz,weave_distance*1000.0,int(filler_depth*100.0),filler_taps,quality]
func make_bead():
 var p=Vector3(torch.position.x,.87,-1.25);pool.position=p
 if bead.is_empty() or bead[-1].distance_to(p)>.055:
  var b=cyl("bead",p,.055,.075,mat(Color("#d9b083"),.8,.22,Color("#8b2b08")));b.rotation_degrees.z=90;bead.append(p)
func _unhandled_input(ev):
 if ev is InputEventScreenTouch:
  if ev.pressed:
   if ev.position.x > get_viewport().get_visible_rect().size.x*0.48 and torch_touch<0:
    torch_touch=ev.index;welding=true;pool.visible=true;last_torch_x=torch.position.x
    if weave_start_ms==0: weave_start_ms=Time.get_ticks_msec()
   elif filler_touch<0:
    filler_touch=ev.index
    if not filler_was_down: filler_taps+=1
    filler_was_down=true
  else:
   if ev.index==torch_touch: torch_touch=-1;welding=false;pool.visible=false;torch_target=Vector2.ZERO;torch_velocity=Vector2.ZERO
   if ev.index==filler_touch: filler_touch=-1;filler_was_down=false
 if ev is InputEventScreenDrag and ev.index==torch_touch:
  var motion=ev.relative
  if motion.length()<TOUCH_DEADZONE: return
  var dx=motion.x*TORCH_SENSITIVITY
  var dz=motion.y*TORCH_SENSITIVITY
  torch_target=Vector2(dx,dz)
  weave_distance+=abs(dx)
  travel_distance+=abs(dz)
  var dir=sign(torch.position.x-last_torch_x)
  if dir!=0 and last_weave_dir!=0 and dir!=last_weave_dir: weave_reversals+=1
  if dir!=0:last_weave_dir=dir
  last_torch_x=torch.position.x
 if ev is InputEventMouseButton and ev.button_index==MOUSE_BUTTON_LEFT:
  welding=ev.pressed;pool.visible=welding
 if ev is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
  torch.position.x=clamp(torch.position.x+ev.relative.x*.003,-2.1,2.1)
