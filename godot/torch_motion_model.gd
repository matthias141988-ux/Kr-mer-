extends RefCounted
class_name TorchMotionModel

# Combines travel direction and weave into ONE continuous torch path.
# Local axes: X = weave, Y = arc-height correction, Z = travel along seam.
var position:=Vector3.ZERO
var travel_speed:=0.0
var weave_input:=0.0
var height_input:=0.0
var smoothing:=12.0
var velocity:=Vector3.ZERO

func update(delta:float, stick:Vector2, height:float, speed_scale:float=1.0)->Vector3:
 weave_input=stick.x
 # Forward/back input is real torch travel along the seam, not camera movement.
 travel_speed=-stick.y*speed_scale
 height_input=height
 var target:=Vector3(weave_input,height_input,travel_speed)
 velocity=velocity.lerp(target,clamp(delta*smoothing,0.0,1.0))
 position+=velocity*delta
 return position

func motion_metrics()->Dictionary:
 return {
  "weave":abs(velocity.x),
  "travel":abs(velocity.z),
  "height_correction":velocity.y,
  "is_combined_motion":abs(velocity.x)>0.01 and abs(velocity.z)>0.01
 }
