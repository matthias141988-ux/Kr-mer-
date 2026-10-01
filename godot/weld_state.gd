extends RefCounted
class_name WeldState

var process := "WIG_ZUSATZ"
var current_a := 85.0
var gas_l_min := 8.0
var travel_mm_min := 0.0
var arc_gap_mm := 2.5
var torch_angle_deg := 12.0
var weave_hz := 0.0
var filler_level := 0.0
var heat := 0.0
var pool := 0.0

func step(delta:float, arc_on:bool)->void:
 var energy=(current_a/100.0)*(1.0/max(travel_mm_min/80.0,0.35)) if arc_on else 0.0
 heat=move_toward(heat,energy,delta*(1.8 if arc_on else 0.55))
 pool=clamp(heat*(1.0-abs(arc_gap_mm-2.5)*0.12),0.0,1.5)

func visual_state()->Dictionary:
 var hot=clamp(pool,0.0,1.0)
 return {
  "pool_scale":lerp(0.65,1.45,hot),
  "core_energy":lerp(2.0,10.0,hot),
  "haz_strength":clamp(max(heat-0.65,0.0),0.0,1.0),
  "bead_height":clamp(0.7+filler_level*0.65,0.65,1.5)
 }
