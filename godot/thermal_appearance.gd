extends RefCounted
class_name ThermalAppearance

# Visual training model. Values are normalized simulation state, not acceptance limits.
# Final calibration must use licensed/independently measured reference data per material/process.
static func stainless_visual(heat:float, gas_coverage:float, travel_stability:float)->Dictionary:
 var oxidation:=clamp(heat*(1.15-gas_coverage)*1.8 + (1.0-travel_stability)*0.35,0.0,1.0)
 var tint:Color
 var label:String
 if oxidation < 0.12:
  tint=Color(0.78,0.80,0.82); label="metallisch / geringe Oxidation"
 elif oxidation < 0.28:
  tint=Color(0.88,0.70,0.25); label="stroh-gold"
 elif oxidation < 0.48:
  tint=Color(0.72,0.32,0.20); label="braun / rot"
 elif oxidation < 0.68:
  tint=Color(0.40,0.25,0.66); label="violett"
 elif oxidation < 0.84:
  tint=Color(0.16,0.36,0.68); label="blau"
 else:
  tint=Color(0.16,0.19,0.21); label="dunkel / starke Oxidation"
 return {"oxidation":oxidation,"tint":tint,"label":label,
 "haz_width":lerp(0.55,1.8,clamp(heat,0.0,1.0)),
 "roughness":lerp(0.28,0.62,oxidation)}

static func causes(heat:float, gas_coverage:float, travel_stability:float)->Array[String]:
 var out:Array[String]=[]
 if heat>0.72: out.append("Wärmeeinbringung hoch")
 if gas_coverage<0.65: out.append("Schutzgasabdeckung unzureichend")
 if travel_stability<0.65: out.append("Führung/Geschwindigkeit ungleichmäßig")
 return out
