extends RefCounted
class_name WeldingReference

# Educational reference data. Normative wording/tables are not reproduced.
# Verify against the applicable current standard and qualified WPS before production use.
const ISO_4063 := {
 "111":{"name":"E-Hand / Lichtbogenhandschweißen","app_key":"E_HAND"},
 "121":{"name":"Unterpulverschweißen mit einer Drahtelektrode","app_key":"UP"},
 "131":{"name":"MIG-Schweißen mit Massivdrahtelektrode","app_key":"MIG"},
 "135":{"name":"MAG-Schweißen mit Massivdrahtelektrode","app_key":"MAG"},
 "141":{"name":"WIG-Schweißen mit Massivdraht/-stab","app_key":"WIG_ZUSATZ"},
 "142":{"name":"WIG-Schweißen autogen","app_key":"WIG_AUTOGEN"}
}

const WPS_LEARNING_FIELDS := [
 "Schweißprozess nach ISO 4063",
 "Grundwerkstoff / Werkstoffgruppe",
 "Nahtart und Schweißposition",
 "Zusatzwerkstoff und Abmessung",
 "Schutzgas",
 "Stromart / Polarität",
 "Strom, Spannung und Drahtvorschub soweit anwendbar",
 "Schweißgeschwindigkeit",
 "Vorwärm- und Zwischenlagentemperatur soweit anwendbar",
 "Lagenfolge"
]

static func process(code:String)->Dictionary:
 return ISO_4063.get(code,{})

static func training_note()->String:
 return "Lernhilfe – keine qualifizierte WPS. Für Fertigung gelten die anwendbaren Anforderungen und freigegebenen Schweißanweisungen."
