# 4-story MRF Building
#############################################################
#############################################################
#                    SPECIFY ANALYSIS OPTIONS               #
#############################################################
#############################################################
set EQ 		  1; 	 # 1 Run dynamic  analysis    0 Do not run dynamiv  analysis 
set PO 		  0; 	 # 1 Run pushover analysis    0 Do not run pushover analysis 
set Animation 1; 	 # 1 Show animation    		  0 Do not show animation
#############################################################
#############################################################
#############################################################
#############################################################
#############################################################
#############################################################
#############################################################
#############################################################
#############################################################
#############################################################
#############################################################
#############################################################
#############################################################
#############################################################
#############################################################
#############################################################
#############################################################
#############################################################
#############################################################
#############################################################
#############################################################

# CLEAR ALL;
wipe all;

# BUILD MODEL (2D - 3 DOF/node)
model basic -ndm 2 -ndf 3
geomTransf PDelta 1;

#############################################################
# SOURCING SUBROUTINES
#############################################################

source DisplayModel3D.tcl;
source DisplayPlane.tcl;
source Spring_Panel.tcl;
source Spring_IMK.tcl;
source Spring_Pinching.tcl;
source ConstructPanel.tcl;
source DynamicAnalysisCollapseSolver.tcl;

#############################################################
# Prepare and Create Results Folders
#############################################################

set MainFolder "ResultsMainFolder";
set SubFolder  "ResultsSubFolder";
file mkdir $MainFolder;
cd $MainFolder
file mkdir $SubFolder;
cd ..

####################################################################################################
#                                              INPUT                                               #
####################################################################################################

# FRAME CENTERLINE DIMENSIONS
set NStory  4;
set NBay  3;

# MATERIAL PROPERTIES
set E  29000.0; 
set Fy [expr 55.000000 * 1.000000];

# PANEL ZONE PARAMETERS
set SH_Panel 0.03;
set A_Stiff 1000.0;
set I_Stiff 100000.0;

# Composite Beam Factor
puts "This is the CG model"
set Composite 1;
set Comp_I    1.4;
set Comp_I_GC 1.4;

# Basic Materials
uniaxialMaterial Elastic  99 1000000000.;  #Rigid Material 
uniaxialMaterial Elastic  9  1.e-9; 		#Flexible Material 

####################################################################################################
#                                          PRE-CALCULATIONS                                        #
####################################################################################################

# REDUCED BEAM SECTION LENGTH (from column face to RBS center)
set L_RBS5  [expr  0.625 *  6.56 +  0.750 * 21.10/2.];
set L_RBS4  [expr  0.625 *  6.56 +  0.750 * 21.10/2.];
set L_RBS3  [expr  0.625 *  8.30 +  0.750 * 21.20/2.];
set L_RBS2  [expr  0.625 *  8.30 +  0.750 * 21.20/2.];

# FRAME GRID LINES
set HBuilding 648.00;
set Floor5  648.00;
set Floor4  492.00;
set Floor3  336.00;
set Floor2  180.00;
set Floor1 0.0;

set Axis1 0.0;
set Axis2 240.00;
set Axis3 480.00;
set Axis4 720.00;
set Axis5 960.00;
set Axis6 1200.00;
set WFrame 720.00;

####################################################################################################
#                                				NODES       				                       #
####################################################################################################

#SUPPORT NODES
node 11   $Axis1  $Floor1; node 12   $Axis2  $Floor1; node 13   $Axis3  $Floor1; node 14   $Axis4  $Floor1; node 15   $Axis5  $Floor1; node 16   $Axis6  $Floor1; 

# LEANING/GRAVITY COLUMN NODES
node 55   $Axis5  $Floor5; node 56   $Axis6  $Floor5; 
node 45   $Axis5  $Floor4; node 46   $Axis6  $Floor4; 
node 35   $Axis5  $Floor3; node 36   $Axis6  $Floor3; 
node 25   $Axis5  $Floor2; node 26   $Axis6  $Floor2; 

# MRF BEAM NODES
node 514   [expr $Axis1 + $L_RBS5 + 23.70/2] $Floor5; node 522   [expr $Axis2 - $L_RBS5 - 23.70/2] $Floor5; node 524   [expr $Axis2 + $L_RBS5 + 23.70/2] $Floor5; node 532   [expr $Axis3 - $L_RBS5 - 23.70/2] $Floor5; node 534   [expr $Axis3 + $L_RBS5 + 23.70/2] $Floor5; node 542   [expr $Axis4 - $L_RBS5 - 23.70/2] $Floor5; 
node 414   [expr $Axis1 + $L_RBS4 + 24.50/2] $Floor4; node 422   [expr $Axis2 - $L_RBS4 - 24.50/2] $Floor4; node 424   [expr $Axis2 + $L_RBS4 + 24.50/2] $Floor4; node 432   [expr $Axis3 - $L_RBS4 - 24.50/2] $Floor4; node 434   [expr $Axis3 + $L_RBS4 + 24.50/2] $Floor4; node 442   [expr $Axis4 - $L_RBS4 - 24.50/2] $Floor4; 
node 314   [expr $Axis1 + $L_RBS3 + 24.50/2] $Floor3; node 322   [expr $Axis2 - $L_RBS3 - 24.50/2] $Floor3; node 324   [expr $Axis2 + $L_RBS3 + 24.50/2] $Floor3; node 332   [expr $Axis3 - $L_RBS3 - 24.50/2] $Floor3; node 334   [expr $Axis3 + $L_RBS3 + 24.50/2] $Floor3; node 342   [expr $Axis4 - $L_RBS3 - 24.50/2] $Floor3; 
node 214   [expr $Axis1 + $L_RBS2 + 24.50/2] $Floor2; node 222   [expr $Axis2 - $L_RBS2 - 24.50/2] $Floor2; node 224   [expr $Axis2 + $L_RBS2 + 24.50/2] $Floor2; node 232   [expr $Axis3 - $L_RBS2 - 24.50/2] $Floor2; node 234   [expr $Axis3 + $L_RBS2 + 24.50/2] $Floor2; node 242   [expr $Axis4 - $L_RBS2 - 24.50/2] $Floor2; 

