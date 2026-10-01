extends RefCounted
class_name TheoryMode

var questions := [
 {"category":"WIG","q":"Welche Änderung verkürzt bei sonst gleichen Bedingungen den Lichtbogen?","answers":["Brenner näher ans Werkstück","Gasmenge erhöhen","Zusatz dicker wählen","Fahrweg verlängern"],"correct":0,"why":"Die Lichtbogenlänge wird wesentlich durch den Abstand zwischen Elektrode und Werkstück bestimmt."},
 {"category":"MIG/MAG","q":"Welche Größe beeinflusst bei einem Drahtprozess unmittelbar die Abschmelzleistung?","answers":["Drahtvorschub","Helmfilter","Düsenfarbe","Werkbankhöhe"],"correct":0,"why":"Der Drahtvorschub ist eng mit Strom und Abschmelzleistung gekoppelt; genaue Zusammenhänge hängen von Prozess und Kennlinie ab."},
 {"category":"E-Hand","q":"Was kann bei zu großem Elektrodenabstand passieren?","answers":["Lichtbogen wird instabil oder reißt ab","Elektrode wird länger","Schlacke verschwindet","Werkstück wird automatisch vorgewärmt"],"correct":0,"why":"Ein zu langer Lichtbogen wird instabil und kann abreißen."},
 {"category":"Fehleranalyse","q":"Welche Beobachtung passt zu zu hoher Wärmeeinbringung?","answers":["Breiteres Bad und stärkere Wärmeeinflusszone","Kein Lichtbogen","Elektrode wächst","Gasflasche wird voller"],"correct":0,"why":"Mehr Wärmeeinbringung kann Bad und Wärmeeinflusszone vergrößern."}
]
var index:=0
var correct_count:=0

func current()->Dictionary:
 return questions[index]

func answer(selected:int)->Dictionary:
 var q=current()
 var ok=selected==q.correct
 if ok: correct_count+=1
 return {"correct":ok,"explanation":q.why,"score":correct_count,"total":questions.size()}

func next()->Dictionary:
 index=(index+1)%questions.size()
 return current()
