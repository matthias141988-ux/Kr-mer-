extends Node3D
class_name HandRigController

@export var torch_hand: Node3D
@export var filler_hand: Node3D
@export var torch_tip: Node3D
@export var filler_tip: Node3D

var torch_home:=Transform3D.IDENTITY
var filler_home:=Transform3D.IDENTITY
var filler_dip:=0.0
var hand_smoothing:=14.0

func _ready():
 if torch_hand: torch_home=torch_hand.transform
 if filler_hand: filler_home=filler_hand.transform

# Called from the SAME control values that drive welding physics.
# No canned hand animation: what the player does is what the hands show.
func sync_controls(delta:float, torch_motion:Vector3, filler_motion:Vector3, arc_active:bool):
 if torch_hand:
  var target=torch_home
  target.origin += Vector3(torch_motion.x*0.16, torch_motion.y*0.10, torch_motion.z*0.18)
  # visible wrist/burner lean follows combined travel + weave
  target.basis = torch_home.basis.rotated(Vector3.FORWARD, -torch_motion.x*0.16)
  target.basis = target.basis.rotated(Vector3.RIGHT, torch_motion.z*0.10)
  torch_hand.transform=torch_hand.transform.interpolate_with(target,clamp(delta*hand_smoothing,0.0,1.0))

 if filler_hand:
  var target2=filler_home
  target2.origin += Vector3(filler_motion.x*0.12, filler_motion.y*0.08, filler_motion.z*0.18)
  # filler dip physically advances the hand/rod toward the pool
  target2.origin.z -= filler_dip*0.12
  filler_hand.transform=filler_hand.transform.interpolate_with(target2,clamp(delta*hand_smoothing,0.0,1.0))

func set_filler_dip(amount:float):
 filler_dip=clamp(amount,0.0,1.0)

func contact_points()->Dictionary:
 return {
  "torch_tip": torch_tip.global_position if torch_tip else Vector3.ZERO,
  "filler_tip": filler_tip.global_position if filler_tip else Vector3.ZERO
 }