# MRF COLUMN NODES
node 511  $Axis1 [expr $Floor5 - 21.10/2]; node 521  $Axis2 [expr $Floor5 - 21.10/2]; node 531  $Axis3 [expr $Floor5 - 21.10/2]; node 541  $Axis4 [expr $Floor5 - 21.10/2]; 
node 413  $Axis1 [expr $Floor4 + 21.10/2]; node 423  $Axis2 [expr $Floor4 + 21.10/2]; node 433  $Axis3 [expr $Floor4 + 21.10/2]; node 443  $Axis4 [expr $Floor4 + 21.10/2]; 
node 411  $Axis1 [expr $Floor4 - 21.10/2]; node 421  $Axis2 [expr $Floor4 - 21.10/2]; node 431  $Axis3 [expr $Floor4 - 21.10/2]; node 441  $Axis4 [expr $Floor4 - 21.10/2]; 
node 313  $Axis1 [expr $Floor3 + 21.20/2]; node 323  $Axis2 [expr $Floor3 + 21.20/2]; node 333  $Axis3 [expr $Floor3 + 21.20/2]; node 343  $Axis4 [expr $Floor3 + 21.20/2]; 
node 311  $Axis1 [expr $Floor3 - 21.20/2]; node 321  $Axis2 [expr $Floor3 - 21.20/2]; node 331  $Axis3 [expr $Floor3 - 21.20/2]; node 341  $Axis4 [expr $Floor3 - 21.20/2]; 
node 213  $Axis1 [expr $Floor2 + 21.20/2]; node 223  $Axis2 [expr $Floor2 + 21.20/2]; node 233  $Axis3 [expr $Floor2 + 21.20/2]; node 243  $Axis4 [expr $Floor2 + 21.20/2]; 
node 211  $Axis1 [expr $Floor2 - 21.20/2]; node 221  $Axis2 [expr $Floor2 - 21.20/2]; node 231  $Axis3 [expr $Floor2 - 21.20/2]; node 241  $Axis4 [expr $Floor2 - 21.20/2]; 
node 113  $Axis1 $Floor1; node 123  $Axis2 $Floor1; node 133  $Axis3 $Floor1; node 143  $Axis4 $Floor1; 

# BEAM PLASTIC HINGE NODES
node 5140   [expr $Axis1 + $L_RBS5 + 23.70/2] $Floor5; node 5220   [expr $Axis2 - $L_RBS5 - 23.70/2] $Floor5; node 5240   [expr $Axis2 + $L_RBS5 + 23.70/2] $Floor5; node 5320   [expr $Axis3 - $L_RBS5 - 23.70/2] $Floor5; node 5340   [expr $Axis3 + $L_RBS5 + 23.70/2] $Floor5; node 5420   [expr $Axis4 - $L_RBS5 - 23.70/2] $Floor5; 
node 4140   [expr $Axis1 + $L_RBS4 + 24.50/2] $Floor4; node 4220   [expr $Axis2 - $L_RBS4 - 24.50/2] $Floor4; node 4240   [expr $Axis2 + $L_RBS4 + 24.50/2] $Floor4; node 4320   [expr $Axis3 - $L_RBS4 - 24.50/2] $Floor4; node 4340   [expr $Axis3 + $L_RBS4 + 24.50/2] $Floor4; node 4420   [expr $Axis4 - $L_RBS4 - 24.50/2] $Floor4; 
node 3140   [expr $Axis1 + $L_RBS3 + 24.50/2] $Floor3; node 3220   [expr $Axis2 - $L_RBS3 - 24.50/2] $Floor3; node 3240   [expr $Axis2 + $L_RBS3 + 24.50/2] $Floor3; node 3320   [expr $Axis3 - $L_RBS3 - 24.50/2] $Floor3; node 3340   [expr $Axis3 + $L_RBS3 + 24.50/2] $Floor3; node 3420   [expr $Axis4 - $L_RBS3 - 24.50/2] $Floor3; 
node 2140   [expr $Axis1 + $L_RBS2 + 24.50/2] $Floor2; node 2220   [expr $Axis2 - $L_RBS2 - 24.50/2] $Floor2; node 2240   [expr $Axis2 + $L_RBS2 + 24.50/2] $Floor2; node 2320   [expr $Axis3 - $L_RBS2 - 24.50/2] $Floor2; node 2340   [expr $Axis3 + $L_RBS2 + 24.50/2] $Floor2; node 2420   [expr $Axis4 - $L_RBS2 - 24.50/2] $Floor2; 

# COLUMN SPLICE NODES
node 103170 $Axis1 [expr ($Floor3+$Floor4)/2]; node 103270 $Axis2 [expr ($Floor3+$Floor4)/2]; node 103370 $Axis3 [expr ($Floor3+$Floor4)/2]; node 103470 $Axis4 [expr ($Floor3+$Floor4)/2]; node 103570 $Axis5 [expr ($Floor3+$Floor4)/2]; node 103670 $Axis6 [expr ($Floor3+$Floor4)/2]; 

# EGF BEAM NODES
node 554  $Axis5  $Floor5; node 562  $Axis6  $Floor5; 
node 454  $Axis5  $Floor4; node 462  $Axis6  $Floor4; 
node 354  $Axis5  $Floor3; node 362  $Axis6  $Floor3; 
node 254  $Axis5  $Floor2; node 262  $Axis6  $Floor2; 

# EGF COLUMN NODES
node 551  $Axis5  $Floor5; node 561  $Axis6  $Floor5; 
node 453  $Axis5  $Floor4; node 463  $Axis6  $Floor4; 
node 451  $Axis5  $Floor4; node 461  $Axis6  $Floor4; 
node 353  $Axis5  $Floor3; node 363  $Axis6  $Floor3; 
node 351  $Axis5  $Floor3; node 361  $Axis6  $Floor3; 
node 253  $Axis5  $Floor2; node 263  $Axis6  $Floor2; 
node 251  $Axis5  $Floor2; node 261  $Axis6  $Floor2; 
node 153  $Axis5  $Floor1; node 163  $Axis6  $Floor1; 

# PANEL ZONE NODES AND ELASTIC ELEMENTS
# CROSS PANEL ZONE NODES AND ELASTIC ELEMENTS
# Command Syntax; 
# ConstructPanel Axis Floor X_Axis Y_Floor E A_Panel I_Panel d_Col d_Beam transfTag 
ConstructPanel  1 5 $Axis1 $Floor5 $E $A_Stiff $I_Stiff 23.70 21.10 1; ConstructPanel  2 5 $Axis2 $Floor5 $E $A_Stiff $I_Stiff 23.70 21.10 1; ConstructPanel  3 5 $Axis3 $Floor5 $E $A_Stiff $I_Stiff 23.70 21.10 1; ConstructPanel  4 5 $Axis4 $Floor5 $E $A_Stiff $I_Stiff 23.70 21.10 1; 
ConstructPanel  1 4 $Axis1 $Floor4 $E $A_Stiff $I_Stiff 23.70 21.10 1; ConstructPanel  2 4 $Axis2 $Floor4 $E $A_Stiff $I_Stiff 23.70 21.10 1; ConstructPanel  3 4 $Axis3 $Floor4 $E $A_Stiff $I_Stiff 23.70 21.10 1; ConstructPanel  4 4 $Axis4 $Floor4 $E $A_Stiff $I_Stiff 23.70 21.10 1; 
ConstructPanel  1 3 $Axis1 $Floor3 $E $A_Stiff $I_Stiff 24.50 21.20 1; ConstructPanel  2 3 $Axis2 $Floor3 $E $A_Stiff $I_Stiff 24.50 21.20 1; ConstructPanel  3 3 $Axis3 $Floor3 $E $A_Stiff $I_Stiff 24.50 21.20 1; ConstructPanel  4 3 $Axis4 $Floor3 $E $A_Stiff $I_Stiff 24.50 21.20 1; 
ConstructPanel  1 2 $Axis1 $Floor2 $E $A_Stiff $I_Stiff 24.50 21.20 1; ConstructPanel  2 2 $Axis2 $Floor2 $E $A_Stiff $I_Stiff 24.50 21.20 1; ConstructPanel  3 2 $Axis3 $Floor2 $E $A_Stiff $I_Stiff 24.50 21.20 1; ConstructPanel  4 2 $Axis4 $Floor2 $E $A_Stiff $I_Stiff 24.50 21.20 1; 

