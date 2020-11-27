####################################################################################################
####################################################################################################
#                                        2-story MRF Building
####################################################################################################
####################################################################################################

# CLEAR ALL;
wipe all;

# BUILD MODEL (2D - 3 DOF/node)
model basic -ndm 2 -ndf 3

####################################################################################################
#                                        BASIC MODEL VARIABLES                                     #
####################################################################################################

set  global RunTime;
set  global StartTime;
set  global MaxRunTime;
set  MaxRunTime [expr 10.0000 * 60.];
set  StartTime [clock seconds];
set  RunTime 0.0;
set  EQ 1;
set  PO 0;
set  ELF 0;
set  Composite 1;
set  ShowAnimation 1;
set  ModePO 1;
set  DriftPO 0.100000;
set  DampModeI 1;
set  DampModeJ 3;
set  zeta 0.020000;

####################################################################################################
#                                       SOURCING SUBROUTINES                                       #
####################################################################################################

source DisplayModel3D.tcl;
source DisplayPlane.tcl;
source Spring_PZ.tcl;
source Spring_IMK.tcl;
source Spring_Zero.tcl;
source Spring_Rigid.tcl;
source Spring_Pinching.tcl;
source ConstructPanel_Rectangle.tcl;
source DynamicAnalysisCollapseSolverX.tcl;
source Generate_lognrmrand.tcl;

####################################################################################################
#                                          Create Results Folders                                  #
####################################################################################################

# RESULT FOLDER
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
set NStory  2;
set NBay  3;

# MATERIAL PROPERTIES
set E  29000.0; 
set mu    0.3; 
set fy  [expr  55.0 *   1.0];

# BASIC MATERIALS
uniaxialMaterial Elastic  9  1.e-9; 		#Flexible Material 
uniaxialMaterial Elastic  99 1000000000.;  #Rigid Material 
uniaxialMaterial UVCuniaxial  666 29000.0000 55.0000 18.0000 10.0000 0.0000 1.0000 2 3500.0000 180.0000 345.0000 10.0000; #Voce-Chaboche Material

# GEOMETRIC TRANSFORMATIONS IDs
geomTransf Linear 		 1;
geomTransf PDelta 		 2;
geomTransf Corotational 3;
set trans_Linear 	1;
set trans_PDelta 	2;
set trans_Corot  	3;
set trans_selected  2;

# STIFF ELEMENTS PROPERTY
set A_Stiff 1000.0;
set I_Stiff 100000.0;

# COMPOSITE BEAM FACTOR
puts "Composite Action is Considered"
set Composite 1;
set Comp_I    1.400;
set Comp_I_GC 1.400;

# FIBER ELEMENT PROPERTIES
set nSegments    8;
set initialGI    0.00100;
set nIntegration 5;

# LOGARITHMIC STANDARD DEVIATIONS (FOR UNCERTAINTY CONSIDERATION)
global Sigma_IMKcol Sigma_IMKbeam Sigma_Pinching4 Sigma_PZ; 
set Sigma_IMKcol [list  1.e-9 1.e-9 1.e-9 1.e-9 1.e-9 1.e-9 1.e-9 1.e-9 1.e-9 ];
set Sigma_IMKbeam   [list  1.e-9 1.e-9 1.e-9 1.e-9 1.e-9 1.e-9 1.e-9 1.e-9 1.e-9 ];
set Sigma_Pinching4 [list  1.e-9 1.e-9 1.e-9 1.e-9 1.e-9 1.e-9 1.e-9 1.e-9 ];
set Sigma_PZ        [list  1.e-9 1.e-9 1.e-9 1.e-9 ];
set Sigma_fy     1.e-9;
set Sigma_zeta   1.e-9;
global Sigma_fy Sigma_fyB Sigma_fyG Sigma_GI; global xRandom;
set SigmaX $Sigma_fy;  Generate_lognrmrand $fy 	$SigmaX; 	set fy      $xRandom;

####################################################################################################
#                                          PRE-CALCULATIONS                                        #
####################################################################################################

# REDUCED BEAM SECTION CONNECTION DISTANCE FROM COLUMN
set L_RBS3  [expr  0.625 *  5.53 +  0.750 * 15.90/2.];
set L_RBS2  [expr  0.625 * 10.50 +  0.750 * 30.30/2.];

