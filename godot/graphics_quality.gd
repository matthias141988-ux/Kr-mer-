extends RefCounted
class_name GraphicsQuality
const PRESETS={
 "LOW":{"shadow":false,"arc_shadows":false,"particles":0.35,"reflection":0.35,"scale":0.72},
 "HIGH":{"shadow":true,"arc_shadows":true,"particles":0.8,"reflection":0.8,"scale":0.9},
 "ULTRA":{"shadow":true,"arc_shadows":true,"particles":1.0,"reflection":1.0,"scale":1.0}}
static func choose(fps:float,current:String)->String:
 if fps<42.0 and current=="ULTRA": return "HIGH"
 if fps<34.0: return "LOW"
 return current
