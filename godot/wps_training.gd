extends RefCounted
class_name WPSTraining

# Training model only: it teaches how a WPS is read and assembled.
# It must never label user-entered values as a qualified/approved production WPS.
const SECTIONS := [
 {"id":"identity","title":"WPS-Kopf","fields":["WPS-Nr.","Revision","Hersteller","Bauteil/Anwendung"]},
 {"id":"joint","title":"Verbindung","fields":["Nahtart","Fugenform","Abmessungen","Schweißposition"]},
 {"id":"materials","title":"Werkstoffe","fields":["Grundwerkstoff 1","Grundwerkstoff 2","Dicke","Rohrdurchmesser"]},
 {"id":"process","title":"Verfahren","fields":["ISO-4063-Prozessnummer","Verfahrensbezeichnung","Lagenfolge"]},
 {"id":"consumables","title":"Zusätze / Gase","fields":["Zusatzwerkstoff","Durchmesser","Schutzgas","Gasmenge"]},
 {"id":"parameters","title":"Schweißparameter","fields":["Stromart/Polarität","Strom","Spannung","Drahtvorschub","Schweißgeschwindigkeit"]},
 {"id":"thermal","title":"Temperaturführung","fields":["Vorwärmtemperatur","Zwischenlagentemperatur","Wärmenachbehandlung"]},
 {"id":"technique","title":"Schweißtechnik","fields":["Brenner-/Elektrodenwinkel","Pendeln","Lagen","Reinigung zwischen Lagen"]}
]

static func new_training_wps()->Dictionary:
 var data:={}
 for section in SECTIONS:
  for field in section.fields: data[field]=""
 data["status"]="TRAINING"
 return data

static func validate_training(data:Dictionary)->Array[String]:
 var missing:Array[String]=[]
 for required in ["WPS-Nr.","Nahtart","Grundwerkstoff 1","ISO-4063-Prozessnummer","Schweißposition"]:
  if str(data.get(required,"")).strip_edges()=="": missing.append(required)
 return missing

static func disclaimer()->String:
 return "WPS-Lernmodus: keine qualifizierte oder freigegebene Schweißanweisung. Produktions-WPS müssen aus dem geltenden qualifizierten Verfahren und den anwendbaren Anforderungen abgeleitet/freigegeben werden."
