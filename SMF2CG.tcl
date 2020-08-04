# 2-story MRF Building
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
set NStory  2;
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
set L_RBS3  [expr  0.625 *  5.53 +  0.750 * 15.90/2.];
set L_RBS2  [expr  0.625 * 10.50 +  0.750 * 30.30/2.];

# FRAME GRID LINES
set HBuilding 336.00;
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
#                                				NODES       				                        #
####################################################################################################

#SUPPORT NODES
node 11   $Axis1  $Floor1; node 12   $Axis2  $Floor1; node 13   $Axis3  $Floor1; node 14   $Axis4  $Floor1; node 15   $Axis5  $Floor1; node 16   $Axis6  $Floor1; 

# LEANING/GRAVITY COLUMN NODES
node 35   $Axis5  $Floor3; node 36   $Axis6  $Floor3; 
node 25   $Axis5  $Floor2; node 26   $Axis6  $Floor2; 

# MRF BEAM NODES
node 314   [expr $Axis1 + $L_RBS3 + 24.50/2] $Floor3; node 322   [expr $Axis2 - $L_RBS3 - 25.00/2] $Floor3; node 324   [expr $Axis2 + $L_RBS3 + 25.00/2] $Floor3; node 332   [expr $Axis3 - $L_RBS3 - 25.00/2] $Floor3; node 334   [expr $Axis3 + $L_RBS3 + 25.00/2] $Floor3; node 342   [expr $Axis4 - $L_RBS3 - 24.50/2] $Floor3; 
node 214   [expr $Axis1 + $L_RBS2 + 24.50/2] $Floor2; node 222   [expr $Axis2 - $L_RBS2 - 25.00/2] $Floor2; node 224   [expr $Axis2 + $L_RBS2 + 25.00/2] $Floor2; node 232   [expr $Axis3 - $L_RBS2 - 25.00/2] $Floor2; node 234   [expr $Axis3 + $L_RBS2 + 25.00/2] $Floor2; node 242   [expr $Axis4 - $L_RBS2 - 24.50/2] $Floor2; 

# MRF COLUMN NODES
node 311  $Axis1 [expr $Floor3 - 15.90/2]; node 321  $Axis2 [expr $Floor3 - 15.90/2]; node 331  $Axis3 [expr $Floor3 - 15.90/2]; node 341  $Axis4 [expr $Floor3 - 15.90/2]; 
node 213  $Axis1 [expr $Floor2 + 30.30/2]; node 223  $Axis2 [expr $Floor2 + 30.30/2]; node 233  $Axis3 [expr $Floor2 + 30.30/2]; node 243  $Axis4 [expr $Floor2 + 30.30/2]; 
node 211  $Axis1 [expr $Floor2 - 30.30/2]; node 221  $Axis2 [expr $Floor2 - 30.30/2]; node 231  $Axis3 [expr $Floor2 - 30.30/2]; node 241  $Axis4 [expr $Floor2 - 30.30/2]; 
node 113  $Axis1 $Floor1; node 123  $Axis2 $Floor1; node 133  $Axis3 $Floor1; node 143  $Axis4 $Floor1; 

# BEAM PLASTIC HINGE NODES
node 3140   [expr $Axis1 + $L_RBS3 + 24.50/2] $Floor3; node 3220   [expr $Axis2 - $L_RBS3 - 25.00/2] $Floor3; node 3240   [expr $Axis2 + $L_RBS3 + 25.00/2] $Floor3; node 3320   [expr $Axis3 - $L_RBS3 - 25.00/2] $Floor3; node 3340   [expr $Axis3 + $L_RBS3 + 25.00/2] $Floor3; node 3420   [expr $Axis4 - $L_RBS3 - 24.50/2] $Floor3; 
node 2140   [expr $Axis1 + $L_RBS2 + 24.50/2] $Floor2; node 2220   [expr $Axis2 - $L_RBS2 - 25.00/2] $Floor2; node 2240   [expr $Axis2 + $L_RBS2 + 25.00/2] $Floor2; node 2320   [expr $Axis3 - $L_RBS2 - 25.00/2] $Floor2; node 2340   [expr $Axis3 + $L_RBS2 + 25.00/2] $Floor2; node 2420   [expr $Axis4 - $L_RBS2 - 24.50/2] $Floor2; 