# FRAME GRID LINES
set Floor3  336.00;
set Floor2  180.00;
set Floor1 0.0;

set Axis1 0.0;
set Axis2 240.00;
set Axis3 480.00;
set Axis4 720.00;
set Axis5 960.00;
set Axis6 1200.00;

set HBuilding 336.00;
set WFrame 720.00;
variable HBuilding 336.00;

####################################################################################################
#                                                  NODES                                           #
####################################################################################################

# COMMAND SYNTAX 
# node $NodeID  $X-Coordinate  $Y-Coordinate;

#SUPPORT NODES
node 110   $Axis1  $Floor1; node 120   $Axis2  $Floor1; node 130   $Axis3  $Floor1; node 140   $Axis4  $Floor1; node 150   $Axis5  $Floor1; node 160   $Axis6  $Floor1; 

# EGF COLUMN GRID NODES
node 350   $Axis5  $Floor3; node 360   $Axis6  $Floor3; 
node 250   $Axis5  $Floor2; node 260   $Axis6  $Floor2; 

# EGF COLUMN NODES
node 351  $Axis5  $Floor3; node 361  $Axis6  $Floor3; 
node 253  $Axis5  $Floor2; node 263  $Axis6  $Floor2; 
node 251  $Axis5  $Floor2; node 261  $Axis6  $Floor2; 
node 153  $Axis5  $Floor1; node 163  $Axis6  $Floor1; 

# EGF BEAM NODES
node 354  $Axis5  $Floor3; node 362  $Axis6  $Floor3; 
node 254  $Axis5  $Floor2; node 262  $Axis6  $Floor2; 

# MF COLUMN NODES
node 311  $Axis1 [expr $Floor3 - 15.90/2]; node 321  $Axis2 [expr $Floor3 - 15.90/2]; node 331  $Axis3 [expr $Floor3 - 15.90/2]; node 341  $Axis4 [expr $Floor3 - 15.90/2]; 
node 213  $Axis1 [expr $Floor2 + 30.30/2]; node 223  $Axis2 [expr $Floor2 + 30.30/2]; node 233  $Axis3 [expr $Floor2 + 30.30/2]; node 243  $Axis4 [expr $Floor2 + 30.30/2]; 
node 211  $Axis1 [expr $Floor2 - 30.30/2]; node 221  $Axis2 [expr $Floor2 - 30.30/2]; node 231  $Axis3 [expr $Floor2 - 30.30/2]; node 241  $Axis4 [expr $Floor2 - 30.30/2]; 
node 113  $Axis1 $Floor1; node 123  $Axis2 $Floor1; node 133  $Axis3 $Floor1; node 143  $Axis4 $Floor1; 

# MF BEAM NODES
node 314   [expr $Axis1 + $L_RBS3 + 24.50/2] $Floor3; node 322   [expr $Axis2 - $L_RBS3 - 25.00/2] $Floor3; node 324   [expr $Axis2 + $L_RBS3 + 25.00/2] $Floor3; node 332   [expr $Axis3 - $L_RBS3 - 25.00/2] $Floor3; node 334   [expr $Axis3 + $L_RBS3 + 25.00/2] $Floor3; node 342   [expr $Axis4 - $L_RBS3 - 24.50/2] $Floor3; 
node 214   [expr $Axis1 + $L_RBS2 + 24.50/2] $Floor2; node 222   [expr $Axis2 - $L_RBS2 - 25.00/2] $Floor2; node 224   [expr $Axis2 + $L_RBS2 + 25.00/2] $Floor2; node 232   [expr $Axis3 - $L_RBS2 - 25.00/2] $Floor2; node 234   [expr $Axis3 + $L_RBS2 + 25.00/2] $Floor2; node 242   [expr $Axis4 - $L_RBS2 - 24.50/2] $Floor2; 

