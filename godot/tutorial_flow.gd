extends RefCounted
class_name TutorialFlow

enum Choice { UNSET, GUIDED, DIRECT }

var choice := Choice.UNSET
var step := 0
const STEPS := [
 {"title":"Willkommen bei WeldQuest","text":"Möchtest du eine kurze Einführung oder direkt schweißen?"},
 {"title":"Brennerhand","text":"Rechts führst du Brenner oder Elektrodenhalter. Ruhig führen; bewusst pendeln."},
 {"title":"Zweite Hand","text":"Bei WIG mit Zusatz dosierst du links den Zusatz. Autogen sowie MIG/MAG/E-Hand passen die Bedienung automatisch an."},
 {"title":"Schweißbad lesen","text":"Achte auf Badgröße, Lichtbogenabstand, Geschwindigkeit und Nahtreaktion."},
 {"title":"Bereit","text":"Die Hilfen bleiben später im Trainingsmodus wieder einschaltbar."}
]

func start_guided()->Dictionary:
 choice=Choice.GUIDED;step=0
 return STEPS[step]

func start_direct()->void:
 choice=Choice.DIRECT

func next()->Dictionary:
 step=min(step+1,STEPS.size()-1)
 return STEPS[step]

func finished()->bool:
 return choice==Choice.DIRECT or (choice==Choice.GUIDED and step>=STEPS.size()-1)
