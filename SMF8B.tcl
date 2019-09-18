# 8-story MRF Building
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
source Spring_Zero.tcl;
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
set NStory  8;
set NBay  3;

# MATERIAL PROPERTIES
set E  29000.0; 
set Fy [expr 55.000000 * 1.000000];

# PANEL ZONE PARAMETERS
set SH_Panel 0.03;
set A_Stiff 1000.0;
set I_Stiff 100000.0;

# Composite Beam Factor
puts "This is the B model"
set Composite 0;
set Comp_I    1.0;
set Comp_I_GC 1.0;

# Basic Materials
uniaxialMaterial Elastic  99 1000000000.;  #Rigid Material 
uniaxialMaterial Elastic  9  1.e-9; 		#Flexible Material 

####################################################################################################
#                                          PRE-CALCULATIONS                                        #
####################################################################################################

# REDUCED BEAM SECTION LENGTH (from column face to RBS center)
set L_RBS9  [expr  0.625 *  8.27 +  0.750 * 21.10/2.];
set L_RBS8  [expr  0.625 *  9.96 +  0.750 * 26.70/2.];
set L_RBS7  [expr  0.625 *  9.96 +  0.750 * 26.70/2.];
set L_RBS6  [expr  0.625 *  9.99 +  0.750 * 26.90/2.];
set L_RBS5  [expr  0.625 *  9.99 +  0.750 * 26.90/2.];
set L_RBS4  [expr  0.625 * 10.50 +  0.750 * 30.00/2.];
set L_RBS3  [expr  0.625 * 10.50 +  0.750 * 30.00/2.];
set L_RBS2  [expr  0.625 * 10.50 +  0.750 * 29.80/2.];

# FRAME GRID LINES
set HBuilding 1272.00;
set Floor9  1272.00;
set Floor8  1116.00;
set Floor7  960.00;
set Floor6  804.00;
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
node 95   $Axis5  $Floor9; node 96   $Axis6  $Floor9; 
node 85   $Axis5  $Floor8; node 86   $Axis6  $Floor8; 
node 75   $Axis5  $Floor7; node 76   $Axis6  $Floor7; 
node 65   $Axis5  $Floor6; node 66   $Axis6  $Floor6; 
node 55   $Axis5  $Floor5; node 56   $Axis6  $Floor5; 
node 45   $Axis5  $Floor4; node 46   $Axis6  $Floor4; 
node 35   $Axis5  $Floor3; node 36   $Axis6  $Floor3; 
node 25   $Axis5  $Floor2; node 26   $Axis6  $Floor2; 

# MRF BEAM NODES
node 914   [expr $Axis1 + $L_RBS9 + 24.30/2] $Floor9; node 922   [expr $Axis2 - $L_RBS9 - 24.30/2] $Floor9; node 924   [expr $Axis2 + $L_RBS9 + 24.30/2] $Floor9; node 932   [expr $Axis3 - $L_RBS9 - 24.30/2] $Floor9; node 934   [expr $Axis3 + $L_RBS9 + 24.30/2] $Floor9; node 942   [expr $Axis4 - $L_RBS9 - 24.30/2] $Floor9; 
node 814   [expr $Axis1 + $L_RBS8 + 24.50/2] $Floor8; node 822   [expr $Axis2 - $L_RBS8 - 24.50/2] $Floor8; node 824   [expr $Axis2 + $L_RBS8 + 24.50/2] $Floor8; node 832   [expr $Axis3 - $L_RBS8 - 24.50/2] $Floor8; node 834   [expr $Axis3 + $L_RBS8 + 24.50/2] $Floor8; node 842   [expr $Axis4 - $L_RBS8 - 24.50/2] $Floor8; 
node 714   [expr $Axis1 + $L_RBS7 + 24.50/2] $Floor7; node 722   [expr $Axis2 - $L_RBS7 - 24.50/2] $Floor7; node 724   [expr $Axis2 + $L_RBS7 + 24.50/2] $Floor7; node 732   [expr $Axis3 - $L_RBS7 - 24.50/2] $Floor7; node 734   [expr $Axis3 + $L_RBS7 + 24.50/2] $Floor7; node 742   [expr $Axis4 - $L_RBS7 - 24.50/2] $Floor7; 
node 614   [expr $Axis1 + $L_RBS6 + 24.50/2] $Floor6; node 622   [expr $Axis2 - $L_RBS6 - 25.20/2] $Floor6; node 624   [expr $Axis2 + $L_RBS6 + 25.20/2] $Floor6; node 632   [expr $Axis3 - $L_RBS6 - 25.20/2] $Floor6; node 634   [expr $Axis3 + $L_RBS6 + 25.20/2] $Floor6; node 642   [expr $Axis4 - $L_RBS6 - 24.50/2] $Floor6; 
node 514   [expr $Axis1 + $L_RBS5 + 24.50/2] $Floor5; node 522   [expr $Axis2 - $L_RBS5 - 25.20/2] $Floor5; node 524   [expr $Axis2 + $L_RBS5 + 25.20/2] $Floor5; node 532   [expr $Axis3 - $L_RBS5 - 25.20/2] $Floor5; node 534   [expr $Axis3 + $L_RBS5 + 25.20/2] $Floor5; node 542   [expr $Axis4 - $L_RBS5 - 24.50/2] $Floor5; 
node 414   [expr $Axis1 + $L_RBS4 + 24.70/2] $Floor4; node 422   [expr $Axis2 - $L_RBS4 - 25.50/2] $Floor4; node 424   [expr $Axis2 + $L_RBS4 + 25.50/2] $Floor4; node 432   [expr $Axis3 - $L_RBS4 - 25.50/2] $Floor4; node 434   [expr $Axis3 + $L_RBS4 + 25.50/2] $Floor4; node 442   [expr $Axis4 - $L_RBS4 - 24.70/2] $Floor4; 
node 314   [expr $Axis1 + $L_RBS3 + 24.70/2] $Floor3; node 322   [expr $Axis2 - $L_RBS3 - 25.50/2] $Floor3; node 324   [expr $Axis2 + $L_RBS3 + 25.50/2] $Floor3; node 332   [expr $Axis3 - $L_RBS3 - 25.50/2] $Floor3; node 334   [expr $Axis3 + $L_RBS3 + 25.50/2] $Floor3; node 342   [expr $Axis4 - $L_RBS3 - 24.70/2] $Floor3; 
node 214   [expr $Axis1 + $L_RBS2 + 24.70/2] $Floor2; node 222   [expr $Axis2 - $L_RBS2 - 25.50/2] $Floor2; node 224   [expr $Axis2 + $L_RBS2 + 25.50/2] $Floor2; node 232   [expr $Axis3 - $L_RBS2 - 25.50/2] $Floor2; node 234   [expr $Axis3 + $L_RBS2 + 25.50/2] $Floor2; node 242   [expr $Axis4 - $L_RBS2 - 24.70/2] $Floor2; 

# MRF COLUMN NODES
node 911  $Axis1 [expr $Floor9 - 21.10/2]; node 921  $Axis2 [expr $Floor9 - 21.10/2]; node 931  $Axis3 [expr $Floor9 - 21.10/2]; node 941  $Axis4 [expr $Floor9 - 21.10/2]; 
node 813  $Axis1 [expr $Floor8 + 26.70/2]; node 823  $Axis2 [expr $Floor8 + 26.70/2]; node 833  $Axis3 [expr $Floor8 + 26.70/2]; node 843  $Axis4 [expr $Floor8 + 26.70/2]; 
node 811  $Axis1 [expr $Floor8 - 26.70/2]; node 821  $Axis2 [expr $Floor8 - 26.70/2]; node 831  $Axis3 [expr $Floor8 - 26.70/2]; node 841  $Axis4 [expr $Floor8 - 26.70/2]; 
node 713  $Axis1 [expr $Floor7 + 26.70/2]; node 723  $Axis2 [expr $Floor7 + 26.70/2]; node 733  $Axis3 [expr $Floor7 + 26.70/2]; node 743  $Axis4 [expr $Floor7 + 26.70/2]; 
node 711  $Axis1 [expr $Floor7 - 26.70/2]; node 721  $Axis2 [expr $Floor7 - 26.70/2]; node 731  $Axis3 [expr $Floor7 - 26.70/2]; node 741  $Axis4 [expr $Floor7 - 26.70/2]; 
node 613  $Axis1 [expr $Floor6 + 26.90/2]; node 623  $Axis2 [expr $Floor6 + 26.90/2]; node 633  $Axis3 [expr $Floor6 + 26.90/2]; node 643  $Axis4 [expr $Floor6 + 26.90/2]; 
node 611  $Axis1 [expr $Floor6 - 26.90/2]; node 621  $Axis2 [expr $Floor6 - 26.90/2]; node 631  $Axis3 [expr $Floor6 - 26.90/2]; node 641  $Axis4 [expr $Floor6 - 26.90/2]; 
node 513  $Axis1 [expr $Floor5 + 26.90/2]; node 523  $Axis2 [expr $Floor5 + 26.90/2]; node 533  $Axis3 [expr $Floor5 + 26.90/2]; node 543  $Axis4 [expr $Floor5 + 26.90/2]; 
node 511  $Axis1 [expr $Floor5 - 26.90/2]; node 521  $Axis2 [expr $Floor5 - 26.90/2]; node 531  $Axis3 [expr $Floor5 - 26.90/2]; node 541  $Axis4 [expr $Floor5 - 26.90/2]; 
node 413  $Axis1 [expr $Floor4 + 30.00/2]; node 423  $Axis2 [expr $Floor4 + 30.00/2]; node 433  $Axis3 [expr $Floor4 + 30.00/2]; node 443  $Axis4 [expr $Floor4 + 30.00/2]; 
node 411  $Axis1 [expr $Floor4 - 30.00/2]; node 421  $Axis2 [expr $Floor4 - 30.00/2]; node 431  $Axis3 [expr $Floor4 - 30.00/2]; node 441  $Axis4 [expr $Floor4 - 30.00/2]; 
node 313  $Axis1 [expr $Floor3 + 30.00/2]; node 323  $Axis2 [expr $Floor3 + 30.00/2]; node 333  $Axis3 [expr $Floor3 + 30.00/2]; node 343  $Axis4 [expr $Floor3 + 30.00/2]; 
node 311  $Axis1 [expr $Floor3 - 30.00/2]; node 321  $Axis2 [expr $Floor3 - 30.00/2]; node 331  $Axis3 [expr $Floor3 - 30.00/2]; node 341  $Axis4 [expr $Floor3 - 30.00/2]; 
node 213  $Axis1 [expr $Floor2 + 29.80/2]; node 223  $Axis2 [expr $Floor2 + 29.80/2]; node 233  $Axis3 [expr $Floor2 + 29.80/2]; node 243  $Axis4 [expr $Floor2 + 29.80/2]; 
node 211  $Axis1 [expr $Floor2 - 29.80/2]; node 221  $Axis2 [expr $Floor2 - 29.80/2]; node 231  $Axis3 [expr $Floor2 - 29.80/2]; node 241  $Axis4 [expr $Floor2 - 29.80/2]; 
node 113  $Axis1 $Floor1; node 123  $Axis2 $Floor1; node 133  $Axis3 $Floor1; node 143  $Axis4 $Floor1; 

