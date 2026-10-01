extends RefCounted
class_name ControlSensitivity

# Mouse-like sensitivity tuning for both virtual sticks.
var torch_sensitivity:=1.00
var filler_sensitivity:=1.00
var fine_zone:=0.42
var response_curve:=1.65
var deadzone:=0.10
var invert_y:=false

func apply(raw:Vector2, is_torch:bool)->Vector2:
 var v=raw
 if v.length()<deadzone:return Vector2.ZERO
 var s=torch_sensitivity if is_torch else filler_sensitivity
 var x=sign(v.x)*pow(abs(v.x),response_curve)
 var y=sign(v.y)*pow(abs(v.y),response_curve)
 if invert_y:y=-y
 # Extra precision around center for arc-length and small weave corrections.
 var fine=lerp(0.45,1.0,smoothstep(fine_zone,1.0,v.length()))
 return Vector2(x,y)*s*fine

func preset(name:String):
 match name:
  "precision": torch_sensitivity=.55;filler_sensitivity=.60;response_curve=2.0
  "normal": torch_sensitivity=1.0;filler_sensitivity=1.0;response_curve=1.65
  "fast": torch_sensitivity=1.45;filler_sensitivity=1.35;response_curve=1.35

func settings_schema()->Dictionary:
 return {
  "torch_sensitivity":{"min":0.25,"max":2.0,"step":0.05},
  "filler_sensitivity":{"min":0.25,"max":2.0,"step":0.05},
  "deadzone":{"min":0.02,"max":0.25,"step":0.01},
  "response_curve":{"min":1.0,"max":2.5,"step":0.05},
  "invert_y":{}
 }
