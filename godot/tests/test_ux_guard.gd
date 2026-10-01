extends SceneTree
func _init():
 var guard=load("res://ux_guard.gd")
 var ok=guard.evaluate(Vector2(1920,1080),[Rect2(20,20,360,120)],[Rect2(40,850,220,160),Rect2(1660,850,220,160)])
 assert(ok.passed)
 var bad=guard.evaluate(Vector2(1080,1920),[Rect2(700,300,300,300)],[Rect2(10,10,30,30)])
 assert(not bad.passed)
 assert(guard.control_hint("WIG_ZUSATZ")=="Rechts Brenner · Links Zusatz")
 print("UX_GUARD_TESTS_OK")
 quit()
