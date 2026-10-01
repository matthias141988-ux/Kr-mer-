extends RefCounted
class_name TemperatureHUD

# Training visualization, not a calibrated pyrometer.
var workpiece_c := 20.0
var interpass_c := 20.0
var peak_c := 20.0
var cooling_rate := 0.0

func step(delta:float, heat_state:float, arc_on:bool, ambient_c:float=20.0)->void:
 var previous:=workpiece_c
 var target:=ambient_c + heat_state*520.0
 workpiece_c=lerp(workpiece_c,target,clamp(delta*(2.4 if arc_on else 0.35),0.0,1.0))
 peak_c=max(peak_c,workpiece_c)
 if not arc_on:
  cooling_rate=(previous-workpiece_c)/max(delta,0.001)
 interpass_c=workpiece_c

func display()->Dictionary:
 return {
  "current":"%.0f °C" % workpiece_c,
  "peak":"MAX %.0f °C" % peak_c,
  "interpass":"ZWISCHENLAGE %.0f °C" % interpass_c,
  "cooling":"ABKÜHLUNG %.1f °C/s" % cooling_rate,
  "warning":workpiece_c>250.0
 }
