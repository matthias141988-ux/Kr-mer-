extends Node
class_name WeldingAudio

# Audio events are driven by simulation state; final samples must be licensed/original field recordings.
var arc_player:AudioStreamPlayer
var ambience_player:AudioStreamPlayer
var metal_player:AudioStreamPlayer3D
var arc_mix:=0.0

func bind_players(arc:AudioStreamPlayer, ambience:AudioStreamPlayer, metal:AudioStreamPlayer3D):
 arc_player=arc;ambience_player=ambience;metal_player=metal

func update_arc(delta:float, process:String, active:bool, stability:float, current_a:float):
 var target=1.0 if active else 0.0
 arc_mix=lerp(arc_mix,target,clamp(delta*18.0,0.0,1.0))
 if arc_player:
  arc_player.volume_db=linear_to_db(max(arc_mix,0.001))
  arc_player.pitch_scale=clamp(0.88+current_a/900.0+(1.0-stability)*0.08,0.8,1.2)

func event_name(process:String, filler_contact:bool, arc_break:bool)->String:
 if arc_break:return "arc_break"
 if filler_contact:return "filler_dip"
 match process:
  "WIG_ZUSATZ","WIG_AUTOGEN": return "tig_arc"
  "MIG": return "mig_arc"
  "MAG": return "mag_arc"
  "E_HAND": return "stick_arc"
 return "workshop_ambience"
