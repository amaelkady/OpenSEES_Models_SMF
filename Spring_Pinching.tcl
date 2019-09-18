########################################################################################################
# Spring_Pinching.tcl 
#                                    
# SubRoutine to model a rotational spring representing the behaviour of shear-tab Connections
#
# Reference: 
# Elkady, A. and D. G. Lignos (2015). "Effect of Gravity Framing on the Overstrength and Collapse Capacity
# 	of Steel Frame Buildings with Perimeter Special Moment Frames." Earthquake Engineering & Structural 
#	Dynamics 44(8): 1289–1307.
#
#######################################################################################################
#
# Input Arguments
# 	SpringID		Spring ID
# 	Node_i			Node i ID
# 	Node_j			Node j ID
# 	Mp				Effective plastic strength of the gravity beam
# 	gap				Gap distance between beam end and column flange
# 	ResponseID		0 --> Bare Shear Connection
#					1 --> Composite Shear Connection
#					2 --> Composite Shear Connection with Stiffeneing due to Binding
#
# Written by: Ahmed Elkady 
# Created:       09/09/2013
# Last Modified: 09/09/2013
########################################################################################################


proc Spring_Pinching {SpringID Node_i Node_j M_p gap ResponseID} {

if {$ResponseID == 0} {
	set M_max_pos [expr  0.121* $M_p];
	set M_max_neg [expr  0.121* $M_p];
	set M1_P [expr 0.521 * $M_max_pos]; set M1_N [expr -0.521 * $M_max_neg];
	set M2_P [expr 0.967 * $M_max_pos]; set M2_N [expr -0.967 * $M_max_neg];
	set M3_P [expr 1.000 * $M_max_pos]; set M3_N [expr -1.000 * $M_max_neg];
	set M4_P [expr 0.901 * $M_max_pos]; set M4_N [expr -0.901 * $M_max_neg];
	set Th_1_P 0.0045; set Th_1_N -0.0045;
	set Th_2_P 0.0465; set Th_2_N -0.0465;
	set Th_3_P 0.0750; set Th_3_N -0.0750;
	set Th_4_P 0.1000; set Th_4_N -0.1000;
	set rDispP  0.57; set rDispN  0.57;
	set rForceP 0.40; set rForceN 0.40;
	set uForceP 0.05; set uForceN 0.05;
	set gK1 0.0; set gD1 0.0; set gF1 0.0;
	set gK2 0.0; set gD2 0.0; set gF2 0.0;
	set gK3 0.0; set gD3 0.0; set gF3 0.0;
	set gK4 0.0; set gD4 0.0; set gF4 0.0;
	set gKLim 0.2; set gDLim 0.1; set gFLim 0.0;
	set gE 10;
	set dmgType "energy";
	set Th_U_P  [expr   $gap  + 0.000];
	set Th_U_N  [expr   -$gap - 0.000];
}

if {$ResponseID == 1} {
	set M_max_pos [expr 0.35* $M_p];
	set M_max_neg [expr 0.64*0.35* $M_p];
	set M1_P [expr 0.250 * $M_max_pos]; set M1_N [expr -0.250 * $M_max_pos];
	set M2_P [expr 1.000 * $M_max_pos]; set M2_N [expr -1.000 * $M_max_neg];
	set M3_P [expr 1.001 * $M_max_pos]; set M3_N [expr -1.001 * $M_max_neg];
	set M4_P [expr 0.530 * $M_max_pos]; set M4_N [expr -0.540 * $M_max_neg];
	set Th_1_P 0.0042; set Th_1_N -0.0042;
	set Th_2_P 0.0200; set Th_2_N -0.0110;
	set Th_3_P 0.0390; set Th_3_N -0.0300;
	set Th_4_P 0.0400; set Th_4_N -0.0550;
	set rDispP  0.40; set rDispN  0.50;
	set rForceP 0.13; set rForceN 0.53;
	set uForceP 0.01; set uForceN 0.05;
	set gK1 0.0; set gD1 0.0; set gF1 0.0;
	set gK2 0.0; set gD2 0.0; set gF2 0.0;
	set gK3 0.0; set gD3 0.0; set gF3 0.0;
	set gK4 0.0; set gD4 0.0; set gF4 0.0;
	set gKLim 0.30; set gDLim 0.05; set gFLim 0.05;
	set gE 10;
	set dmgType "energy";
	set Th_U_P  [expr   $gap + 0.000];
	set Th_U_N  [expr  -$gap - 0.000];
}

if {$ResponseID == 2} {
	set M_max_pos [expr 0.35* $M_p];
	set M_max_neg [expr 0.49*0.35* $M_p];
	set M1_P [expr 0.250 * $M_max_pos]; set M1_N [expr -1.000 * $M_max_neg];
	set M2_P [expr 1.000 * $M_max_pos]; set M2_N [expr -1.001 * $M_max_neg];
	set M3_P [expr 1.001 * $M_max_pos]; set M3_N [expr -2.353 * $M_max_neg]; 
	set M4_P [expr 0.530 * $M_max_pos]; set M4_N [expr -2.350 * $M_max_neg]; 
	set Th_1_P 0.0042; set Th_1_N -0.0080;
	set Th_2_P 0.0200; set Th_2_N [expr -1.0 * $gap];
	set Th_3_P 0.0390; set Th_3_N [expr -1.0 * $gap - 0.015];
	set Th_4_P 0.0400; set Th_4_N [expr -1.0 * $gap - 0.040];
	set rDispP  0.40; set rDispN  0.50;
	set rForceP 0.13; set rForceN 0.53;
	set uForceP 0.01; set uForceN 0.05;
	set gK1 0.0; set gD1 0.0; set gF1 0.0;
	set gK2 0.0; set gD2 0.0; set gF2 0.0;
	set gK3 0.0; set gD3 0.0; set gF3 0.0;
	set gK4 0.0; set gD4 0.0; set gF4 0.0;
	set gKLim 0.30; set gDLim 0.05; set gFLim 0.05;
	set gE 10;
	set dmgType "energy";
	set Th_U_P  [expr   $gap + 0.040];
	set Th_U_N  [expr  -$gap - 0.040];
}

set Dummy_ID [expr   12 * $SpringID]; 
uniaxialMaterial Pinching4 $Dummy_ID $M1_P $Th_1_P $M2_P $Th_2_P $M3_P $Th_3_P $M4_P $Th_4_P     $M1_N $Th_1_N $M2_N $Th_2_N $M3_N $Th_3_N $M4_N $Th_4_N    $rDispP $rForceP $uForceP   $rDispN $rForceN $uForceN   $gK1 $gK2 $gK3 $gK4 $gKLim     $gD1 $gD2 $gD3 $gD4 $gDLim   $gF1 $gF2 $gF3 $gF4 $gFLim     $gE $dmgType
uniaxialMaterial MinMax $SpringID $Dummy_ID -min $Th_U_N -max $Th_U_P
# Define Zero Length Rotational Spring
element zeroLength $SpringID $Node_i $Node_j  -mat $SpringID -dir 6;

if {$ResponseID == 2} {
	# Stiffening Spring
	set Esc [expr $M_max_pos / $Th_2_P];
	set My [expr  0.71 * $M_max_pos];
	set eta 0.0001;
	set damage "damage"
	set SpringID2 [expr  $SpringID+8];
	set Dummy_ID2 [expr   $SpringID2+1]; 
	uniaxialMaterial ElasticPPGap $Dummy_ID2 $Esc $My $gap $eta $damage
	uniaxialMaterial MinMax $SpringID2 $Dummy_ID2 -max [expr   $gap + 0.040]
	element zeroLength $SpringID2 $Node_i $Node_j  -mat $SpringID2 -dir 6;
}

}