# BEAM SPRING NODES
node 3140   [expr $Axis1 + $L_RBS3 + 24.50/2] $Floor3; node 3220   [expr $Axis2 - $L_RBS3 - 25.00/2] $Floor3; node 3240   [expr $Axis2 + $L_RBS3 + 25.00/2] $Floor3; node 3320   [expr $Axis3 - $L_RBS3 - 25.00/2] $Floor3; node 3340   [expr $Axis3 + $L_RBS3 + 25.00/2] $Floor3; node 3420   [expr $Axis4 - $L_RBS3 - 24.50/2] $Floor3; 
node 2140   [expr $Axis1 + $L_RBS2 + 24.50/2] $Floor2; node 2220   [expr $Axis2 - $L_RBS2 - 25.00/2] $Floor2; node 2240   [expr $Axis2 + $L_RBS2 + 25.00/2] $Floor2; node 2320   [expr $Axis3 - $L_RBS2 - 25.00/2] $Floor2; node 2340   [expr $Axis3 + $L_RBS2 + 25.00/2] $Floor2; node 2420   [expr $Axis4 - $L_RBS2 - 24.50/2] $Floor2; 

# COLUMN SPLICE NODES

###################################################################################################
#                                  PANEL ZONE NODES & ELEMENTS                                    #
###################################################################################################

# PANEL ZONE NODES AND ELASTIC ELEMENTS
# Command Syntax; 
# ConstructPanel_Rectangle Axis Floor X_Axis Y_Floor E A_Panel I_Panel d_Col d_Beam transfTag 
ConstructPanel_Rectangle  1 3 $Axis1 $Floor3 $E $A_Stiff $I_Stiff 24.50 15.90 $trans_selected; ConstructPanel_Rectangle  2 3 $Axis2 $Floor3 $E $A_Stiff $I_Stiff 25.00 15.90 $trans_selected; ConstructPanel_Rectangle  3 3 $Axis3 $Floor3 $E $A_Stiff $I_Stiff 25.00 15.90 $trans_selected; ConstructPanel_Rectangle  4 3 $Axis4 $Floor3 $E $A_Stiff $I_Stiff 24.50 15.90 $trans_selected; 
ConstructPanel_Rectangle  1 2 $Axis1 $Floor2 $E $A_Stiff $I_Stiff 24.50 30.30 $trans_selected; ConstructPanel_Rectangle  2 2 $Axis2 $Floor2 $E $A_Stiff $I_Stiff 25.00 30.30 $trans_selected; ConstructPanel_Rectangle  3 2 $Axis3 $Floor2 $E $A_Stiff $I_Stiff 25.00 30.30 $trans_selected; ConstructPanel_Rectangle  4 2 $Axis4 $Floor2 $E $A_Stiff $I_Stiff 24.50 30.30 $trans_selected; 

####################################################################################################
#                                          PANEL ZONE SPRINGS                                      #
####################################################################################################

# COMMAND SYNTAX 
# Spring_PZ    Element_ID Node_i Node_j E mu fy tw_Col tdp d_Col d_Beam tf_Col bf_Col Ic trib ts Response_ID transfTag
Spring_PZ    903100 403109 403110 $E $mu [expr $fy *   1.0]  0.60   0.00 24.50 15.90  0.96 12.90 4020.00 3.500 4.000 2 1; Spring_PZ    903200 403209 403210 $E $mu [expr $fy *   1.0]  0.70   0.00 25.00 15.90  1.22 13.00 5170.00 3.500 4.000 0 1; Spring_PZ    903300 403309 403310 $E $mu [expr $fy *   1.0]  0.70   0.00 25.00 15.90  1.22 13.00 5170.00 3.500 4.000 0 1; Spring_PZ    903400 403409 403410 $E $mu [expr $fy *   1.0]  0.60   0.00 24.50 15.90  0.96 12.90 4020.00 3.500 4.000 2 1; 
Spring_PZ    902100 402109 402110 $E $mu [expr $fy *   1.0]  0.60   0.38 24.50 30.30  0.96 12.90 4020.00 3.500 4.000 2 1; Spring_PZ    902200 402209 402210 $E $mu [expr $fy *   1.0]  0.70   1.19 25.00 30.30  1.22 13.00 5170.00 3.500 4.000 0 1; Spring_PZ    902300 402309 402310 $E $mu [expr $fy *   1.0]  0.70   1.19 25.00 30.30  1.22 13.00 5170.00 3.500 4.000 0 1; Spring_PZ    902400 402409 402410 $E $mu [expr $fy *   1.0]  0.60   0.38 24.50 30.30  0.96 12.90 4020.00 3.500 4.000 2 1; 

