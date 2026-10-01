extends RefCounted
class_name WeldLocalization

const LANGUAGES := {
 "de":{"name":"Deutsch","native":"Deutsch"},
 "en":{"name":"English","native":"English"},
 "pl":{"name":"Polish","native":"Polski"},
 "es":{"name":"Spanish","native":"Español"},
 "fr":{"name":"French","native":"Français"},
 "it":{"name":"Italian","native":"Italiano"},
 "pt":{"name":"Portuguese","native":"Português"},
 "tr":{"name":"Turkish","native":"Türkçe"},
 "uk":{"name":"Ukrainian","native":"Українська"},
 "ro":{"name":"Romanian","native":"Română"},
 "cs":{"name":"Czech","native":"Čeština"},
 "nl":{"name":"Dutch","native":"Nederlands"},
 "zh":{"name":"Chinese","native":"中文"},
 "ja":{"name":"Japanese","native":"日本語"},
 "ko":{"name":"Korean","native":"한국어"}
}
const BASE := {
 "de":{"welcome":"Willkommen bei WeldQuest","tutorial":"Tutorial starten","direct":"Direkt schweißen","theory":"Theorie","settings":"Einstellungen"},
 "en":{"welcome":"Welcome to WeldQuest","tutorial":"Start tutorial","direct":"Start welding","theory":"Theory","settings":"Settings"}
}
static func tr_key(lang:String,key:String)->String:
 return BASE.get(lang,BASE["en"]).get(key,BASE["en"].get(key,key))
