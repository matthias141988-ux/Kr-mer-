extends RefCounted
class_name WeldLeaderboard

var entries:Array[Dictionary]=[]

func submit(player:String, process:String, position:String, score:float, assisted:bool)->void:
 entries.append({"player":player,"process":process,"position":position,
 "score":score,"assisted":assisted,"verified":not assisted})
 entries.sort_custom(func(a,b): return a.score>b.score)

func top(process:String="",position:String="",limit:int=20)->Array[Dictionary]:
 var out:Array[Dictionary]=[]
 for e in entries:
  if (process=="" or e.process==process) and (position=="" or e.position==position):
   out.append(e)
   if out.size()>=limit: break
 return out
