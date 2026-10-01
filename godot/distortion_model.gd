extends RefCounted
class_name DistortionModel

# Training model: distortion evolves from heat input, restraint, geometry and weld sequence.
var longitudinal:=0.0
var angular:=0.0
var transverse:=0.0
var residual_heat:=0.0

func step(delta:float, heat:float, travel_speed:float, thickness_mm:float, restraint:float, side_bias:float)->Dictionary:
 residual_heat=lerp(residual_heat,heat,clamp(delta*1.8,0.0,1.0))
 var thin_factor=clamp(3.0/max(thickness_mm,0.5),0.25,3.0)
 var slow_factor=clamp(90.0/max(travel_speed,15.0),0.45,2.2)
 var free_factor=1.0-clamp(restraint,0.0,0.95)
 longitudinal += residual_heat*thin_factor*slow_factor*free_factor*delta*0.0018
 angular += residual_heat*thin_factor*side_bias*free_factor*delta*0.0024
 transverse += residual_heat*thin_factor*free_factor*delta*0.0008
 return {"longitudinal":longitudinal,"angular":angular,"transverse":transverse,"heat":residual_heat}

func cooling_step(delta:float, ambient_factor:float=1.0):
 residual_heat=move_toward(residual_heat,0.0,delta*0.08*ambient_factor)
