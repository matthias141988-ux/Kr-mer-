extends RefCounted
class_name WeldProcessProfiles

const PROFILES := {
 "WIG_ZUSATZ": {
  "label":"WIG mit Zusatz",
  "controls":"Rechts: Brenner führen/pendeln · Links: Zusatz dosieren",
  "wire_mode":"manual_rod", "requires_filler_hand":true, "arc_style":"tig"
 },
 "WIG_AUTOGEN": {
  "label":"WIG autogen",
  "controls":"Rechts: Brenner führen · Links frei für Werkstück/Position",
  "wire_mode":"none", "requires_filler_hand":false, "arc_style":"tig"
 },
 "MIG": {
  "label":"MIG",
  "controls":"Rechts: Brenner führen · Trigger: Lichtbogen/Draht",
  "wire_mode":"continuous", "requires_filler_hand":false, "arc_style":"mig"
 },
 "MAG": {
  "label":"MAG",
  "controls":"Rechts: Brenner führen · Trigger: Lichtbogen/Draht",
  "wire_mode":"continuous", "requires_filler_hand":false, "arc_style":"mag"
 }
}

static func get_profile(id:String)->Dictionary:
 return PROFILES.get(id, PROFILES["WIG_ZUSATZ"])
