extends RefCounted
class_name InstructorSignoff

static func create(result_id:String, trainee:String, instructor:String, note:String)->Dictionary:
 return {"result_id":result_id,"trainee":trainee,"instructor":instructor,
 "note":note,"signed_at":Time.get_datetime_string_from_system(),
 "type":"TRAINING_SIGNOFF",
 "disclaimer":"Interne Trainingsfreigabe; kein Ersatz für gesetzlich/normativ erforderliche Prüfbescheinigungen."}