####################################################################################################
#                                   		PANEL ZONE SPRINGS	                                   #
####################################################################################################

# Command Syntax; 
# Spring_Panel Element_ID Node_i Node_j E Fy tp d_Colum d_Beam tf_Column bf_Column SH_Panel Response_ID transfTag Units
Spring_Panel 905100 405109 405110 $E $Fy [expr  0.43 +  0.00] 23.70 21.10  0.59  7.04  0.03 2 1 2; Spring_Panel 905200 405209 405210 $E $Fy [expr  0.43 +  0.31] 23.70 21.10  0.59  7.04  0.03 0 1 2; Spring_Panel 905300 405309 405310 $E $Fy [expr  0.43 +  0.31] 23.70 21.10  0.59  7.04  0.03 0 1 2; Spring_Panel 905400 405409 405410 $E $Fy [expr  0.43 +  0.00] 23.70 21.10  0.59  7.04  0.03 2 1 2; 
Spring_Panel 904100 404109 404110 $E $Fy [expr  0.43 +  0.00] 23.70 21.10  0.59  7.04  0.03 2 1 2; Spring_Panel 904200 404209 404210 $E $Fy [expr  0.43 +  0.31] 23.70 21.10  0.59  7.04  0.03 0 1 2; Spring_Panel 904300 404309 404310 $E $Fy [expr  0.43 +  0.31] 23.70 21.10  0.59  7.04  0.03 0 1 2; Spring_Panel 904400 404409 404410 $E $Fy [expr  0.43 +  0.00] 23.70 21.10  0.59  7.04  0.03 2 1 2; 
Spring_Panel 903100 403109 403110 $E $Fy [expr  0.55 +  0.00] 24.50 21.20  0.98  9.00  0.03 2 1 2; Spring_Panel 903200 403209 403210 $E $Fy [expr  0.55 +  0.31] 24.50 21.20  0.98  9.00  0.03 0 1 2; Spring_Panel 903300 403309 403310 $E $Fy [expr  0.55 +  0.31] 24.50 21.20  0.98  9.00  0.03 0 1 2; Spring_Panel 903400 403409 403410 $E $Fy [expr  0.55 +  0.00] 24.50 21.20  0.98  9.00  0.03 2 1 2; 
Spring_Panel 902100 402109 402110 $E $Fy [expr  0.55 +  0.00] 24.50 21.20  0.98  9.00  0.03 2 1 2; Spring_Panel 902200 402209 402210 $E $Fy [expr  0.55 +  0.31] 24.50 21.20  0.98  9.00  0.03 0 1 2; Spring_Panel 902300 402309 402310 $E $Fy [expr  0.55 +  0.31] 24.50 21.20  0.98  9.00  0.03 0 1 2; Spring_Panel 902400 402409 402410 $E $Fy [expr  0.55 +  0.00] 24.50 21.20  0.98  9.00  0.03 2 1 2; 

####################################################################################################
#                                     ELASTIC COLUMNS AND BEAMS                                    #
####################################################################################################

# Stiffness Modifiers
set n 10.;
set K44_2 [expr 6*(1+$n)/(2+3*$n)];
set K11_2 [expr (1+2*$n)*$K44_2/(1+$n)];
set K33_2 [expr (1+2*$n)*$K44_2/(1+$n)];
set K44_1 [expr 6*$n/(1+3*$n)];
set K11_1 [expr (1+2*$n)*$K44_1/(1+$n)];
set K33_1 [expr 2*$K44_1];

