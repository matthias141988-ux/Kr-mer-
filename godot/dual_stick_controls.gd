extends Control
class_name DualStickControls

signal torch_motion(delta:Vector3)
signal secondary_motion(delta:Vector3)

var left_id:=-1
var right_id:=-1
var left_origin:=Vector2.ZERO
var right_origin:=Vector2.ZERO
var left_value:=Vector2.ZERO
var right_value:=Vector2.ZERO
var left_depth:=0.0
var right_depth:=0.0
const RADIUS:=105.0
const DEADZONE:=0.10

func _input(e):
 if e is InputEventScreenTouch:
  if e.pressed:
   if e.position.y < size.y*0.55: return
   if e.position.x < size.x*0.5 and left_id<0:
    left_id=e.index;left_origin=e.position
   elif e.position.x>=size.x*0.5 and right_id<0:
    right_id=e.index;right_origin=e.position
  else:
   if e.index==left_id: left_id=-1;left_value=Vector2.ZERO;left_depth=0.0
   if e.index==right_id: right_id=-1;right_value=Vector2.ZERO;right_depth=0.0
 if e is InputEventScreenDrag:
  if e.index==left_id: left_value=_stick(e.position-left_origin)
  if e.index==right_id: right_value=_stick(e.position-right_origin)

func _process(delta):
 # Left stick: X/Y work-plane movement. Pressure substitute/vertical swipe is Z depth.
 # Right stick: lateral weave + travel. Together they provide simultaneous 3D control.
 var lv=_curve(left_value);var rv=_curve(right_value)
 left_depth=lerp(left_depth,-lv.y,clamp(delta*8.0,0.0,1.0))
 right_depth=lerp(right_depth,-rv.y,clamp(delta*8.0,0.0,1.0))
 torch_motion.emit(Vector3(rv.x,lv.y,right_depth)*delta)
 secondary_motion.emit(Vector3(lv.x,rv.y,left_depth)*delta)

func _stick(v:Vector2)->Vector2:
 var n=v/RADIUS
 if n.length()<DEADZONE:return Vector2.ZERO
 return n.limit_length(1.0)

func _curve(v:Vector2)->Vector2:
 # Fine center control, full travel near rim: better for TIG weaving than linear touch.
 return Vector2(sign(v.x)*pow(abs(v.x),1.65),sign(v.y)*pow(abs(v.y),1.65))
