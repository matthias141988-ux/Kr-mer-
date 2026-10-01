extends RefCounted
class_name WeldSimulation

static func evaluate(process:String, speed:float, weave_hz:float, filler:float, arc_gap:float, torch_angle:float)->Dictionary:
 var score:=100.0
 var faults:Array[String]=[]
 var heat_factor:=1.0
 if speed<35.0: score-=18.0;heat_factor+=0.35;faults.append("zu langsam / Wärmeeintrag hoch")
 if speed>130.0: score-=22.0;heat_factor-=0.25;faults.append("zu schnell / Bindung kritisch")
 if arc_gap>0.005: score-=18.0;faults.append("Lichtbogen zu lang")
 if abs(torch_angle)>18.0: score-=14.0;faults.append("Brennerwinkel instabil")
 if process=="WIG_ZUSATZ":
  if filler<0.15: score-=18.0;faults.append("zu wenig Zusatz")
  elif filler>0.9: score-=12.0;faults.append("zu viel Zusatz")
 if process=="WIG_AUTOGEN" and filler>0.05:
  score-=10.0;faults.append("Autogen: kein Zusatz vorgesehen")
 if process in ["MIG","MAG"] and weave_hz>4.0:
  score-=8.0;faults.append("unnötig hektische Brennerbewegung")
 return {"score":clamp(score,0.0,100.0),"faults":faults,"heat_factor":heat_factor}

static func bead_response(result:Dictionary)->Dictionary:
 var h:float=result.heat_factor
 return {
  "width_scale":clamp(h,0.65,1.55),
  "glow":clamp(h,0.5,1.5),
  "oxidation":clamp((h-1.0)*1.4,0.0,1.0),
  "quality":result.score
 }