# COLUMNS
# element ModElasticBeam2d $eleTag $iNode $jNode $A $E $Iz $K11 $K33 $K44 $transfTag 
element ModElasticBeam2d 604100 413 511  18.3000 $E [expr ($n+1)/$n*1560.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 604200 423 521  18.3000 $E [expr ($n+1)/$n*1560.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 604300 433 531  18.3000 $E [expr ($n+1)/$n*1560.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 604400 443 541  18.3000 $E [expr ($n+1)/$n*1560.0000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 603102 103170 411 18.3000 $E [expr ($n+1)/$n*1560.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 603202 103270 421 18.3000 $E [expr ($n+1)/$n*1560.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 603302 103370 431 18.3000 $E [expr ($n+1)/$n*1560.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 603402 103470 441 18.3000 $E [expr ($n+1)/$n*1560.0000] $K33_1 $K11_1 $K44_1 1;  
element ModElasticBeam2d 603101 313 103170 30.3000 $E [expr ($n+1)/$n*3000.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 603201 323 103270 30.3000 $E [expr ($n+1)/$n*3000.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 603301 333 103370 30.3000 $E [expr ($n+1)/$n*3000.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 603401 343 103470 30.3000 $E [expr ($n+1)/$n*3000.0000] $K33_1 $K11_1 $K44_1 1;  
element ModElasticBeam2d 602100 213 311  30.3000 $E [expr ($n+1)/$n*3000.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 602200 223 321  30.3000 $E [expr ($n+1)/$n*3000.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 602300 233 331  30.3000 $E [expr ($n+1)/$n*3000.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 602400 243 341  30.3000 $E [expr ($n+1)/$n*3000.0000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 601100 113 211  30.3000 $E [expr ($n+1)/$n*3000.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 601200 123 221  30.3000 $E [expr ($n+1)/$n*3000.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 601300 133 231  30.3000 $E [expr ($n+1)/$n*3000.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 601400 143 241  30.3000 $E [expr ($n+1)/$n*3000.0000] $K11_2 $K33_2 $K44_2 1; 

# BEAMS
element ModElasticBeam2d 505100 514 522  16.700 $E [expr ($n+1)/$n*0.90*$Comp_I*1170.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 505200 524 532  16.700 $E [expr ($n+1)/$n*0.90*$Comp_I*1170.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 505300 534 542  16.700 $E [expr ($n+1)/$n*0.90*$Comp_I*1170.000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 504100 414 422  16.700 $E [expr ($n+1)/$n*0.90*$Comp_I*1170.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 504200 424 432  16.700 $E [expr ($n+1)/$n*0.90*$Comp_I*1170.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 504300 434 442  16.700 $E [expr ($n+1)/$n*0.90*$Comp_I*1170.000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 503100 314 322  21.500 $E [expr ($n+1)/$n*0.90*$Comp_I*1600.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 503200 324 332  21.500 $E [expr ($n+1)/$n*0.90*$Comp_I*1600.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 503300 334 342  21.500 $E [expr ($n+1)/$n*0.90*$Comp_I*1600.000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 502100 214 222  21.500 $E [expr ($n+1)/$n*0.90*$Comp_I*1600.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 502200 224 232  21.500 $E [expr ($n+1)/$n*0.90*$Comp_I*1600.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 502300 234 242  21.500 $E [expr ($n+1)/$n*0.90*$Comp_I*1600.000] $K11_2 $K33_2 $K44_2 1; 

####################################################################################################
#                                      ELASTIC RBS ELEMENTS                                        #
####################################################################################################

element elasticBeamColumn 505104 405104 5140 14.568 $E [expr 1.4*947.023] 1; element elasticBeamColumn 505202 405202 5220 14.568 $E [expr 1.4*947.023] 1; element elasticBeamColumn 505204 405204 5240 14.568 $E [expr 1.4*947.023] 1; element elasticBeamColumn 505302 405302 5320 14.568 $E [expr 1.4*947.023] 1; element elasticBeamColumn 505304 405304 5340 14.568 $E [expr 1.4*947.023] 1; element elasticBeamColumn 505402 405402 5420 14.568 $E [expr 1.4*947.023] 1; 
element elasticBeamColumn 504104 404104 4140 14.568 $E [expr 1.4*947.023] 1; element elasticBeamColumn 504202 404202 4220 14.568 $E [expr 1.4*947.023] 1; element elasticBeamColumn 504204 404204 4240 14.568 $E [expr 1.4*947.023] 1; element elasticBeamColumn 504302 404302 4320 14.568 $E [expr 1.4*947.023] 1; element elasticBeamColumn 504304 404304 4340 14.568 $E [expr 1.4*947.023] 1; element elasticBeamColumn 504402 404402 4420 14.568 $E [expr 1.4*947.023] 1; 
element elasticBeamColumn 503104 403104 3140 18.429 $E [expr 1.4*1278.471] 1; element elasticBeamColumn 503202 403202 3220 18.429 $E [expr 1.4*1278.471] 1; element elasticBeamColumn 503204 403204 3240 18.429 $E [expr 1.4*1278.471] 1; element elasticBeamColumn 503302 403302 3320 18.429 $E [expr 1.4*1278.471] 1; element elasticBeamColumn 503304 403304 3340 18.429 $E [expr 1.4*1278.471] 1; element elasticBeamColumn 503402 403402 3420 18.429 $E [expr 1.4*1278.471] 1; 
element elasticBeamColumn 502104 402104 2140 18.429 $E [expr 1.4*1278.471] 1; element elasticBeamColumn 502202 402202 2220 18.429 $E [expr 1.4*1278.471] 1; element elasticBeamColumn 502204 402204 2240 18.429 $E [expr 1.4*1278.471] 1; element elasticBeamColumn 502302 402302 2320 18.429 $E [expr 1.4*1278.471] 1; element elasticBeamColumn 502304 402304 2340 18.429 $E [expr 1.4*1278.471] 1; element elasticBeamColumn 502402 402402 2420 18.429 $E [expr 1.4*1278.471] 1; 

###################################################################################################
#                                 COLUMN AND BEAM PLASTIC SPRINGS                                 #
###################################################################################################

# Command Syntax; 
# Spring_IMK SpringID iNode jNode E Fy Ix d tw bf tf htw bftf ry L Ls Lb My PgPye CompositeFLAG MRFconnection Units; 

# BEAM SPRINGS
Spring_IMK 905104 514  5140 $E $Fy [expr $Comp_I*724.046] 21.100 0.405 6.560 0.650 46.300 5.040 1.350 192.275 108.150 96.138 6358.136 0.0 $Composite 0 2; Spring_IMK 905202 5220 522  $E $Fy [expr $Comp_I*724.046] 21.100 0.405 6.560 0.650 46.300 5.040 1.350 192.275 108.150 96.138 6358.136 0.0 $Composite 0 2; Spring_IMK 905204 524  5240 $E $Fy [expr $Comp_I*724.046] 21.100 0.405 6.560 0.650 46.300 5.040 1.350 192.275 108.150 96.138 6358.136 0.0 $Composite 0 2; Spring_IMK 905302 5320 532  $E $Fy [expr $Comp_I*724.046] 21.100 0.405 6.560 0.650 46.300 5.040 1.350 192.275 108.150 96.138 6358.136 0.0 $Composite 0 2; Spring_IMK 905304 534  5340 $E $Fy [expr $Comp_I*724.046] 21.100 0.405 6.560 0.650 46.300 5.040 1.350 192.275 108.150 96.138 6358.136 0.0 $Composite 0 2; Spring_IMK 905402 5420 542  $E $Fy [expr $Comp_I*724.046] 21.100 0.405 6.560 0.650 46.300 5.040 1.350 192.275 108.150 96.138 6358.136 0.0 $Composite 0 2; 
Spring_IMK 904104 414  4140 $E $Fy [expr $Comp_I*724.046] 21.100 0.405 6.560 0.650 46.300 5.040 1.350 191.475 107.750 95.737 6358.136 0.0 $Composite 0 2; Spring_IMK 904202 4220 422  $E $Fy [expr $Comp_I*724.046] 21.100 0.405 6.560 0.650 46.300 5.040 1.350 191.475 107.750 95.737 6358.136 0.0 $Composite 0 2; Spring_IMK 904204 424  4240 $E $Fy [expr $Comp_I*724.046] 21.100 0.405 6.560 0.650 46.300 5.040 1.350 191.475 107.750 95.737 6358.136 0.0 $Composite 0 2; Spring_IMK 904302 4320 432  $E $Fy [expr $Comp_I*724.046] 21.100 0.405 6.560 0.650 46.300 5.040 1.350 191.475 107.750 95.737 6358.136 0.0 $Composite 0 2; Spring_IMK 904304 434  4340 $E $Fy [expr $Comp_I*724.046] 21.100 0.405 6.560 0.650 46.300 5.040 1.350 191.475 107.750 95.737 6358.136 0.0 $Composite 0 2; Spring_IMK 904402 4420 442  $E $Fy [expr $Comp_I*724.046] 21.100 0.405 6.560 0.650 46.300 5.040 1.350 191.475 107.750 95.737 6358.136 0.0 $Composite 0 2; 
Spring_IMK 903104 314  3140 $E $Fy [expr $Comp_I*956.942] 21.200 0.455 8.300 0.740 41.200 5.600 1.810 189.225 107.750 94.612 8378.276 0.0 $Composite 0 2; Spring_IMK 903202 3220 322  $E $Fy [expr $Comp_I*956.942] 21.200 0.455 8.300 0.740 41.200 5.600 1.810 189.225 107.750 94.612 8378.276 0.0 $Composite 0 2; Spring_IMK 903204 324  3240 $E $Fy [expr $Comp_I*956.942] 21.200 0.455 8.300 0.740 41.200 5.600 1.810 189.225 107.750 94.612 8378.276 0.0 $Composite 0 2; Spring_IMK 903302 3320 332  $E $Fy [expr $Comp_I*956.942] 21.200 0.455 8.300 0.740 41.200 5.600 1.810 189.225 107.750 94.612 8378.276 0.0 $Composite 0 2; Spring_IMK 903304 334  3340 $E $Fy [expr $Comp_I*956.942] 21.200 0.455 8.300 0.740 41.200 5.600 1.810 189.225 107.750 94.612 8378.276 0.0 $Composite 0 2; Spring_IMK 903402 3420 342  $E $Fy [expr $Comp_I*956.942] 21.200 0.455 8.300 0.740 41.200 5.600 1.810 189.225 107.750 94.612 8378.276 0.0 $Composite 0 2; 
Spring_IMK 902104 214  2140 $E $Fy [expr $Comp_I*956.942] 21.200 0.455 8.300 0.740 41.200 5.600 1.810 189.225 107.750 94.612 8378.276 0.0 $Composite 0 2; Spring_IMK 902202 2220 222  $E $Fy [expr $Comp_I*956.942] 21.200 0.455 8.300 0.740 41.200 5.600 1.810 189.225 107.750 94.612 8378.276 0.0 $Composite 0 2; Spring_IMK 902204 224  2240 $E $Fy [expr $Comp_I*956.942] 21.200 0.455 8.300 0.740 41.200 5.600 1.810 189.225 107.750 94.612 8378.276 0.0 $Composite 0 2; Spring_IMK 902302 2320 232  $E $Fy [expr $Comp_I*956.942] 21.200 0.455 8.300 0.740 41.200 5.600 1.810 189.225 107.750 94.612 8378.276 0.0 $Composite 0 2; Spring_IMK 902304 234  2340 $E $Fy [expr $Comp_I*956.942] 21.200 0.455 8.300 0.740 41.200 5.600 1.810 189.225 107.750 94.612 8378.276 0.0 $Composite 0 2; Spring_IMK 902402 2420 242  $E $Fy [expr $Comp_I*956.942] 21.200 0.455 8.300 0.740 41.200 5.600 1.810 189.225 107.750 94.612 8378.276 0.0 $Composite 0 2; 

# Column Springs
Spring_IMK 905101 511 405101 $E $Fy 1560.000 23.700 0.430 7.040 0.590 49.700 5.970 1.370 134.900 67.450 134.900  9317.000 0.035 0 2 2; Spring_IMK 905201 521 405201 $E $Fy 1560.000 23.700 0.430 7.040 0.590 49.700 5.970 1.370 134.900 67.450 134.900 9317.000 0.023 0 2 2; Spring_IMK 905301 531 405301 $E $Fy 1560.000 23.700 0.430 7.040 0.590 49.700 5.970 1.370 134.900 67.450 134.900 9317.000 0.023 0 2 2; Spring_IMK 905401 541 405401 $E $Fy 1560.000 23.700 0.430 7.040 0.590 49.700 5.970 1.370 134.900 67.450 134.900 9317.000 0.035 0 2 2; 
Spring_IMK 904103 413 404103 $E $Fy 1560.000 23.700 0.430 7.040 0.590 49.700 5.970 1.370 134.900 67.450 134.900  9317.000 0.035 0 2 2; Spring_IMK 904203 423 404203 $E $Fy 1560.000 23.700 0.430 7.040 0.590 49.700 5.970 1.370 134.900 67.450 134.900 9317.000 0.023 0 2 2; Spring_IMK 904303 433 404303 $E $Fy 1560.000 23.700 0.430 7.040 0.590 49.700 5.970 1.370 134.900 67.450 134.900 9317.000 0.023 0 2 2; Spring_IMK 904403 443 404403 $E $Fy 1560.000 23.700 0.430 7.040 0.590 49.700 5.970 1.370 134.900 67.450 134.900 9317.000 0.035 0 2 2; 
Spring_IMK 904101 411 404101 $E $Fy 1560.000 23.700 0.430 7.040 0.590 49.700 5.970 1.370 134.900 67.450 134.900  9317.000 0.035 0 2 2; Spring_IMK 904201 421 404201 $E $Fy 1560.000 23.700 0.430 7.040 0.590 49.700 5.970 1.370 134.900 67.450 134.900 9317.000 0.023 0 2 2; Spring_IMK 904301 431 404301 $E $Fy 1560.000 23.700 0.430 7.040 0.590 49.700 5.970 1.370 134.900 67.450 134.900 9317.000 0.023 0 2 2; Spring_IMK 904401 441 404401 $E $Fy 1560.000 23.700 0.430 7.040 0.590 49.700 5.970 1.370 134.900 67.450 134.900 9317.000 0.035 0 2 2; 
Spring_IMK 903103 313 403103 $E $Fy 3000.000 24.500 0.550 9.000 0.980 39.200 4.590 1.990 134.850 67.425 134.850 16940.000 0.046 0 2 2; Spring_IMK 903203 323 403203 $E $Fy 3000.000 24.500 0.550 9.000 0.980 39.200 4.590 1.990 134.850 67.425 134.850 16940.000 0.031 0 2 2; Spring_IMK 903303 333 403303 $E $Fy 3000.000 24.500 0.550 9.000 0.980 39.200 4.590 1.990 134.850 67.425 134.850 16940.000 0.031 0 2 2; Spring_IMK 903403 343 403403 $E $Fy 3000.000 24.500 0.550 9.000 0.980 39.200 4.590 1.990 134.850 67.425 134.850 16940.000 0.046 0 2 2; 
Spring_IMK 903101 311 403101 $E $Fy 3000.000 24.500 0.550 9.000 0.980 39.200 4.590 1.990 134.800 67.400 134.800 16940.000 0.046 0 2 2; Spring_IMK 903201 321 403201 $E $Fy 3000.000 24.500 0.550 9.000 0.980 39.200 4.590 1.990 134.800 67.400 134.800 16940.000 0.031 0 2 2; Spring_IMK 903301 331 403301 $E $Fy 3000.000 24.500 0.550 9.000 0.980 39.200 4.590 1.990 134.800 67.400 134.800 16940.000 0.031 0 2 2; Spring_IMK 903401 341 403401 $E $Fy 3000.000 24.500 0.550 9.000 0.980 39.200 4.590 1.990 134.800 67.400 134.800 16940.000 0.046 0 2 2; 
Spring_IMK 902103 213 402103 $E $Fy 3000.000 24.500 0.550 9.000 0.980 39.200 4.590 1.990 158.800 79.400 158.800 16940.000 0.072 0 2 2; Spring_IMK 902203 223 402203 $E $Fy 3000.000 24.500 0.550 9.000 0.980 39.200 4.590 1.990 158.800 79.400 158.800 16940.000 0.048 0 2 2; Spring_IMK 902303 233 402303 $E $Fy 3000.000 24.500 0.550 9.000 0.980 39.200 4.590 1.990 158.800 79.400 158.800 16940.000 0.048 0 2 2; Spring_IMK 902403 243 402403 $E $Fy 3000.000 24.500 0.550 9.000 0.980 39.200 4.590 1.990 158.800 79.400 158.800 16940.000 0.072 0 2 2; 
Spring_IMK 902101 211 402101 $E $Fy 3000.000 24.500 0.550 9.000 0.980 39.200 4.590 1.990 158.800 79.400 158.800 16940.000 0.072 0 2 2; Spring_IMK 902201 221 402201 $E $Fy 3000.000 24.500 0.550 9.000 0.980 39.200 4.590 1.990 158.800 79.400 158.800 16940.000 0.048 0 2 2; Spring_IMK 902301 231 402301 $E $Fy 3000.000 24.500 0.550 9.000 0.980 39.200 4.590 1.990 158.800 79.400 158.800 16940.000 0.048 0 2 2; Spring_IMK 902401 241 402401 $E $Fy 3000.000 24.500 0.550 9.000 0.980 39.200 4.590 1.990 158.800 79.400 158.800 16940.000 0.072 0 2 2; 
Spring_IMK 901103 11  113 	 $E $Fy 3000.000 24.500 0.550 9.000 0.980 39.200 4.590 1.990 169.400 84.700 169.400 16940.000 0.098 0 2 2; Spring_IMK 901203 12  123 	$E $Fy 3000.000 24.500 0.550 9.000 0.980 39.200 4.590 1.990 169.400 84.700 169.400 16940.000 0.065 0 2 2; Spring_IMK 901303 13 133 $E $Fy 3000.000 24.500 0.550 9.000 0.980 39.200 4.590 1.990 169.400 84.700 169.400 16940.000 0.065 0 2 2; Spring_IMK 901403 14 143 $E $Fy 3000.000 24.500 0.550 9.000 0.980 39.200 4.590 1.990 169.400 84.700 169.400 16940.000 0.098 0 2 2; 

####################################################################################################
#                                          RIGID FLOOR LINKS                                       #
####################################################################################################

# COMMAND SYNTAX 
# element truss $ElementID $iNode $jNode $Area $matID
element truss 1005 405404 55 $A_Stiff 99;
element truss 1004 404404 45 $A_Stiff 99;
element truss 1003 403404 35 $A_Stiff 99;
element truss 1002 402404 25 $A_Stiff 99;

####################################################################################################
#                              EQUIVELANT GRAVITY COLUMNS AND BEAMS                                #
####################################################################################################

# Gravity Columns
element elasticBeamColumn  604500  453  551  [expr 53.000 / 2] $E [expr (724.000  + 138.000) / 2] 1; element elasticBeamColumn  604600  463  561  [expr 53.000 / 2] $E [expr (724.000  + 138.000) / 2] 1; 
element elasticBeamColumn  603502  103570 451  [expr 212.000 / 2] $E [expr (724.000  + 138.000) / 2] 1;  element elasticBeamColumn 603602 103670 461  [expr 212.000 / 2] $E [expr (724.000  + 138.000) / 2] 1;  
element elasticBeamColumn  603501  353 103570  [expr 53.000 / 2] $E [expr (724.000  + 476.000) / 2] 1;  element elasticBeamColumn 603601 363 103670  [expr 53.000 / 2] $E [expr (724.000  + 476.000) / 2] 1;  
element elasticBeamColumn  602500  253  351  [expr 53.000 / 2] $E [expr (724.000  + 476.000) / 2] 1; element elasticBeamColumn  602600  263  361  [expr 53.000 / 2] $E [expr (724.000  + 476.000) / 2] 1; 
element elasticBeamColumn  601500  153  251  [expr 53.000 / 2] $E [expr (724.000  + 476.000) / 2] 1; element elasticBeamColumn  601600  163  261  [expr 53.000 / 2] $E [expr (724.000  + 476.000) / 2] 1; 

# Gravity Beams
element elasticBeamColumn  505400 554  562  81.500  $E [expr $Comp_I_GC * 6800.000] 1;
element elasticBeamColumn  504400 454  462  81.500  $E [expr $Comp_I_GC * 6800.000] 1;
element elasticBeamColumn  503400 354  362  81.500  $E [expr $Comp_I_GC * 6800.000] 1;
element elasticBeamColumn  502400 254  262  81.500  $E [expr $Comp_I_GC * 6800.000] 1;

# Gravity Columns Springs
Spring_IMK  905501 55 551 $E $Fy [expr (724.000 + 138.000)/2] 14.000 0.440 14.500 0.710 25.900 10.200 3.700 156.000 78.000 156.000 12971.200 0.0 0 2 2; Spring_IMK  905601 56 561 $E $Fy [expr (724.000 + 138.000)/2] 14.000 0.440 14.500 0.710 25.900 10.200 3.700 156.000 78.000 156.000 12971.200 0.0 0 2 2; 
Spring_IMK  904503 45 453 $E $Fy [expr (724.000 + 138.000)/2] 14.000 0.440 14.500 0.710 25.900 10.200 3.700 156.000 78.000 156.000 12971.200 0.0 0 2 2; Spring_IMK  904603 46 463 $E $Fy [expr (724.000 + 138.000)/2] 14.000 0.440 14.500 0.710 25.900 10.200 3.700 156.000 78.000 156.000 12971.200 0.0 0 2 2; 
Spring_IMK  904501 45 451 $E $Fy [expr (724.000 + 138.000)/2] 14.000 0.440 14.500 0.710 25.900 10.200 3.700 156.000 78.000 156.000 12971.200 0.0 0 2 2; Spring_IMK  904601 46 461 $E $Fy [expr (724.000 + 138.000)/2] 14.000 0.440 14.500 0.710 25.900 10.200 3.700 156.000 78.000 156.000 12971.200 0.0 0 2 2; 
Spring_IMK  903503 35 353 $E $Fy [expr (724.000 + 476.000)/2] 14.000 0.440 14.500 0.710 25.900 10.200 3.700 156.000 78.000 156.000 19190.600 0.0 0 2 2; Spring_IMK  903603 36 363 $E $Fy [expr (724.000 + 476.000)/2] 14.000 0.440 14.500 0.710 25.900 10.200 3.700 156.000 78.000 156.000 19190.600 0.0 0 2 2; 
Spring_IMK  903501 35 351 $E $Fy [expr (724.000 + 476.000)/2] 14.000 0.440 14.500 0.710 25.900 10.200 3.700 156.000 78.000 156.000 19190.600 0.0 0 2 2; Spring_IMK  903601 36 361 $E $Fy [expr (724.000 + 476.000)/2] 14.000 0.440 14.500 0.710 25.900 10.200 3.700 156.000 78.000 156.000 19190.600 0.0 0 2 2; 
Spring_IMK  902503 25 253 $E $Fy [expr (724.000 + 476.000)/2] 14.000 0.440 14.500 0.710 25.900 10.200 3.700 156.000 78.000 156.000 19190.600 0.0 0 2 2; Spring_IMK  902603 26 263 $E $Fy [expr (724.000 + 476.000)/2] 14.000 0.440 14.500 0.710 25.900 10.200 3.700 156.000 78.000 156.000 19190.600 0.0 0 2 2; 
Spring_IMK  902501 25 251 $E $Fy [expr (724.000 + 476.000)/2] 14.000 0.440 14.500 0.710 25.900 10.200 3.700 156.000 78.000 156.000 19190.600 0.0 0 2 2; Spring_IMK  902601 26 261 $E $Fy [expr (724.000 + 476.000)/2] 14.000 0.440 14.500 0.710 25.900 10.200 3.700 156.000 78.000 156.000 19190.600 0.0 0 2 2; 
Spring_IMK  901503 15 153 $E $Fy [expr 476.000/2] 			  14.000 0.440 14.500 0.710 25.900 10.200 3.700 180.000 90.000 180.000 10043.000 0.0 0 2 2; Spring_IMK  901603 16 163 $E $Fy [expr 476.000/2] 			  14.000 0.440 14.500 0.710 25.900 10.200 3.700 180.000 90.000 180.000 10043.000 0.0 0 2 2; 

# GRAVITY BEAMS SPRINGS
set gap 0.08;
Spring_Pinching  905504  55   554 40837.500 $gap 1; Spring_Pinching  905602  562  56  40837.500 $gap 1; 
Spring_Pinching  904504  45   454 40837.500 $gap 1; Spring_Pinching  904602  462  46  40837.500 $gap 1; 
Spring_Pinching  903504  35   354 40837.500 $gap 1; Spring_Pinching  903602  362  36  40837.500 $gap 1; 
Spring_Pinching  902504  25   254 40837.500 $gap 1; Spring_Pinching  902602  262  26  40837.500 $gap 1; 

###################################################################################################
#                                       BOUNDARY CONDITIONS                                       #
###################################################################################################

# MRF Supports
fix 11 1 1 1; fix 12 1 1 1; fix 13 1 1 1; fix 14 1 1 1; 

# EGF Supports
fix 15 1 1 1; fix 16 1 1 1; 

# MRF Floor Movement
equalDOF 405104  405204  1; equalDOF 405104  405304  1; equalDOF 405104  405404  1; 
equalDOF 404104  404204  1; equalDOF 404104  404304  1; equalDOF 404104  404404  1; 
equalDOF 403104  403204  1; equalDOF 403104  403304  1; equalDOF 403104  403404  1; 
equalDOF 402104  402204  1; equalDOF 402104  402304  1; equalDOF 402104  402404  1; 

# MRF Column Joints
equalDOF  405101 	511 1 2; equalDOF  405201 	521 1 2; equalDOF  405301 	531 1 2; equalDOF  405401 	541 1 2; 
equalDOF  404103 	413 1 2; equalDOF  404203 	423 1 2; equalDOF  404303 	433 1 2; equalDOF  404403 	443 1 2; 
equalDOF  403103 	313 1 2; equalDOF  403203 	323 1 2; equalDOF  403303 	333 1 2; equalDOF  403403 	343 1 2; 
equalDOF  402103 	213 1 2; equalDOF  402203 	223 1 2; equalDOF  402303 	233 1 2; equalDOF  402403 	243 1 2; 
equalDOF  404101 	411 1 2; equalDOF  404201 	421 1 2; equalDOF  404301 	431 1 2; equalDOF  404401 	441 1 2; 
equalDOF  403101 	311 1 2; equalDOF  403201 	321 1 2; equalDOF  403301 	331 1 2; equalDOF  403401 	341 1 2; 
equalDOF  402101 	211 1 2; equalDOF  402201 	221 1 2; equalDOF  402301 	231 1 2; equalDOF  402401 	241 1 2; 
equalDOF  11 	113 1 2; equalDOF  12 	123 1 2; equalDOF  13 	133 1 2; equalDOF  14 	143 1 2; 

# MRF Beam Joints
equalDOF  5140 	514 1 2; equalDOF  5220 	522 1 2; equalDOF  5240 	524 1 2; equalDOF  5320 	532 1 2; equalDOF  5340 	534 1 2; equalDOF  5420 	542 1 2; 
equalDOF  4140 	414 1 2; equalDOF  4220 	422 1 2; equalDOF  4240 	424 1 2; equalDOF  4320 	432 1 2; equalDOF  4340 	434 1 2; equalDOF  4420 	442 1 2; 
equalDOF  3140 	314 1 2; equalDOF  3220 	322 1 2; equalDOF  3240 	324 1 2; equalDOF  3320 	332 1 2; equalDOF  3340 	334 1 2; equalDOF  3420 	342 1 2; 
equalDOF  2140 	214 1 2; equalDOF  2220 	222 1 2; equalDOF  2240 	224 1 2; equalDOF  2320 	232 1 2; equalDOF  2340 	234 1 2; equalDOF  2420 	242 1 2; 

# EGF Beam Joints
equalDOF  55 	554 1 2; equalDOF  56 	562 1 2; 
equalDOF  45 	454 1 2; equalDOF  46 	462 1 2; 
equalDOF  35 	354 1 2; equalDOF  36 	362 1 2; 
equalDOF  25 	254 1 2; equalDOF  26 	262 1 2; 

# EGF Column Joints
equalDOF  55 	551 1 2; equalDOF  56 	561 1 2; 
equalDOF  45 	453 1 2; equalDOF  46 	463 1 2; 
equalDOF  35 	353 1 2; equalDOF  36 	363 1 2; 
equalDOF  25 	253 1 2; equalDOF  26 	263 1 2; 
equalDOF  45 	451 1 2; equalDOF  46 	461 1 2; 
equalDOF  35 	351 1 2; equalDOF  36 	361 1 2; 
equalDOF  25 	251 1 2; equalDOF  26 	261 1 2; 
equalDOF  15 	153 1 2; equalDOF  16 	163 1 2; 

###################################################################################################
###################################################################################################
										  puts "Model Built"
###################################################################################################
###################################################################################################

###################################################################################################
#                                             RECORDERS                                           #
###################################################################################################

# Time
recorder Node -file $MainFolder/$SubFolder/Time.out  -time -node 11 -dof 1 disp;

# Story Drift
recorder Drift -file $MainFolder/$SubFolder/SDR_MRF4.out   -iNode 404104 -jNode 405104 -dof 1 -perpDirn 2;
recorder Drift -file $MainFolder/$SubFolder/SDR_MRF3.out   -iNode 403104 -jNode 404104 -dof 1 -perpDirn 2;
recorder Drift -file $MainFolder/$SubFolder/SDR_MRF2.out   -iNode 402104 -jNode 403104 -dof 1 -perpDirn 2;
recorder Drift -file $MainFolder/$SubFolder/SDR_MRF1.out   -iNode 11   	 -jNode 402104 -dof 1 -perpDirn 2;

if {$EQ==1} {
# Floor Accelerations
recorder Node -file $MainFolder/$SubFolder/RFA_MRF5.out   -node 405103 -dof 1 accel;
recorder Node -file $MainFolder/$SubFolder/RFA_MRF4.out   -node 404103 -dof 1 accel;
recorder Node -file $MainFolder/$SubFolder/RFA_MRF3.out   -node 403103 -dof 1 accel;
recorder Node -file $MainFolder/$SubFolder/RFA_MRF2.out   -node 402103 -dof 1 accel;
recorder Node -file $MainFolder/$SubFolder/RFA_MRF1.out   -node 11     -dof 1 accel;
}

###################################################################################################
#                                            NODAL MASS                                           #
###################################################################################################

set g 386.09;
mass 405103 0.2888  1.e-9 1.e-9; mass 405203 0.2888  1.e-9 1.e-9; mass 405303 0.2888  1.e-9 1.e-9; mass 405403 0.2888  1.e-9 1.e-9; mass 55 0.2888  1.e-9 1.e-9; mass 56 0.2888  1.e-9 1.e-9; 
mass 404103 0.3056  1.e-9 1.e-9; mass 404203 0.3056  1.e-9 1.e-9; mass 404303 0.3056  1.e-9 1.e-9; mass 404403 0.3056  1.e-9 1.e-9; mass 45 0.3056  1.e-9 1.e-9; mass 46 0.3056  1.e-9 1.e-9; 
mass 403103 0.3056  1.e-9 1.e-9; mass 403203 0.3056  1.e-9 1.e-9; mass 403303 0.3056  1.e-9 1.e-9; mass 403403 0.3056  1.e-9 1.e-9; mass 35 0.3056  1.e-9 1.e-9; mass 36 0.3056  1.e-9 1.e-9; 
mass 402103 0.3108  1.e-9 1.e-9; mass 402203 0.3108  1.e-9 1.e-9; mass 402303 0.3108  1.e-9 1.e-9; mass 402403 0.3108  1.e-9 1.e-9; mass 25 0.3108  1.e-9 1.e-9; mass 26 0.3108  1.e-9 1.e-9; 

###################################################################################################
#                                        EIGEN VALUE ANALYSIS                                     #
###################################################################################################

set pi [expr 2.0*asin(1.0)];
set nEigen 4;
set lambdaN [eigen [expr $nEigen]];
set lambda1 [lindex $lambdaN 0];
set lambda2 [lindex $lambdaN 1];
set lambda3 [lindex $lambdaN 2];
set lambda4 [lindex $lambdaN 3];
set w1 [expr pow($lambda1,0.5)];
set w2 [expr pow($lambda2,0.5)];
set w3 [expr pow($lambda3,0.5)];
set w4 [expr pow($lambda4,0.5)];
set T1 [expr 2.0*$pi/$w1];
set T2 [expr 2.0*$pi/$w2];
set T3 [expr 2.0*$pi/$w3];
set T4 [expr 2.0*$pi/$w4];
puts "T1 = $T1 s";
puts "T2 = $T2 s";
puts "T3 = $T3 s";

###################################################################################################
###################################################################################################
									  puts "Eigen Analysis Done"
###################################################################################################
###################################################################################################

###################################################################################################
#                                      STATIC GRAVITY ANALYSIS                                    #
###################################################################################################

pattern Plain 100 Linear {

# MRF COLUMNS LOADS
load 405103 0. -34.969 0.; load 405203 0. -23.312 0.; load 405303 0. -23.312 0.; load 405403 0. -34.969 0.; 
load 404103 0. -42.337 0.; load 404203 0. -28.225 0.; load 404303 0. -28.225 0.; load 404403 0. -42.337 0.; 
load 403103 0. -42.337 0.; load 403203 0. -28.225 0.; load 403303 0. -28.225 0.; load 403403 0. -42.337 0.; 
load 402103 0. -43.125 0.; load 402203 0. -28.750 0.; load 402303 0. -28.750 0.; load 402403 0. -43.125 0.; 

# EGC/LC COLUMN LOADS
load 55 0. -310.443794 0.; load 56 0. -310.443794 0.; 
load 45 0. -344.887107 0.; load 46 0. -344.887107 0.; 
load 35 0. -344.887107 0.; load 36 0. -344.887107 0.; 
load 25 0. -346.724595 0.; load 26 0. -346.724595 0.; 

}

# Conversion Parameters
constraints Plain;
numberer RCM;
system BandGeneral;
test NormDispIncr 1.0e-5 60 ;
algorithm Newton;
integrator LoadControl 0.1;
analysis Static;
analyze 10;

loadConst -time 0.0;

###################################################################################################
###################################################################################################
									 puts "Gravity Done"
###################################################################################################
###################################################################################################

puts "Seismic Weight = 3236.4 kip";
puts "Seismic Mass = 7.3 kip.sec2/in";

if {$Animation == 1} {
	DisplayModel3D DeformedShape 5 50 50  2000 1500
}

###################################################################################################
#                                        Pushover Analysis                       		          #
###################################################################################################

if {$PO==1} {

	# Create Load Pattern
	pattern Plain 222 Linear {
	load 405103 0.21526 0.0 0.0
	load 404103 0.15905 0.0 0.0
	load 403103 0.10490 0.0 0.0
	load 402103 0.05076 0.0 0.0
	}

	# Displacement Control Parameters
	set CtrlNode 405104;
	set CtrlDOF 1;
	set Dmax [expr 0.100*$Floor5];
	set Dincr [expr 0.005];
	set Nsteps [expr int($Dmax/$Dincr)];
	
	constraints Plain;
	numberer RCM; 
	system UmfPack;
	test NormDispIncr 1.0e-5 400;
	algorithm 	KrylovNewton;
	integrator 	DisplacementControl $CtrlNode $CtrlDOF $Dincr;
	analysis 	Static;
	analyze 	$Nsteps;

	puts "Pushover complete"
}

###################################################################################################
#                                   DYNAMIC EARTHQUAKE ANALYSIS                                   #
###################################################################################################

if {$EQ==1} {

	set GMfile "NR94cnp.txt";							# ground motion filename
	set dt 0.01;										# timestep of input GM file
	set EqScale 1.0;									# ground motion scaling factor
	set TotalNumberOfSteps 2495;						# number of steps in ground motion
	set GMtime [expr $dt*$TotalNumberOfSteps + 10.0];	# total time of ground motion + 10 sec of free vibration
	set NumSteps [expr round(($GMtime + 0.0)/$dt)];		# number of steps in analysis
	set TotalNumberOfSteps $NumSteps;
	set dtAnalysis $dt;
	set totTime [expr $dt*$TotalNumberOfSteps];	
		
	# Rayleigh Damping
	set zeta 0.02;
	set a0 [expr $zeta*2.0*$w1*$w3/($w1 + $w3)];
	set a1 [expr $zeta*2.0/($w1 + $w3)];
	set a1_mod [expr $a1*(1.0+$n)/$n];
	region 1 -eleRange  502100  604400 -rayleigh 0.0 0.0 $a1_mod 0.0;
	region 2 -node  402103 402203 402303 402403 102500 102600 403103 403203 403303 403403 103500 103600 404103 404203 404303 404403 104500 104600 405103 405203 405303 405403 105500 105600  -rayleigh $a0 0.0 0.0 0.0;

	# GROUND MOTION ACCELERATION FILE INPUT
	set AccelSeries "Series -dt $dt -filePath $GMfile -factor  [expr $EqScale* $g]"
	pattern UniformExcitation  200 1 -accel $AccelSeries

	set SMFFloorNodes [list  402104 403104 404104 405104 ];
	DynamicAnalysisCollapseSolver   $dt	$dtAnalysis	$totTime 4	0.15   $SMFFloorNodes	180.00 156.00;

	puts "Ground Motion Done. End Time: [getTime]"

}

wipe all;
