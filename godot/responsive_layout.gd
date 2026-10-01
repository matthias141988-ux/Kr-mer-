extends RefCounted
class_name ResponsiveLayout

enum Mode { PORTRAIT, LANDSCAPE }

static func mode(viewport:Vector2)->Mode:
 return Mode.LANDSCAPE if viewport.x>=viewport.y else Mode.PORTRAIT

static func welding_layout(viewport:Vector2)->Dictionary:
 var landscape:=mode(viewport)==Mode.LANDSCAPE
 if landscape:
  return {
   "mode":"landscape","hud_scale":1.0,
   "left_stick":Vector2(viewport.x*0.14,viewport.y*0.78),
   "right_stick":Vector2(viewport.x*0.86,viewport.y*0.78),
   "safe_weld_rect":Rect2(viewport.x*0.27,viewport.y*0.16,viewport.x*0.46,viewport.y*0.62),
   "panel_mode":"side"
  }
 return {
  "mode":"portrait","hud_scale":0.84,
  "left_stick":Vector2(viewport.x*0.22,viewport.y*0.82),
  "right_stick":Vector2(viewport.x*0.78,viewport.y*0.82),
  "safe_weld_rect":Rect2(viewport.x*0.10,viewport.y*0.16,viewport.x*0.80,viewport.y*0.48),
  "panel_mode":"drawer"
 }

static func camera_fov(viewport:Vector2)->float:
 return 67.0 if mode(viewport)==Mode.LANDSCAPE else 76.0