####################################################################################################
#                                     ELASTIC COLUMNS AND BEAMS                                    #
####################################################################################################

# COMMAND SYNTAX 
# element ModElasticBeam2d $ElementID $iNode $jNode $Area $E $Ix $K11 $K33 $K44 $transformation 

# STIFFNESS MODIFIERS
set n 10.;
set K44_2 [expr 6*(1+$n)/(2+3*$n)];
set K11_2 [expr (1+2*$n)*$K44_2/(1+$n)];
set K33_2 [expr (1+2*$n)*$K44_2/(1+$n)];
set K44_1 [expr 6*$n/(1+3*$n)];
set K11_1 [expr (1+2*$n)*$K44_1/(1+$n)];
set K33_1 [expr 2*$K44_1];

# COLUMNS
element ModElasticBeam2d   602100      213      311  38.5000 $E [expr ($n+1)/$n*4020.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   602200      223      321  47.7000 $E [expr ($n+1)/$n*5170.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   602300      233      331  47.7000 $E [expr ($n+1)/$n*5170.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   602400      243      341  38.5000 $E [expr ($n+1)/$n*4020.0000] $K11_2 $K33_2 $K44_2 $trans_selected; 
element ModElasticBeam2d   601100      113      211  38.5000 $E [expr ($n+1)/$n*4020.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   601200      123      221  47.7000 $E [expr ($n+1)/$n*5170.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   601300      133      231  47.7000 $E [expr ($n+1)/$n*5170.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   601400      143      241  38.5000 $E [expr ($n+1)/$n*4020.0000] $K11_2 $K33_2 $K44_2 $trans_selected; 

# BEAMS
element ModElasticBeam2d   503100      314      322  9.1300 $E [expr ($n+1)/$n*0.90*$Comp_I*375.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   503200      324      332  9.1300 $E [expr ($n+1)/$n*0.90*$Comp_I*375.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   503300      334      342  9.1300 $E [expr ($n+1)/$n*0.90*$Comp_I*375.0000] $K11_2 $K33_2 $K44_2 $trans_selected; 
element ModElasticBeam2d   502100      214      222  38.9000 $E [expr ($n+1)/$n*0.90*$Comp_I*5770.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   502200      224      232  38.9000 $E [expr ($n+1)/$n*0.90*$Comp_I*5770.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   502300      234      242  38.9000 $E [expr ($n+1)/$n*0.90*$Comp_I*5770.0000] $K11_2 $K33_2 $K44_2 $trans_selected; 

####################################################################################################
#                                      ELASTIC RBS ELEMENTS                                        #
####################################################################################################

element elasticBeamColumn 503104 403104 3140 7.913 $E [expr $Comp_I*302.285] 1; element elasticBeamColumn 503202 403202 3220 7.913 $E [expr $Comp_I*302.285] 1; element elasticBeamColumn 503204 403204 3240 7.913 $E [expr $Comp_I*302.285] 1; element elasticBeamColumn 503302 403302 3320 7.913 $E [expr $Comp_I*302.285] 1; element elasticBeamColumn 503304 403304 3340 7.913 $E [expr $Comp_I*302.285] 1; element elasticBeamColumn 503402 403402 3420 7.913 $E [expr $Comp_I*302.285] 1; 
element elasticBeamColumn 502104 402104 2140 33.650 $E [expr $Comp_I*4642.794] 1; element elasticBeamColumn 502202 402202 2220 33.650 $E [expr $Comp_I*4642.794] 1; element elasticBeamColumn 502204 402204 2240 33.650 $E [expr $Comp_I*4642.794] 1; element elasticBeamColumn 502302 402302 2320 33.650 $E [expr $Comp_I*4642.794] 1; element elasticBeamColumn 502304 402304 2340 33.650 $E [expr $Comp_I*4642.794] 1; element elasticBeamColumn 502402 402402 2420 33.650 $E [expr $Comp_I*4642.794] 1; 

###################################################################################################
#                                           MF BEAM SPRINGS                                       #
###################################################################################################

# Command Syntax 
# Spring_IMK SpringID iNode jNode E fy Ix d htw bftf ry L Ls Lb My PgPye CompositeFLAG MFconnection Units; 

Spring_IMK 903104 314 3140 $E $fy [expr $Comp_I*229.570] 15.900 51.600 6.280 1.170 196.412 98.206 107.625 2076.279 0.0 $Composite 0 2; Spring_IMK 903202 3220 322 $E $fy [expr $Comp_I*229.570] 15.900 51.600 6.280 1.170 196.412 98.206 107.625 2076.279 0.0 $Composite 0 2; Spring_IMK 903204 324 3240 $E $fy [expr $Comp_I*229.570] 15.900 51.600 6.280 1.170 196.412 98.206 107.625 2076.279 0.0 $Composite 0 2; Spring_IMK 903302 3320 332 $E $fy [expr $Comp_I*229.570] 15.900 51.600 6.280 1.170 196.162 98.081 107.500 2076.279 0.0 $Composite 0 2; Spring_IMK 903304 334 3340 $E $fy [expr $Comp_I*229.570] 15.900 51.600 6.280 1.170 196.162 98.081 107.500 2076.279 0.0 $Composite 0 2; Spring_IMK 903402 3420 342 $E $fy [expr $Comp_I*229.570] 15.900 51.600 6.280 1.170 196.412 98.206 107.625 2076.279 0.0 $Composite 0 2; 
Spring_IMK 902104 214 2140 $E $fy [expr $Comp_I*3515.589] 30.300 43.900 5.270 2.250 179.400 89.700 107.625 16756.191 0.0 $Composite 0 2; Spring_IMK 902202 2220 222 $E $fy [expr $Comp_I*3515.589] 30.300 43.900 5.270 2.250 179.400 89.700 107.625 16756.191 0.0 $Composite 0 2; Spring_IMK 902204 224 2240 $E $fy [expr $Comp_I*3515.589] 30.300 43.900 5.270 2.250 179.400 89.700 107.625 16756.191 0.0 $Composite 0 2; Spring_IMK 902302 2320 232 $E $fy [expr $Comp_I*3515.589] 30.300 43.900 5.270 2.250 179.150 89.575 107.500 16756.191 0.0 $Composite 0 2; Spring_IMK 902304 234 2340 $E $fy [expr $Comp_I*3515.589] 30.300 43.900 5.270 2.250 179.150 89.575 107.500 16756.191 0.0 $Composite 0 2; Spring_IMK 902402 2420 242 $E $fy [expr $Comp_I*3515.589] 30.300 43.900 5.270 2.250 179.400 89.700 107.625 16756.191 0.0 $Composite 0 2; 

###################################################################################################
#                                           MF COLUMN SPRINGS                                     #
###################################################################################################

Spring_IMK  903101  403101     311 $E $fy 4020.0000 24.5000 35.6000 6.7000 2.9700 132.9000 66.4500 132.9000 22385.0000 0.0110  0 0 2; Spring_IMK  903201  403201     321 $E $fy 5170.0000 25.0000 30.6000 5.3100 3.0500 132.9000 66.4500 132.9000 28314.0000 0.0133  0 0 2; Spring_IMK  903301  403301     331 $E $fy 5170.0000 25.0000 30.6000 5.3100 3.0500 132.9000 66.4500 132.9000 28314.0000 0.0133  0 0 2; Spring_IMK  903401  403401     341 $E $fy 4020.0000 24.5000 35.6000 6.7000 2.9700 132.9000 66.4500 132.9000 22385.0000 0.0110  0 0 2; 
Spring_IMK  902103  402103     213 $E $fy 4020.0000 24.5000 35.6000 6.7000 2.9700 132.9000 66.4500 132.9000 22385.0000 0.0110  0 0 2; Spring_IMK  902203  402203     223 $E $fy 5170.0000 25.0000 30.6000 5.3100 3.0500 132.9000 66.4500 132.9000 28314.0000 0.0133  0 0 2; Spring_IMK  902303  402303     233 $E $fy 5170.0000 25.0000 30.6000 5.3100 3.0500 132.9000 66.4500 132.9000 28314.0000 0.0133  0 0 2; Spring_IMK  902403  402403     243 $E $fy 4020.0000 24.5000 35.6000 6.7000 2.9700 132.9000 66.4500 132.9000 22385.0000 0.0110  0 0 2; 
Spring_IMK  902101  402101     211 $E $fy 4020.0000 24.5000 35.6000 6.7000 2.9700 164.8500 82.4250 164.8500 22385.0000 0.0246  0 0 2; Spring_IMK  902201  402201     221 $E $fy 5170.0000 25.0000 30.6000 5.3100 3.0500 164.8500 82.4250 164.8500 28314.0000 0.0298  0 0 2; Spring_IMK  902301  402301     231 $E $fy 5170.0000 25.0000 30.6000 5.3100 3.0500 164.8500 82.4250 164.8500 28314.0000 0.0298  0 0 2; Spring_IMK  902401  402401     241 $E $fy 4020.0000 24.5000 35.6000 6.7000 2.9700 164.8500 82.4250 164.8500 22385.0000 0.0246  0 0 2; 
Spring_IMK  901103     110     113 $E $fy 4020.0000 24.5000 35.6000 6.7000 2.9700 164.8500 82.4250 164.8500 22385.0000 0.0246  0 0 2; Spring_IMK  901203     120     123 $E $fy 5170.0000 25.0000 30.6000 5.3100 3.0500 164.8500 82.4250 164.8500 28314.0000 0.0298  0 0 2; Spring_IMK  901303     130     133 $E $fy 5170.0000 25.0000 30.6000 5.3100 3.0500 164.8500 82.4250 164.8500 28314.0000 0.0298  0 0 2; Spring_IMK  901403     140     143 $E $fy 4020.0000 24.5000 35.6000 6.7000 2.9700 164.8500 82.4250 164.8500 22385.0000 0.0246  0 0 2; 

###################################################################################################
#                                          COLUMN SPLICE SPRINGS                                  #
###################################################################################################


####################################################################################################
#                                              FLOOR LINKS                                         #
####################################################################################################

# Command Syntax 
# element truss $ElementID $iNode $jNode $Area $matID
element truss 1003 403404 350 $A_Stiff 99;
element truss 1002 402404 250 $A_Stiff 99;

####################################################################################################
#                                          EGF COLUMNS AND BEAMS                                   #
####################################################################################################

# GRAVITY COLUMNS
element elasticBeamColumn  602500     253     351 66.2500 $E [expr (905.0000  + 1566.0000)] $trans_PDelta; element elasticBeamColumn  602600     263     361 66.2500 $E [expr (905.0000  + 1566.0000)] $trans_PDelta; 
element elasticBeamColumn  601500     153     251 66.2500 $E [expr (905.0000  + 1566.0000)] $trans_PDelta; element elasticBeamColumn  601600     163     261 66.2500 $E [expr (905.0000  + 1566.0000)] $trans_PDelta; 

# GRAVITY BEAMS
element elasticBeamColumn  503400     354     362 97.8000 $E [expr $Comp_I_GC * 8160.0000] $trans_PDelta;
element elasticBeamColumn  502400     254     262 97.8000 $E [expr $Comp_I_GC * 8160.0000] $trans_PDelta;

# GRAVITY COLUMNS SPRINGS
Spring_IMK   903501     350     351 $E $fy [expr (905.0000 + 1566.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 34001.0000 0 $Composite 0 2; Spring_IMK   903601     360     361 $E $fy [expr (905.0000 + 1566.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 34001.0000 0 $Composite 0 2; 
Spring_IMK   902503     250     253 $E $fy [expr (905.0000 + 1566.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 34001.0000 0 $Composite 0 2; Spring_IMK   902603     260     263 $E $fy [expr (905.0000 + 1566.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 34001.0000 0 $Composite 0 2; 
Spring_IMK   902501     250     251 $E $fy [expr (905.0000 + 1566.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 34001.0000 0 $Composite 0 2; Spring_IMK   902601     260     261 $E $fy [expr (905.0000 + 1566.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 34001.0000 0 $Composite 0 2; 
Spring_IMK   901503     150     153 $E $fy 1566.0000 14.0000 25.9000 10.2000 3.7000 180.0000 90.0000 180.0000 22566.5000 0 $Composite 0 2; Spring_IMK   901603     160     163 $E $fy 1566.0000 14.0000 25.9000 10.2000 3.7000 180.0000 90.0000 180.0000 22566.5000 0 $Composite 0 2; 

# GRAVITY BEAMS SPRINGS
set gap 0.08;
Spring_Pinching   903504     350     354 49005.0000 $gap 1; Spring_Pinching   903602     360     362 49005.0000 $gap 1; 
Spring_Pinching   902504     250     254 49005.0000 $gap 1; Spring_Pinching   902602     260     262 49005.0000 $gap 1; 

###################################################################################################
#                                       BOUNDARY CONDITIONS                                       #
###################################################################################################

# MF SUPPORTS
fix 110 1 1 0; 
fix 120 1 1 0; 
fix 130 1 1 0; 
fix 140 1 1 0; 

# EGF SUPPORTS
fix 150 1 1 0; fix 160 1 1 0; 

# MF FLOOR MOVEMENT
equalDOF 403104 403204 1; equalDOF 403104 403304 1; equalDOF 403104 403404 1; 
equalDOF 402104 402204 1; equalDOF 402104 402304 1; equalDOF 402104 402404 1; 

# EGF FLOOR MOVEMENT
equalDOF 350 360 1;
equalDOF 250 260 1;


##################################################################################################
##################################################################################################
                                       puts "Model Built"
##################################################################################################
##################################################################################################

###################################################################################################
#                                             RECORDERS                                           #
###################################################################################################

# EIGEN VECTORS
recorder Node -file $MainFolder/EigenAnalysis/EigenVectorsMode1.out -node 402104 403104  -dof 1 "eigen  1";
recorder Node -file $MainFolder/EigenAnalysis/EigenVectorsMode2.out -node 402104 403104  -dof 1 "eigen  2";

# TIME
recorder Node -file $MainFolder/$SubFolder/Time.out  -time -node 110 -dof 1 disp;

# SUPPORT REACTIONS
recorder Node -file $MainFolder/$SubFolder/Support1.out -node     110 -dof 1 2 6 reaction; recorder Node -file $MainFolder/$SubFolder/Support2.out -node     120 -dof 1 2 6 reaction; recorder Node -file $MainFolder/$SubFolder/Support3.out -node     130 -dof 1 2 6 reaction; recorder Node -file $MainFolder/$SubFolder/Support4.out -node     140 -dof 1 2 6 reaction; recorder Node -file $MainFolder/$SubFolder/Support5.out -node     150 -dof 1 2 6 reaction; recorder Node -file $MainFolder/$SubFolder/Support6.out -node     160 -dof 1 2 6 reaction; 

# STORY DRIFT RATIO
recorder Drift -file $MainFolder/$SubFolder/SDR2_MF.out -iNode  402104 -jNode  403104 -dof 1 -perpDirn 2; 
recorder Drift -file $MainFolder/$SubFolder/SDR1_MF.out -iNode     110 -jNode  402104 -dof 1 -perpDirn 2; 

# COLUMN ELASTIC ELEMENT FORCES
recorder Element -file $MainFolder/$SubFolder/Column21.out -ele  602100 force; recorder Element -file $MainFolder/$SubFolder/Column22.out -ele  602200 force; recorder Element -file $MainFolder/$SubFolder/Column23.out -ele  602300 force; recorder Element -file $MainFolder/$SubFolder/Column24.out -ele  602400 force; recorder Element -file $MainFolder/$SubFolder/Column25.out -ele  602500 force; recorder Element -file $MainFolder/$SubFolder/Column26.out -ele  602600 force; 
recorder Element -file $MainFolder/$SubFolder/Column11.out -ele  601100 force; recorder Element -file $MainFolder/$SubFolder/Column12.out -ele  601200 force; recorder Element -file $MainFolder/$SubFolder/Column13.out -ele  601300 force; recorder Element -file $MainFolder/$SubFolder/Column14.out -ele  601400 force; recorder Element -file $MainFolder/$SubFolder/Column15.out -ele  601500 force; recorder Element -file $MainFolder/$SubFolder/Column16.out -ele  601600 force; 

###################################################################################################
#                                              NODAL MASS                                         #
###################################################################################################

set g 386.10;
mass 403104 0.1476  1.e-9 1.e-9; mass 403204 0.1709  1.e-9 1.e-9; mass 403304 0.1709  1.e-9 1.e-9; mass 403404 0.1709  1.e-9 1.e-9; mass 350 0.5361  1.e-9 1.e-9; mass 360 0.5361  1.e-9 1.e-9; 
mass 402104 0.2797  1.e-9 1.e-9; mass 402204 0.3030  1.e-9 1.e-9; mass 402304 0.3030  1.e-9 1.e-9; mass 402404 0.3030  1.e-9 1.e-9; mass 250 0.3380  1.e-9 1.e-9; mass 260 0.3380  1.e-9 1.e-9; 

constraints Plain;

###################################################################################################
#                                        EIGEN VALUE ANALYSIS                                     #
###################################################################################################

set pi [expr 2.0*asin(1.0)];
set nEigen 2;
set lambdaN [eigen [expr $nEigen]];
set lambda1 [lindex $lambdaN 0];
set lambda2 [lindex $lambdaN 1];
set w1 [expr pow($lambda1,0.5)];
set w2 [expr pow($lambda2,0.5)];
set T1 [expr round(2.0*$pi/$w1 *1000.)/1000.];
set T2 [expr round(2.0*$pi/$w2 *1000.)/1000.];
puts "T1 = $T1 s";
puts "T2 = $T2 s";
set fileX [open "EigenPeriod.out" w];
puts $fileX $T1;puts $fileX $T2;close $fileX;


constraints Plain;
algorithm Newton;
integrator LoadControl 1;
analysis Static;
analyze 1;

###################################################################################################
###################################################################################################
									puts "Eigen Analysis Done"
###################################################################################################
###################################################################################################

if {$ShowAnimation == 1} {
	DisplayModel3D DeformedShape 5 50 50  2000 1500;
}

###################################################################################################
#                                   DYNAMIC EARTHQUAKE ANALYSIS                                   #
###################################################################################################

if {$EQ==1} {

set GMfile "NR94cnp.txt";				# ground motion filename
set GMdt 0.01;							# timestep of input GM file
set EqSF 1.0;							# ground motion scaling factor
set GMpoints 2495;						# number of steps in ground motion

# Rayleigh Damping
global Sigma_zeta; global xRandom;
set zeta 0.020;
set SigmaX $Sigma_zeta; Generate_lognrmrand $zeta 		$SigmaX; 		set zeta 	$xRandom;
set a0 [expr $zeta*2.0*$w1*$w2/($w1 + $w2)];
set a1 [expr $zeta*2.0/($w1 + $w2)];
set a1_mod [expr $a1*(1.0+$n)/$n];
region 1 -ele  604100 604200 604300 604400 603102 603202 603302 603402 603101 603201 603301 603401 602100 602200 602300 602400 601100 601200 601300 601400 505100 505200 505300 504100 504200 504300 503100 503200 503300 502100 502200 502300  -rayleigh 0.0 0.0 $a1_mod 0.0;
region 2 -node  402104 402204 402304 402404 250 260 403104 403204 403304 403404 350 360  -rayleigh $a0 0.0 0.0 0.0;
region 3 -eleRange  900000  999999 -rayleigh 0.0 0.0 [expr $a1_mod/10] 0.0;

# GROUND MOTION ACCELERATION FILE INPUT
set AccelSeries "Series -dt $GMdt -filePath $GMfile -factor  [expr $EqSF * $g]"
pattern UniformExcitation  200 1 -accel $AccelSeries

set MF_FloorNodes [list  402104 403104 ];
set EGF_FloorNodes [list  250 350 ];
set GMduration [expr $GMdt*$GMpoints];
set FVduration 10.000000;
set NumSteps [expr round(($GMduration + $FVduration)/$GMdt)];	# number of steps in analysis
set totTime [expr $GMdt*$NumSteps];                            # Total time of analysis
set dtAnalysis [expr 0.500000*$GMdt];                             	# dt of Analysis

DynamicAnalysisCollapseSolverX  $GMdt	$dtAnalysis	$totTime $NStory	 0.15   $MF_FloorNodes	$EGF_FloorNodes	180.00 156.00 1 $StartTime $MaxRunTime;

###################################################################################################
###################################################################################################
							puts "Ground Motion Done. End Time: [getTime]"
###################################################################################################
###################################################################################################
}

wipe all;
