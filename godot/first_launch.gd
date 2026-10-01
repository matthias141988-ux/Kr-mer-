extends RefCounted
class_name FirstLaunch
var language:=""
var completed:=false
func needs_language()->bool: return language==""
func choose_language(code:String)->bool:
 if not WeldLocalization.LANGUAGES.has(code): return false
 language=code
 TranslationServer.set_locale(code)
 return true
func finish()->void: completed=true