# EGF BEAM NODES
node 354  $Axis5  $Floor3; node 362  $Axis6  $Floor3; 
node 254  $Axis5  $Floor2; node 262  $Axis6  $Floor2; 

# EGF COLUMN NODES
node 351  $Axis5  $Floor3; node 361  $Axis6  $Floor3; 
node 253  $Axis5  $Floor2; node 263  $Axis6  $Floor2; 
node 251  $Axis5  $Floor2; node 261  $Axis6  $Floor2; 
node 153  $Axis5  $Floor1; node 163  $Axis6  $Floor1; 

# PANEL ZONE NODES AND ELASTIC ELEMENTS
# CROSS PANEL ZONE NODES AND ELASTIC ELEMENTS
# Command Syntax; 
# ConstructPanel_Rectangle Axis Floor X_Axis Y_Floor E A_Panel I_Panel d_Col d_Beam transfTag 
ConstructPanel_Rectangle  1 3 $Axis1 $Floor3 $E $A_Stiff $I_Stiff 24.50 15.90 1; ConstructPanel_Rectangle  2 3 $Axis2 $Floor3 $E $A_Stiff $I_Stiff 25.00 15.90 1; ConstructPanel_Rectangle  3 3 $Axis3 $Floor3 $E $A_Stiff $I_Stiff 25.00 15.90 1; ConstructPanel_Rectangle  4 3 $Axis4 $Floor3 $E $A_Stiff $I_Stiff 24.50 15.90 1; 
ConstructPanel_Rectangle  1 2 $Axis1 $Floor2 $E $A_Stiff $I_Stiff 24.50 30.30 1; ConstructPanel_Rectangle  2 2 $Axis2 $Floor2 $E $A_Stiff $I_Stiff 25.00 30.30 1; ConstructPanel_Rectangle  3 2 $Axis3 $Floor2 $E $A_Stiff $I_Stiff 25.00 30.30 1; ConstructPanel_Rectangle  4 2 $Axis4 $Floor2 $E $A_Stiff $I_Stiff 24.50 30.30 1; 

####################################################################################################
#                                   		PANEL ZONE SPRINGS	                                    #
####################################################################################################

