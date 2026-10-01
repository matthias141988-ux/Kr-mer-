extends RefCounted
class_name SpecialFeatures
const FEATURES={
 "ARC_VISION":{"name":"Arc Vision","desc":"Zeitlupe nach dem Run: Brennerweg, Pendelpfad und Zusatz-Tupfer über der Naht."},
 "THERMAL_REPLAY":{"name":"Thermal Replay","desc":"Zeigt die simulierte Wärmeentwicklung und Abkühlung entlang der Naht."},
 "GHOST_TORCH":{"name":"Ghost Torch","desc":"Transparenter Idealpfad im Trainingsmodus; in Prüfungen deaktiviert."},
 "CUT_VIEW":{"name":"Virtual Cut","desc":"Virtueller Querschliff mit Einbrand-, Nahtform- und Fehleranalyse."},
 "HELM_CAM":{"name":"Helmet Cam","desc":"Wiederholung aus der Helm-Innenansicht ohne störendes Trainings-HUD."},
 "X_RAY_TRAINING":{"name":"NDT View","desc":"Didaktische Anzeige simulierter innerer Unregelmäßigkeiten."}}
static func allowed_in_exam(id:String)->bool:
 return id in ["HELM_CAM"]