# BEAM PLASTIC HINGE NODES
node 9140   [expr $Axis1 + $L_RBS9 + 24.30/2] $Floor9; node 9220   [expr $Axis2 - $L_RBS9 - 24.30/2] $Floor9; node 9240   [expr $Axis2 + $L_RBS9 + 24.30/2] $Floor9; node 9320   [expr $Axis3 - $L_RBS9 - 24.30/2] $Floor9; node 9340   [expr $Axis3 + $L_RBS9 + 24.30/2] $Floor9; node 9420   [expr $Axis4 - $L_RBS9 - 24.30/2] $Floor9; 
node 8140   [expr $Axis1 + $L_RBS8 + 24.50/2] $Floor8; node 8220   [expr $Axis2 - $L_RBS8 - 24.50/2] $Floor8; node 8240   [expr $Axis2 + $L_RBS8 + 24.50/2] $Floor8; node 8320   [expr $Axis3 - $L_RBS8 - 24.50/2] $Floor8; node 8340   [expr $Axis3 + $L_RBS8 + 24.50/2] $Floor8; node 8420   [expr $Axis4 - $L_RBS8 - 24.50/2] $Floor8; 
node 7140   [expr $Axis1 + $L_RBS7 + 24.50/2] $Floor7; node 7220   [expr $Axis2 - $L_RBS7 - 24.50/2] $Floor7; node 7240   [expr $Axis2 + $L_RBS7 + 24.50/2] $Floor7; node 7320   [expr $Axis3 - $L_RBS7 - 24.50/2] $Floor7; node 7340   [expr $Axis3 + $L_RBS7 + 24.50/2] $Floor7; node 7420   [expr $Axis4 - $L_RBS7 - 24.50/2] $Floor7; 
node 6140   [expr $Axis1 + $L_RBS6 + 24.50/2] $Floor6; node 6220   [expr $Axis2 - $L_RBS6 - 25.20/2] $Floor6; node 6240   [expr $Axis2 + $L_RBS6 + 25.20/2] $Floor6; node 6320   [expr $Axis3 - $L_RBS6 - 25.20/2] $Floor6; node 6340   [expr $Axis3 + $L_RBS6 + 25.20/2] $Floor6; node 6420   [expr $Axis4 - $L_RBS6 - 24.50/2] $Floor6; 
node 5140   [expr $Axis1 + $L_RBS5 + 24.50/2] $Floor5; node 5220   [expr $Axis2 - $L_RBS5 - 25.20/2] $Floor5; node 5240   [expr $Axis2 + $L_RBS5 + 25.20/2] $Floor5; node 5320   [expr $Axis3 - $L_RBS5 - 25.20/2] $Floor5; node 5340   [expr $Axis3 + $L_RBS5 + 25.20/2] $Floor5; node 5420   [expr $Axis4 - $L_RBS5 - 24.50/2] $Floor5; 
node 4140   [expr $Axis1 + $L_RBS4 + 24.70/2] $Floor4; node 4220   [expr $Axis2 - $L_RBS4 - 25.50/2] $Floor4; node 4240   [expr $Axis2 + $L_RBS4 + 25.50/2] $Floor4; node 4320   [expr $Axis3 - $L_RBS4 - 25.50/2] $Floor4; node 4340   [expr $Axis3 + $L_RBS4 + 25.50/2] $Floor4; node 4420   [expr $Axis4 - $L_RBS4 - 24.70/2] $Floor4; 
node 3140   [expr $Axis1 + $L_RBS3 + 24.70/2] $Floor3; node 3220   [expr $Axis2 - $L_RBS3 - 25.50/2] $Floor3; node 3240   [expr $Axis2 + $L_RBS3 + 25.50/2] $Floor3; node 3320   [expr $Axis3 - $L_RBS3 - 25.50/2] $Floor3; node 3340   [expr $Axis3 + $L_RBS3 + 25.50/2] $Floor3; node 3420   [expr $Axis4 - $L_RBS3 - 24.70/2] $Floor3; 
node 2140   [expr $Axis1 + $L_RBS2 + 24.70/2] $Floor2; node 2220   [expr $Axis2 - $L_RBS2 - 25.50/2] $Floor2; node 2240   [expr $Axis2 + $L_RBS2 + 25.50/2] $Floor2; node 2320   [expr $Axis3 - $L_RBS2 - 25.50/2] $Floor2; node 2340   [expr $Axis3 + $L_RBS2 + 25.50/2] $Floor2; node 2420   [expr $Axis4 - $L_RBS2 - 24.70/2] $Floor2; 

# COLUMN SPLICE NODES
node 107170 $Axis1 [expr ($Floor7+$Floor8)/2]; node 107270 $Axis2 [expr ($Floor7+$Floor8)/2]; node 107370 $Axis3 [expr ($Floor7+$Floor8)/2]; node 107470 $Axis4 [expr ($Floor7+$Floor8)/2]; node 107570 $Axis5 [expr ($Floor7+$Floor8)/2]; node 107670 $Axis6 [expr ($Floor7+$Floor8)/2]; 
node 105170 $Axis1 [expr ($Floor5+$Floor6)/2]; node 105270 $Axis2 [expr ($Floor5+$Floor6)/2]; node 105370 $Axis3 [expr ($Floor5+$Floor6)/2]; node 105470 $Axis4 [expr ($Floor5+$Floor6)/2]; node 105570 $Axis5 [expr ($Floor5+$Floor6)/2]; node 105670 $Axis6 [expr ($Floor5+$Floor6)/2]; 
node 103170 $Axis1 [expr ($Floor3+$Floor4)/2]; node 103270 $Axis2 [expr ($Floor3+$Floor4)/2]; node 103370 $Axis3 [expr ($Floor3+$Floor4)/2]; node 103470 $Axis4 [expr ($Floor3+$Floor4)/2]; node 103570 $Axis5 [expr ($Floor3+$Floor4)/2]; node 103670 $Axis6 [expr ($Floor3+$Floor4)/2]; 

# EGF BEAM NODES
node 954  $Axis5  $Floor9; node 962  $Axis6  $Floor9; 
node 854  $Axis5  $Floor8; node 862  $Axis6  $Floor8; 
node 754  $Axis5  $Floor7; node 762  $Axis6  $Floor7; 
node 654  $Axis5  $Floor6; node 662  $Axis6  $Floor6; 
node 554  $Axis5  $Floor5; node 562  $Axis6  $Floor5; 
node 454  $Axis5  $Floor4; node 462  $Axis6  $Floor4; 
node 354  $Axis5  $Floor3; node 362  $Axis6  $Floor3; 
node 254  $Axis5  $Floor2; node 262  $Axis6  $Floor2; 

# EGF COLUMN NODES
node 951  $Axis5  $Floor9; node 961  $Axis6  $Floor9; 
node 853  $Axis5  $Floor8; node 863  $Axis6  $Floor8; 
node 851  $Axis5  $Floor8; node 861  $Axis6  $Floor8; 
node 753  $Axis5  $Floor7; node 763  $Axis6  $Floor7; 
node 751  $Axis5  $Floor7; node 761  $Axis6  $Floor7; 
node 653  $Axis5  $Floor6; node 663  $Axis6  $Floor6; 
node 651  $Axis5  $Floor6; node 661  $Axis6  $Floor6; 
node 553  $Axis5  $Floor5; node 563  $Axis6  $Floor5; 
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
ConstructPanel  1 9 $Axis1 $Floor9 $E $A_Stiff $I_Stiff 24.30 21.10 1; ConstructPanel  2 9 $Axis2 $Floor9 $E $A_Stiff $I_Stiff 24.30 21.10 1; ConstructPanel  3 9 $Axis3 $Floor9 $E $A_Stiff $I_Stiff 24.30 21.10 1; ConstructPanel  4 9 $Axis4 $Floor9 $E $A_Stiff $I_Stiff 24.30 21.10 1; 
ConstructPanel  1 8 $Axis1 $Floor8 $E $A_Stiff $I_Stiff 24.30 26.70 1; ConstructPanel  2 8 $Axis2 $Floor8 $E $A_Stiff $I_Stiff 24.30 26.70 1; ConstructPanel  3 8 $Axis3 $Floor8 $E $A_Stiff $I_Stiff 24.30 26.70 1; ConstructPanel  4 8 $Axis4 $Floor8 $E $A_Stiff $I_Stiff 24.30 26.70 1; 
ConstructPanel  1 7 $Axis1 $Floor7 $E $A_Stiff $I_Stiff 24.50 26.70 1; ConstructPanel  2 7 $Axis2 $Floor7 $E $A_Stiff $I_Stiff 24.50 26.70 1; ConstructPanel  3 7 $Axis3 $Floor7 $E $A_Stiff $I_Stiff 24.50 26.70 1; ConstructPanel  4 7 $Axis4 $Floor7 $E $A_Stiff $I_Stiff 24.50 26.70 1; 
ConstructPanel  1 6 $Axis1 $Floor6 $E $A_Stiff $I_Stiff 24.50 26.90 1; ConstructPanel  2 6 $Axis2 $Floor6 $E $A_Stiff $I_Stiff 24.50 26.90 1; ConstructPanel  3 6 $Axis3 $Floor6 $E $A_Stiff $I_Stiff 24.50 26.90 1; ConstructPanel  4 6 $Axis4 $Floor6 $E $A_Stiff $I_Stiff 24.50 26.90 1; 
ConstructPanel  1 5 $Axis1 $Floor5 $E $A_Stiff $I_Stiff 24.50 26.90 1; ConstructPanel  2 5 $Axis2 $Floor5 $E $A_Stiff $I_Stiff 25.20 26.90 1; ConstructPanel  3 5 $Axis3 $Floor5 $E $A_Stiff $I_Stiff 25.20 26.90 1; ConstructPanel  4 5 $Axis4 $Floor5 $E $A_Stiff $I_Stiff 24.50 26.90 1; 
ConstructPanel  1 4 $Axis1 $Floor4 $E $A_Stiff $I_Stiff 24.50 30.00 1; ConstructPanel  2 4 $Axis2 $Floor4 $E $A_Stiff $I_Stiff 25.20 30.00 1; ConstructPanel  3 4 $Axis3 $Floor4 $E $A_Stiff $I_Stiff 25.20 30.00 1; ConstructPanel  4 4 $Axis4 $Floor4 $E $A_Stiff $I_Stiff 24.50 30.00 1; 
ConstructPanel  1 3 $Axis1 $Floor3 $E $A_Stiff $I_Stiff 24.70 30.00 1; ConstructPanel  2 3 $Axis2 $Floor3 $E $A_Stiff $I_Stiff 25.50 30.00 1; ConstructPanel  3 3 $Axis3 $Floor3 $E $A_Stiff $I_Stiff 25.50 30.00 1; ConstructPanel  4 3 $Axis4 $Floor3 $E $A_Stiff $I_Stiff 24.70 30.00 1; 
ConstructPanel  1 2 $Axis1 $Floor2 $E $A_Stiff $I_Stiff 24.70 29.80 1; ConstructPanel  2 2 $Axis2 $Floor2 $E $A_Stiff $I_Stiff 25.50 29.80 1; ConstructPanel  3 2 $Axis3 $Floor2 $E $A_Stiff $I_Stiff 25.50 29.80 1; ConstructPanel  4 2 $Axis4 $Floor2 $E $A_Stiff $I_Stiff 24.70 29.80 1; 

