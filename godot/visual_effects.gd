extends RefCounted
class_name VisualEffects
static func arc_state(heat:float,stability:float,gas:float)->Dictionary:
 return {
  "arc_energy":lerp(5.0,11.0,clamp(heat,0.0,1.0))*lerp(0.82,1.0,stability),
  "pool_scale":lerp(0.7,1.5,clamp(heat,0.0,1.0)),
  "smoke":clamp((1.0-gas)*0.55+max(heat-0.8,0.0),0.0,1.0),
  "micro_particles":clamp((1.0-stability)*0.35,0.0,0.35),
  "reflection_strength":lerp(0.35,1.0,clamp(heat,0.0,1.0))}
