extends RefCounted
class_name CertificationMode

const POSITIONS := {
 "PA":{"label":"Wannenlage","difficulty":1.0},
 "PB":{"label":"Horizontal-Vertikal / Kehlnaht","difficulty":1.15},
 "PC":{"label":"Querposition","difficulty":1.3},
 "PF":{"label":"Steigend","difficulty":1.55},
 "PG":{"label":"Fallend","difficulty":1.5},
 "PE":{"label":"Überkopf","difficulty":1.85}
}

static func new_exam(process:String, position:String)->Dictionary:
 return {"process":process,"position":position,"attempts":0,"passed":false,
 "assistance":false,"hud_help":false,"result":{}}

static func evaluate(exam:Dictionary, weld_result:Dictionary)->Dictionary:
 var limit:=78.0
 var score:float=weld_result.get("score",0.0)
 var passed:=score>=limit and not exam.get("assistance",false)
 return {"score":score,"passed":passed,"position":exam.position,
 "note":"Simulierte WeldQuest-Prüfung – keine amtliche Schweißerprüfung."}
