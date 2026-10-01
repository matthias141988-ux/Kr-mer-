extends RefCounted
class_name UXGuard

# Runtime usability guardrails for welding: keep the weld pool visible and controls predictable.
const MIN_TOUCH_TARGET_PX := 56
const HUD_SAFE_CENTER := Rect2(520,220,880,620)
const MAX_PRIMARY_ACTIONS := 4

static func evaluate(viewport:Vector2, hud_rects:Array[Rect2], touch_rects:Array[Rect2])->Dictionary:
 var issues:Array[String]=[]
 for r in touch_rects:
  if r.size.x<MIN_TOUCH_TARGET_PX or r.size.y<MIN_TOUCH_TARGET_PX:
   issues.append("Touch-Ziel zu klein")
 for r in hud_rects:
  if r.intersects(HUD_SAFE_CENTER):
   issues.append("HUD verdeckt den Schweißbereich")
 if viewport.x<viewport.y:
  issues.append("Schweißmodus für Querformat optimieren")
 return {"passed":issues.is_empty(),"issues":issues}

static func control_hint(process:String)->String:
 match process:
  "WIG_ZUSATZ": return "Rechts Brenner · Links Zusatz"
  "WIG_AUTOGEN": return "Rechts Brenner · zweite Hand frei"
  "MIG","MAG": return "Rechts Brenner · Trigger Draht/Lichtbogen"
  "E_HAND": return "Rechts Elektrodenhalter · Abstand halten"
  _: return "Brenner führen"
