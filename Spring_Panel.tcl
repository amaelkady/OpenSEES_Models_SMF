########################################################################################################
# Spring_Panel.tcl
#
# SubRoutine to construct a rotational spring with a trilinear hysteretic beahviour (Panel Zone Spring)                                                            
#                                                                                                      
# Input Arguments
# 	P_Elm			Element ID
# 	iNode			Node i ID
# 	jNode			Node j ID
# 	E				Young's Modulus
# 	Fy				Expected Yield Stress
# 	tp				Column Web + Doubler Plates Thickness
# 	d_Col			Column Depth
# 	d_Beam			Beam Depth
# 	tf_Col			Column Flange Thickness
# 	bf_Col			Beam Flange Thickness
# 	SH_Panel		Strain Hardeing (ratio of hardening-to-elastic slopes)
# 	Response_ID		ID for Panel Zone Response: 0 --> Interior Steel Panel Zone with Composite Action
#												1 --> Exterior Steel Panel Zone with Composite Action
#												2 --> Bare Steel Interior/Exterior Steel Panel Zone
# 	transfTag		Geometric Transformation ID
# 	Units			1 --> mm 
#					2 --> inches	
#                                                                                                      
# Written by: Ahmed Elkady
# Created:       02/07/2012
#
########################################################################################################


proc Spring_Panel {P_Elm Node_i Node_j E Fy tp d_Col d_Beam tf_Col bf_Col SH_Panel Response_ID transfTag Units} {

if {$Units == 1} {
	set ts 	 102.; 	#Slab Thickness Above Rib (mm)
	set trib 89.;	#Steel Deck Rib Depth (mm)
} else {
	set ts 	 4.00; 	#Slab Thickness Above Rib (in)
	set trib 3.5;	#Steel Deck Rib Depth (in)
}

 # Floor Deck Parameters for Composite Action Consideration
 set d_BeamP [expr $d_Beam + $trib + $ts - 0.5 * $ts]; # Effective Depth in Positive Moment
 set d_BeamN $d_Beam; 								   # Effective Depth in Negative Moment
 
 set Vy [expr 0.55 * $Fy * $d_Col * $tp];  # Yield Shear Force
 set G [expr $E/(2.0 * (1.0 + 0.30))];     # Shear Modulus
 set Ke [expr 0.95 * $G * $tp * $d_Col];   # Elastic Shear Stiffness
 
 set gamma1_y [expr $Vy/$Ke]; 
 set gamma2_y [expr 4.0 * $gamma1_y];  
 set gamma3_y [expr 100.0 * $gamma1_y];

 set KpP  [expr 0.95 * $G * $bf_Col * ($tf_Col * $tf_Col) / $d_BeamP]; # Plastic Stiffness
 set M1yP [expr $gamma1_y * ($Ke * $d_BeamP)];
 set M2yP [expr $M1yP + ($KpP * $d_BeamP) * ($gamma2_y - $gamma1_y)];
 set M3yP [expr $M2yP + ($SH_Panel * $Ke * $d_BeamP) * ($gamma3_y - $gamma2_y)];
 
 set KpN  [expr 0.95 * $G * $bf_Col * ($tf_Col * $tf_Col) / $d_BeamN]; # Plastic Stiffness
 set M1yN [expr $gamma1_y * ($Ke * $d_BeamN)];
 set M2yN [expr $M1yN + ($KpN * $d_BeamN) * ($gamma2_y - $gamma1_y)];
 set M3yN [expr $M2yN + ($SH_Panel * $Ke * $d_BeamN) * ($gamma3_y - $gamma2_y)];
 
 set Th_U_P   0.3;
 set Th_U_N  -0.3;

 set Dummy_ID [expr   12 * $P_Elm]; 
 
 # Hysteretic Material without pinching and damage
 # uniaxialMaterial Hysteretic $matTag $s1p $e1p $s2p $e2p <$s3p $e3p> $s1n $e1n $s2n $e2n <$s3n $e3n> $pinchX $pinchY $damage1 $damage2

 # Composite Interior Steel Panel Zone
 if { $Response_ID == 0.0 } {
	 uniaxialMaterial Hysteretic $Dummy_ID  $M1yP $gamma1_y  $M2yP $gamma2_y $M3yP $gamma3_y [expr -$M1yP] [expr -$gamma1_y] [expr -$M2yP] [expr -$gamma2_y] [expr -$M3yP] [expr -$gamma3_y] 0.25 0.75 0. 0. 0.
	 uniaxialMaterial MinMax $P_Elm $Dummy_ID -min $Th_U_N -max $Th_U_P
 }
 
 # Composite Exterior Steel Panel Zone
 if { $Response_ID == 1.0 } {
	 uniaxialMaterial Hysteretic $Dummy_ID  $M1yP $gamma1_y  $M2yP $gamma2_y $M3yP $gamma3_y [expr -$M1yN] [expr -$gamma1_y] [expr -$M2yN] [expr -$gamma2_y] [expr -$M3yN] [expr -$gamma3_y] 0.25 0.75 0. 0. 0.
	 uniaxialMaterial MinMax $P_Elm $Dummy_ID -min $Th_U_N -max $Th_U_P
 }
 
 # Bare Steel Interior/Exterior Steel Panel Zone
 if { $Response_ID == 2.0 } {
	 uniaxialMaterial Hysteretic $Dummy_ID  $M1yN $gamma1_y  $M2yN $gamma2_y $M3yN $gamma3_y [expr -$M1yN] [expr -$gamma1_y] [expr -$M2yN] [expr -$gamma2_y] [expr -$M3yN] [expr -$gamma3_y] 0.25 0.75 0. 0. 0.
	 uniaxialMaterial MinMax $P_Elm $Dummy_ID -min $Th_U_N -max $Th_U_P
 } 
 
 element zeroLength $P_Elm $Node_i $Node_j -mat $P_Elm -dir 6
 
}