# Command Syntax; 
# Spring_Panel Element_ID Node_i Node_j E Fy tp d_Colum d_Beam tf_Column bf_Column SH_Panel Response_ID transfTag Units
Spring_Panel 903100 403109 403110 $E $Fy [expr  0.60 +  0.00] 24.50 15.90  0.96 12.90  0.03 2 1 2; Spring_Panel 903200 403209 403210 $E $Fy [expr  0.70 +  0.00] 25.00 15.90  1.22 13.00  0.03 2 1 2; Spring_Panel 903300 403309 403310 $E $Fy [expr  0.70 +  0.00] 25.00 15.90  1.22 13.00  0.03 2 1 2; Spring_Panel 903400 403409 403410 $E $Fy [expr  0.60 +  0.00] 24.50 15.90  0.96 12.90  0.03 2 1 2; 
Spring_Panel 902100 402109 402110 $E $Fy [expr  0.60 +  0.38] 24.50 30.30  0.96 12.90  0.03 2 1 2; Spring_Panel 902200 402209 402210 $E $Fy [expr  0.70 +  1.19] 25.00 30.30  1.22 13.00  0.03 2 1 2; Spring_Panel 902300 402309 402310 $E $Fy [expr  0.70 +  1.19] 25.00 30.30  1.22 13.00  0.03 2 1 2; Spring_Panel 902400 402409 402410 $E $Fy [expr  0.60 +  0.38] 24.50 30.30  0.96 12.90  0.03 2 1 2; 

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
element ModElasticBeam2d 602100 213 311  38.5000 $E [expr ($n+1)/$n*4020.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 602200 223 321  47.7000 $E [expr ($n+1)/$n*5170.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 602300 233 331  47.7000 $E [expr ($n+1)/$n*5170.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 602400 243 341  38.5000 $E [expr ($n+1)/$n*4020.0000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 601100 113 211  38.5000 $E [expr ($n+1)/$n*4020.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 601200 123 221  47.7000 $E [expr ($n+1)/$n*5170.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 601300 133 231  47.7000 $E [expr ($n+1)/$n*5170.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 601400 143 241  38.5000 $E [expr ($n+1)/$n*4020.0000] $K11_2 $K33_2 $K44_2 1; 

# BEAMS
element ModElasticBeam2d 503100 314 322  9.130 $E [expr ($n+1)/$n*0.90*$Comp_I*375.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 503200 324 332  9.130 $E [expr ($n+1)/$n*0.90*$Comp_I*375.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 503300 334 342  9.130 $E [expr ($n+1)/$n*0.90*$Comp_I*375.000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 502100 214 222  38.900 $E [expr ($n+1)/$n*0.90*$Comp_I*5770.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 502200 224 232  38.900 $E [expr ($n+1)/$n*0.90*$Comp_I*5770.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 502300 234 242  38.900 $E [expr ($n+1)/$n*0.90*$Comp_I*5770.000] $K11_2 $K33_2 $K44_2 1; 

####################################################################################################
#                                      ELASTIC RBS ELEMENTS                                        #
####################################################################################################

element elasticBeamColumn 503104 403104 3140  9.130 $E [expr $Comp_I* 375.000] 1; element elasticBeamColumn 503202 403202 3220  9.130 $E [expr $Comp_I* 375.000] 1; element elasticBeamColumn 503204 403204 3240  9.130 $E [expr $Comp_I* 375.000] 1; element elasticBeamColumn 503302 403302 3320  9.130 $E [expr $Comp_I* 375.000] 1; element elasticBeamColumn 503304 403304 3340  9.130 $E [expr $Comp_I* 375.000] 1; element elasticBeamColumn 503402 403402 3420  9.130 $E [expr $Comp_I*375.000] 1; 
element elasticBeamColumn 502104 402104 2140 38.900 $E [expr $Comp_I*5770.000] 1; element elasticBeamColumn 502202 402202 2220 38.900 $E [expr $Comp_I*5770.000] 1; element elasticBeamColumn 502204 402204 2240 38.900 $E [expr $Comp_I*5770.000] 1; element elasticBeamColumn 502302 402302 2320 38.900 $E [expr $Comp_I*5770.000] 1; element elasticBeamColumn 502304 402304 2340 38.900 $E [expr $Comp_I*5770.000] 1; element elasticBeamColumn 502402 402402 2420 38.900 $E [expr $Comp_I*5770.000] 1; 

###################################################################################################
#                                 COLUMN AND BEAM PLASTIC SPRINGS                                 #
###################################################################################################

# Command Syntax; 
# Spring_IMK SpringID iNode jNode E Fy Ix d tw bf tf htw bftf ry L Ls Lb My PgPye CompositeFLAG MRFconnection Units; 

# BEAM SPRINGS
Spring_IMK 903104 314  3140 $E $Fy [expr $Comp_I* 375.000] 15.900 0.275 5.530 0.440 51.600 6.280 1.170 214.144 107.625 107.072 3214.202 0.0 $Composite 2 2; Spring_IMK 903202 3220 322  $E $Fy [expr $Comp_I*375.000] 15.900 0.275 5.530 0.440 51.600 6.280 1.170 214.144 107.625 107.072 3214.202 0.0 $Composite 2 2; Spring_IMK 903204 324  3240 $E $Fy [expr $Comp_I*375.000] 15.900 0.275 5.530 0.440 51.600 6.280 1.170 214.144 107.625 107.072 3214.202 0.0 $Composite 2 2; Spring_IMK 903302 3320 332  $E $Fy [expr $Comp_I*375.000] 15.900 0.275 5.530 0.440 51.600 6.280 1.170 213.894 107.500 106.947 3214.202 0.0 $Composite 2 2; Spring_IMK 903304 334  3340 $E $Fy [expr $Comp_I*375.000] 15.900 0.275 5.530 0.440 51.600 6.280 1.170 213.894 107.500 106.947 3214.202 0.0 $Composite 2 2; Spring_IMK 903402 3420 342  $E $Fy [expr $Comp_I*375.000] 15.900 0.275 5.530 0.440 51.600 6.280 1.170 214.144 107.625 107.072 3214.202 0.0 $Composite 2 2; 
Spring_IMK 902104 214  2140 $E $Fy [expr $Comp_I*5770.000] 30.300 0.615 10.500 1.000 43.900 5.270 2.250 213.150 107.625 106.575 26062.604 0.0 $Composite 2 2; Spring_IMK 902202 2220 222  $E $Fy [expr $Comp_I*5770.000] 30.300 0.615 10.500 1.000 43.900 5.270 2.250 213.150 107.625 106.575 26062.604 0.0 $Composite 2 2; Spring_IMK 902204 224  2240 $E $Fy [expr $Comp_I*5770.000] 30.300 0.615 10.500 1.000 43.900 5.270 2.250 213.150 107.625 106.575 26062.604 0.0 $Composite 2 2; Spring_IMK 902302 2320 232  $E $Fy [expr $Comp_I*5770.000] 30.300 0.615 10.500 1.000 43.900 5.270 2.250 212.900 107.500 106.450 26062.604 0.0 $Composite 2 2; Spring_IMK 902304 234  2340 $E $Fy [expr $Comp_I*5770.000] 30.300 0.615 10.500 1.000 43.900 5.270 2.250 212.900 107.500 106.450 26062.604 0.0 $Composite 2 2; Spring_IMK 902402 2420 242  $E $Fy [expr $Comp_I*5770.000] 30.300 0.615 10.500 1.000 43.900 5.270 2.250 213.150 107.625 106.575 26062.604 0.0 $Composite 2 2; 

# Column Springs
Spring_IMK 903101 311 403101 $E $Fy 4020.000 24.500 0.605 12.900 0.960 35.600 6.700 2.970 132.900 66.450 132.900 22385.000 0.040 0 2 2; Spring_IMK 903201 321 403201 $E $Fy 5170.000 25.000 0.705 13.000 1.220 30.600 5.310 3.050 132.900 66.450 132.900 28314.000 0.024 0 2 2; Spring_IMK 903301 331 403301 $E $Fy 5170.000 25.000 0.705 13.000 1.220 30.600 5.310 3.050 132.900 66.450 132.900 28314.000 0.024 0 2 2; Spring_IMK 903401 341 403401 $E $Fy 4020.000 24.500 0.605 12.900 0.960 35.600 6.700 2.970 132.900 66.450 132.900 22385.000 0.040 0 2 2; 
Spring_IMK 902103 213 402103 $E $Fy 4020.000 24.500 0.605 12.900 0.960 35.600 6.700 2.970 156.900 78.450 156.900 22385.000 0.040 0 2 2; Spring_IMK 902203 223 402203 $E $Fy 5170.000 25.000 0.705 13.000 1.220 30.600 5.310 3.050 156.900 78.450 156.900 28314.000 0.024 0 2 2; Spring_IMK 902303 233 402303 $E $Fy 5170.000 25.000 0.705 13.000 1.220 30.600 5.310 3.050 156.900 78.450 156.900 28314.000 0.024 0 2 2; Spring_IMK 902403 243 402403 $E $Fy 4020.000 24.500 0.605 12.900 0.960 35.600 6.700 2.970 156.900 78.450 156.900 22385.000 0.040 0 2 2; 
Spring_IMK 902101 211 402101 $E $Fy 4020.000 24.500 0.605 12.900 0.960 35.600 6.700 2.970 149.700 74.850 149.700 22385.000 0.040 0 2 2; Spring_IMK 902201 221 402201 $E $Fy 5170.000 25.000 0.705 13.000 1.220 30.600 5.310 3.050 149.700 74.850 149.700 28314.000 0.024 0 2 2; Spring_IMK 902301 231 402301 $E $Fy 5170.000 25.000 0.705 13.000 1.220 30.600 5.310 3.050 149.700 74.850 149.700 28314.000 0.024 0 2 2; Spring_IMK 902401 241 402401 $E $Fy 4020.000 24.500 0.605 12.900 0.960 35.600 6.700 2.970 149.700 74.850 149.700 22385.000 0.040 0 2 2; 
Spring_IMK 901103 11 	 113 $E $Fy 4020.000 24.500 0.605 12.900 0.960 35.600 6.700 2.970 164.850 82.425 164.850 22385.000 0.117 0 2 2; Spring_IMK 901203 12 123 $E $Fy 5170.000 25.000 0.705 13.000 1.220 30.600 5.310 3.050 164.850 82.425 164.850 28314.000 0.070 0 2 2; Spring_IMK 901303 13 133 $E $Fy 5170.000 25.000 0.705 13.000 1.220 30.600 5.310 3.050 164.850 82.425 164.850 28314.000 0.070 0 2 2; Spring_IMK 901403 14 143 $E $Fy 4020.000 24.500 0.605 12.900 0.960 35.600 6.700 2.970 164.850 82.425 164.850 22385.000 0.117 0 2 2; 

####################################################################################################
#                                          RIGID FLOOR LINKS                                       #
####################################################################################################

# COMMAND SYNTAX 
# element truss $ElementID $iNode $jNode $Area $matID
element truss 1003 403404 35 $A_Stiff 99;
element truss 1002 402404 25 $A_Stiff 99;

####################################################################################################
#                              EQUIVELANT GRAVITY COLUMNS AND BEAMS                                #
####################################################################################################

# Gravity Columns
element elasticBeamColumn  602500  253  351  [expr 100000.000 / 2] $E [expr (100000000.000  + 1566.000) / 2] 1; element elasticBeamColumn  602600  263  361  [expr 100000.000 / 2] $E [expr (100000000.000  + 1566.000) / 2] 1; 
element elasticBeamColumn  601500  153  251  [expr 100000.000 / 2] $E [expr (100000000.000  + 1566.000) / 2] 1; element elasticBeamColumn  601600  163  261  [expr 100000.000 / 2] $E [expr (100000000.000  + 1566.000) / 2] 1; 

# Gravity Beams
element elasticBeamColumn  503400 354  362  100000.000  $E [expr $Comp_I_GC * 100000000.000] 1;
element elasticBeamColumn  502400 254  262  100000.000  $E [expr $Comp_I_GC * 100000000.000] 1;

# Gravity Columns Springs
Spring_IMK  903501 35 351 $E $Fy [expr (680.000 + 1566.000)/2] 14.000 0.440 14.500 0.710 25.900 10.200 3.700 156.000 78.000 156.000 32428.000 0.0 0 2 2; Spring_IMK  903601 36 361 $E $Fy [expr (680.000 + 1566.000)/2] 14.000 0.440 14.500 0.710 25.900 10.200 3.700 156.000 78.000 156.000 32428.000 0.0 0 2 2; 
Spring_IMK  902503 25 253 $E $Fy [expr (680.000 + 1566.000)/2] 14.000 0.440 14.500 0.710 25.900 10.200 3.700 156.000 78.000 156.000 32428.000 0.0 0 2 2; Spring_IMK  902603 26 263 $E $Fy [expr (680.000 + 1566.000)/2] 14.000 0.440 14.500 0.710 25.900 10.200 3.700 156.000 78.000 156.000 32428.000 0.0 0 2 2; 
Spring_IMK  902501 25 251 $E $Fy [expr (680.000 + 1566.000)/2] 14.000 0.440 14.500 0.710 25.900 10.200 3.700 156.000 78.000 156.000 32428.000 0.0 0 2 2; Spring_IMK  902601 26 261 $E $Fy [expr (680.000 + 1566.000)/2] 14.000 0.440 14.500 0.710 25.900 10.200 3.700 156.000 78.000 156.000 32428.000 0.0 0 2 2; 
Spring_IMK  901503 15 153 $E $Fy [expr 1566.000/2] 			14.000 0.440 14.500 0.710 25.900 10.200 3.700 180.000 90.000 180.000 22566.500 0.0 0 2 2; Spring_IMK  901603 16 163 $E $Fy [expr 1566.000/2] 			14.000 0.440 14.500 0.710 25.900 10.200 3.700 180.000 90.000 180.000 22566.500 0.0 0 2 2; 

# GRAVITY BEAMS SPRINGS
set gap 0.08;
Spring_Pinching  903504  35   354 40837.500 $gap 1; Spring_Pinching  903602  362  36  40837.500 $gap 1; 
Spring_Pinching  902504  25   254 40837.500 $gap 1; Spring_Pinching  902602  262  26  40837.500 $gap 1; 

###################################################################################################
#                                       BOUNDARY CONDITIONS                                       #
###################################################################################################

# MRF Supports
fix 11 1 1 0; fix 12 1 1 0; fix 13 1 1 0; fix 14 1 1 0; 

# EGF Supports
fix 15 1 1 1; fix 16 1 1 1; 

# MRF Floor Movement
equalDOF 403104  403204  1; equalDOF 403104  403304  1; equalDOF 403104  403404  1; 
equalDOF 402104  402204  1; equalDOF 402104  402304  1; equalDOF 402104  402404  1; 

# MRF Column Joints
equalDOF  403101 	311 1 2; equalDOF  403201 	321 1 2; equalDOF  403301 	331 1 2; equalDOF  403401 	341 1 2; 
equalDOF  402103 	213 1 2; equalDOF  402203 	223 1 2; equalDOF  402303 	233 1 2; equalDOF  402403 	243 1 2; 
equalDOF  402101 	211 1 2; equalDOF  402201 	221 1 2; equalDOF  402301 	231 1 2; equalDOF  402401 	241 1 2; 
equalDOF  11 	113 1 2; equalDOF  12 	123 1 2; equalDOF  13 	133 1 2; equalDOF  14 	143 1 2; 

# MRF Beam Joints
equalDOF  3140 	314 1 2; equalDOF  3220 	322 1 2; equalDOF  3240 	324 1 2; equalDOF  3320 	332 1 2; equalDOF  3340 	334 1 2; equalDOF  3420 	342 1 2; 
equalDOF  2140 	214 1 2; equalDOF  2220 	222 1 2; equalDOF  2240 	224 1 2; equalDOF  2320 	232 1 2; equalDOF  2340 	234 1 2; equalDOF  2420 	242 1 2; 

# EGF Beam Joints
equalDOF  35 	354 1 2; equalDOF  36 	362 1 2; 
equalDOF  25 	254 1 2; equalDOF  26 	262 1 2; 

# EGF Column Joints
equalDOF  35 	351 1 2; equalDOF  36 	361 1 2; 
equalDOF  25 	253 1 2; equalDOF  26 	263 1 2; 
equalDOF  25 	251 1 2; equalDOF  26 	261 1 2; 
equalDOF  15 	153 1 2; equalDOF  16 	163 1 2; 

###############################################################################################################################################################################
###############################################################################################################################################################################
                                                                                  puts "Model Built"
###############################################################################################################################################################################
###############################################################################################################################################################################

###################################################################################################
#                                             RECORDERS                                           #
###################################################################################################

# Time
recorder Node -file $MainFolder/$SubFolder/Time.out  -time -node 11 -dof 1 disp;

# Story Drift
recorder Drift -file $MainFolder/$SubFolder/SDR_MRF2.out   -iNode 402104 -jNode 403104 -dof 1 -perpDirn 2; recorder Drift -file $MainFolder/$SubFolder/SDR_EGF2.out -iNode 102500 -jNode    103500 -dof 1 -perpDirn 2;
recorder Drift -file $MainFolder/$SubFolder/SDR_MRF1.out   -iNode 11   -jNode 402104 -dof 1 -perpDirn 2; recorder Drift -file $MainFolder/$SubFolder/SDR_EGF1.out -iNode 101500 -jNode    102500 -dof 1 -perpDirn 2;

if {$EQ==1} {
# Floor Accelerations
recorder Node -file $MainFolder/$SubFolder/RFA_MRF3.out   -node 403103 -dof 1 accel; recorder Node -file $MainFolder/$SubFolder/RFA_EGF3.out -node 35 -dof 1 accel;
recorder Node -file $MainFolder/$SubFolder/RFA_MRF2.out   -node 402103 -dof 1 accel; recorder Node -file $MainFolder/$SubFolder/RFA_EGF2.out -node 25 -dof 1 accel;
recorder Node -file $MainFolder/$SubFolder/RFA_MRF1.out   -node 11   -dof 1 accel; recorder Node -file $MainFolder/$SubFolder/RFA_EGF1.out -node 101500  -dof 1 accel;
}

###################################################################################################
#                                            NODAL MASS                                           #
###################################################################################################

set g 386.09;
mass 403103 0.4045  1.e-9 1.e-9; mass 403203 0.4045  1.e-9 1.e-9; mass 403303 0.4045  1.e-9 1.e-9; mass 403403 0.4045  1.e-9 1.e-9; mass 35 0.4045  1.e-9 1.e-9; mass 36 0.4045  1.e-9 1.e-9; 
mass 402103 0.7382  1.e-9 1.e-9; mass 402203 0.7382  1.e-9 1.e-9; mass 402303 0.7382  1.e-9 1.e-9; mass 402403 0.7382  1.e-9 1.e-9; mass 25 0.7382  1.e-9 1.e-9; mass 26 0.7382  1.e-9 1.e-9; 

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
set T1 [expr 2.0*$pi/$w1];
set T2 [expr 2.0*$pi/$w2];
puts "T1 = $T1 s";
puts "T2 = $T2 s";

##############################################################################################################################################################################
###############################################################################################################################################################################
                                                                               puts "Eigen Analysis Done"
###############################################################################################################################################################################
###############################################################################################################################################################################

###################################################################################################
#                                      STATIC GRAVITY ANALYSIS                                    #
###################################################################################################

pattern Plain 100 Linear {

# MRF COLUMNS LOADS
load 403103 0. -84.030 0.; load 403203 0. -63.555 0.; load 403303 0. -63.555 0.; load 403403 0. -84.030 0.; 
load 402103 0. -164.400 0.; load 402203 0. -120.300 0.; load 402303 0. -120.300 0.; load 402403 0. -164.400 0.; 

# EGC/LC COLUMN LOADS
load 35 0. -361.840000 0.; load 36 0. -361.840000 0.; 
load 25 0. -619.000000 0.; load 26 0. -619.000000 0.; 

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

###############################################################################################################################################################################
###############################################################################################################################################################################
                                                                                     puts "Gravity Done"
###############################################################################################################################################################################
###############################################################################################################################################################################

puts "Seismic Weight= 2826.250 kip";
puts "Seismic Mass=  6.856 kip.sec2/in";

if {$ShowAnimation == 1} {
DisplayModel3D DeformedShape 5 50 50  2000 1500
}

############################################################################
#                          Pushover Analysis                     		    #
############################################################################

if {$PO==1} {

	# Create Load Pattern
	pattern Plain 222 Linear {
	load 403103 0.27933 0.0 0.0
	load 402103 0.12671 0.0 0.0
	}

	# Displacement Control Parameters
	set CtrlNode 403104;
	set CtrlDOF 1;
	set Dmax [expr 0.100*$Floor3];
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
	set zeta 0.020;
	set a0 [expr $zeta*2.0*$w1*$w2/($w1 + $w2)];
	set a1 [expr $zeta*2.0/($w1 + $w2)];
	set a1_mod [expr $a1*(1.0+$n)/$n];
	region 1 -eleRange  502100  602400 -rayleigh 0.0 0.0 $a1_mod 0.0;
	region 2 -node  402103 402203 402303 402403 102500 102600 403103 403203 403303 403403 103500 103600  -rayleigh $a0 0.0 0.0 0.0;
	
	# GROUND MOTION ACCELERATION FILE INPUT
	set AccelSeries "Series -dt $dt -filePath $GMfile -factor  [expr $EqScale* $g]"
	pattern UniformExcitation  200 1 -accel $AccelSeries

	set SMFFloorNodes [list  402104 403104 ];
	DynamicAnalysisCollapseSolver   $dt	$dtAnalysis	$totTime 4	0.15   $SMFFloorNodes	180.00 156.00;

	puts "Ground Motion Done. End Time: [getTime]"
	
}

wipe all;