####################################################################################################
#                                   		PANEL ZONE SPRINGS	                                   #
####################################################################################################

# Command Syntax; 
# Spring_Panel Element_ID Node_i Node_j E Fy tp d_Colum d_Beam tf_Column bf_Column SH_Panel Response_ID transfTag Units
Spring_Panel 909100 409109 409110 $E $Fy [expr  0.52 +  0.00] 24.30 21.10  0.88  9.07  0.03 2 1 2; Spring_Panel 909200 409209 409210 $E $Fy [expr  0.52 +  0.31] 24.30 21.10  0.88  9.07  0.03 2 1 2; Spring_Panel 909300 409309 409310 $E $Fy [expr  0.52 +  0.31] 24.30 21.10  0.88  9.07  0.03 2 1 2; Spring_Panel 909400 409409 409410 $E $Fy [expr  0.52 +  0.00] 24.30 21.10  0.88  9.07  0.03 2 1 2; 
Spring_Panel 908100 408109 408110 $E $Fy [expr  0.52 +  0.00] 24.30 26.70  0.88  9.07  0.03 2 1 2; Spring_Panel 908200 408209 408210 $E $Fy [expr  0.52 +  0.56] 24.30 26.70  0.88  9.07  0.03 2 1 2; Spring_Panel 908300 408309 408310 $E $Fy [expr  0.52 +  0.56] 24.30 26.70  0.88  9.07  0.03 2 1 2; Spring_Panel 908400 408409 408410 $E $Fy [expr  0.52 +  0.00] 24.30 26.70  0.88  9.07  0.03 2 1 2; 
Spring_Panel 907100 407109 407110 $E $Fy [expr  0.60 +  0.00] 24.50 26.70  0.96 12.90  0.03 2 1 2; Spring_Panel 907200 407209 407210 $E $Fy [expr  0.60 +  0.44] 24.50 26.70  0.96 12.90  0.03 2 1 2; Spring_Panel 907300 407309 407310 $E $Fy [expr  0.60 +  0.44] 24.50 26.70  0.96 12.90  0.03 2 1 2; Spring_Panel 907400 407409 407410 $E $Fy [expr  0.60 +  0.00] 24.50 26.70  0.96 12.90  0.03 2 1 2; 
Spring_Panel 906100 406109 406110 $E $Fy [expr  0.60 +  0.00] 24.50 26.90  0.96 12.90  0.03 2 1 2; Spring_Panel 906200 406209 406210 $E $Fy [expr  0.60 +  0.56] 24.50 26.90  0.96 12.90  0.03 2 1 2; Spring_Panel 906300 406309 406310 $E $Fy [expr  0.60 +  0.56] 24.50 26.90  0.96 12.90  0.03 2 1 2; Spring_Panel 906400 406409 406410 $E $Fy [expr  0.60 +  0.00] 24.50 26.90  0.96 12.90  0.03 2 1 2; 
Spring_Panel 905100 405109 405110 $E $Fy [expr  0.60 +  0.00] 24.50 26.90  0.96 12.90  0.03 2 1 2; Spring_Panel 905200 405209 405210 $E $Fy [expr  0.75 +  0.31] 25.20 26.90  1.34 12.90  0.03 2 1 2; Spring_Panel 905300 405309 405310 $E $Fy [expr  0.75 +  0.31] 25.20 26.90  1.34 12.90  0.03 2 1 2; Spring_Panel 905400 405409 405410 $E $Fy [expr  0.60 +  0.00] 24.50 26.90  0.96 12.90  0.03 2 1 2; 
Spring_Panel 904100 404109 404110 $E $Fy [expr  0.60 +  0.06] 24.50 30.00  0.96 12.90  0.03 2 1 2; Spring_Panel 904200 404209 404210 $E $Fy [expr  0.75 +  0.63] 25.20 30.00  1.34 12.90  0.03 2 1 2; Spring_Panel 904300 404309 404310 $E $Fy [expr  0.75 +  0.63] 25.20 30.00  1.34 12.90  0.03 2 1 2; Spring_Panel 904400 404409 404410 $E $Fy [expr  0.60 +  0.06] 24.50 30.00  0.96 12.90  0.03 2 1 2; 
Spring_Panel 903100 403109 403110 $E $Fy [expr  0.65 +  0.06] 24.70 30.00  1.09 12.90  0.03 2 1 2; Spring_Panel 903200 403209 403210 $E $Fy [expr  0.81 +  0.44] 25.50 30.00  1.46 13.00  0.03 2 1 2; Spring_Panel 903300 403309 403310 $E $Fy [expr  0.81 +  0.44] 25.50 30.00  1.46 13.00  0.03 2 1 2; Spring_Panel 903400 403409 403410 $E $Fy [expr  0.65 +  0.06] 24.70 30.00  1.09 12.90  0.03 2 1 2; 
Spring_Panel 902100 402109 402110 $E $Fy [expr  0.65 +  0.00] 24.70 29.80  1.09 12.90  0.03 2 1 2; Spring_Panel 902200 402209 402210 $E $Fy [expr  0.81 +  0.38] 25.50 29.80  1.46 13.00  0.03 2 1 2; Spring_Panel 902300 402309 402310 $E $Fy [expr  0.81 +  0.38] 25.50 29.80  1.46 13.00  0.03 2 1 2; Spring_Panel 902400 402409 402410 $E $Fy [expr  0.65 +  0.00] 24.70 29.80  1.09 12.90  0.03 2 1 2; 

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
element ModElasticBeam2d 608100 813 911  27.7000 $E [expr ($n+1)/$n*2700.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 608200 823 921  27.7000 $E [expr ($n+1)/$n*2700.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 608300 833 931  27.7000 $E [expr ($n+1)/$n*2700.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 608400 843 941  27.7000 $E [expr ($n+1)/$n*2700.0000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 607102 107170 811 27.7000 $E [expr ($n+1)/$n*2700.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 607202 107270 821 27.7000 $E [expr ($n+1)/$n*2700.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 607302 107370 831 27.7000 $E [expr ($n+1)/$n*2700.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 607402 107470 841 27.7000 $E [expr ($n+1)/$n*2700.0000] $K33_1 $K11_1 $K44_1 1;  
element ModElasticBeam2d 607101 713 107170 38.5000 $E [expr ($n+1)/$n*4020.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 607201 723 107270 38.5000 $E [expr ($n+1)/$n*4020.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 607301 733 107370 38.5000 $E [expr ($n+1)/$n*4020.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 607401 743 107470 38.5000 $E [expr ($n+1)/$n*4020.0000] $K33_1 $K11_1 $K44_1 1;  
element ModElasticBeam2d 606100 613 711  38.5000 $E [expr ($n+1)/$n*4020.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 606200 623 721  38.5000 $E [expr ($n+1)/$n*4020.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 606300 633 731  38.5000 $E [expr ($n+1)/$n*4020.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 606400 643 741  38.5000 $E [expr ($n+1)/$n*4020.0000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 605102 105170 611 38.5000 $E [expr ($n+1)/$n*4020.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 605202 105270 621 38.5000 $E [expr ($n+1)/$n*4020.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 605302 105370 631 38.5000 $E [expr ($n+1)/$n*4020.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 605402 105470 641 38.5000 $E [expr ($n+1)/$n*4020.0000] $K33_1 $K11_1 $K44_1 1;  
element ModElasticBeam2d 605101 513 105170 38.5000 $E [expr ($n+1)/$n*4020.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 605201 523 105270 51.7000 $E [expr ($n+1)/$n*5680.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 605301 533 105370 51.7000 $E [expr ($n+1)/$n*5680.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 605401 543 105470 38.5000 $E [expr ($n+1)/$n*4020.0000] $K33_1 $K11_1 $K44_1 1;  
element ModElasticBeam2d 604100 413 511  38.5000 $E [expr ($n+1)/$n*4020.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 604200 423 521  51.7000 $E [expr ($n+1)/$n*5680.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 604300 433 531  51.7000 $E [expr ($n+1)/$n*5680.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 604400 443 541  38.5000 $E [expr ($n+1)/$n*4020.0000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 603102 103170 411 38.5000 $E [expr ($n+1)/$n*4020.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 603202 103270 421 51.7000 $E [expr ($n+1)/$n*5680.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 603302 103370 431 51.7000 $E [expr ($n+1)/$n*5680.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 603402 103470 441 38.5000 $E [expr ($n+1)/$n*4020.0000] $K33_1 $K11_1 $K44_1 1;  
element ModElasticBeam2d 603101 313 103170 43.0000 $E [expr ($n+1)/$n*4580.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 603201 323 103270 56.3000 $E [expr ($n+1)/$n*6260.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 603301 333 103370 56.3000 $E [expr ($n+1)/$n*6260.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 603401 343 103470 43.0000 $E [expr ($n+1)/$n*4580.0000] $K33_1 $K11_1 $K44_1 1;  
element ModElasticBeam2d 602100 213 311  43.0000 $E [expr ($n+1)/$n*4580.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 602200 223 321  56.3000 $E [expr ($n+1)/$n*6260.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 602300 233 331  56.3000 $E [expr ($n+1)/$n*6260.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 602400 243 341  43.0000 $E [expr ($n+1)/$n*4580.0000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 601100 113 211  43.0000 $E [expr ($n+1)/$n*4580.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 601200 123 221  56.3000 $E [expr ($n+1)/$n*6260.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 601300 133 231  56.3000 $E [expr ($n+1)/$n*6260.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 601400 143 241  43.0000 $E [expr ($n+1)/$n*4580.0000] $K11_2 $K33_2 $K44_2 1; 

# BEAMS
element ModElasticBeam2d 509100 914 922  20.000 $E [expr ($n+1)/$n*0.90*$Comp_I*1480.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 509200 924 932  20.000 $E [expr ($n+1)/$n*0.90*$Comp_I*1480.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 509300 934 942  20.000 $E [expr ($n+1)/$n*0.90*$Comp_I*1480.000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 508100 814 822  24.800 $E [expr ($n+1)/$n*0.90*$Comp_I*2850.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 508200 824 832  24.800 $E [expr ($n+1)/$n*0.90*$Comp_I*2850.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 508300 834 842  24.800 $E [expr ($n+1)/$n*0.90*$Comp_I*2850.000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 507100 714 722  24.800 $E [expr ($n+1)/$n*0.90*$Comp_I*2850.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 507200 724 732  24.800 $E [expr ($n+1)/$n*0.90*$Comp_I*2850.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 507300 734 742  24.800 $E [expr ($n+1)/$n*0.90*$Comp_I*2850.000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 506100 614 622  27.700 $E [expr ($n+1)/$n*0.90*$Comp_I*3270.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 506200 624 632  27.700 $E [expr ($n+1)/$n*0.90*$Comp_I*3270.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 506300 634 642  27.700 $E [expr ($n+1)/$n*0.90*$Comp_I*3270.000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 505100 514 522  27.700 $E [expr ($n+1)/$n*0.90*$Comp_I*3270.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 505200 524 532  27.700 $E [expr ($n+1)/$n*0.90*$Comp_I*3270.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 505300 534 542  27.700 $E [expr ($n+1)/$n*0.90*$Comp_I*3270.000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 504100 414 422  34.200 $E [expr ($n+1)/$n*0.90*$Comp_I*4930.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 504200 424 432  34.200 $E [expr ($n+1)/$n*0.90*$Comp_I*4930.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 504300 434 442  34.200 $E [expr ($n+1)/$n*0.90*$Comp_I*4930.000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 503100 314 322  34.200 $E [expr ($n+1)/$n*0.90*$Comp_I*4930.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 503200 324 332  34.200 $E [expr ($n+1)/$n*0.90*$Comp_I*4930.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 503300 334 342  34.200 $E [expr ($n+1)/$n*0.90*$Comp_I*4930.000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 502100 214 222  31.700 $E [expr ($n+1)/$n*0.90*$Comp_I*4470.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 502200 224 232  31.700 $E [expr ($n+1)/$n*0.90*$Comp_I*4470.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 502300 234 242  31.700 $E [expr ($n+1)/$n*0.90*$Comp_I*4470.000] $K11_2 $K33_2 $K44_2 1; 

####################################################################################################
#                                      ELASTIC RBS ELEMENTS                                        #
####################################################################################################

element elasticBeamColumn 509104 409104 9140 17.168 $E [expr 1.0*1184.765] 1; element elasticBeamColumn 509202 409202 9220 17.168 $E [expr 1.0*1184.765] 1; element elasticBeamColumn 509204 409204 9240 17.168 $E [expr 1.0*1184.765] 1; element elasticBeamColumn 509302 409302 9320 17.168 $E [expr 1.0*1184.765] 1; element elasticBeamColumn 509304 409304 9340 17.168 $E [expr 1.0*1184.765] 1; element elasticBeamColumn 509402 409402 9420 17.168 $E [expr 1.0*1184.765] 1; 
element elasticBeamColumn 508104 408104 8140 21.613 $E [expr 1.0*2308.766] 1; element elasticBeamColumn 508202 408202 8220 21.613 $E [expr 1.0*2308.766] 1; element elasticBeamColumn 508204 408204 8240 21.613 $E [expr 1.0*2308.766] 1; element elasticBeamColumn 508302 408302 8320 21.613 $E [expr 1.0*2308.766] 1; element elasticBeamColumn 508304 408304 8340 21.613 $E [expr 1.0*2308.766] 1; element elasticBeamColumn 508402 408402 8420 21.613 $E [expr 1.0*2308.766] 1; 
element elasticBeamColumn 507104 407104 7140 21.613 $E [expr 1.0*2308.766] 1; element elasticBeamColumn 507202 407202 7220 21.613 $E [expr 1.0*2308.766] 1; element elasticBeamColumn 507204 407204 7240 21.613 $E [expr 1.0*2308.766] 1; element elasticBeamColumn 507302 407302 7320 21.613 $E [expr 1.0*2308.766] 1; element elasticBeamColumn 507304 407304 7340 21.613 $E [expr 1.0*2308.766] 1; element elasticBeamColumn 507402 407402 7420 21.613 $E [expr 1.0*2308.766] 1; 
element elasticBeamColumn 506104 406104 6140 23.979 $E [expr 1.0*2633.412] 1; element elasticBeamColumn 506202 406202 6220 23.979 $E [expr 1.0*2633.412] 1; element elasticBeamColumn 506204 406204 6240 23.979 $E [expr 1.0*2633.412] 1; element elasticBeamColumn 506302 406302 6320 23.979 $E [expr 1.0*2633.412] 1; element elasticBeamColumn 506304 406304 6340 23.979 $E [expr 1.0*2633.412] 1; element elasticBeamColumn 506402 406402 6420 23.979 $E [expr 1.0*2633.412] 1; 
element elasticBeamColumn 505104 405104 5140 23.979 $E [expr 1.0*2633.412] 1; element elasticBeamColumn 505202 405202 5220 23.979 $E [expr 1.0*2633.412] 1; element elasticBeamColumn 505204 405204 5240 23.979 $E [expr 1.0*2633.412] 1; element elasticBeamColumn 505302 405302 5320 23.979 $E [expr 1.0*2633.412] 1; element elasticBeamColumn 505304 405304 5340 23.979 $E [expr 1.0*2633.412] 1; element elasticBeamColumn 505402 405402 5420 23.979 $E [expr 1.0*2633.412] 1; 
element elasticBeamColumn 504104 404104 4140 29.738 $E [expr 1.0*3981.760] 1; element elasticBeamColumn 504202 404202 4220 29.738 $E [expr 1.0*3981.760] 1; element elasticBeamColumn 504204 404204 4240 29.738 $E [expr 1.0*3981.760] 1; element elasticBeamColumn 504302 404302 4320 29.738 $E [expr 1.0*3981.760] 1; element elasticBeamColumn 504304 404304 4340 29.738 $E [expr 1.0*3981.760] 1; element elasticBeamColumn 504402 404402 4420 29.738 $E [expr 1.0*3981.760] 1; 
element elasticBeamColumn 503104 403104 3140 29.738 $E [expr 1.0*3981.760] 1; element elasticBeamColumn 503202 403202 3220 29.738 $E [expr 1.0*3981.760] 1; element elasticBeamColumn 503204 403204 3240 29.738 $E [expr 1.0*3981.760] 1; element elasticBeamColumn 503302 403302 3320 29.738 $E [expr 1.0*3981.760] 1; element elasticBeamColumn 503304 403304 3340 29.738 $E [expr 1.0*3981.760] 1; element elasticBeamColumn 503402 403402 3420 29.738 $E [expr 1.0*3981.760] 1; 
element elasticBeamColumn 502104 402104 2140 27.710 $E [expr 1.0*3628.595] 1; element elasticBeamColumn 502202 402202 2220 27.710 $E [expr 1.0*3628.595] 1; element elasticBeamColumn 502204 402204 2240 27.710 $E [expr 1.0*3628.595] 1; element elasticBeamColumn 502302 402302 2320 27.710 $E [expr 1.0*3628.595] 1; element elasticBeamColumn 502304 402304 2340 27.710 $E [expr 1.0*3628.595] 1; element elasticBeamColumn 502402 402402 2420 27.710 $E [expr 1.0*3628.595] 1; 

###################################################################################################
#                                 COLUMN AND BEAM PLASTIC SPRINGS                                 #
###################################################################################################

# Command Syntax; 
# Spring_IMK SpringID iNode jNode E Fy Ix d tw bf tf htw bftf ry L Ls Lb My PgPye CompositeFLAG MRFconnection Units; 

# BEAM SPRINGS
Spring_IMK 909104 914  9140 $E $Fy [expr $Comp_I*889.530] 21.100 0.430 8.270 0.685 43.600 6.040 1.800 189.537 107.850 94.769 7779.350 0.0 $Composite 0 2; Spring_IMK 909202 9220 922  $E $Fy [expr $Comp_I*889.530] 21.100 0.430 8.270 0.685 43.600 6.040 1.800 189.537 107.850 94.769 7779.350 0.0 $Composite 0 2; Spring_IMK 909204 924  9240 $E $Fy [expr $Comp_I*889.530] 21.100 0.430 8.270 0.685 43.600 6.040 1.800 189.537 107.850 94.769 7779.350 0.0 $Composite 0 2; Spring_IMK 909302 9320 932  $E $Fy [expr $Comp_I*889.530] 21.100 0.430 8.270 0.685 43.600 6.040 1.800 189.537 107.850 94.769 7779.350 0.0 $Composite 0 2; Spring_IMK 909304 934  9340 $E $Fy [expr $Comp_I*889.530] 21.100 0.430 8.270 0.685 43.600 6.040 1.800 189.537 107.850 94.769 7779.350 0.0 $Composite 0 2; Spring_IMK 909402 9420 942  $E $Fy [expr $Comp_I*889.530] 21.100 0.430 8.270 0.685 43.600 6.040 1.800 189.537 107.850 94.769 7779.350 0.0 $Composite 0 2; 
Spring_IMK 908104 814  8140 $E $Fy [expr $Comp_I*1767.531] 26.700 0.460 9.960 0.640 52.700 7.780 2.070 183.025 107.750 91.513 12033.325 0.0 $Composite 0 2; Spring_IMK 908202 8220 822  $E $Fy [expr $Comp_I*1767.531] 26.700 0.460 9.960 0.640 52.700 7.780 2.070 183.025 107.750 91.513 12033.325 0.0 $Composite 0 2; Spring_IMK 908204 824  8240 $E $Fy [expr $Comp_I*1767.531] 26.700 0.460 9.960 0.640 52.700 7.780 2.070 183.025 107.750 91.513 12033.325 0.0 $Composite 0 2; Spring_IMK 908302 8320 832  $E $Fy [expr $Comp_I*1767.531] 26.700 0.460 9.960 0.640 52.700 7.780 2.070 183.025 107.750 91.513 12033.325 0.0 $Composite 0 2; Spring_IMK 908304 834  8340 $E $Fy [expr $Comp_I*1767.531] 26.700 0.460 9.960 0.640 52.700 7.780 2.070 183.025 107.750 91.513 12033.325 0.0 $Composite 0 2; Spring_IMK 908402 8420 842  $E $Fy [expr $Comp_I*1767.531] 26.700 0.460 9.960 0.640 52.700 7.780 2.070 183.025 107.750 91.513 12033.325 0.0 $Composite 0 2; 
Spring_IMK 907104 714  7140 $E $Fy [expr $Comp_I*1767.531] 26.700 0.460 9.960 0.640 52.700 7.780 2.070 183.025 107.750 91.513 12033.325 0.0 $Composite 0 2; Spring_IMK 907202 7220 722  $E $Fy [expr $Comp_I*1767.531] 26.700 0.460 9.960 0.640 52.700 7.780 2.070 183.025 107.750 91.513 12033.325 0.0 $Composite 0 2; Spring_IMK 907204 724  7240 $E $Fy [expr $Comp_I*1767.531] 26.700 0.460 9.960 0.640 52.700 7.780 2.070 183.025 107.750 91.513 12033.325 0.0 $Composite 0 2; Spring_IMK 907302 7320 732  $E $Fy [expr $Comp_I*1767.531] 26.700 0.460 9.960 0.640 52.700 7.780 2.070 183.025 107.750 91.513 12033.325 0.0 $Composite 0 2; Spring_IMK 907304 734  7340 $E $Fy [expr $Comp_I*1767.531] 26.700 0.460 9.960 0.640 52.700 7.780 2.070 183.025 107.750 91.513 12033.325 0.0 $Composite 0 2; Spring_IMK 907402 7420 742  $E $Fy [expr $Comp_I*1767.531] 26.700 0.460 9.960 0.640 52.700 7.780 2.070 183.025 107.750 91.513 12033.325 0.0 $Composite 0 2; 
Spring_IMK 906104 614  6140 $E $Fy [expr $Comp_I*1996.823] 26.900 0.490 9.990 0.745 49.500 6.700 2.120 182.488 107.575 91.244 13617.900 0.0 $Composite 0 2; Spring_IMK 906202 6220 622  $E $Fy [expr $Comp_I*1996.823] 26.900 0.490 9.990 0.745 49.500 6.700 2.120 182.488 107.575 91.244 13617.900 0.0 $Composite 0 2; Spring_IMK 906204 624  6240 $E $Fy [expr $Comp_I*1996.823] 26.900 0.490 9.990 0.745 49.500 6.700 2.120 182.488 107.575 91.244 13617.900 0.0 $Composite 0 2; Spring_IMK 906302 6320 632  $E $Fy [expr $Comp_I*1996.823] 26.900 0.490 9.990 0.745 49.500 6.700 2.120 182.138 107.400 91.069 13617.900 0.0 $Composite 0 2; Spring_IMK 906304 634  6340 $E $Fy [expr $Comp_I*1996.823] 26.900 0.490 9.990 0.745 49.500 6.700 2.120 182.138 107.400 91.069 13617.900 0.0 $Composite 0 2; Spring_IMK 906402 6420 642  $E $Fy [expr $Comp_I*1996.823] 26.900 0.490 9.990 0.745 49.500 6.700 2.120 182.488 107.575 91.244 13617.900 0.0 $Composite 0 2; 
Spring_IMK 905104 514  5140 $E $Fy [expr $Comp_I*1996.823] 26.900 0.490 9.990 0.745 49.500 6.700 2.120 182.488 107.575 91.244 13617.900 0.0 $Composite 0 2; Spring_IMK 905202 5220 522  $E $Fy [expr $Comp_I*1996.823] 26.900 0.490 9.990 0.745 49.500 6.700 2.120 182.488 107.575 91.244 13617.900 0.0 $Composite 0 2; Spring_IMK 905204 524  5240 $E $Fy [expr $Comp_I*1996.823] 26.900 0.490 9.990 0.745 49.500 6.700 2.120 182.488 107.575 91.244 13617.900 0.0 $Composite 0 2; Spring_IMK 905302 5320 532  $E $Fy [expr $Comp_I*1996.823] 26.900 0.490 9.990 0.745 49.500 6.700 2.120 182.138 107.400 91.069 13617.900 0.0 $Composite 0 2; Spring_IMK 905304 534  5340 $E $Fy [expr $Comp_I*1996.823] 26.900 0.490 9.990 0.745 49.500 6.700 2.120 182.138 107.400 91.069 13617.900 0.0 $Composite 0 2; Spring_IMK 905402 5420 542  $E $Fy [expr $Comp_I*1996.823] 26.900 0.490 9.990 0.745 49.500 6.700 2.120 182.488 107.575 91.244 13617.900 0.0 $Composite 0 2; 
Spring_IMK 904104 414  4140 $E $Fy [expr $Comp_I*3033.519] 30.000 0.565 10.500 0.850 47.800 6.170 2.190 179.275 107.450 89.638 18649.036 0.0 $Composite 0 2; Spring_IMK 904202 4220 422  $E $Fy [expr $Comp_I*3033.519] 30.000 0.565 10.500 0.850 47.800 6.170 2.190 179.275 107.450 89.638 18649.036 0.0 $Composite 0 2; Spring_IMK 904204 424  4240 $E $Fy [expr $Comp_I*3033.519] 30.000 0.565 10.500 0.850 47.800 6.170 2.190 179.275 107.450 89.638 18649.036 0.0 $Composite 0 2; Spring_IMK 904302 4320 432  $E $Fy [expr $Comp_I*3033.519] 30.000 0.565 10.500 0.850 47.800 6.170 2.190 178.875 107.250 89.438 18649.036 0.0 $Composite 0 2; Spring_IMK 904304 434  4340 $E $Fy [expr $Comp_I*3033.519] 30.000 0.565 10.500 0.850 47.800 6.170 2.190 178.875 107.250 89.438 18649.036 0.0 $Composite 0 2; Spring_IMK 904402 4420 442  $E $Fy [expr $Comp_I*3033.519] 30.000 0.565 10.500 0.850 47.800 6.170 2.190 179.275 107.450 89.638 18649.036 0.0 $Composite 0 2; 
Spring_IMK 903104 314  3140 $E $Fy [expr $Comp_I*3033.519] 30.000 0.565 10.500 0.850 47.800 6.170 2.190 179.275 107.450 89.638 18649.036 0.0 $Composite 0 2; Spring_IMK 903202 3220 322  $E $Fy [expr $Comp_I*3033.519] 30.000 0.565 10.500 0.850 47.800 6.170 2.190 179.275 107.450 89.638 18649.036 0.0 $Composite 0 2; Spring_IMK 903204 324  3240 $E $Fy [expr $Comp_I*3033.519] 30.000 0.565 10.500 0.850 47.800 6.170 2.190 179.275 107.450 89.638 18649.036 0.0 $Composite 0 2; Spring_IMK 903302 3320 332  $E $Fy [expr $Comp_I*3033.519] 30.000 0.565 10.500 0.850 47.800 6.170 2.190 178.875 107.250 89.438 18649.036 0.0 $Composite 0 2; Spring_IMK 903304 334  3340 $E $Fy [expr $Comp_I*3033.519] 30.000 0.565 10.500 0.850 47.800 6.170 2.190 178.875 107.250 89.438 18649.036 0.0 $Composite 0 2; Spring_IMK 903402 3420 342  $E $Fy [expr $Comp_I*3033.519] 30.000 0.565 10.500 0.850 47.800 6.170 2.190 179.275 107.450 89.638 18649.036 0.0 $Composite 0 2; 
Spring_IMK 902104 214  2140 $E $Fy [expr $Comp_I*2787.189] 29.800 0.545 10.500 0.760 49.600 6.890 2.150 179.425 107.450 89.713 17107.675 0.0 $Composite 0 2; Spring_IMK 902202 2220 222  $E $Fy [expr $Comp_I*2787.189] 29.800 0.545 10.500 0.760 49.600 6.890 2.150 179.425 107.450 89.713 17107.675 0.0 $Composite 0 2; Spring_IMK 902204 224  2240 $E $Fy [expr $Comp_I*2787.189] 29.800 0.545 10.500 0.760 49.600 6.890 2.150 179.425 107.450 89.713 17107.675 0.0 $Composite 0 2; Spring_IMK 902302 2320 232  $E $Fy [expr $Comp_I*2787.189] 29.800 0.545 10.500 0.760 49.600 6.890 2.150 179.025 107.250 89.513 17107.675 0.0 $Composite 0 2; Spring_IMK 902304 234  2340 $E $Fy [expr $Comp_I*2787.189] 29.800 0.545 10.500 0.760 49.600 6.890 2.150 179.025 107.250 89.513 17107.675 0.0 $Composite 0 2; Spring_IMK 902402 2420 242  $E $Fy [expr $Comp_I*2787.189] 29.800 0.545 10.500 0.760 49.600 6.890 2.150 179.425 107.450 89.713 17107.675 0.0 $Composite 0 2; 

# Column Springs
Spring_IMK 909101 911 409101 $E $Fy 2700.000 24.300 0.515 9.070 0.875 41.900 5.180 1.980 132.100 66.050 132.100 15367.000 0.023 0 2 2; Spring_IMK 909201 921 409201 $E $Fy 2700.000 24.300 0.515 9.070 0.875 41.900 5.180 1.980 132.100 66.050 132.100 15367.000 0.015 0 2 2; Spring_IMK 909301 931 409301 $E $Fy 2700.000 24.300 0.515 9.070 0.875 41.900 5.180 1.980 132.100 66.050 132.100 15367.000 0.015 0 2 2; Spring_IMK 909401 941 409401 $E $Fy 2700.000 24.300 0.515 9.070 0.875 41.900 5.180 1.980 132.100 66.050 132.100 15367.000 0.023 0 2 2; 
Spring_IMK 908103 813 408103 $E $Fy 2700.000 24.300 0.515 9.070 0.875 41.900 5.180 1.980 132.100 66.050 132.100 15367.000 0.023 0 2 2; Spring_IMK 908203 823 408203 $E $Fy 2700.000 24.300 0.515 9.070 0.875 41.900 5.180 1.980 132.100 66.050 132.100 15367.000 0.015 0 2 2; Spring_IMK 908303 833 408303 $E $Fy 2700.000 24.300 0.515 9.070 0.875 41.900 5.180 1.980 132.100 66.050 132.100 15367.000 0.015 0 2 2; Spring_IMK 908403 843 408403 $E $Fy 2700.000 24.300 0.515 9.070 0.875 41.900 5.180 1.980 132.100 66.050 132.100 15367.000 0.023 0 2 2; 
Spring_IMK 908101 811 408101 $E $Fy 2700.000 24.300 0.515 9.070 0.875 41.900 5.180 1.980 129.300 64.650 129.300 15367.000 0.023 0 2 2; Spring_IMK 908201 821 408201 $E $Fy 2700.000 24.300 0.515 9.070 0.875 41.900 5.180 1.980 129.300 64.650 129.300 15367.000 0.015 0 2 2; Spring_IMK 908301 831 408301 $E $Fy 2700.000 24.300 0.515 9.070 0.875 41.900 5.180 1.980 129.300 64.650 129.300 15367.000 0.015 0 2 2; Spring_IMK 908401 841 408401 $E $Fy 2700.000 24.300 0.515 9.070 0.875 41.900 5.180 1.980 129.300 64.650 129.300 15367.000 0.023 0 2 2; 
Spring_IMK 907103 713 407103 $E $Fy 4020.000 24.500 0.605 12.900 0.960 35.600 6.700 2.970 129.300 64.650 129.300 22385.000 0.037 0 2 2; Spring_IMK 907203 723 407203 $E $Fy 4020.000 24.500 0.605 12.900 0.960 35.600 6.700 2.970 129.300 64.650 129.300 22385.000 0.024 0 2 2; Spring_IMK 907303 733 407303 $E $Fy 4020.000 24.500 0.605 12.900 0.960 35.600 6.700 2.970 129.300 64.650 129.300 22385.000 0.024 0 2 2; Spring_IMK 907403 743 407403 $E $Fy 4020.000 24.500 0.605 12.900 0.960 35.600 6.700 2.970 129.300 64.650 129.300 22385.000 0.037 0 2 2; 
Spring_IMK 907101 711 407101 $E $Fy 4020.000 24.500 0.605 12.900 0.960 35.600 6.700 2.970 129.300 64.650 129.300 22385.000 0.037 0 2 2; Spring_IMK 907201 721 407201 $E $Fy 4020.000 24.500 0.605 12.900 0.960 35.600 6.700 2.970 129.300 64.650 129.300 22385.000 0.024 0 2 2; Spring_IMK 907301 731 407301 $E $Fy 4020.000 24.500 0.605 12.900 0.960 35.600 6.700 2.970 129.300 64.650 129.300 22385.000 0.024 0 2 2; Spring_IMK 907401 741 407401 $E $Fy 4020.000 24.500 0.605 12.900 0.960 35.600 6.700 2.970 129.300 64.650 129.300 22385.000 0.037 0 2 2; 
Spring_IMK 906103 613 406103 $E $Fy 4020.000 24.500 0.605 12.900 0.960 35.600 6.700 2.970 129.200 64.600 129.200 22385.000 0.057 0 2 2; Spring_IMK 906203 623 406203 $E $Fy 4020.000 24.500 0.605 12.900 0.960 35.600 6.700 2.970 129.200 64.600 129.200 22385.000 0.038 0 2 2; Spring_IMK 906303 633 406303 $E $Fy 4020.000 24.500 0.605 12.900 0.960 35.600 6.700 2.970 129.200 64.600 129.200 22385.000 0.038 0 2 2; Spring_IMK 906403 643 406403 $E $Fy 4020.000 24.500 0.605 12.900 0.960 35.600 6.700 2.970 129.200 64.600 129.200 22385.000 0.057 0 2 2; 
Spring_IMK 906101 611 406101 $E $Fy 4020.000 24.500 0.605 12.900 0.960 35.600 6.700 2.970 129.100 64.550 129.100 22385.000 0.057 0 2 2; Spring_IMK 906201 621 406201 $E $Fy 4020.000 24.500 0.605 12.900 0.960 35.600 6.700 2.970 129.100 64.550 129.100 22385.000 0.038 0 2 2; Spring_IMK 906301 631 406301 $E $Fy 4020.000 24.500 0.605 12.900 0.960 35.600 6.700 2.970 129.100 64.550 129.100 22385.000 0.038 0 2 2; Spring_IMK 906401 641 406401 $E $Fy 4020.000 24.500 0.605 12.900 0.960 35.600 6.700 2.970 129.100 64.550 129.100 22385.000 0.057 0 2 2; 
Spring_IMK 905103 513 405103 $E $Fy 4020.000 24.500 0.605 12.900 0.960 35.600 6.700 2.970 129.100 64.550 129.100 22385.000 0.076 0 2 2; Spring_IMK 905203 523 405203 $E $Fy 5680.000 25.200 0.750 12.900 1.340 28.700 4.810 3.040 129.100 64.550 129.100 30915.500 0.038 0 2 2; Spring_IMK 905303 533 405303 $E $Fy 5680.000 25.200 0.750 12.900 1.340 28.700 4.810 3.040 129.100 64.550 129.100 30915.500 0.038 0 2 2; Spring_IMK 905403 543 405403 $E $Fy 4020.000 24.500 0.605 12.900 0.960 35.600 6.700 2.970 129.100 64.550 129.100 22385.000 0.076 0 2 2; 
Spring_IMK 905101 511 405101 $E $Fy 4020.000 24.500 0.605 12.900 0.960 35.600 6.700 2.970 129.100 64.550 129.100 22385.000 0.076 0 2 2; Spring_IMK 905201 521 405201 $E $Fy 5680.000 25.200 0.750 12.900 1.340 28.700 4.810 3.040 129.100 64.550 129.100 30915.500 0.038 0 2 2; Spring_IMK 905301 531 405301 $E $Fy 5680.000 25.200 0.750 12.900 1.340 28.700 4.810 3.040 129.100 64.550 129.100 30915.500 0.038 0 2 2; Spring_IMK 905401 541 405401 $E $Fy 4020.000 24.500 0.605 12.900 0.960 35.600 6.700 2.970 129.100 64.550 129.100 22385.000 0.076 0 2 2; 
Spring_IMK 904103 413 404103 $E $Fy 4020.000 24.500 0.605 12.900 0.960 35.600 6.700 2.970 127.550 63.775 127.550 22385.000 0.096 0 2 2; Spring_IMK 904203 423 404203 $E $Fy 5680.000 25.200 0.750 12.900 1.340 28.700 4.810 3.040 127.550 63.775 127.550 30915.500 0.048 0 2 2; Spring_IMK 904303 433 404303 $E $Fy 5680.000 25.200 0.750 12.900 1.340 28.700 4.810 3.040 127.550 63.775 127.550 30915.500 0.048 0 2 2; Spring_IMK 904403 443 404403 $E $Fy 4020.000 24.500 0.605 12.900 0.960 35.600 6.700 2.970 127.550 63.775 127.550 22385.000 0.096 0 2 2; 
Spring_IMK 904101 411 404101 $E $Fy 4020.000 24.500 0.605 12.900 0.960 35.600 6.700 2.970 126.000 63.000 126.000 22385.000 0.096 0 2 2; Spring_IMK 904201 421 404201 $E $Fy 5680.000 25.200 0.750 12.900 1.340 28.700 4.810 3.040 126.000 63.000 126.000 30915.500 0.048 0 2 2; Spring_IMK 904301 431 404301 $E $Fy 5680.000 25.200 0.750 12.900 1.340 28.700 4.810 3.040 126.000 63.000 126.000 30915.500 0.048 0 2 2; Spring_IMK 904401 441 404401 $E $Fy 4020.000 24.500 0.605 12.900 0.960 35.600 6.700 2.970 126.000 63.000 126.000 22385.000 0.096 0 2 2; 
Spring_IMK 903103 313 403103 $E $Fy 4580.000 24.700 0.650 12.900 1.090 33.200 5.920 3.010 126.000 63.000 126.000 25289.000 0.104 0 2 2; Spring_IMK 903203 323 403203 $E $Fy 6260.000 25.500 0.810 13.000 1.460 26.600 4.430 3.070 126.000 63.000 126.000 33819.500 0.053 0 2 2; Spring_IMK 903303 333 403303 $E $Fy 6260.000 25.500 0.810 13.000 1.460 26.600 4.430 3.070 126.000 63.000 126.000 33819.500 0.053 0 2 2; Spring_IMK 903403 343 403403 $E $Fy 4580.000 24.700 0.650 12.900 1.090 33.200 5.920 3.010 126.000 63.000 126.000 25289.000 0.104 0 2 2; 
Spring_IMK 903101 311 403101 $E $Fy 4580.000 24.700 0.650 12.900 1.090 33.200 5.920 3.010 126.000 63.000 126.000 25289.000 0.104 0 2 2; Spring_IMK 903201 321 403201 $E $Fy 6260.000 25.500 0.810 13.000 1.460 26.600 4.430 3.070 126.000 63.000 126.000 33819.500 0.053 0 2 2; Spring_IMK 903301 331 403301 $E $Fy 6260.000 25.500 0.810 13.000 1.460 26.600 4.430 3.070 126.000 63.000 126.000 33819.500 0.053 0 2 2; Spring_IMK 903401 341 403401 $E $Fy 4580.000 24.700 0.650 12.900 1.090 33.200 5.920 3.010 126.000 63.000 126.000 25289.000 0.104 0 2 2; 
Spring_IMK 902103 213 402103 $E $Fy 4580.000 24.700 0.650 12.900 1.090 33.200 5.920 3.010 150.100 75.050 150.100 25289.000 0.122 0 2 2; Spring_IMK 902203 223 402203 $E $Fy 6260.000 25.500 0.810 13.000 1.460 26.600 4.430 3.070 150.100 75.050 150.100 33819.500 0.062 0 2 2; Spring_IMK 902303 233 402303 $E $Fy 6260.000 25.500 0.810 13.000 1.460 26.600 4.430 3.070 150.100 75.050 150.100 33819.500 0.062 0 2 2; Spring_IMK 902403 243 402403 $E $Fy 4580.000 24.700 0.650 12.900 1.090 33.200 5.920 3.010 150.100 75.050 150.100 25289.000 0.122 0 2 2; 
Spring_IMK 902101 211 402101 $E $Fy 4580.000 24.700 0.650 12.900 1.090 33.200 5.920 3.010 150.200 75.100 150.200 25289.000 0.122 0 2 2; Spring_IMK 902201 221 402201 $E $Fy 6260.000 25.500 0.810 13.000 1.460 26.600 4.430 3.070 150.200 75.100 150.200 33819.500 0.062 0 2 2; Spring_IMK 902301 231 402301 $E $Fy 6260.000 25.500 0.810 13.000 1.460 26.600 4.430 3.070 150.200 75.100 150.200 33819.500 0.062 0 2 2; Spring_IMK 902401 241 402401 $E $Fy 4580.000 24.700 0.650 12.900 1.090 33.200 5.920 3.010 150.200 75.100 150.200 25289.000 0.122 0 2 2; 
Spring_IMK 901103 11 113 $E $Fy 4580.000 24.700 0.650 12.900 1.090 33.200 5.920 3.010 165.100 82.550 165.100 25289.000 0.140 0 2 2; Spring_IMK 901203 12 123 $E $Fy 6260.000 25.500 0.810 13.000 1.460 26.600 4.430 3.070 165.100 82.550 165.100 33819.500 0.072 0 2 2; Spring_IMK 901303 13 133 $E $Fy 6260.000 25.500 0.810 13.000 1.460 26.600 4.430 3.070 165.100 82.550 165.100 33819.500 0.072 0 2 2; Spring_IMK 901403 14 143 $E $Fy 4580.000 24.700 0.650 12.900 1.090 33.200 5.920 3.010 165.100 82.550 165.100 25289.000 0.140 0 2 2; 

####################################################################################################
#                                          RIGID FLOOR LINKS                                       #
####################################################################################################

# COMMAND SYNTAX 
# element truss $ElementID $iNode $jNode $Area $matID
element truss 1009 409404 95 $A_Stiff 99;
element truss 1008 408404 85 $A_Stiff 99;
element truss 1007 407404 75 $A_Stiff 99;
element truss 1006 406404 65 $A_Stiff 99;
element truss 1005 405404 55 $A_Stiff 99;
element truss 1004 404404 45 $A_Stiff 99;
element truss 1003 403404 35 $A_Stiff 99;
element truss 1002 402404 25 $A_Stiff 99;

####################################################################################################
#                              EQUIVELANT GRAVITY COLUMNS AND BEAMS                                #
####################################################################################################

# Gravity Columns
element elasticBeamColumn  608500  853  951  [expr 100000.000 / 2] $E [expr (100000000.000  + 436.000) / 2] 1; element elasticBeamColumn  608600  863  961  [expr 100000.000 / 2] $E [expr (100000000.000  + 436.000) / 2] 1; 
element elasticBeamColumn 607502 107570 851  [expr 100000.000 / 2] $E [expr (100000000.000  + 436.000) / 2] 1;  element elasticBeamColumn 607602 107670 861  [expr 100000.000 / 2] $E [expr (100000000.000  + 436.000) / 2] 1;  
element elasticBeamColumn 607501 753 107570  [expr 100000.000 / 2] $E [expr (100000000.000  + 1360.000) / 2] 1;  element elasticBeamColumn 607601 763 107670  [expr 100000.000 / 2] $E [expr (100000000.000  + 1360.000) / 2] 1;  
element elasticBeamColumn  606500  653  751  [expr 100000.000 / 2] $E [expr (100000000.000  + 1360.000) / 2] 1; element elasticBeamColumn  606600  663  761  [expr 100000.000 / 2] $E [expr (100000000.000  + 1360.000) / 2] 1; 
element elasticBeamColumn 605502 105570 651  [expr 100000.000 / 2] $E [expr (100000000.000  + 1360.000) / 2] 1;  element elasticBeamColumn 605602 105670 661  [expr 100000.000 / 2] $E [expr (100000000.000  + 1360.000) / 2] 1;  
element elasticBeamColumn 605501 553 105570  [expr 100000.000 / 2] $E [expr (100000000.000  + 1638.000) / 2] 1;  element elasticBeamColumn 605601 563 105670  [expr 100000.000 / 2] $E [expr (100000000.000  + 1638.000) / 2] 1;  
element elasticBeamColumn  604500  453  551  [expr 100000.000 / 2] $E [expr (100000000.000  + 1638.000) / 2] 1; element elasticBeamColumn  604600  463  561  [expr 100000.000 / 2] $E [expr (100000000.000  + 1638.000) / 2] 1; 
element elasticBeamColumn 603502 103570 451  [expr 100000.000 / 2] $E [expr (100000000.000  + 1638.000) / 2] 1;  element elasticBeamColumn 603602 103670 461  [expr 100000.000 / 2] $E [expr (100000000.000  + 1638.000) / 2] 1;  
element elasticBeamColumn 603501 353 103570  [expr 100000.000 / 2] $E [expr (100000000.000  + 1842.000) / 2] 1;  element elasticBeamColumn 603601 363 103670  [expr 100000.000 / 2] $E [expr (100000000.000  + 1842.000) / 2] 1;  
element elasticBeamColumn  602500  253  351  [expr 100000.000 / 2] $E [expr (100000000.000  + 1842.000) / 2] 1; element elasticBeamColumn  602600  263  361  [expr 100000.000 / 2] $E [expr (100000000.000  + 1842.000) / 2] 1; 
element elasticBeamColumn  601500  153  251  [expr 100000.000 / 2] $E [expr (100000000.000  + 1842.000) / 2] 1; element elasticBeamColumn  601600  163  261  [expr 100000.000 / 2] $E [expr (100000000.000  + 1842.000) / 2] 1; 

# Gravity Beams
element elasticBeamColumn  509400 954  962  100000.000  $E [expr $Comp_I_GC * 100000000.000] 1;
element elasticBeamColumn  508400 854  862  100000.000  $E [expr $Comp_I_GC * 100000000.000] 1;
element elasticBeamColumn  507400 754  762  100000.000  $E [expr $Comp_I_GC * 100000000.000] 1;
element elasticBeamColumn  506400 654  662  100000.000  $E [expr $Comp_I_GC * 100000000.000] 1;
element elasticBeamColumn  505400 554  562  100000.000  $E [expr $Comp_I_GC * 100000000.000] 1;
element elasticBeamColumn  504400 454  462  100000.000  $E [expr $Comp_I_GC * 100000000.000] 1;
element elasticBeamColumn  503400 354  362  100000.000  $E [expr $Comp_I_GC * 100000000.000] 1;
element elasticBeamColumn  502400 254  262  100000.000  $E [expr $Comp_I_GC * 100000000.000] 1;

# Gravity Columns Springs
Spring_Zero 909501 95 951; Spring_Zero 909601 96 961; 
Spring_Zero 908503 85 853; Spring_Zero 908603 86 863; 
Spring_Zero 908501 85 851; Spring_Zero 908601 86 861; 
Spring_Zero 907503 75 753; Spring_Zero 907603 76 763; 
Spring_Zero 907501 75 751; Spring_Zero 907601 76 761; 
Spring_Zero 906503 65 653; Spring_Zero 906603 66 663; 
Spring_Zero 906501 65 651; Spring_Zero 906601 66 661; 
Spring_Zero 905503 55 553; Spring_Zero 905603 56 563; 
Spring_Zero 905501 55 551; Spring_Zero 905601 56 561; 
Spring_Zero 904503 45 453; Spring_Zero 904603 46 463; 
Spring_Zero 904501 45 451; Spring_Zero 904601 46 461; 
Spring_Zero 903503 35 353; Spring_Zero 903603 36 363; 
Spring_Zero 903501 35 351; Spring_Zero 903601 36 361; 
Spring_Zero 902503 25 253; Spring_Zero 902603 26 263; 
Spring_Zero 902501 25 251; Spring_Zero 902601 26 261; 
Spring_Zero 901503 15 153; Spring_Zero 901603 16 163; 

# GRAVITY BEAMS SPRINGS
set gap 0.08;
Spring_Pinching  909504  95   954 40837.500 $gap 0; Spring_Pinching  909602  962  96  40837.500 $gap 0; 
Spring_Pinching  908504  85   854 40837.500 $gap 0; Spring_Pinching  908602  862  86  40837.500 $gap 0; 
Spring_Pinching  907504  75   754 40837.500 $gap 0; Spring_Pinching  907602  762  76  40837.500 $gap 0; 
Spring_Pinching  906504  65   654 40837.500 $gap 0; Spring_Pinching  906602  662  66  40837.500 $gap 0; 
Spring_Pinching  905504  55   554 40837.500 $gap 0; Spring_Pinching  905602  562  56  40837.500 $gap 0; 
Spring_Pinching  904504  45   454 40837.500 $gap 0; Spring_Pinching  904602  462  46  40837.500 $gap 0; 
Spring_Pinching  903504  35   354 40837.500 $gap 0; Spring_Pinching  903602  362  36  40837.500 $gap 0; 
Spring_Pinching  902504  25   254 40837.500 $gap 0; Spring_Pinching  902602  262  26  40837.500 $gap 0; 

###################################################################################################
#                                       BOUNDARY CONDITIONS                                       #
###################################################################################################

# MRF Supports
fix 11 1 1 1; fix 12 1 1 1; fix 13 1 1 1; fix 14 1 1 1; 

# EGF Supports
fix 15 1 1 1; fix 16 1 1 1; 

# MRF Floor Movement
equalDOF 409104  409204  1; equalDOF 409104  409304  1; equalDOF 409104  409404  1; 
equalDOF 408104  408204  1; equalDOF 408104  408304  1; equalDOF 408104  408404  1; 
equalDOF 407104  407204  1; equalDOF 407104  407304  1; equalDOF 407104  407404  1; 
equalDOF 406104  406204  1; equalDOF 406104  406304  1; equalDOF 406104  406404  1; 
equalDOF 405104  405204  1; equalDOF 405104  405304  1; equalDOF 405104  405404  1; 
equalDOF 404104  404204  1; equalDOF 404104  404304  1; equalDOF 404104  404404  1; 
equalDOF 403104  403204  1; equalDOF 403104  403304  1; equalDOF 403104  403404  1; 
equalDOF 402104  402204  1; equalDOF 402104  402304  1; equalDOF 402104  402404  1; 

# MRF Column Joints
equalDOF  409101 	911 1 2; equalDOF  409201 	921 1 2; equalDOF  409301 	931 1 2; equalDOF  409401 	941 1 2; 
equalDOF  408103 	813 1 2; equalDOF  408203 	823 1 2; equalDOF  408303 	833 1 2; equalDOF  408403 	843 1 2; 
equalDOF  407103 	713 1 2; equalDOF  407203 	723 1 2; equalDOF  407303 	733 1 2; equalDOF  407403 	743 1 2; 
equalDOF  406103 	613 1 2; equalDOF  406203 	623 1 2; equalDOF  406303 	633 1 2; equalDOF  406403 	643 1 2; 
equalDOF  405103 	513 1 2; equalDOF  405203 	523 1 2; equalDOF  405303 	533 1 2; equalDOF  405403 	543 1 2; 
equalDOF  404103 	413 1 2; equalDOF  404203 	423 1 2; equalDOF  404303 	433 1 2; equalDOF  404403 	443 1 2; 
equalDOF  403103 	313 1 2; equalDOF  403203 	323 1 2; equalDOF  403303 	333 1 2; equalDOF  403403 	343 1 2; 
equalDOF  402103 	213 1 2; equalDOF  402203 	223 1 2; equalDOF  402303 	233 1 2; equalDOF  402403 	243 1 2; 
equalDOF  408101 	811 1 2; equalDOF  408201 	821 1 2; equalDOF  408301 	831 1 2; equalDOF  408401 	841 1 2; 
equalDOF  407101 	711 1 2; equalDOF  407201 	721 1 2; equalDOF  407301 	731 1 2; equalDOF  407401 	741 1 2; 
equalDOF  406101 	611 1 2; equalDOF  406201 	621 1 2; equalDOF  406301 	631 1 2; equalDOF  406401 	641 1 2; 
equalDOF  405101 	511 1 2; equalDOF  405201 	521 1 2; equalDOF  405301 	531 1 2; equalDOF  405401 	541 1 2; 
equalDOF  404101 	411 1 2; equalDOF  404201 	421 1 2; equalDOF  404301 	431 1 2; equalDOF  404401 	441 1 2; 
equalDOF  403101 	311 1 2; equalDOF  403201 	321 1 2; equalDOF  403301 	331 1 2; equalDOF  403401 	341 1 2; 
equalDOF  402101 	211 1 2; equalDOF  402201 	221 1 2; equalDOF  402301 	231 1 2; equalDOF  402401 	241 1 2; 
equalDOF  11 	113 1 2; equalDOF  12 	123 1 2; equalDOF  13 	133 1 2; equalDOF  14 	143 1 2; 

# MRF Beam Joints
equalDOF  9140 	914 1 2; equalDOF  9220 	922 1 2; equalDOF  9240 	924 1 2; equalDOF  9320 	932 1 2; equalDOF  9340 	934 1 2; equalDOF  9420 	942 1 2; 
equalDOF  8140 	814 1 2; equalDOF  8220 	822 1 2; equalDOF  8240 	824 1 2; equalDOF  8320 	832 1 2; equalDOF  8340 	834 1 2; equalDOF  8420 	842 1 2; 
equalDOF  7140 	714 1 2; equalDOF  7220 	722 1 2; equalDOF  7240 	724 1 2; equalDOF  7320 	732 1 2; equalDOF  7340 	734 1 2; equalDOF  7420 	742 1 2; 
equalDOF  6140 	614 1 2; equalDOF  6220 	622 1 2; equalDOF  6240 	624 1 2; equalDOF  6320 	632 1 2; equalDOF  6340 	634 1 2; equalDOF  6420 	642 1 2; 
equalDOF  5140 	514 1 2; equalDOF  5220 	522 1 2; equalDOF  5240 	524 1 2; equalDOF  5320 	532 1 2; equalDOF  5340 	534 1 2; equalDOF  5420 	542 1 2; 
equalDOF  4140 	414 1 2; equalDOF  4220 	422 1 2; equalDOF  4240 	424 1 2; equalDOF  4320 	432 1 2; equalDOF  4340 	434 1 2; equalDOF  4420 	442 1 2; 
equalDOF  3140 	314 1 2; equalDOF  3220 	322 1 2; equalDOF  3240 	324 1 2; equalDOF  3320 	332 1 2; equalDOF  3340 	334 1 2; equalDOF  3420 	342 1 2; 
equalDOF  2140 	214 1 2; equalDOF  2220 	222 1 2; equalDOF  2240 	224 1 2; equalDOF  2320 	232 1 2; equalDOF  2340 	234 1 2; equalDOF  2420 	242 1 2; 

# EGF Beam Joints
equalDOF  95 	954 1 2; equalDOF  96 	962 1 2; 
equalDOF  85 	854 1 2; equalDOF  86 	862 1 2; 
equalDOF  75 	754 1 2; equalDOF  76 	762 1 2; 
equalDOF  65 	654 1 2; equalDOF  66 	662 1 2; 
equalDOF  55 	554 1 2; equalDOF  56 	562 1 2; 
equalDOF  45 	454 1 2; equalDOF  46 	462 1 2; 
equalDOF  35 	354 1 2; equalDOF  36 	362 1 2; 
equalDOF  25 	254 1 2; equalDOF  26 	262 1 2; 

# EGF Column Joints
equalDOF  95 	951 1 2; equalDOF  96 	961 1 2; 
equalDOF  85 	853 1 2; equalDOF  86 	863 1 2; 
equalDOF  75 	753 1 2; equalDOF  76 	763 1 2; 
equalDOF  65 	653 1 2; equalDOF  66 	663 1 2; 
equalDOF  55 	553 1 2; equalDOF  56 	563 1 2; 
equalDOF  45 	453 1 2; equalDOF  46 	463 1 2; 
equalDOF  35 	353 1 2; equalDOF  36 	363 1 2; 
equalDOF  25 	253 1 2; equalDOF  26 	263 1 2; 
equalDOF  85 	851 1 2; equalDOF  86 	861 1 2; 
equalDOF  75 	751 1 2; equalDOF  76 	761 1 2; 
equalDOF  65 	651 1 2; equalDOF  66 	661 1 2; 
equalDOF  55 	551 1 2; equalDOF  56 	561 1 2; 
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
recorder Drift -file $MainFolder/$SubFolder/SDR_MRF8.out   -iNode 408104 -jNode 409104 -dof 1 -perpDirn 2;
recorder Drift -file $MainFolder/$SubFolder/SDR_MRF7.out   -iNode 407104 -jNode 408104 -dof 1 -perpDirn 2;
recorder Drift -file $MainFolder/$SubFolder/SDR_MRF6.out   -iNode 406104 -jNode 407104 -dof 1 -perpDirn 2;
recorder Drift -file $MainFolder/$SubFolder/SDR_MRF5.out   -iNode 405104 -jNode 406104 -dof 1 -perpDirn 2;
recorder Drift -file $MainFolder/$SubFolder/SDR_MRF4.out   -iNode 404104 -jNode 405104 -dof 1 -perpDirn 2;
recorder Drift -file $MainFolder/$SubFolder/SDR_MRF3.out   -iNode 403104 -jNode 404104 -dof 1 -perpDirn 2;
recorder Drift -file $MainFolder/$SubFolder/SDR_MRF2.out   -iNode 402104 -jNode 403104 -dof 1 -perpDirn 2;
recorder Drift -file $MainFolder/$SubFolder/SDR_MRF1.out   -iNode 11     -jNode 402104 -dof 1 -perpDirn 2;

if {$EQ==1} {
# Floor Accelerations
recorder Node -file $MainFolder/$SubFolder/RFA_MRF9.out   -node 409103 -dof 1 accel;
recorder Node -file $MainFolder/$SubFolder/RFA_MRF8.out   -node 408103 -dof 1 accel;
recorder Node -file $MainFolder/$SubFolder/RFA_MRF7.out   -node 407103 -dof 1 accel;
recorder Node -file $MainFolder/$SubFolder/RFA_MRF6.out   -node 406103 -dof 1 accel;
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
mass 409103 0.2888  1.e-9 1.e-9; mass 409203 0.2888  1.e-9 1.e-9; mass 409303 0.2888  1.e-9 1.e-9; mass 409403 0.2888  1.e-9 1.e-9; mass 95 0.2888  1.e-9 1.e-9; mass 96 0.2888  1.e-9 1.e-9; 
mass 408103 0.3056  1.e-9 1.e-9; mass 408203 0.3056  1.e-9 1.e-9; mass 408303 0.3056  1.e-9 1.e-9; mass 408403 0.3056  1.e-9 1.e-9; mass 85 0.3056  1.e-9 1.e-9; mass 86 0.3056  1.e-9 1.e-9; 
mass 407103 0.3056  1.e-9 1.e-9; mass 407203 0.3056  1.e-9 1.e-9; mass 407303 0.3056  1.e-9 1.e-9; mass 407403 0.3056  1.e-9 1.e-9; mass 75 0.3056  1.e-9 1.e-9; mass 76 0.3056  1.e-9 1.e-9; 
mass 406103 0.3056  1.e-9 1.e-9; mass 406203 0.3056  1.e-9 1.e-9; mass 406303 0.3056  1.e-9 1.e-9; mass 406403 0.3056  1.e-9 1.e-9; mass 65 0.3056  1.e-9 1.e-9; mass 66 0.3056  1.e-9 1.e-9; 
mass 405103 0.3056  1.e-9 1.e-9; mass 405203 0.3056  1.e-9 1.e-9; mass 405303 0.3056  1.e-9 1.e-9; mass 405403 0.3056  1.e-9 1.e-9; mass 55 0.3056  1.e-9 1.e-9; mass 56 0.3056  1.e-9 1.e-9; 
mass 404103 0.3056  1.e-9 1.e-9; mass 404203 0.3056  1.e-9 1.e-9; mass 404303 0.3056  1.e-9 1.e-9; mass 404403 0.3056  1.e-9 1.e-9; mass 45 0.3056  1.e-9 1.e-9; mass 46 0.3056  1.e-9 1.e-9; 
mass 403103 0.3056  1.e-9 1.e-9; mass 403203 0.3056  1.e-9 1.e-9; mass 403303 0.3056  1.e-9 1.e-9; mass 403403 0.3056  1.e-9 1.e-9; mass 35 0.3056  1.e-9 1.e-9; mass 36 0.3056  1.e-9 1.e-9; 
mass 402103 0.3108  1.e-9 1.e-9; mass 402203 0.3108  1.e-9 1.e-9; mass 402303 0.3108  1.e-9 1.e-9; mass 402403 0.3108  1.e-9 1.e-9; mass 25 0.3108  1.e-9 1.e-9; mass 26 0.3108  1.e-9 1.e-9; 

###################################################################################################
#                                        EIGEN VALUE ANALYSIS                                     #
###################################################################################################

set pi [expr 2.0*asin(1.0)];
set nEigen 8;
set lambdaN [eigen [expr $nEigen]];
set lambda1 [lindex $lambdaN 0];
set lambda2 [lindex $lambdaN 1];
set lambda3 [lindex $lambdaN 2];
set lambda4 [lindex $lambdaN 3];
set lambda5 [lindex $lambdaN 4];
set lambda6 [lindex $lambdaN 5];
set lambda7 [lindex $lambdaN 6];
set lambda8 [lindex $lambdaN 7];
set w1 [expr pow($lambda1,0.5)];
set w2 [expr pow($lambda2,0.5)];
set w3 [expr pow($lambda3,0.5)];
set w4 [expr pow($lambda4,0.5)];
set w5 [expr pow($lambda5,0.5)];
set w6 [expr pow($lambda6,0.5)];
set w7 [expr pow($lambda7,0.5)];
set w8 [expr pow($lambda8,0.5)];
set T1 [expr 2.0*$pi/$w1];
set T2 [expr 2.0*$pi/$w2];
set T3 [expr 2.0*$pi/$w3];
set T4 [expr 2.0*$pi/$w4];
set T5 [expr 2.0*$pi/$w5];
set T6 [expr 2.0*$pi/$w6];
set T7 [expr 2.0*$pi/$w7];
set T8 [expr 2.0*$pi/$w8];
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
load 409103 0. -34.969 0.; load 409203 0. -23.312 0.; load 409303 0. -23.312 0.; load 409403 0. -34.969 0.; 
load 408103 0. -42.337 0.; load 408203 0. -28.225 0.; load 408303 0. -28.225 0.; load 408403 0. -42.337 0.; 
load 407103 0. -42.337 0.; load 407203 0. -28.225 0.; load 407303 0. -28.225 0.; load 407403 0. -42.337 0.; 
load 406103 0. -42.337 0.; load 406203 0. -28.225 0.; load 406303 0. -28.225 0.; load 406403 0. -42.337 0.; 
load 405103 0. -42.337 0.; load 405203 0. -28.225 0.; load 405303 0. -28.225 0.; load 405403 0. -42.337 0.; 
load 404103 0. -42.337 0.; load 404203 0. -28.225 0.; load 404303 0. -28.225 0.; load 404403 0. -42.337 0.; 
load 403103 0. -42.337 0.; load 403203 0. -28.225 0.; load 403303 0. -28.225 0.; load 403403 0. -42.337 0.; 
load 402103 0. -43.125 0.; load 402203 0. -28.750 0.; load 402303 0. -28.750 0.; load 402403 0. -43.125 0.; 

# EGC/LC COLUMN LOADS
load 95 0. -310.443794 0.; load 96 0. -310.443794 0.; 
load 85 0. -344.887107 0.; load 86 0. -344.887107 0.; 
load 75 0. -344.887107 0.; load 76 0. -344.887107 0.; 
load 65 0. -344.887107 0.; load 66 0. -344.887107 0.; 
load 55 0. -344.887107 0.; load 56 0. -344.887107 0.; 
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

puts "Seismic Weight = 6560.0 kip";
puts "Seismic Mass = 14.6 kip.sec2/in";

if {$Animation == 1} {
	DisplayModel3D DeformedShape 5 50 50  2000 1500
}

###################################################################################################
#                                        Pushover Analysis                       		          #
###################################################################################################

if {$PO==1} {

	# Create Load Pattern
	pattern Plain 222 Linear {
	load 409103 0.39618 0.0 0.0
	load 408103 0.36509 0.0 0.0
	load 407103 0.32196 0.0 0.0
	load 406103 0.27003 0.0 0.0
	load 405103 0.21147 0.0 0.0
	load 404103 0.15470 0.0 0.0
	load 403103 0.10069 0.0 0.0
	load 402103 0.04728 0.0 0.0
	}

	# Displacement Control Parameters
	set CtrlNode 409104;
	set CtrlDOF 1;
	set Dmax [expr 0.100*$Floor9];
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
	set a0 [expr $zeta*2.0*$w1*$w3/($w1 + $w3)];
	set a1 [expr $zeta*2.0/($w1 + $w3)];
	set a1_mod [expr $a1*(1.0+$n)/$n];
	region 1 -eleRange  502100  608400 -rayleigh 0.0 0.0 $a1_mod 0.0;
	region 2 -node  402103 402203 402303 402403 102500 102600 403103 403203 403303 403403 103500 103600 404103 404203 404303 404403 104500 104600 405103 405203 405303 405403 105500 105600 406103 406203 406303 406403 106500 106600 407103 407203 407303 407403 107500 107600 408103 408203 408303 408403 108500 108600 409103 409203 409303 409403 109500 109600  -rayleigh $a0 0.0 0.0 0.0;

	# GROUND MOTION ACCELERATION FILE INPUT
	set AccelSeries "Series -dt $dt -filePath $GMfile -factor  [expr $EqScale* $g]"
	pattern UniformExcitation  200 1 -accel $AccelSeries

	set SMFFloorNodes [list  402104 403104 404104 405104 406104 407104 408104 409104 ];
	DynamicAnalysisCollapseSolver   $dt	$dtAnalysis	$totTime $NStory	0.15   $SMFFloorNodes	180.00 156.00;

	puts "Ground Motion Done. End Time: [getTime]"

}

wipe all;
