# 12-story MRF Building
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
set NStory 12;
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
set L_RBS13  [expr  0.625 *  9.02 +  0.750 * 24.10/2.];
set L_RBS12  [expr  0.625 *  9.02 +  0.750 * 24.10/2.];
set L_RBS11  [expr  0.625 *  9.99 +  0.750 * 26.90/2.];
set L_RBS10  [expr  0.625 *  9.99 +  0.750 * 26.90/2.];
set L_RBS9  [expr  0.625 * 10.50 +  0.750 * 30.00/2.];
set L_RBS8  [expr  0.625 * 10.50 +  0.750 * 30.00/2.];
set L_RBS7  [expr  0.625 * 10.50 +  0.750 * 30.00/2.];
set L_RBS6  [expr  0.625 * 10.50 +  0.750 * 30.00/2.];
set L_RBS5  [expr  0.625 * 10.50 +  0.750 * 30.30/2.];
set L_RBS4  [expr  0.625 * 10.50 +  0.750 * 30.30/2.];
set L_RBS3  [expr  0.625 * 10.50 +  0.750 * 30.30/2.];
set L_RBS2  [expr  0.625 * 10.50 +  0.750 * 30.20/2.];

# FRAME GRID LINES
set HBuilding 1896.00;
set Floor13  1896.00;
set Floor12  1740.00;
set Floor11  1584.00;
set Floor10  1428.00;
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
node 135   $Axis5  $Floor13; node 136   $Axis6  $Floor13; 
node 125   $Axis5  $Floor12; node 126   $Axis6  $Floor12; 
node 115   $Axis5  $Floor11; node 116   $Axis6  $Floor11; 
node 105   $Axis5  $Floor10; node 106   $Axis6  $Floor10; 
node 95   $Axis5  $Floor9; node 96   $Axis6  $Floor9; 
node 85   $Axis5  $Floor8; node 86   $Axis6  $Floor8; 
node 75   $Axis5  $Floor7; node 76   $Axis6  $Floor7; 
node 65   $Axis5  $Floor6; node 66   $Axis6  $Floor6; 
node 55   $Axis5  $Floor5; node 56   $Axis6  $Floor5; 
node 45   $Axis5  $Floor4; node 46   $Axis6  $Floor4; 
node 35   $Axis5  $Floor3; node 36   $Axis6  $Floor3; 
node 25   $Axis5  $Floor2; node 26   $Axis6  $Floor2; 

# MRF BEAM NODES
node 1314   [expr $Axis1 + $L_RBS13 + 24.10/2] $Floor13; node 1322   [expr $Axis2 - $L_RBS13 - 24.30/2] $Floor13; node 1324   [expr $Axis2 + $L_RBS13 + 24.30/2] $Floor13; node 1332   [expr $Axis3 - $L_RBS13 - 24.30/2] $Floor13; node 1334   [expr $Axis3 + $L_RBS13 + 24.30/2] $Floor13; node 1342   [expr $Axis4 - $L_RBS13 - 24.10/2] $Floor13; 
node 1214   [expr $Axis1 + $L_RBS12 + 24.50/2] $Floor12; node 1222   [expr $Axis2 - $L_RBS12 - 24.50/2] $Floor12; node 1224   [expr $Axis2 + $L_RBS12 + 24.50/2] $Floor12; node 1232   [expr $Axis3 - $L_RBS12 - 24.50/2] $Floor12; node 1234   [expr $Axis3 + $L_RBS12 + 24.50/2] $Floor12; node 1242   [expr $Axis4 - $L_RBS12 - 24.50/2] $Floor12; 
node 1114   [expr $Axis1 + $L_RBS11 + 24.50/2] $Floor11; node 1122   [expr $Axis2 - $L_RBS11 - 24.50/2] $Floor11; node 1124   [expr $Axis2 + $L_RBS11 + 24.50/2] $Floor11; node 1132   [expr $Axis3 - $L_RBS11 - 24.50/2] $Floor11; node 1134   [expr $Axis3 + $L_RBS11 + 24.50/2] $Floor11; node 1142   [expr $Axis4 - $L_RBS11 - 24.50/2] $Floor11; 
node 1014   [expr $Axis1 + $L_RBS10 + 24.50/2] $Floor10; node 1022   [expr $Axis2 - $L_RBS10 - 25.20/2] $Floor10; node 1024   [expr $Axis2 + $L_RBS10 + 25.20/2] $Floor10; node 1032   [expr $Axis3 - $L_RBS10 - 25.20/2] $Floor10; node 1034   [expr $Axis3 + $L_RBS10 + 25.20/2] $Floor10; node 1042   [expr $Axis4 - $L_RBS10 - 24.50/2] $Floor10; 
node 914   [expr $Axis1 + $L_RBS9 + 24.50/2] $Floor9; node 922   [expr $Axis2 - $L_RBS9 - 25.20/2] $Floor9; node 924   [expr $Axis2 + $L_RBS9 + 25.20/2] $Floor9; node 932   [expr $Axis3 - $L_RBS9 - 25.20/2] $Floor9; node 934   [expr $Axis3 + $L_RBS9 + 25.20/2] $Floor9; node 942   [expr $Axis4 - $L_RBS9 - 24.50/2] $Floor9; 
node 814   [expr $Axis1 + $L_RBS8 + 25.00/2] $Floor8; node 822   [expr $Axis2 - $L_RBS8 - 25.70/2] $Floor8; node 824   [expr $Axis2 + $L_RBS8 + 25.70/2] $Floor8; node 832   [expr $Axis3 - $L_RBS8 - 25.70/2] $Floor8; node 834   [expr $Axis3 + $L_RBS8 + 25.70/2] $Floor8; node 842   [expr $Axis4 - $L_RBS8 - 25.00/2] $Floor8; 
node 714   [expr $Axis1 + $L_RBS7 + 25.00/2] $Floor7; node 722   [expr $Axis2 - $L_RBS7 - 25.70/2] $Floor7; node 724   [expr $Axis2 + $L_RBS7 + 25.70/2] $Floor7; node 732   [expr $Axis3 - $L_RBS7 - 25.70/2] $Floor7; node 734   [expr $Axis3 + $L_RBS7 + 25.70/2] $Floor7; node 742   [expr $Axis4 - $L_RBS7 - 25.00/2] $Floor7; 
node 614   [expr $Axis1 + $L_RBS6 + 25.50/2] $Floor6; node 622   [expr $Axis2 - $L_RBS6 - 26.30/2] $Floor6; node 624   [expr $Axis2 + $L_RBS6 + 26.30/2] $Floor6; node 632   [expr $Axis3 - $L_RBS6 - 26.30/2] $Floor6; node 634   [expr $Axis3 + $L_RBS6 + 26.30/2] $Floor6; node 642   [expr $Axis4 - $L_RBS6 - 25.50/2] $Floor6; 
node 514   [expr $Axis1 + $L_RBS5 + 25.50/2] $Floor5; node 522   [expr $Axis2 - $L_RBS5 - 26.30/2] $Floor5; node 524   [expr $Axis2 + $L_RBS5 + 26.30/2] $Floor5; node 532   [expr $Axis3 - $L_RBS5 - 26.30/2] $Floor5; node 534   [expr $Axis3 + $L_RBS5 + 26.30/2] $Floor5; node 542   [expr $Axis4 - $L_RBS5 - 25.50/2] $Floor5; 
node 414   [expr $Axis1 + $L_RBS4 + 26.00/2] $Floor4; node 422   [expr $Axis2 - $L_RBS4 - 26.70/2] $Floor4; node 424   [expr $Axis2 + $L_RBS4 + 26.70/2] $Floor4; node 432   [expr $Axis3 - $L_RBS4 - 26.70/2] $Floor4; node 434   [expr $Axis3 + $L_RBS4 + 26.70/2] $Floor4; node 442   [expr $Axis4 - $L_RBS4 - 26.00/2] $Floor4; 
node 314   [expr $Axis1 + $L_RBS3 + 26.00/2] $Floor3; node 322   [expr $Axis2 - $L_RBS3 - 26.70/2] $Floor3; node 324   [expr $Axis2 + $L_RBS3 + 26.70/2] $Floor3; node 332   [expr $Axis3 - $L_RBS3 - 26.70/2] $Floor3; node 334   [expr $Axis3 + $L_RBS3 + 26.70/2] $Floor3; node 342   [expr $Axis4 - $L_RBS3 - 26.00/2] $Floor3; 
node 214   [expr $Axis1 + $L_RBS2 + 26.00/2] $Floor2; node 222   [expr $Axis2 - $L_RBS2 - 26.70/2] $Floor2; node 224   [expr $Axis2 + $L_RBS2 + 26.70/2] $Floor2; node 232   [expr $Axis3 - $L_RBS2 - 26.70/2] $Floor2; node 234   [expr $Axis3 + $L_RBS2 + 26.70/2] $Floor2; node 242   [expr $Axis4 - $L_RBS2 - 26.00/2] $Floor2; 

# MRF COLUMN NODES
node 1311  $Axis1 [expr $Floor13 - 24.10/2]; node 1321  $Axis2 [expr $Floor13 - 24.10/2]; node 1331  $Axis3 [expr $Floor13 - 24.10/2]; node 1341  $Axis4 [expr $Floor13 - 24.10/2]; 
node 1213  $Axis1 [expr $Floor12 + 24.10/2]; node 1223  $Axis2 [expr $Floor12 + 24.10/2]; node 1233  $Axis3 [expr $Floor12 + 24.10/2]; node 1243  $Axis4 [expr $Floor12 + 24.10/2]; 
node 1211  $Axis1 [expr $Floor12 - 24.10/2]; node 1221  $Axis2 [expr $Floor12 - 24.10/2]; node 1231  $Axis3 [expr $Floor12 - 24.10/2]; node 1241  $Axis4 [expr $Floor12 - 24.10/2]; 
node 1113  $Axis1 [expr $Floor11 + 26.90/2]; node 1123  $Axis2 [expr $Floor11 + 26.90/2]; node 1133  $Axis3 [expr $Floor11 + 26.90/2]; node 1143  $Axis4 [expr $Floor11 + 26.90/2]; 
node 1111  $Axis1 [expr $Floor11 - 26.90/2]; node 1121  $Axis2 [expr $Floor11 - 26.90/2]; node 1131  $Axis3 [expr $Floor11 - 26.90/2]; node 1141  $Axis4 [expr $Floor11 - 26.90/2]; 
node 1013  $Axis1 [expr $Floor10 + 26.90/2]; node 1023  $Axis2 [expr $Floor10 + 26.90/2]; node 1033  $Axis3 [expr $Floor10 + 26.90/2]; node 1043  $Axis4 [expr $Floor10 + 26.90/2]; 
node 1011  $Axis1 [expr $Floor10 - 26.90/2]; node 1021  $Axis2 [expr $Floor10 - 26.90/2]; node 1031  $Axis3 [expr $Floor10 - 26.90/2]; node 1041  $Axis4 [expr $Floor10 - 26.90/2]; 
node 913  $Axis1 [expr $Floor9 + 30.00/2]; node 923  $Axis2 [expr $Floor9 + 30.00/2]; node 933  $Axis3 [expr $Floor9 + 30.00/2]; node 943  $Axis4 [expr $Floor9 + 30.00/2]; 
node 911  $Axis1 [expr $Floor9 - 30.00/2]; node 921  $Axis2 [expr $Floor9 - 30.00/2]; node 931  $Axis3 [expr $Floor9 - 30.00/2]; node 941  $Axis4 [expr $Floor9 - 30.00/2]; 
node 813  $Axis1 [expr $Floor8 + 30.00/2]; node 823  $Axis2 [expr $Floor8 + 30.00/2]; node 833  $Axis3 [expr $Floor8 + 30.00/2]; node 843  $Axis4 [expr $Floor8 + 30.00/2]; 
node 811  $Axis1 [expr $Floor8 - 30.00/2]; node 821  $Axis2 [expr $Floor8 - 30.00/2]; node 831  $Axis3 [expr $Floor8 - 30.00/2]; node 841  $Axis4 [expr $Floor8 - 30.00/2]; 
node 713  $Axis1 [expr $Floor7 + 30.00/2]; node 723  $Axis2 [expr $Floor7 + 30.00/2]; node 733  $Axis3 [expr $Floor7 + 30.00/2]; node 743  $Axis4 [expr $Floor7 + 30.00/2]; 
node 711  $Axis1 [expr $Floor7 - 30.00/2]; node 721  $Axis2 [expr $Floor7 - 30.00/2]; node 731  $Axis3 [expr $Floor7 - 30.00/2]; node 741  $Axis4 [expr $Floor7 - 30.00/2]; 
node 613  $Axis1 [expr $Floor6 + 30.00/2]; node 623  $Axis2 [expr $Floor6 + 30.00/2]; node 633  $Axis3 [expr $Floor6 + 30.00/2]; node 643  $Axis4 [expr $Floor6 + 30.00/2]; 
node 611  $Axis1 [expr $Floor6 - 30.00/2]; node 621  $Axis2 [expr $Floor6 - 30.00/2]; node 631  $Axis3 [expr $Floor6 - 30.00/2]; node 641  $Axis4 [expr $Floor6 - 30.00/2]; 
node 513  $Axis1 [expr $Floor5 + 30.30/2]; node 523  $Axis2 [expr $Floor5 + 30.30/2]; node 533  $Axis3 [expr $Floor5 + 30.30/2]; node 543  $Axis4 [expr $Floor5 + 30.30/2]; 
node 511  $Axis1 [expr $Floor5 - 30.30/2]; node 521  $Axis2 [expr $Floor5 - 30.30/2]; node 531  $Axis3 [expr $Floor5 - 30.30/2]; node 541  $Axis4 [expr $Floor5 - 30.30/2]; 
node 413  $Axis1 [expr $Floor4 + 30.30/2]; node 423  $Axis2 [expr $Floor4 + 30.30/2]; node 433  $Axis3 [expr $Floor4 + 30.30/2]; node 443  $Axis4 [expr $Floor4 + 30.30/2]; 
node 411  $Axis1 [expr $Floor4 - 30.30/2]; node 421  $Axis2 [expr $Floor4 - 30.30/2]; node 431  $Axis3 [expr $Floor4 - 30.30/2]; node 441  $Axis4 [expr $Floor4 - 30.30/2]; 
node 313  $Axis1 [expr $Floor3 + 30.30/2]; node 323  $Axis2 [expr $Floor3 + 30.30/2]; node 333  $Axis3 [expr $Floor3 + 30.30/2]; node 343  $Axis4 [expr $Floor3 + 30.30/2]; 
node 311  $Axis1 [expr $Floor3 - 30.30/2]; node 321  $Axis2 [expr $Floor3 - 30.30/2]; node 331  $Axis3 [expr $Floor3 - 30.30/2]; node 341  $Axis4 [expr $Floor3 - 30.30/2]; 
node 213  $Axis1 [expr $Floor2 + 30.20/2]; node 223  $Axis2 [expr $Floor2 + 30.20/2]; node 233  $Axis3 [expr $Floor2 + 30.20/2]; node 243  $Axis4 [expr $Floor2 + 30.20/2]; 
node 211  $Axis1 [expr $Floor2 - 30.20/2]; node 221  $Axis2 [expr $Floor2 - 30.20/2]; node 231  $Axis3 [expr $Floor2 - 30.20/2]; node 241  $Axis4 [expr $Floor2 - 30.20/2]; 
node 113  $Axis1 $Floor1; node 123  $Axis2 $Floor1; node 133  $Axis3 $Floor1; node 143  $Axis4 $Floor1; 

# BEAM PLASTIC HINGE NODES
node 13140   [expr $Axis1 + $L_RBS13 + 24.10/2] $Floor13; node 13220   [expr $Axis2 - $L_RBS13 - 24.30/2] $Floor13; node 13240   [expr $Axis2 + $L_RBS13 + 24.30/2] $Floor13; node 13320   [expr $Axis3 - $L_RBS13 - 24.30/2] $Floor13; node 13340   [expr $Axis3 + $L_RBS13 + 24.30/2] $Floor13; node 13420   [expr $Axis4 - $L_RBS13 - 24.10/2] $Floor13; 
node 12140   [expr $Axis1 + $L_RBS12 + 24.50/2] $Floor12; node 12220   [expr $Axis2 - $L_RBS12 - 24.50/2] $Floor12; node 12240   [expr $Axis2 + $L_RBS12 + 24.50/2] $Floor12; node 12320   [expr $Axis3 - $L_RBS12 - 24.50/2] $Floor12; node 12340   [expr $Axis3 + $L_RBS12 + 24.50/2] $Floor12; node 12420   [expr $Axis4 - $L_RBS12 - 24.50/2] $Floor12; 
node 11140   [expr $Axis1 + $L_RBS11 + 24.50/2] $Floor11; node 11220   [expr $Axis2 - $L_RBS11 - 24.50/2] $Floor11; node 11240   [expr $Axis2 + $L_RBS11 + 24.50/2] $Floor11; node 11320   [expr $Axis3 - $L_RBS11 - 24.50/2] $Floor11; node 11340   [expr $Axis3 + $L_RBS11 + 24.50/2] $Floor11; node 11420   [expr $Axis4 - $L_RBS11 - 24.50/2] $Floor11; 
node 10140   [expr $Axis1 + $L_RBS10 + 24.50/2] $Floor10; node 10220   [expr $Axis2 - $L_RBS10 - 25.20/2] $Floor10; node 10240   [expr $Axis2 + $L_RBS10 + 25.20/2] $Floor10; node 10320   [expr $Axis3 - $L_RBS10 - 25.20/2] $Floor10; node 10340   [expr $Axis3 + $L_RBS10 + 25.20/2] $Floor10; node 10420   [expr $Axis4 - $L_RBS10 - 24.50/2] $Floor10; 
node 9140   [expr $Axis1 + $L_RBS9 + 24.50/2] $Floor9; node 9220   [expr $Axis2 - $L_RBS9 - 25.20/2] $Floor9; node 9240   [expr $Axis2 + $L_RBS9 + 25.20/2] $Floor9; node 9320   [expr $Axis3 - $L_RBS9 - 25.20/2] $Floor9; node 9340   [expr $Axis3 + $L_RBS9 + 25.20/2] $Floor9; node 9420   [expr $Axis4 - $L_RBS9 - 24.50/2] $Floor9; 
node 8140   [expr $Axis1 + $L_RBS8 + 25.00/2] $Floor8; node 8220   [expr $Axis2 - $L_RBS8 - 25.70/2] $Floor8; node 8240   [expr $Axis2 + $L_RBS8 + 25.70/2] $Floor8; node 8320   [expr $Axis3 - $L_RBS8 - 25.70/2] $Floor8; node 8340   [expr $Axis3 + $L_RBS8 + 25.70/2] $Floor8; node 8420   [expr $Axis4 - $L_RBS8 - 25.00/2] $Floor8; 
node 7140   [expr $Axis1 + $L_RBS7 + 25.00/2] $Floor7; node 7220   [expr $Axis2 - $L_RBS7 - 25.70/2] $Floor7; node 7240   [expr $Axis2 + $L_RBS7 + 25.70/2] $Floor7; node 7320   [expr $Axis3 - $L_RBS7 - 25.70/2] $Floor7; node 7340   [expr $Axis3 + $L_RBS7 + 25.70/2] $Floor7; node 7420   [expr $Axis4 - $L_RBS7 - 25.00/2] $Floor7; 
node 6140   [expr $Axis1 + $L_RBS6 + 25.50/2] $Floor6; node 6220   [expr $Axis2 - $L_RBS6 - 26.30/2] $Floor6; node 6240   [expr $Axis2 + $L_RBS6 + 26.30/2] $Floor6; node 6320   [expr $Axis3 - $L_RBS6 - 26.30/2] $Floor6; node 6340   [expr $Axis3 + $L_RBS6 + 26.30/2] $Floor6; node 6420   [expr $Axis4 - $L_RBS6 - 25.50/2] $Floor6; 
node 5140   [expr $Axis1 + $L_RBS5 + 25.50/2] $Floor5; node 5220   [expr $Axis2 - $L_RBS5 - 26.30/2] $Floor5; node 5240   [expr $Axis2 + $L_RBS5 + 26.30/2] $Floor5; node 5320   [expr $Axis3 - $L_RBS5 - 26.30/2] $Floor5; node 5340   [expr $Axis3 + $L_RBS5 + 26.30/2] $Floor5; node 5420   [expr $Axis4 - $L_RBS5 - 25.50/2] $Floor5; 
node 4140   [expr $Axis1 + $L_RBS4 + 26.00/2] $Floor4; node 4220   [expr $Axis2 - $L_RBS4 - 26.70/2] $Floor4; node 4240   [expr $Axis2 + $L_RBS4 + 26.70/2] $Floor4; node 4320   [expr $Axis3 - $L_RBS4 - 26.70/2] $Floor4; node 4340   [expr $Axis3 + $L_RBS4 + 26.70/2] $Floor4; node 4420   [expr $Axis4 - $L_RBS4 - 26.00/2] $Floor4; 
node 3140   [expr $Axis1 + $L_RBS3 + 26.00/2] $Floor3; node 3220   [expr $Axis2 - $L_RBS3 - 26.70/2] $Floor3; node 3240   [expr $Axis2 + $L_RBS3 + 26.70/2] $Floor3; node 3320   [expr $Axis3 - $L_RBS3 - 26.70/2] $Floor3; node 3340   [expr $Axis3 + $L_RBS3 + 26.70/2] $Floor3; node 3420   [expr $Axis4 - $L_RBS3 - 26.00/2] $Floor3; 
node 2140   [expr $Axis1 + $L_RBS2 + 26.00/2] $Floor2; node 2220   [expr $Axis2 - $L_RBS2 - 26.70/2] $Floor2; node 2240   [expr $Axis2 + $L_RBS2 + 26.70/2] $Floor2; node 2320   [expr $Axis3 - $L_RBS2 - 26.70/2] $Floor2; node 2340   [expr $Axis3 + $L_RBS2 + 26.70/2] $Floor2; node 2420   [expr $Axis4 - $L_RBS2 - 26.00/2] $Floor2; 

# COLUMN SPLICE NODES
node 111170 $Axis1 [expr ($Floor11+$Floor12)/2]; node 111270 $Axis2 [expr ($Floor11+$Floor12)/2]; node 111370 $Axis3 [expr ($Floor11+$Floor12)/2]; node 111470 $Axis4 [expr ($Floor11+$Floor12)/2]; node 111570 $Axis5 [expr ($Floor11+$Floor12)/2]; node 111670 $Axis6 [expr ($Floor11+$Floor12)/2]; 
node 109170 $Axis1 [expr ($Floor9+$Floor10)/2]; node 109270 $Axis2 [expr ($Floor9+$Floor10)/2]; node 109370 $Axis3 [expr ($Floor9+$Floor10)/2]; node 109470 $Axis4 [expr ($Floor9+$Floor10)/2]; node 109570 $Axis5 [expr ($Floor9+$Floor10)/2]; node 109670 $Axis6 [expr ($Floor9+$Floor10)/2]; 
node 107170 $Axis1 [expr ($Floor7+$Floor8)/2]; node 107270 $Axis2 [expr ($Floor7+$Floor8)/2]; node 107370 $Axis3 [expr ($Floor7+$Floor8)/2]; node 107470 $Axis4 [expr ($Floor7+$Floor8)/2]; node 107570 $Axis5 [expr ($Floor7+$Floor8)/2]; node 107670 $Axis6 [expr ($Floor7+$Floor8)/2]; 
node 105170 $Axis1 [expr ($Floor5+$Floor6)/2]; node 105270 $Axis2 [expr ($Floor5+$Floor6)/2]; node 105370 $Axis3 [expr ($Floor5+$Floor6)/2]; node 105470 $Axis4 [expr ($Floor5+$Floor6)/2]; node 105570 $Axis5 [expr ($Floor5+$Floor6)/2]; node 105670 $Axis6 [expr ($Floor5+$Floor6)/2]; 
node 103170 $Axis1 [expr ($Floor3+$Floor4)/2]; node 103270 $Axis2 [expr ($Floor3+$Floor4)/2]; node 103370 $Axis3 [expr ($Floor3+$Floor4)/2]; node 103470 $Axis4 [expr ($Floor3+$Floor4)/2]; node 103570 $Axis5 [expr ($Floor3+$Floor4)/2]; node 103670 $Axis6 [expr ($Floor3+$Floor4)/2]; 

# EGF BEAM NODES
node 1354  $Axis5  $Floor13; node 1362  $Axis6  $Floor13; 
node 1254  $Axis5  $Floor12; node 1262  $Axis6  $Floor12; 
node 1154  $Axis5  $Floor11; node 1162  $Axis6  $Floor11; 
node 1054  $Axis5  $Floor10; node 1062  $Axis6  $Floor10; 
node 954  $Axis5  $Floor9; node 962  $Axis6  $Floor9; 
node 854  $Axis5  $Floor8; node 862  $Axis6  $Floor8; 
node 754  $Axis5  $Floor7; node 762  $Axis6  $Floor7; 
node 654  $Axis5  $Floor6; node 662  $Axis6  $Floor6; 
node 554  $Axis5  $Floor5; node 562  $Axis6  $Floor5; 
node 454  $Axis5  $Floor4; node 462  $Axis6  $Floor4; 
node 354  $Axis5  $Floor3; node 362  $Axis6  $Floor3; 
node 254  $Axis5  $Floor2; node 262  $Axis6  $Floor2; 

# EGF COLUMN NODES
node 1351  $Axis5  $Floor13; node 1361  $Axis6  $Floor13; 
node 1253  $Axis5  $Floor12; node 1263  $Axis6  $Floor12; 
node 1251  $Axis5  $Floor12; node 1261  $Axis6  $Floor12; 
node 1153  $Axis5  $Floor11; node 1163  $Axis6  $Floor11; 
node 1151  $Axis5  $Floor11; node 1161  $Axis6  $Floor11; 
node 1053  $Axis5  $Floor10; node 1063  $Axis6  $Floor10; 
node 1051  $Axis5  $Floor10; node 1061  $Axis6  $Floor10; 
node 953  $Axis5  $Floor9; node 963  $Axis6  $Floor9; 
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
ConstructPanel  1 13 $Axis1 $Floor13 $E $A_Stiff $I_Stiff 24.10 24.10 1; ConstructPanel  2 13 $Axis2 $Floor13 $E $A_Stiff $I_Stiff 24.30 24.10 1; ConstructPanel  3 13 $Axis3 $Floor13 $E $A_Stiff $I_Stiff 24.30 24.10 1; ConstructPanel  4 13 $Axis4 $Floor13 $E $A_Stiff $I_Stiff 24.10 24.10 1; 
ConstructPanel  1 12 $Axis1 $Floor12 $E $A_Stiff $I_Stiff 24.10 24.10 1; ConstructPanel  2 12 $Axis2 $Floor12 $E $A_Stiff $I_Stiff 24.30 24.10 1; ConstructPanel  3 12 $Axis3 $Floor12 $E $A_Stiff $I_Stiff 24.30 24.10 1; ConstructPanel  4 12 $Axis4 $Floor12 $E $A_Stiff $I_Stiff 24.10 24.10 1; 
ConstructPanel  1 11 $Axis1 $Floor11 $E $A_Stiff $I_Stiff 24.50 26.90 1; ConstructPanel  2 11 $Axis2 $Floor11 $E $A_Stiff $I_Stiff 24.50 26.90 1; ConstructPanel  3 11 $Axis3 $Floor11 $E $A_Stiff $I_Stiff 24.50 26.90 1; ConstructPanel  4 11 $Axis4 $Floor11 $E $A_Stiff $I_Stiff 24.50 26.90 1; 
ConstructPanel  1 10 $Axis1 $Floor10 $E $A_Stiff $I_Stiff 24.50 26.90 1; ConstructPanel  2 10 $Axis2 $Floor10 $E $A_Stiff $I_Stiff 24.50 26.90 1; ConstructPanel  3 10 $Axis3 $Floor10 $E $A_Stiff $I_Stiff 24.50 26.90 1; ConstructPanel  4 10 $Axis4 $Floor10 $E $A_Stiff $I_Stiff 24.50 26.90 1; 
ConstructPanel  1 9 $Axis1 $Floor9 $E $A_Stiff $I_Stiff 24.50 30.00 1; ConstructPanel  2 9 $Axis2 $Floor9 $E $A_Stiff $I_Stiff 25.20 30.00 1; ConstructPanel  3 9 $Axis3 $Floor9 $E $A_Stiff $I_Stiff 25.20 30.00 1; ConstructPanel  4 9 $Axis4 $Floor9 $E $A_Stiff $I_Stiff 24.50 30.00 1; 
ConstructPanel  1 8 $Axis1 $Floor8 $E $A_Stiff $I_Stiff 24.50 30.00 1; ConstructPanel  2 8 $Axis2 $Floor8 $E $A_Stiff $I_Stiff 25.20 30.00 1; ConstructPanel  3 8 $Axis3 $Floor8 $E $A_Stiff $I_Stiff 25.20 30.00 1; ConstructPanel  4 8 $Axis4 $Floor8 $E $A_Stiff $I_Stiff 24.50 30.00 1; 
ConstructPanel  1 7 $Axis1 $Floor7 $E $A_Stiff $I_Stiff 25.00 30.00 1; ConstructPanel  2 7 $Axis2 $Floor7 $E $A_Stiff $I_Stiff 25.70 30.00 1; ConstructPanel  3 7 $Axis3 $Floor7 $E $A_Stiff $I_Stiff 25.70 30.00 1; ConstructPanel  4 7 $Axis4 $Floor7 $E $A_Stiff $I_Stiff 25.00 30.00 1; 
ConstructPanel  1 6 $Axis1 $Floor6 $E $A_Stiff $I_Stiff 25.00 30.00 1; ConstructPanel  2 6 $Axis2 $Floor6 $E $A_Stiff $I_Stiff 25.70 30.00 1; ConstructPanel  3 6 $Axis3 $Floor6 $E $A_Stiff $I_Stiff 25.70 30.00 1; ConstructPanel  4 6 $Axis4 $Floor6 $E $A_Stiff $I_Stiff 25.00 30.00 1; 
ConstructPanel  1 5 $Axis1 $Floor5 $E $A_Stiff $I_Stiff 25.50 30.30 1; ConstructPanel  2 5 $Axis2 $Floor5 $E $A_Stiff $I_Stiff 26.30 30.30 1; ConstructPanel  3 5 $Axis3 $Floor5 $E $A_Stiff $I_Stiff 26.30 30.30 1; ConstructPanel  4 5 $Axis4 $Floor5 $E $A_Stiff $I_Stiff 25.50 30.30 1; 
ConstructPanel  1 4 $Axis1 $Floor4 $E $A_Stiff $I_Stiff 25.50 30.30 1; ConstructPanel  2 4 $Axis2 $Floor4 $E $A_Stiff $I_Stiff 26.30 30.30 1; ConstructPanel  3 4 $Axis3 $Floor4 $E $A_Stiff $I_Stiff 26.30 30.30 1; ConstructPanel  4 4 $Axis4 $Floor4 $E $A_Stiff $I_Stiff 25.50 30.30 1; 
ConstructPanel  1 3 $Axis1 $Floor3 $E $A_Stiff $I_Stiff 26.00 30.30 1; ConstructPanel  2 3 $Axis2 $Floor3 $E $A_Stiff $I_Stiff 26.70 30.30 1; ConstructPanel  3 3 $Axis3 $Floor3 $E $A_Stiff $I_Stiff 26.70 30.30 1; ConstructPanel  4 3 $Axis4 $Floor3 $E $A_Stiff $I_Stiff 26.00 30.30 1; 
ConstructPanel  1 2 $Axis1 $Floor2 $E $A_Stiff $I_Stiff 26.00 30.20 1; ConstructPanel  2 2 $Axis2 $Floor2 $E $A_Stiff $I_Stiff 26.70 30.20 1; ConstructPanel  3 2 $Axis3 $Floor2 $E $A_Stiff $I_Stiff 26.70 30.20 1; ConstructPanel  4 2 $Axis4 $Floor2 $E $A_Stiff $I_Stiff 26.00 30.20 1; 

####################################################################################################
#                                   		PANEL ZONE SPRINGS	                                   #
####################################################################################################

# Command Syntax; 
# Spring_Panel Element_ID Node_i Node_j E Fy tp d_Colum d_Beam tf_Column bf_Column SH_Panel Response_ID transfTag Units
Spring_Panel 913100 413109 413110 $E $Fy [expr  0.47 +  0.06] 24.10 24.10  0.77  9.02  0.03 2 1 2; Spring_Panel 913200 413209 413210 $E $Fy [expr  0.52 +  0.56] 24.30 24.10  0.88  9.07  0.03 2 1 2; Spring_Panel 913300 413309 413310 $E $Fy [expr  0.52 +  0.56] 24.30 24.10  0.88  9.07  0.03 2 1 2; Spring_Panel 913400 413409 413410 $E $Fy [expr  0.47 +  0.06] 24.10 24.10  0.77  9.02  0.03 2 1 2; 
Spring_Panel 912100 412109 412110 $E $Fy [expr  0.47 +  0.06] 24.10 24.10  0.77  9.02  0.03 2 1 2; Spring_Panel 912200 412209 412210 $E $Fy [expr  0.52 +  0.56] 24.30 24.10  0.88  9.07  0.03 2 1 2; Spring_Panel 912300 412309 412310 $E $Fy [expr  0.52 +  0.56] 24.30 24.10  0.88  9.07  0.03 2 1 2; Spring_Panel 912400 412409 412410 $E $Fy [expr  0.47 +  0.06] 24.10 24.10  0.77  9.02  0.03 2 1 2; 
Spring_Panel 911100 411109 411110 $E $Fy [expr  0.60 +  0.00] 24.50 26.90  0.96 12.90  0.03 2 1 2; Spring_Panel 911200 411209 411210 $E $Fy [expr  0.60 +  0.56] 24.50 26.90  0.96 12.90  0.03 2 1 2; Spring_Panel 911300 411309 411310 $E $Fy [expr  0.60 +  0.56] 24.50 26.90  0.96 12.90  0.03 2 1 2; Spring_Panel 911400 411409 411410 $E $Fy [expr  0.60 +  0.00] 24.50 26.90  0.96 12.90  0.03 2 1 2; 
Spring_Panel 910100 410109 410110 $E $Fy [expr  0.60 +  0.00] 24.50 26.90  0.96 12.90  0.03 2 1 2; Spring_Panel 910200 410209 410210 $E $Fy [expr  0.60 +  0.56] 24.50 26.90  0.96 12.90  0.03 2 1 2; Spring_Panel 910300 410309 410310 $E $Fy [expr  0.60 +  0.56] 24.50 26.90  0.96 12.90  0.03 2 1 2; Spring_Panel 910400 410409 410410 $E $Fy [expr  0.60 +  0.00] 24.50 26.90  0.96 12.90  0.03 2 1 2; 
Spring_Panel 909100 409109 409110 $E $Fy [expr  0.60 +  0.06] 24.50 30.00  0.96 12.90  0.03 2 1 2; Spring_Panel 909200 409209 409210 $E $Fy [expr  0.75 +  0.63] 25.20 30.00  1.34 12.90  0.03 2 1 2; Spring_Panel 909300 409309 409310 $E $Fy [expr  0.75 +  0.63] 25.20 30.00  1.34 12.90  0.03 2 1 2; Spring_Panel 909400 409409 409410 $E $Fy [expr  0.60 +  0.06] 24.50 30.00  0.96 12.90  0.03 2 1 2; 
Spring_Panel 908100 408109 408110 $E $Fy [expr  0.60 +  0.06] 24.50 30.00  0.96 12.90  0.03 2 1 2; Spring_Panel 908200 408209 408210 $E $Fy [expr  0.75 +  0.63] 25.20 30.00  1.34 12.90  0.03 2 1 2; Spring_Panel 908300 408309 408310 $E $Fy [expr  0.75 +  0.63] 25.20 30.00  1.34 12.90  0.03 2 1 2; Spring_Panel 908400 408409 408410 $E $Fy [expr  0.60 +  0.06] 24.50 30.00  0.96 12.90  0.03 2 1 2; 
Spring_Panel 907100 407109 407110 $E $Fy [expr  0.70 +  0.00] 25.00 30.00  1.22 13.00  0.03 2 1 2; Spring_Panel 907200 407209 407210 $E $Fy [expr  0.87 +  0.44] 25.70 30.00  1.57 13.00  0.03 2 1 2; Spring_Panel 907300 407309 407310 $E $Fy [expr  0.87 +  0.44] 25.70 30.00  1.57 13.00  0.03 2 1 2; Spring_Panel 907400 407409 407410 $E $Fy [expr  0.70 +  0.00] 25.00 30.00  1.22 13.00  0.03 2 1 2; 
Spring_Panel 906100 406109 406110 $E $Fy [expr  0.70 +  0.00] 25.00 30.00  1.22 13.00  0.03 2 1 2; Spring_Panel 906200 406209 406210 $E $Fy [expr  0.87 +  0.44] 25.70 30.00  1.57 13.00  0.03 2 1 2; Spring_Panel 906300 406309 406310 $E $Fy [expr  0.87 +  0.44] 25.70 30.00  1.57 13.00  0.03 2 1 2; Spring_Panel 906400 406409 406410 $E $Fy [expr  0.70 +  0.00] 25.00 30.00  1.22 13.00  0.03 2 1 2; 
Spring_Panel 905100 405109 405110 $E $Fy [expr  0.81 +  0.00] 25.50 30.30  1.46 13.00  0.03 2 1 2; Spring_Panel 905200 405209 405210 $E $Fy [expr  1.04 +  0.38] 26.30 30.30  1.89 13.20  0.03 2 1 2; Spring_Panel 905300 405309 405310 $E $Fy [expr  1.04 +  0.38] 26.30 30.30  1.89 13.20  0.03 2 1 2; Spring_Panel 905400 405409 405410 $E $Fy [expr  0.81 +  0.00] 25.50 30.30  1.46 13.00  0.03 2 1 2; 
Spring_Panel 904100 404109 404110 $E $Fy [expr  0.81 +  0.00] 25.50 30.30  1.46 13.00  0.03 2 1 2; Spring_Panel 904200 404209 404210 $E $Fy [expr  1.04 +  0.38] 26.30 30.30  1.89 13.20  0.03 2 1 2; Spring_Panel 904300 404309 404310 $E $Fy [expr  1.04 +  0.38] 26.30 30.30  1.89 13.20  0.03 2 1 2; Spring_Panel 904400 404409 404410 $E $Fy [expr  0.81 +  0.00] 25.50 30.30  1.46 13.00  0.03 2 1 2; 
Spring_Panel 903100 403109 403110 $E $Fy [expr  0.96 +  0.00] 26.00 30.30  1.73 13.10  0.03 2 1 2; Spring_Panel 903200 403209 403210 $E $Fy [expr  1.16 +  0.19] 26.70 30.30  2.09 13.30  0.03 2 1 2; Spring_Panel 903300 403309 403310 $E $Fy [expr  1.16 +  0.19] 26.70 30.30  2.09 13.30  0.03 2 1 2; Spring_Panel 903400 403409 403410 $E $Fy [expr  0.96 +  0.00] 26.00 30.30  1.73 13.10  0.03 2 1 2; 
Spring_Panel 902100 402109 402110 $E $Fy [expr  0.96 +  0.00] 26.00 30.20  1.73 13.10  0.03 2 1 2; Spring_Panel 902200 402209 402210 $E $Fy [expr  1.16 +  0.06] 26.70 30.20  2.09 13.30  0.03 2 1 2; Spring_Panel 902300 402309 402310 $E $Fy [expr  1.16 +  0.06] 26.70 30.20  2.09 13.30  0.03 2 1 2; Spring_Panel 902400 402409 402410 $E $Fy [expr  0.96 +  0.00] 26.00 30.20  1.73 13.10  0.03 2 1 2; 

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
element ModElasticBeam2d 612100 1213 1311  24.7000 $E [expr ($n+1)/$n*2370.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 612200 1223 1321  27.7000 $E [expr ($n+1)/$n*2700.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 612300 1233 1331  27.7000 $E [expr ($n+1)/$n*2700.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 612400 1243 1341  24.7000 $E [expr ($n+1)/$n*2370.0000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 611102 111170 1211 24.7000 $E [expr ($n+1)/$n*2370.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 611202 111270 1221 27.7000 $E [expr ($n+1)/$n*2700.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 611302 111370 1231 27.7000 $E [expr ($n+1)/$n*2700.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 611402 111470 1241 24.7000 $E [expr ($n+1)/$n*2370.0000] $K33_1 $K11_1 $K44_1 1;  
element ModElasticBeam2d 611101 1113 111170 38.5000 $E [expr ($n+1)/$n*4020.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 611201 1123 111270 38.5000 $E [expr ($n+1)/$n*4020.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 611301 1133 111370 38.5000 $E [expr ($n+1)/$n*4020.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 611401 1143 111470 38.5000 $E [expr ($n+1)/$n*4020.0000] $K33_1 $K11_1 $K44_1 1;  
element ModElasticBeam2d 610100 1013 1111  38.5000 $E [expr ($n+1)/$n*4020.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 610200 1023 1121  38.5000 $E [expr ($n+1)/$n*4020.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 610300 1033 1131  38.5000 $E [expr ($n+1)/$n*4020.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 610400 1043 1141  38.5000 $E [expr ($n+1)/$n*4020.0000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 609102 109170 1011 38.5000 $E [expr ($n+1)/$n*4020.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 609202 109270 1021 38.5000 $E [expr ($n+1)/$n*4020.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 609302 109370 1031 38.5000 $E [expr ($n+1)/$n*4020.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 609402 109470 1041 38.5000 $E [expr ($n+1)/$n*4020.0000] $K33_1 $K11_1 $K44_1 1;  
element ModElasticBeam2d 609101 913 109170 38.5000 $E [expr ($n+1)/$n*4020.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 609201 923 109270 51.7000 $E [expr ($n+1)/$n*5680.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 609301 933 109370 51.7000 $E [expr ($n+1)/$n*5680.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 609401 943 109470 38.5000 $E [expr ($n+1)/$n*4020.0000] $K33_1 $K11_1 $K44_1 1;  
element ModElasticBeam2d 608100 813 911  38.5000 $E [expr ($n+1)/$n*4020.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 608200 823 921  51.7000 $E [expr ($n+1)/$n*5680.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 608300 833 931  51.7000 $E [expr ($n+1)/$n*5680.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 608400 843 941  38.5000 $E [expr ($n+1)/$n*4020.0000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 607102 107170 811 38.5000 $E [expr ($n+1)/$n*4020.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 607202 107270 821 51.7000 $E [expr ($n+1)/$n*5680.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 607302 107370 831 51.7000 $E [expr ($n+1)/$n*5680.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 607402 107470 841 38.5000 $E [expr ($n+1)/$n*4020.0000] $K33_1 $K11_1 $K44_1 1;  
element ModElasticBeam2d 607101 713 107170 47.7000 $E [expr ($n+1)/$n*5170.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 607201 723 107270 60.7000 $E [expr ($n+1)/$n*6820.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 607301 733 107370 60.7000 $E [expr ($n+1)/$n*6820.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 607401 743 107470 47.7000 $E [expr ($n+1)/$n*5170.0000] $K33_1 $K11_1 $K44_1 1;  
element ModElasticBeam2d 606100 613 711  47.7000 $E [expr ($n+1)/$n*5170.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 606200 623 721  60.7000 $E [expr ($n+1)/$n*6820.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 606300 633 731  60.7000 $E [expr ($n+1)/$n*6820.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 606400 643 741  47.7000 $E [expr ($n+1)/$n*5170.0000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 605102 105170 611 47.7000 $E [expr ($n+1)/$n*5170.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 605202 105270 621 60.7000 $E [expr ($n+1)/$n*6820.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 605302 105370 631 60.7000 $E [expr ($n+1)/$n*6820.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 605402 105470 641 47.7000 $E [expr ($n+1)/$n*5170.0000] $K33_1 $K11_1 $K44_1 1;  
element ModElasticBeam2d 605101 513 105170 56.3000 $E [expr ($n+1)/$n*6260.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 605201 523 105270 73.5000 $E [expr ($n+1)/$n*8490.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 605301 533 105370 73.5000 $E [expr ($n+1)/$n*8490.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 605401 543 105470 56.3000 $E [expr ($n+1)/$n*6260.0000] $K33_1 $K11_1 $K44_1 1;  
element ModElasticBeam2d 604100 413 511  56.3000 $E [expr ($n+1)/$n*6260.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 604200 423 521  73.5000 $E [expr ($n+1)/$n*8490.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 604300 433 531  73.5000 $E [expr ($n+1)/$n*8490.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 604400 443 541  56.3000 $E [expr ($n+1)/$n*6260.0000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 603102 103170 411 56.3000 $E [expr ($n+1)/$n*6260.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 603202 103270 421 73.5000 $E [expr ($n+1)/$n*8490.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 603302 103370 431 73.5000 $E [expr ($n+1)/$n*8490.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 603402 103470 441 56.3000 $E [expr ($n+1)/$n*6260.0000] $K33_1 $K11_1 $K44_1 1;  
element ModElasticBeam2d 603101 313 103170 67.2000 $E [expr ($n+1)/$n*7650.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 603201 323 103270 82.0000 $E [expr ($n+1)/$n*9600.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 603301 333 103370 82.0000 $E [expr ($n+1)/$n*9600.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 603401 343 103470 67.2000 $E [expr ($n+1)/$n*7650.0000] $K33_1 $K11_1 $K44_1 1;  
element ModElasticBeam2d 602100 213 311  67.2000 $E [expr ($n+1)/$n*7650.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 602200 223 321  82.0000 $E [expr ($n+1)/$n*9600.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 602300 233 331  82.0000 $E [expr ($n+1)/$n*9600.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 602400 243 341  67.2000 $E [expr ($n+1)/$n*7650.0000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 601100 113 211  67.2000 $E [expr ($n+1)/$n*7650.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 601200 123 221  82.0000 $E [expr ($n+1)/$n*9600.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 601300 133 231  82.0000 $E [expr ($n+1)/$n*9600.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 601400 143 241  67.2000 $E [expr ($n+1)/$n*7650.0000] $K11_2 $K33_2 $K44_2 1; 

# BEAMS
element ModElasticBeam2d 513100 1314 1322  24.700 $E [expr ($n+1)/$n*0.90*$Comp_I*2370.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 513200 1324 1332  24.700 $E [expr ($n+1)/$n*0.90*$Comp_I*2370.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 513300 1334 1342  24.700 $E [expr ($n+1)/$n*0.90*$Comp_I*2370.000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 512100 1214 1222  24.700 $E [expr ($n+1)/$n*0.90*$Comp_I*2370.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 512200 1224 1232  24.700 $E [expr ($n+1)/$n*0.90*$Comp_I*2370.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 512300 1234 1242  24.700 $E [expr ($n+1)/$n*0.90*$Comp_I*2370.000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 511100 1114 1122  27.700 $E [expr ($n+1)/$n*0.90*$Comp_I*3270.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 511200 1124 1132  27.700 $E [expr ($n+1)/$n*0.90*$Comp_I*3270.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 511300 1134 1142  27.700 $E [expr ($n+1)/$n*0.90*$Comp_I*3270.000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 510100 1014 1022  27.700 $E [expr ($n+1)/$n*0.90*$Comp_I*3270.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 510200 1024 1032  27.700 $E [expr ($n+1)/$n*0.90*$Comp_I*3270.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 510300 1034 1042  27.700 $E [expr ($n+1)/$n*0.90*$Comp_I*3270.000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 509100 914 922  34.200 $E [expr ($n+1)/$n*0.90*$Comp_I*4930.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 509200 924 932  34.200 $E [expr ($n+1)/$n*0.90*$Comp_I*4930.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 509300 934 942  34.200 $E [expr ($n+1)/$n*0.90*$Comp_I*4930.000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 508100 814 822  34.200 $E [expr ($n+1)/$n*0.90*$Comp_I*4930.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 508200 824 832  34.200 $E [expr ($n+1)/$n*0.90*$Comp_I*4930.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 508300 834 842  34.200 $E [expr ($n+1)/$n*0.90*$Comp_I*4930.000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 507100 714 722  34.200 $E [expr ($n+1)/$n*0.90*$Comp_I*4930.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 507200 724 732  34.200 $E [expr ($n+1)/$n*0.90*$Comp_I*4930.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 507300 734 742  34.200 $E [expr ($n+1)/$n*0.90*$Comp_I*4930.000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 506100 614 622  34.200 $E [expr ($n+1)/$n*0.90*$Comp_I*4930.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 506200 624 632  34.200 $E [expr ($n+1)/$n*0.90*$Comp_I*4930.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 506300 634 642  34.200 $E [expr ($n+1)/$n*0.90*$Comp_I*4930.000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 505100 514 522  38.900 $E [expr ($n+1)/$n*0.90*$Comp_I*5770.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 505200 524 532  38.900 $E [expr ($n+1)/$n*0.90*$Comp_I*5770.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 505300 534 542  38.900 $E [expr ($n+1)/$n*0.90*$Comp_I*5770.000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 504100 414 422  38.900 $E [expr ($n+1)/$n*0.90*$Comp_I*5770.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 504200 424 432  38.900 $E [expr ($n+1)/$n*0.90*$Comp_I*5770.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 504300 434 442  38.900 $E [expr ($n+1)/$n*0.90*$Comp_I*5770.000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 503100 314 322  38.900 $E [expr ($n+1)/$n*0.90*$Comp_I*5770.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 503200 324 332  38.900 $E [expr ($n+1)/$n*0.90*$Comp_I*5770.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 503300 334 342  38.900 $E [expr ($n+1)/$n*0.90*$Comp_I*5770.000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 502100 214 222  36.500 $E [expr ($n+1)/$n*0.90*$Comp_I*5360.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 502200 224 232  36.500 $E [expr ($n+1)/$n*0.90*$Comp_I*5360.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 502300 234 242  36.500 $E [expr ($n+1)/$n*0.90*$Comp_I*5360.000] $K11_2 $K33_2 $K44_2 1; 

####################################################################################################
#                                      ELASTIC RBS ELEMENTS                                        #
####################################################################################################

element elasticBeamColumn 513104 413104 13140 21.227 $E [expr 1.0*1897.290] 1; element elasticBeamColumn 513202 413202 13220 21.227 $E [expr 1.0*1897.290] 1; element elasticBeamColumn 513204 413204 13240 21.227 $E [expr 1.0*1897.290] 1; element elasticBeamColumn 513302 413302 13320 21.227 $E [expr 1.0*1897.290] 1; element elasticBeamColumn 513304 413304 13340 21.227 $E [expr 1.0*1897.290] 1; element elasticBeamColumn 513402 413402 13420 21.227 $E [expr 1.0*1897.290] 1; 
element elasticBeamColumn 512104 412104 12140 21.227 $E [expr 1.0*1897.290] 1; element elasticBeamColumn 512202 412202 12220 21.227 $E [expr 1.0*1897.290] 1; element elasticBeamColumn 512204 412204 12240 21.227 $E [expr 1.0*1897.290] 1; element elasticBeamColumn 512302 412302 12320 21.227 $E [expr 1.0*1897.290] 1; element elasticBeamColumn 512304 412304 12340 21.227 $E [expr 1.0*1897.290] 1; element elasticBeamColumn 512402 412402 12420 21.227 $E [expr 1.0*1897.290] 1; 
element elasticBeamColumn 511104 411104 11140 23.979 $E [expr 1.0*2633.412] 1; element elasticBeamColumn 511202 411202 11220 23.979 $E [expr 1.0*2633.412] 1; element elasticBeamColumn 511204 411204 11240 23.979 $E [expr 1.0*2633.412] 1; element elasticBeamColumn 511302 411302 11320 23.979 $E [expr 1.0*2633.412] 1; element elasticBeamColumn 511304 411304 11340 23.979 $E [expr 1.0*2633.412] 1; element elasticBeamColumn 511402 411402 11420 23.979 $E [expr 1.0*2633.412] 1; 
element elasticBeamColumn 510104 410104 10140 23.979 $E [expr 1.0*2633.412] 1; element elasticBeamColumn 510202 410202 10220 23.979 $E [expr 1.0*2633.412] 1; element elasticBeamColumn 510204 410204 10240 23.979 $E [expr 1.0*2633.412] 1; element elasticBeamColumn 510302 410302 10320 23.979 $E [expr 1.0*2633.412] 1; element elasticBeamColumn 510304 410304 10340 23.979 $E [expr 1.0*2633.412] 1; element elasticBeamColumn 510402 410402 10420 23.979 $E [expr 1.0*2633.412] 1; 
element elasticBeamColumn 509104 409104 9140 29.738 $E [expr 1.0*3981.760] 1; element elasticBeamColumn 509202 409202 9220 29.738 $E [expr 1.0*3981.760] 1; element elasticBeamColumn 509204 409204 9240 29.738 $E [expr 1.0*3981.760] 1; element elasticBeamColumn 509302 409302 9320 29.738 $E [expr 1.0*3981.760] 1; element elasticBeamColumn 509304 409304 9340 29.738 $E [expr 1.0*3981.760] 1; element elasticBeamColumn 509402 409402 9420 29.738 $E [expr 1.0*3981.760] 1; 
element elasticBeamColumn 508104 408104 8140 29.738 $E [expr 1.0*3981.760] 1; element elasticBeamColumn 508202 408202 8220 29.738 $E [expr 1.0*3981.760] 1; element elasticBeamColumn 508204 408204 8240 29.738 $E [expr 1.0*3981.760] 1; element elasticBeamColumn 508302 408302 8320 29.738 $E [expr 1.0*3981.760] 1; element elasticBeamColumn 508304 408304 8340 29.738 $E [expr 1.0*3981.760] 1; element elasticBeamColumn 508402 408402 8420 29.738 $E [expr 1.0*3981.760] 1; 
element elasticBeamColumn 507104 407104 7140 29.738 $E [expr 1.0*3981.760] 1; element elasticBeamColumn 507202 407202 7220 29.738 $E [expr 1.0*3981.760] 1; element elasticBeamColumn 507204 407204 7240 29.738 $E [expr 1.0*3981.760] 1; element elasticBeamColumn 507302 407302 7320 29.738 $E [expr 1.0*3981.760] 1; element elasticBeamColumn 507304 407304 7340 29.738 $E [expr 1.0*3981.760] 1; element elasticBeamColumn 507402 407402 7420 29.738 $E [expr 1.0*3981.760] 1; 
element elasticBeamColumn 506104 406104 6140 29.738 $E [expr 1.0*3981.760] 1; element elasticBeamColumn 506202 406202 6220 29.738 $E [expr 1.0*3981.760] 1; element elasticBeamColumn 506204 406204 6240 29.738 $E [expr 1.0*3981.760] 1; element elasticBeamColumn 506302 406302 6320 29.738 $E [expr 1.0*3981.760] 1; element elasticBeamColumn 506304 406304 6340 29.738 $E [expr 1.0*3981.760] 1; element elasticBeamColumn 506402 406402 6420 29.738 $E [expr 1.0*3981.760] 1; 
element elasticBeamColumn 505104 405104 5140 33.650 $E [expr 1.0*4642.794] 1; element elasticBeamColumn 505202 405202 5220 33.650 $E [expr 1.0*4642.794] 1; element elasticBeamColumn 505204 405204 5240 33.650 $E [expr 1.0*4642.794] 1; element elasticBeamColumn 505302 405302 5320 33.650 $E [expr 1.0*4642.794] 1; element elasticBeamColumn 505304 405304 5340 33.650 $E [expr 1.0*4642.794] 1; element elasticBeamColumn 505402 405402 5420 33.650 $E [expr 1.0*4642.794] 1; 
element elasticBeamColumn 504104 404104 4140 33.650 $E [expr 1.0*4642.794] 1; element elasticBeamColumn 504202 404202 4220 33.650 $E [expr 1.0*4642.794] 1; element elasticBeamColumn 504204 404204 4240 33.650 $E [expr 1.0*4642.794] 1; element elasticBeamColumn 504302 404302 4320 33.650 $E [expr 1.0*4642.794] 1; element elasticBeamColumn 504304 404304 4340 33.650 $E [expr 1.0*4642.794] 1; element elasticBeamColumn 504402 404402 4420 33.650 $E [expr 1.0*4642.794] 1; 
element elasticBeamColumn 503104 403104 3140 33.650 $E [expr 1.0*4642.794] 1; element elasticBeamColumn 503202 403202 3220 33.650 $E [expr 1.0*4642.794] 1; element elasticBeamColumn 503204 403204 3240 33.650 $E [expr 1.0*4642.794] 1; element elasticBeamColumn 503302 403302 3320 33.650 $E [expr 1.0*4642.794] 1; element elasticBeamColumn 503304 403304 3340 33.650 $E [expr 1.0*4642.794] 1; element elasticBeamColumn 503402 403402 3420 33.650 $E [expr 1.0*4642.794] 1; 
element elasticBeamColumn 502104 402104 2140 31.617 $E [expr 1.0*4313.898] 1; element elasticBeamColumn 502202 402202 2220 31.617 $E [expr 1.0*4313.898] 1; element elasticBeamColumn 502204 402204 2240 31.617 $E [expr 1.0*4313.898] 1; element elasticBeamColumn 502302 402302 2320 31.617 $E [expr 1.0*4313.898] 1; element elasticBeamColumn 502304 402304 2340 31.617 $E [expr 1.0*4313.898] 1; element elasticBeamColumn 502402 402402 2420 31.617 $E [expr 1.0*4313.898] 1; 

###################################################################################################
#                                 COLUMN AND BEAM PLASTIC SPRINGS                                 #
###################################################################################################

# Command Syntax; 
# Spring_IMK SpringID iNode jNode E Fy Ix d tw bf tf htw bftf ry L Ls Lb My PgPye CompositeFLAG MRFconnection Units; 

# BEAM SPRINGS
Spring_IMK 913104 1314  13140 $E $Fy [expr $Comp_I*1424.581] 24.100 0.470 9.020 0.770 45.900 5.860 1.950 186.450 107.900 93.225 10970.416 0.0 $Composite 0 2; Spring_IMK 913202 13220 1322  $E $Fy [expr $Comp_I*1424.581] 24.100 0.470 9.020 0.770 45.900 5.860 1.950 186.450 107.900 93.225 10970.416 0.0 $Composite 0 2; Spring_IMK 913204 1324  13240 $E $Fy [expr $Comp_I*1424.581] 24.100 0.470 9.020 0.770 45.900 5.860 1.950 186.450 107.900 93.225 10970.416 0.0 $Composite 0 2; Spring_IMK 913302 13320 1332  $E $Fy [expr $Comp_I*1424.581] 24.100 0.470 9.020 0.770 45.900 5.860 1.950 186.350 107.850 93.175 10970.416 0.0 $Composite 0 2; Spring_IMK 913304 1334  13340 $E $Fy [expr $Comp_I*1424.581] 24.100 0.470 9.020 0.770 45.900 5.860 1.950 186.350 107.850 93.175 10970.416 0.0 $Composite 0 2; Spring_IMK 913402 13420 1342  $E $Fy [expr $Comp_I*1424.581] 24.100 0.470 9.020 0.770 45.900 5.860 1.950 186.450 107.900 93.225 10970.416 0.0 $Composite 0 2; 
Spring_IMK 912104 1214  12140 $E $Fy [expr $Comp_I*1424.581] 24.100 0.470 9.020 0.770 45.900 5.860 1.950 186.150 107.750 93.075 10970.416 0.0 $Composite 0 2; Spring_IMK 912202 12220 1222  $E $Fy [expr $Comp_I*1424.581] 24.100 0.470 9.020 0.770 45.900 5.860 1.950 186.150 107.750 93.075 10970.416 0.0 $Composite 0 2; Spring_IMK 912204 1224  12240 $E $Fy [expr $Comp_I*1424.581] 24.100 0.470 9.020 0.770 45.900 5.860 1.950 186.150 107.750 93.075 10970.416 0.0 $Composite 0 2; Spring_IMK 912302 12320 1232  $E $Fy [expr $Comp_I*1424.581] 24.100 0.470 9.020 0.770 45.900 5.860 1.950 186.150 107.750 93.075 10970.416 0.0 $Composite 0 2; Spring_IMK 912304 1234  12340 $E $Fy [expr $Comp_I*1424.581] 24.100 0.470 9.020 0.770 45.900 5.860 1.950 186.150 107.750 93.075 10970.416 0.0 $Composite 0 2; Spring_IMK 912402 12420 1242  $E $Fy [expr $Comp_I*1424.581] 24.100 0.470 9.020 0.770 45.900 5.860 1.950 186.150 107.750 93.075 10970.416 0.0 $Composite 0 2; 
Spring_IMK 911104 1114  11140 $E $Fy [expr $Comp_I*1996.823] 26.900 0.490 9.990 0.745 49.500 6.700 2.120 182.838 107.750 91.419 13617.900 0.0 $Composite 0 2; Spring_IMK 911202 11220 1122  $E $Fy [expr $Comp_I*1996.823] 26.900 0.490 9.990 0.745 49.500 6.700 2.120 182.838 107.750 91.419 13617.900 0.0 $Composite 0 2; Spring_IMK 911204 1124  11240 $E $Fy [expr $Comp_I*1996.823] 26.900 0.490 9.990 0.745 49.500 6.700 2.120 182.838 107.750 91.419 13617.900 0.0 $Composite 0 2; Spring_IMK 911302 11320 1132  $E $Fy [expr $Comp_I*1996.823] 26.900 0.490 9.990 0.745 49.500 6.700 2.120 182.838 107.750 91.419 13617.900 0.0 $Composite 0 2; Spring_IMK 911304 1134  11340 $E $Fy [expr $Comp_I*1996.823] 26.900 0.490 9.990 0.745 49.500 6.700 2.120 182.838 107.750 91.419 13617.900 0.0 $Composite 0 2; Spring_IMK 911402 11420 1142  $E $Fy [expr $Comp_I*1996.823] 26.900 0.490 9.990 0.745 49.500 6.700 2.120 182.838 107.750 91.419 13617.900 0.0 $Composite 0 2; 
Spring_IMK 910104 1014  10140 $E $Fy [expr $Comp_I*1996.823] 26.900 0.490 9.990 0.745 49.500 6.700 2.120 182.488 107.575 91.244 13617.900 0.0 $Composite 0 2; Spring_IMK 910202 10220 1022  $E $Fy [expr $Comp_I*1996.823] 26.900 0.490 9.990 0.745 49.500 6.700 2.120 182.488 107.575 91.244 13617.900 0.0 $Composite 0 2; Spring_IMK 910204 1024  10240 $E $Fy [expr $Comp_I*1996.823] 26.900 0.490 9.990 0.745 49.500 6.700 2.120 182.488 107.575 91.244 13617.900 0.0 $Composite 0 2; Spring_IMK 910302 10320 1032  $E $Fy [expr $Comp_I*1996.823] 26.900 0.490 9.990 0.745 49.500 6.700 2.120 182.138 107.400 91.069 13617.900 0.0 $Composite 0 2; Spring_IMK 910304 1034  10340 $E $Fy [expr $Comp_I*1996.823] 26.900 0.490 9.990 0.745 49.500 6.700 2.120 182.138 107.400 91.069 13617.900 0.0 $Composite 0 2; Spring_IMK 910402 10420 1042  $E $Fy [expr $Comp_I*1996.823] 26.900 0.490 9.990 0.745 49.500 6.700 2.120 182.488 107.575 91.244 13617.900 0.0 $Composite 0 2; 
Spring_IMK 909104 914  9140 $E $Fy [expr $Comp_I*3033.519] 30.000 0.565 10.500 0.850 47.800 6.170 2.190 179.525 107.575 89.763 18649.036 0.0 $Composite 0 2; Spring_IMK 909202 9220 922  $E $Fy [expr $Comp_I*3033.519] 30.000 0.565 10.500 0.850 47.800 6.170 2.190 179.525 107.575 89.763 18649.036 0.0 $Composite 0 2; Spring_IMK 909204 924  9240 $E $Fy [expr $Comp_I*3033.519] 30.000 0.565 10.500 0.850 47.800 6.170 2.190 179.525 107.575 89.763 18649.036 0.0 $Composite 0 2; Spring_IMK 909302 9320 932  $E $Fy [expr $Comp_I*3033.519] 30.000 0.565 10.500 0.850 47.800 6.170 2.190 179.175 107.400 89.588 18649.036 0.0 $Composite 0 2; Spring_IMK 909304 934  9340 $E $Fy [expr $Comp_I*3033.519] 30.000 0.565 10.500 0.850 47.800 6.170 2.190 179.175 107.400 89.588 18649.036 0.0 $Composite 0 2; Spring_IMK 909402 9420 942  $E $Fy [expr $Comp_I*3033.519] 30.000 0.565 10.500 0.850 47.800 6.170 2.190 179.525 107.575 89.763 18649.036 0.0 $Composite 0 2; 
Spring_IMK 908104 814  8140 $E $Fy [expr $Comp_I*3033.519] 30.000 0.565 10.500 0.850 47.800 6.170 2.190 179.025 107.325 89.513 18649.036 0.0 $Composite 0 2; Spring_IMK 908202 8220 822  $E $Fy [expr $Comp_I*3033.519] 30.000 0.565 10.500 0.850 47.800 6.170 2.190 179.025 107.325 89.513 18649.036 0.0 $Composite 0 2; Spring_IMK 908204 824  8240 $E $Fy [expr $Comp_I*3033.519] 30.000 0.565 10.500 0.850 47.800 6.170 2.190 179.025 107.325 89.513 18649.036 0.0 $Composite 0 2; Spring_IMK 908302 8320 832  $E $Fy [expr $Comp_I*3033.519] 30.000 0.565 10.500 0.850 47.800 6.170 2.190 178.675 107.150 89.338 18649.036 0.0 $Composite 0 2; Spring_IMK 908304 834  8340 $E $Fy [expr $Comp_I*3033.519] 30.000 0.565 10.500 0.850 47.800 6.170 2.190 178.675 107.150 89.338 18649.036 0.0 $Composite 0 2; Spring_IMK 908402 8420 842  $E $Fy [expr $Comp_I*3033.519] 30.000 0.565 10.500 0.850 47.800 6.170 2.190 179.025 107.325 89.513 18649.036 0.0 $Composite 0 2; 
Spring_IMK 907104 714  7140 $E $Fy [expr $Comp_I*3033.519] 30.000 0.565 10.500 0.850 47.800 6.170 2.190 179.025 107.325 89.513 18649.036 0.0 $Composite 0 2; Spring_IMK 907202 7220 722  $E $Fy [expr $Comp_I*3033.519] 30.000 0.565 10.500 0.850 47.800 6.170 2.190 179.025 107.325 89.513 18649.036 0.0 $Composite 0 2; Spring_IMK 907204 724  7240 $E $Fy [expr $Comp_I*3033.519] 30.000 0.565 10.500 0.850 47.800 6.170 2.190 179.025 107.325 89.513 18649.036 0.0 $Composite 0 2; Spring_IMK 907302 7320 732  $E $Fy [expr $Comp_I*3033.519] 30.000 0.565 10.500 0.850 47.800 6.170 2.190 178.675 107.150 89.338 18649.036 0.0 $Composite 0 2; Spring_IMK 907304 734  7340 $E $Fy [expr $Comp_I*3033.519] 30.000 0.565 10.500 0.850 47.800 6.170 2.190 178.675 107.150 89.338 18649.036 0.0 $Composite 0 2; Spring_IMK 907402 7420 742  $E $Fy [expr $Comp_I*3033.519] 30.000 0.565 10.500 0.850 47.800 6.170 2.190 179.025 107.325 89.513 18649.036 0.0 $Composite 0 2; 
Spring_IMK 906104 614  6140 $E $Fy [expr $Comp_I*3033.519] 30.000 0.565 10.500 0.850 47.800 6.170 2.190 178.475 107.050 89.237 18649.036 0.0 $Composite 0 2; Spring_IMK 906202 6220 622  $E $Fy [expr $Comp_I*3033.519] 30.000 0.565 10.500 0.850 47.800 6.170 2.190 178.475 107.050 89.237 18649.036 0.0 $Composite 0 2; Spring_IMK 906204 624  6240 $E $Fy [expr $Comp_I*3033.519] 30.000 0.565 10.500 0.850 47.800 6.170 2.190 178.475 107.050 89.237 18649.036 0.0 $Composite 0 2; Spring_IMK 906302 6320 632  $E $Fy [expr $Comp_I*3033.519] 30.000 0.565 10.500 0.850 47.800 6.170 2.190 178.075 106.850 89.037 18649.036 0.0 $Composite 0 2; Spring_IMK 906304 634  6340 $E $Fy [expr $Comp_I*3033.519] 30.000 0.565 10.500 0.850 47.800 6.170 2.190 178.075 106.850 89.037 18649.036 0.0 $Composite 0 2; Spring_IMK 906402 6420 642  $E $Fy [expr $Comp_I*3033.519] 30.000 0.565 10.500 0.850 47.800 6.170 2.190 178.475 107.050 89.237 18649.036 0.0 $Composite 0 2; 
Spring_IMK 905104 514  5140 $E $Fy [expr $Comp_I*3515.589] 30.300 0.615 10.500 1.000 43.900 5.270 2.250 178.250 107.050 89.125 21409.397 0.0 $Composite 0 2; Spring_IMK 905202 5220 522  $E $Fy [expr $Comp_I*3515.589] 30.300 0.615 10.500 1.000 43.900 5.270 2.250 178.250 107.050 89.125 21409.397 0.0 $Composite 0 2; Spring_IMK 905204 524  5240 $E $Fy [expr $Comp_I*3515.589] 30.300 0.615 10.500 1.000 43.900 5.270 2.250 178.250 107.050 89.125 21409.397 0.0 $Composite 0 2; Spring_IMK 905302 5320 532  $E $Fy [expr $Comp_I*3515.589] 30.300 0.615 10.500 1.000 43.900 5.270 2.250 177.850 106.850 88.925 21409.397 0.0 $Composite 0 2; Spring_IMK 905304 534  5340 $E $Fy [expr $Comp_I*3515.589] 30.300 0.615 10.500 1.000 43.900 5.270 2.250 177.850 106.850 88.925 21409.397 0.0 $Composite 0 2; Spring_IMK 905402 5420 542  $E $Fy [expr $Comp_I*3515.589] 30.300 0.615 10.500 1.000 43.900 5.270 2.250 178.250 107.050 89.125 21409.397 0.0 $Composite 0 2; 
Spring_IMK 904104 414  4140 $E $Fy [expr $Comp_I*3515.589] 30.300 0.615 10.500 1.000 43.900 5.270 2.250 177.800 106.825 88.900 21409.397 0.0 $Composite 0 2; Spring_IMK 904202 4220 422  $E $Fy [expr $Comp_I*3515.589] 30.300 0.615 10.500 1.000 43.900 5.270 2.250 177.800 106.825 88.900 21409.397 0.0 $Composite 0 2; Spring_IMK 904204 424  4240 $E $Fy [expr $Comp_I*3515.589] 30.300 0.615 10.500 1.000 43.900 5.270 2.250 177.800 106.825 88.900 21409.397 0.0 $Composite 0 2; Spring_IMK 904302 4320 432  $E $Fy [expr $Comp_I*3515.589] 30.300 0.615 10.500 1.000 43.900 5.270 2.250 177.450 106.650 88.725 21409.397 0.0 $Composite 0 2; Spring_IMK 904304 434  4340 $E $Fy [expr $Comp_I*3515.589] 30.300 0.615 10.500 1.000 43.900 5.270 2.250 177.450 106.650 88.725 21409.397 0.0 $Composite 0 2; Spring_IMK 904402 4420 442  $E $Fy [expr $Comp_I*3515.589] 30.300 0.615 10.500 1.000 43.900 5.270 2.250 177.800 106.825 88.900 21409.397 0.0 $Composite 0 2; 
Spring_IMK 903104 314  3140 $E $Fy [expr $Comp_I*3515.589] 30.300 0.615 10.500 1.000 43.900 5.270 2.250 177.800 106.825 88.900 21409.397 0.0 $Composite 0 2; Spring_IMK 903202 3220 322  $E $Fy [expr $Comp_I*3515.589] 30.300 0.615 10.500 1.000 43.900 5.270 2.250 177.800 106.825 88.900 21409.397 0.0 $Composite 0 2; Spring_IMK 903204 324  3240 $E $Fy [expr $Comp_I*3515.589] 30.300 0.615 10.500 1.000 43.900 5.270 2.250 177.800 106.825 88.900 21409.397 0.0 $Composite 0 2; Spring_IMK 903302 3320 332  $E $Fy [expr $Comp_I*3515.589] 30.300 0.615 10.500 1.000 43.900 5.270 2.250 177.450 106.650 88.725 21409.397 0.0 $Composite 0 2; Spring_IMK 903304 334  3340 $E $Fy [expr $Comp_I*3515.589] 30.300 0.615 10.500 1.000 43.900 5.270 2.250 177.450 106.650 88.725 21409.397 0.0 $Composite 0 2; Spring_IMK 903402 3420 342  $E $Fy [expr $Comp_I*3515.589] 30.300 0.615 10.500 1.000 43.900 5.270 2.250 177.800 106.825 88.900 21409.397 0.0 $Composite 0 2; 
Spring_IMK 902104 214  2140 $E $Fy [expr $Comp_I*3267.797] 30.200 0.585 10.500 0.930 46.200 5.650 2.230 177.875 106.825 88.938 20075.574 0.0 $Composite 0 2; Spring_IMK 902202 2220 222  $E $Fy [expr $Comp_I*3267.797] 30.200 0.585 10.500 0.930 46.200 5.650 2.230 177.875 106.825 88.938 20075.574 0.0 $Composite 0 2; Spring_IMK 902204 224  2240 $E $Fy [expr $Comp_I*3267.797] 30.200 0.585 10.500 0.930 46.200 5.650 2.230 177.875 106.825 88.938 20075.574 0.0 $Composite 0 2; Spring_IMK 902302 2320 232  $E $Fy [expr $Comp_I*3267.797] 30.200 0.585 10.500 0.930 46.200 5.650 2.230 177.525 106.650 88.763 20075.574 0.0 $Composite 0 2; Spring_IMK 902304 234  2340 $E $Fy [expr $Comp_I*3267.797] 30.200 0.585 10.500 0.930 46.200 5.650 2.230 177.525 106.650 88.763 20075.574 0.0 $Composite 0 2; Spring_IMK 902402 2420 242  $E $Fy [expr $Comp_I*3267.797] 30.200 0.585 10.500 0.930 46.200 5.650 2.230 177.875 106.825 88.938 20075.574 0.0 $Composite 0 2; 

# Column Springs
Spring_IMK 913101 1311 413101 $E $Fy 2370.000 24.100 0.470 9.020 0.770 45.900 5.860 1.950 131.900 65.950 131.900 13552.000 0.026 0 2 2; Spring_IMK 913201 1321 413201 $E $Fy 2700.000 24.300 0.515 9.070 0.875 41.900 5.180 1.980 131.900 65.950 131.900 15367.000 0.015 0 2 2; Spring_IMK 913301 1331 413301 $E $Fy 2700.000 24.300 0.515 9.070 0.875 41.900 5.180 1.980 131.900 65.950 131.900 15367.000 0.015 0 2 2; Spring_IMK 913401 1341 413401 $E $Fy 2370.000 24.100 0.470 9.020 0.770 45.900 5.860 1.950 131.900 65.950 131.900 13552.000 0.026 0 2 2; 
Spring_IMK 912103 1213 412103 $E $Fy 2370.000 24.100 0.470 9.020 0.770 45.900 5.860 1.950 131.900 65.950 131.900 13552.000 0.026 0 2 2; Spring_IMK 912203 1223 412203 $E $Fy 2700.000 24.300 0.515 9.070 0.875 41.900 5.180 1.980 131.900 65.950 131.900 15367.000 0.015 0 2 2; Spring_IMK 912303 1233 412303 $E $Fy 2700.000 24.300 0.515 9.070 0.875 41.900 5.180 1.980 131.900 65.950 131.900 15367.000 0.015 0 2 2; Spring_IMK 912403 1243 412403 $E $Fy 2370.000 24.100 0.470 9.020 0.770 45.900 5.860 1.950 131.900 65.950 131.900 13552.000 0.026 0 2 2; 
Spring_IMK 912101 1211 412101 $E $Fy 2370.000 24.100 0.470 9.020 0.770 45.900 5.860 1.950 131.900 65.950 131.900 13552.000 0.026 0 2 2; Spring_IMK 912201 1221 412201 $E $Fy 2700.000 24.300 0.515 9.070 0.875 41.900 5.180 1.980 131.900 65.950 131.900 15367.000 0.015 0 2 2; Spring_IMK 912301 1231 412301 $E $Fy 2700.000 24.300 0.515 9.070 0.875 41.900 5.180 1.980 131.900 65.950 131.900 15367.000 0.015 0 2 2; Spring_IMK 912401 1241 412401 $E $Fy 2370.000 24.100 0.470 9.020 0.770 45.900 5.860 1.950 131.900 65.950 131.900 13552.000 0.026 0 2 2; 
Spring_IMK 911103 1113 411103 $E $Fy 4020.000 24.500 0.605 12.900 0.960 35.600 6.700 2.970 130.500 65.250 130.500 22385.000 0.037 0 2 2; Spring_IMK 911203 1123 411203 $E $Fy 4020.000 24.500 0.605 12.900 0.960 35.600 6.700 2.970 130.500 65.250 130.500 22385.000 0.024 0 2 2; Spring_IMK 911303 1133 411303 $E $Fy 4020.000 24.500 0.605 12.900 0.960 35.600 6.700 2.970 130.500 65.250 130.500 22385.000 0.024 0 2 2; Spring_IMK 911403 1143 411403 $E $Fy 4020.000 24.500 0.605 12.900 0.960 35.600 6.700 2.970 130.500 65.250 130.500 22385.000 0.037 0 2 2; 
Spring_IMK 911101 1111 411101 $E $Fy 4020.000 24.500 0.605 12.900 0.960 35.600 6.700 2.970 129.100 64.550 129.100 22385.000 0.037 0 2 2; Spring_IMK 911201 1121 411201 $E $Fy 4020.000 24.500 0.605 12.900 0.960 35.600 6.700 2.970 129.100 64.550 129.100 22385.000 0.024 0 2 2; Spring_IMK 911301 1131 411301 $E $Fy 4020.000 24.500 0.605 12.900 0.960 35.600 6.700 2.970 129.100 64.550 129.100 22385.000 0.024 0 2 2; Spring_IMK 911401 1141 411401 $E $Fy 4020.000 24.500 0.605 12.900 0.960 35.600 6.700 2.970 129.100 64.550 129.100 22385.000 0.037 0 2 2; 
Spring_IMK 910103 1013 410103 $E $Fy 4020.000 24.500 0.605 12.900 0.960 35.600 6.700 2.970 129.100 64.550 129.100 22385.000 0.057 0 2 2; Spring_IMK 910203 1023 410203 $E $Fy 4020.000 24.500 0.605 12.900 0.960 35.600 6.700 2.970 129.100 64.550 129.100 22385.000 0.038 0 2 2; Spring_IMK 910303 1033 410303 $E $Fy 4020.000 24.500 0.605 12.900 0.960 35.600 6.700 2.970 129.100 64.550 129.100 22385.000 0.038 0 2 2; Spring_IMK 910403 1043 410403 $E $Fy 4020.000 24.500 0.605 12.900 0.960 35.600 6.700 2.970 129.100 64.550 129.100 22385.000 0.057 0 2 2; 
Spring_IMK 910101 1011 410101 $E $Fy 4020.000 24.500 0.605 12.900 0.960 35.600 6.700 2.970 129.100 64.550 129.100 22385.000 0.057 0 2 2; Spring_IMK 910201 1021 410201 $E $Fy 4020.000 24.500 0.605 12.900 0.960 35.600 6.700 2.970 129.100 64.550 129.100 22385.000 0.038 0 2 2; Spring_IMK 910301 1031 410301 $E $Fy 4020.000 24.500 0.605 12.900 0.960 35.600 6.700 2.970 129.100 64.550 129.100 22385.000 0.038 0 2 2; Spring_IMK 910401 1041 410401 $E $Fy 4020.000 24.500 0.605 12.900 0.960 35.600 6.700 2.970 129.100 64.550 129.100 22385.000 0.057 0 2 2; 
Spring_IMK 909103 913 409103 $E $Fy 4020.000 24.500 0.605 12.900 0.960 35.600 6.700 2.970 127.550 63.775 127.550 22385.000 0.076 0 2 2; Spring_IMK 909203 923 409203 $E $Fy 5680.000 25.200 0.750 12.900 1.340 28.700 4.810 3.040 127.550 63.775 127.550 30915.500 0.038 0 2 2; Spring_IMK 909303 933 409303 $E $Fy 5680.000 25.200 0.750 12.900 1.340 28.700 4.810 3.040 127.550 63.775 127.550 30915.500 0.038 0 2 2; Spring_IMK 909403 943 409403 $E $Fy 4020.000 24.500 0.605 12.900 0.960 35.600 6.700 2.970 127.550 63.775 127.550 22385.000 0.076 0 2 2; 
Spring_IMK 909101 911 409101 $E $Fy 4020.000 24.500 0.605 12.900 0.960 35.600 6.700 2.970 126.000 63.000 126.000 22385.000 0.076 0 2 2; Spring_IMK 909201 921 409201 $E $Fy 5680.000 25.200 0.750 12.900 1.340 28.700 4.810 3.040 126.000 63.000 126.000 30915.500 0.038 0 2 2; Spring_IMK 909301 931 409301 $E $Fy 5680.000 25.200 0.750 12.900 1.340 28.700 4.810 3.040 126.000 63.000 126.000 30915.500 0.038 0 2 2; Spring_IMK 909401 941 409401 $E $Fy 4020.000 24.500 0.605 12.900 0.960 35.600 6.700 2.970 126.000 63.000 126.000 22385.000 0.076 0 2 2; 
Spring_IMK 908103 813 408103 $E $Fy 4020.000 24.500 0.605 12.900 0.960 35.600 6.700 2.970 126.000 63.000 126.000 22385.000 0.096 0 2 2; Spring_IMK 908203 823 408203 $E $Fy 5680.000 25.200 0.750 12.900 1.340 28.700 4.810 3.040 126.000 63.000 126.000 30915.500 0.048 0 2 2; Spring_IMK 908303 833 408303 $E $Fy 5680.000 25.200 0.750 12.900 1.340 28.700 4.810 3.040 126.000 63.000 126.000 30915.500 0.048 0 2 2; Spring_IMK 908403 843 408403 $E $Fy 4020.000 24.500 0.605 12.900 0.960 35.600 6.700 2.970 126.000 63.000 126.000 22385.000 0.096 0 2 2; 
Spring_IMK 908101 811 408101 $E $Fy 4020.000 24.500 0.605 12.900 0.960 35.600 6.700 2.970 126.000 63.000 126.000 22385.000 0.096 0 2 2; Spring_IMK 908201 821 408201 $E $Fy 5680.000 25.200 0.750 12.900 1.340 28.700 4.810 3.040 126.000 63.000 126.000 30915.500 0.048 0 2 2; Spring_IMK 908301 831 408301 $E $Fy 5680.000 25.200 0.750 12.900 1.340 28.700 4.810 3.040 126.000 63.000 126.000 30915.500 0.048 0 2 2; Spring_IMK 908401 841 408401 $E $Fy 4020.000 24.500 0.605 12.900 0.960 35.600 6.700 2.970 126.000 63.000 126.000 22385.000 0.096 0 2 2; 
Spring_IMK 907103 713 407103 $E $Fy 5170.000 25.000 0.705 13.000 1.220 30.600 5.310 3.050 126.000 63.000 126.000 28314.000 0.094 0 2 2; Spring_IMK 907203 723 407203 $E $Fy 6820.000 25.700 0.870 13.000 1.570 24.800 4.140 3.080 126.000 63.000 126.000 36663.000 0.049 0 2 2; Spring_IMK 907303 733 407303 $E $Fy 6820.000 25.700 0.870 13.000 1.570 24.800 4.140 3.080 126.000 63.000 126.000 36663.000 0.049 0 2 2; Spring_IMK 907403 743 407403 $E $Fy 5170.000 25.000 0.705 13.000 1.220 30.600 5.310 3.050 126.000 63.000 126.000 28314.000 0.094 0 2 2; 
Spring_IMK 907101 711 407101 $E $Fy 5170.000 25.000 0.705 13.000 1.220 30.600 5.310 3.050 126.000 63.000 126.000 28314.000 0.094 0 2 2; Spring_IMK 907201 721 407201 $E $Fy 6820.000 25.700 0.870 13.000 1.570 24.800 4.140 3.080 126.000 63.000 126.000 36663.000 0.049 0 2 2; Spring_IMK 907301 731 407301 $E $Fy 6820.000 25.700 0.870 13.000 1.570 24.800 4.140 3.080 126.000 63.000 126.000 36663.000 0.049 0 2 2; Spring_IMK 907401 741 407401 $E $Fy 5170.000 25.000 0.705 13.000 1.220 30.600 5.310 3.050 126.000 63.000 126.000 28314.000 0.094 0 2 2; 
Spring_IMK 906103 613 406103 $E $Fy 5170.000 25.000 0.705 13.000 1.220 30.600 5.310 3.050 126.000 63.000 126.000 28314.000 0.110 0 2 2; Spring_IMK 906203 623 406203 $E $Fy 6820.000 25.700 0.870 13.000 1.570 24.800 4.140 3.080 126.000 63.000 126.000 36663.000 0.058 0 2 2; Spring_IMK 906303 633 406303 $E $Fy 6820.000 25.700 0.870 13.000 1.570 24.800 4.140 3.080 126.000 63.000 126.000 36663.000 0.058 0 2 2; Spring_IMK 906403 643 406403 $E $Fy 5170.000 25.000 0.705 13.000 1.220 30.600 5.310 3.050 126.000 63.000 126.000 28314.000 0.110 0 2 2; 
Spring_IMK 906101 611 406101 $E $Fy 5170.000 25.000 0.705 13.000 1.220 30.600 5.310 3.050 126.000 63.000 126.000 28314.000 0.110 0 2 2; Spring_IMK 906201 621 406201 $E $Fy 6820.000 25.700 0.870 13.000 1.570 24.800 4.140 3.080 126.000 63.000 126.000 36663.000 0.058 0 2 2; Spring_IMK 906301 631 406301 $E $Fy 6820.000 25.700 0.870 13.000 1.570 24.800 4.140 3.080 126.000 63.000 126.000 36663.000 0.058 0 2 2; Spring_IMK 906401 641 406401 $E $Fy 5170.000 25.000 0.705 13.000 1.220 30.600 5.310 3.050 126.000 63.000 126.000 28314.000 0.110 0 2 2; 
Spring_IMK 905103 513 405103 $E $Fy 6260.000 25.500 0.810 13.000 1.460 26.600 4.430 3.070 125.850 62.925 125.850 33819.500 0.107 0 2 2; Spring_IMK 905203 523 405203 $E $Fy 8490.000 26.300 1.040 13.200 1.890 20.700 3.490 3.140 125.850 62.925 125.850 45012.000 0.055 0 2 2; Spring_IMK 905303 533 405303 $E $Fy 8490.000 26.300 1.040 13.200 1.890 20.700 3.490 3.140 125.850 62.925 125.850 45012.000 0.055 0 2 2; Spring_IMK 905403 543 405403 $E $Fy 6260.000 25.500 0.810 13.000 1.460 26.600 4.430 3.070 125.850 62.925 125.850 33819.500 0.107 0 2 2; 
Spring_IMK 905101 511 405101 $E $Fy 6260.000 25.500 0.810 13.000 1.460 26.600 4.430 3.070 125.700 62.850 125.700 33819.500 0.107 0 2 2; Spring_IMK 905201 521 405201 $E $Fy 8490.000 26.300 1.040 13.200 1.890 20.700 3.490 3.140 125.700 62.850 125.700 45012.000 0.055 0 2 2; Spring_IMK 905301 531 405301 $E $Fy 8490.000 26.300 1.040 13.200 1.890 20.700 3.490 3.140 125.700 62.850 125.700 45012.000 0.055 0 2 2; Spring_IMK 905401 541 405401 $E $Fy 6260.000 25.500 0.810 13.000 1.460 26.600 4.430 3.070 125.700 62.850 125.700 33819.500 0.107 0 2 2; 
Spring_IMK 904103 413 404103 $E $Fy 6260.000 25.500 0.810 13.000 1.460 26.600 4.430 3.070 125.700 62.850 125.700 33819.500 0.121 0 2 2; Spring_IMK 904203 423 404203 $E $Fy 8490.000 26.300 1.040 13.200 1.890 20.700 3.490 3.140 125.700 62.850 125.700 45012.000 0.062 0 2 2; Spring_IMK 904303 433 404303 $E $Fy 8490.000 26.300 1.040 13.200 1.890 20.700 3.490 3.140 125.700 62.850 125.700 45012.000 0.062 0 2 2; Spring_IMK 904403 443 404403 $E $Fy 6260.000 25.500 0.810 13.000 1.460 26.600 4.430 3.070 125.700 62.850 125.700 33819.500 0.121 0 2 2; 
Spring_IMK 904101 411 404101 $E $Fy 6260.000 25.500 0.810 13.000 1.460 26.600 4.430 3.070 125.700 62.850 125.700 33819.500 0.121 0 2 2; Spring_IMK 904201 421 404201 $E $Fy 8490.000 26.300 1.040 13.200 1.890 20.700 3.490 3.140 125.700 62.850 125.700 45012.000 0.062 0 2 2; Spring_IMK 904301 431 404301 $E $Fy 8490.000 26.300 1.040 13.200 1.890 20.700 3.490 3.140 125.700 62.850 125.700 45012.000 0.062 0 2 2; Spring_IMK 904401 441 404401 $E $Fy 6260.000 25.500 0.810 13.000 1.460 26.600 4.430 3.070 125.700 62.850 125.700 33819.500 0.121 0 2 2; 
Spring_IMK 903103 313 403103 $E $Fy 7650.000 26.000 0.960 13.100 1.730 22.500 3.790 3.110 125.700 62.850 125.700 40837.500 0.113 0 2 2; Spring_IMK 903203 323 403203 $E $Fy 9600.000 26.700 1.160 13.300 2.090 18.600 3.180 3.170 125.700 62.850 125.700 50517.500 0.061 0 2 2; Spring_IMK 903303 333 403303 $E $Fy 9600.000 26.700 1.160 13.300 2.090 18.600 3.180 3.170 125.700 62.850 125.700 50517.500 0.061 0 2 2; Spring_IMK 903403 343 403403 $E $Fy 7650.000 26.000 0.960 13.100 1.730 22.500 3.790 3.110 125.700 62.850 125.700 40837.500 0.113 0 2 2; 
Spring_IMK 903101 311 403101 $E $Fy 7650.000 26.000 0.960 13.100 1.730 22.500 3.790 3.110 125.700 62.850 125.700 40837.500 0.113 0 2 2; Spring_IMK 903201 321 403201 $E $Fy 9600.000 26.700 1.160 13.300 2.090 18.600 3.180 3.170 125.700 62.850 125.700 50517.500 0.061 0 2 2; Spring_IMK 903301 331 403301 $E $Fy 9600.000 26.700 1.160 13.300 2.090 18.600 3.180 3.170 125.700 62.850 125.700 50517.500 0.061 0 2 2; Spring_IMK 903401 341 403401 $E $Fy 7650.000 26.000 0.960 13.100 1.730 22.500 3.790 3.110 125.700 62.850 125.700 40837.500 0.113 0 2 2; 
Spring_IMK 902103 213 402103 $E $Fy 7650.000 26.000 0.960 13.100 1.730 22.500 3.790 3.110 149.750 74.875 149.750 40837.500 0.124 0 2 2; Spring_IMK 902203 223 402203 $E $Fy 9600.000 26.700 1.160 13.300 2.090 18.600 3.180 3.170 149.750 74.875 149.750 50517.500 0.068 0 2 2; Spring_IMK 902303 233 402303 $E $Fy 9600.000 26.700 1.160 13.300 2.090 18.600 3.180 3.170 149.750 74.875 149.750 50517.500 0.068 0 2 2; Spring_IMK 902403 243 402403 $E $Fy 7650.000 26.000 0.960 13.100 1.730 22.500 3.790 3.110 149.750 74.875 149.750 40837.500 0.124 0 2 2; 
Spring_IMK 902101 211 402101 $E $Fy 7650.000 26.000 0.960 13.100 1.730 22.500 3.790 3.110 149.800 74.900 149.800 40837.500 0.124 0 2 2; Spring_IMK 902201 221 402201 $E $Fy 9600.000 26.700 1.160 13.300 2.090 18.600 3.180 3.170 149.800 74.900 149.800 50517.500 0.068 0 2 2; Spring_IMK 902301 231 402301 $E $Fy 9600.000 26.700 1.160 13.300 2.090 18.600 3.180 3.170 149.800 74.900 149.800 50517.500 0.068 0 2 2; Spring_IMK 902401 241 402401 $E $Fy 7650.000 26.000 0.960 13.100 1.730 22.500 3.790 3.110 149.800 74.900 149.800 40837.500 0.124 0 2 2; 
Spring_IMK 901103 11 113 $E $Fy 7650.000 26.000 0.960 13.100 1.730 22.500 3.790 3.110 164.900 82.450 164.900 40837.500 0.136 0 2 2; Spring_IMK 901203 12 123 $E $Fy 9600.000 26.700 1.160 13.300 2.090 18.600 3.180 3.170 164.900 82.450 164.900 50517.500 0.074 0 2 2; Spring_IMK 901303 13 133 $E $Fy 9600.000 26.700 1.160 13.300 2.090 18.600 3.180 3.170 164.900 82.450 164.900 50517.500 0.074 0 2 2; Spring_IMK 901403 14 143 $E $Fy 7650.000 26.000 0.960 13.100 1.730 22.500 3.790 3.110 164.900 82.450 164.900 40837.500 0.136 0 2 2; 

####################################################################################################
#                                          RIGID FLOOR LINKS                                       #
####################################################################################################

# COMMAND SYNTAX 
# element truss $ElementID $iNode $jNode $Area $matID
element truss 1013 413404 135 $A_Stiff 99;
element truss 1012 412404 125 $A_Stiff 99;
element truss 1011 411404 115 $A_Stiff 99;
element truss 1010 410404 105 $A_Stiff 99;
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
element elasticBeamColumn  612500  1253  1351  [expr 100000.000 / 2] $E [expr (100000000.000  + 406.800) / 2] 1; element elasticBeamColumn  612600  1263  1361  [expr 100000.000 / 2] $E [expr (100000000.000  + 406.800) / 2] 1; 
element elasticBeamColumn 611502 111570 1251  [expr 100000.000 / 2] $E [expr (100000000.000  + 406.800) / 2] 1;  element elasticBeamColumn 611602 111670 1261  [expr 100000.000 / 2] $E [expr (100000000.000  + 406.800) / 2] 1;  
element elasticBeamColumn 611501 1153 111570  [expr 100000.000 / 2] $E [expr (100000000.000  + 1360.000) / 2] 1;  element elasticBeamColumn 611601 1163 111670  [expr 100000.000 / 2] $E [expr (100000000.000  + 1360.000) / 2] 1;  
element elasticBeamColumn  610500  1053  1151  [expr 100000.000 / 2] $E [expr (100000000.000  + 1360.000) / 2] 1; element elasticBeamColumn  610600  1063  1161  [expr 100000.000 / 2] $E [expr (100000000.000  + 1360.000) / 2] 1; 
element elasticBeamColumn 609502 109570 1051  [expr 100000.000 / 2] $E [expr (100000000.000  + 1360.000) / 2] 1;  element elasticBeamColumn 609602 109670 1061  [expr 100000.000 / 2] $E [expr (100000000.000  + 1360.000) / 2] 1;  
element elasticBeamColumn 609501 953 109570  [expr 100000.000 / 2] $E [expr (100000000.000  + 1638.000) / 2] 1;  element elasticBeamColumn 609601 963 109670  [expr 100000.000 / 2] $E [expr (100000000.000  + 1638.000) / 2] 1;  
element elasticBeamColumn  608500  853  951  [expr 100000.000 / 2] $E [expr (100000000.000  + 1638.000) / 2] 1; element elasticBeamColumn  608600  863  961  [expr 100000.000 / 2] $E [expr (100000000.000  + 1638.000) / 2] 1; 
element elasticBeamColumn 607502 107570 851  [expr 100000.000 / 2] $E [expr (100000000.000  + 1638.000) / 2] 1;  element elasticBeamColumn 607602 107670 861  [expr 100000.000 / 2] $E [expr (100000000.000  + 1638.000) / 2] 1;  
element elasticBeamColumn 607501 753 107570  [expr 100000.000 / 2] $E [expr (100000000.000  + 2042.000) / 2] 1;  element elasticBeamColumn 607601 763 107670  [expr 100000.000 / 2] $E [expr (100000000.000  + 2042.000) / 2] 1;  
element elasticBeamColumn  606500  653  751  [expr 100000.000 / 2] $E [expr (100000000.000  + 2042.000) / 2] 1; element elasticBeamColumn  606600  663  761  [expr 100000.000 / 2] $E [expr (100000000.000  + 2042.000) / 2] 1; 
element elasticBeamColumn 605502 105570 651  [expr 100000.000 / 2] $E [expr (100000000.000  + 2042.000) / 2] 1;  element elasticBeamColumn 605602 105670 661  [expr 100000.000 / 2] $E [expr (100000000.000  + 2042.000) / 2] 1;  
element elasticBeamColumn 605501 553 105570  [expr 100000.000 / 2] $E [expr (100000000.000  + 2508.000) / 2] 1;  element elasticBeamColumn 605601 563 105670  [expr 100000.000 / 2] $E [expr (100000000.000  + 2508.000) / 2] 1;  
element elasticBeamColumn  604500  453  551  [expr 100000.000 / 2] $E [expr (100000000.000  + 2508.000) / 2] 1; element elasticBeamColumn  604600  463  561  [expr 100000.000 / 2] $E [expr (100000000.000  + 2508.000) / 2] 1; 
element elasticBeamColumn 603502 103570 451  [expr 100000.000 / 2] $E [expr (100000000.000  + 2508.000) / 2] 1;  element elasticBeamColumn 603602 103670 461  [expr 100000.000 / 2] $E [expr (100000000.000  + 2508.000) / 2] 1;  
element elasticBeamColumn 603501 353 103570  [expr 100000.000 / 2] $E [expr (100000000.000  + 2948.000) / 2] 1;  element elasticBeamColumn 603601 363 103670  [expr 100000.000 / 2] $E [expr (100000000.000  + 2948.000) / 2] 1;  
element elasticBeamColumn  602500  253  351  [expr 100000.000 / 2] $E [expr (100000000.000  + 2948.000) / 2] 1; element elasticBeamColumn  602600  263  361  [expr 100000.000 / 2] $E [expr (100000000.000  + 2948.000) / 2] 1; 
element elasticBeamColumn  601500  153  251  [expr 100000.000 / 2] $E [expr (100000000.000  + 2948.000) / 2] 1; element elasticBeamColumn  601600  163  261  [expr 100000.000 / 2] $E [expr (100000000.000  + 2948.000) / 2] 1; 

# Gravity Beams
element elasticBeamColumn  513400 1354  1362  100000.000  $E [expr $Comp_I_GC * 100000000.000] 1;
element elasticBeamColumn  512400 1254  1262  100000.000  $E [expr $Comp_I_GC * 100000000.000] 1;
element elasticBeamColumn  511400 1154  1162  100000.000  $E [expr $Comp_I_GC * 100000000.000] 1;
element elasticBeamColumn  510400 1054  1062  100000.000  $E [expr $Comp_I_GC * 100000000.000] 1;
element elasticBeamColumn  509400 954  962  100000.000  $E [expr $Comp_I_GC * 100000000.000] 1;
element elasticBeamColumn  508400 854  862  100000.000  $E [expr $Comp_I_GC * 100000000.000] 1;
element elasticBeamColumn  507400 754  762  100000.000  $E [expr $Comp_I_GC * 100000000.000] 1;
element elasticBeamColumn  506400 654  662  100000.000  $E [expr $Comp_I_GC * 100000000.000] 1;
element elasticBeamColumn  505400 554  562  100000.000  $E [expr $Comp_I_GC * 100000000.000] 1;
element elasticBeamColumn  504400 454  462  100000.000  $E [expr $Comp_I_GC * 100000000.000] 1;
element elasticBeamColumn  503400 354  362  100000.000  $E [expr $Comp_I_GC * 100000000.000] 1;
element elasticBeamColumn  502400 254  262  100000.000  $E [expr $Comp_I_GC * 100000000.000] 1;

# Gravity Columns Springs
Spring_Zero 913501 135 1351; Spring_Zero 913601 136 1361; 
Spring_Zero 912503 125 1253; Spring_Zero 912603 126 1263; 
Spring_Zero 912501 125 1251; Spring_Zero 912601 126 1261; 
Spring_Zero 911503 115 1153; Spring_Zero 911603 116 1163; 
Spring_Zero 911501 115 1151; Spring_Zero 911601 116 1161; 
Spring_Zero 910503 105 1053; Spring_Zero 910603 106 1063; 
Spring_Zero 910501 105 1051; Spring_Zero 910601 106 1061; 
Spring_Zero 909503 95 953; Spring_Zero 909603 96 963; 
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
Spring_Pinching  913504  135   1354 40837.500 $gap 0; Spring_Pinching  913602  1362  136  40837.500 $gap 0; 
Spring_Pinching  912504  125   1254 40837.500 $gap 0; Spring_Pinching  912602  1262  126  40837.500 $gap 0; 
Spring_Pinching  911504  115   1154 40837.500 $gap 0; Spring_Pinching  911602  1162  116  40837.500 $gap 0; 
Spring_Pinching  910504  105   1054 40837.500 $gap 0; Spring_Pinching  910602  1062  106  40837.500 $gap 0; 
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
equalDOF 413104  413204  1; equalDOF 413104  413304  1; equalDOF 413104  413404  1; 
equalDOF 412104  412204  1; equalDOF 412104  412304  1; equalDOF 412104  412404  1; 
equalDOF 411104  411204  1; equalDOF 411104  411304  1; equalDOF 411104  411404  1; 
equalDOF 410104  410204  1; equalDOF 410104  410304  1; equalDOF 410104  410404  1; 
equalDOF 409104  409204  1; equalDOF 409104  409304  1; equalDOF 409104  409404  1; 
equalDOF 408104  408204  1; equalDOF 408104  408304  1; equalDOF 408104  408404  1; 
equalDOF 407104  407204  1; equalDOF 407104  407304  1; equalDOF 407104  407404  1; 
equalDOF 406104  406204  1; equalDOF 406104  406304  1; equalDOF 406104  406404  1; 
equalDOF 405104  405204  1; equalDOF 405104  405304  1; equalDOF 405104  405404  1; 
equalDOF 404104  404204  1; equalDOF 404104  404304  1; equalDOF 404104  404404  1; 
equalDOF 403104  403204  1; equalDOF 403104  403304  1; equalDOF 403104  403404  1; 
equalDOF 402104  402204  1; equalDOF 402104  402304  1; equalDOF 402104  402404  1; 

# MRF Column Joints
equalDOF  413101 	1311 1 2; equalDOF  413201 	1321 1 2; equalDOF  413301 	1331 1 2; equalDOF  413401 	1341 1 2; 
equalDOF  412103 	1213 1 2; equalDOF  412203 	1223 1 2; equalDOF  412303 	1233 1 2; equalDOF  412403 	1243 1 2; 
equalDOF  411103 	1113 1 2; equalDOF  411203 	1123 1 2; equalDOF  411303 	1133 1 2; equalDOF  411403 	1143 1 2; 
equalDOF  410103 	1013 1 2; equalDOF  410203 	1023 1 2; equalDOF  410303 	1033 1 2; equalDOF  410403 	1043 1 2; 
equalDOF  409103 	913 1 2; equalDOF  409203 	923 1 2; equalDOF  409303 	933 1 2; equalDOF  409403 	943 1 2; 
equalDOF  408103 	813 1 2; equalDOF  408203 	823 1 2; equalDOF  408303 	833 1 2; equalDOF  408403 	843 1 2; 
equalDOF  407103 	713 1 2; equalDOF  407203 	723 1 2; equalDOF  407303 	733 1 2; equalDOF  407403 	743 1 2; 
equalDOF  406103 	613 1 2; equalDOF  406203 	623 1 2; equalDOF  406303 	633 1 2; equalDOF  406403 	643 1 2; 
equalDOF  405103 	513 1 2; equalDOF  405203 	523 1 2; equalDOF  405303 	533 1 2; equalDOF  405403 	543 1 2; 
equalDOF  404103 	413 1 2; equalDOF  404203 	423 1 2; equalDOF  404303 	433 1 2; equalDOF  404403 	443 1 2; 
equalDOF  403103 	313 1 2; equalDOF  403203 	323 1 2; equalDOF  403303 	333 1 2; equalDOF  403403 	343 1 2; 
equalDOF  402103 	213 1 2; equalDOF  402203 	223 1 2; equalDOF  402303 	233 1 2; equalDOF  402403 	243 1 2; 
equalDOF  412101 	1211 1 2; equalDOF  412201 	1221 1 2; equalDOF  412301 	1231 1 2; equalDOF  412401 	1241 1 2; 
equalDOF  411101 	1111 1 2; equalDOF  411201 	1121 1 2; equalDOF  411301 	1131 1 2; equalDOF  411401 	1141 1 2; 
equalDOF  410101 	1011 1 2; equalDOF  410201 	1021 1 2; equalDOF  410301 	1031 1 2; equalDOF  410401 	1041 1 2; 
equalDOF  409101 	911 1 2; equalDOF  409201 	921 1 2; equalDOF  409301 	931 1 2; equalDOF  409401 	941 1 2; 
equalDOF  408101 	811 1 2; equalDOF  408201 	821 1 2; equalDOF  408301 	831 1 2; equalDOF  408401 	841 1 2; 
equalDOF  407101 	711 1 2; equalDOF  407201 	721 1 2; equalDOF  407301 	731 1 2; equalDOF  407401 	741 1 2; 
equalDOF  406101 	611 1 2; equalDOF  406201 	621 1 2; equalDOF  406301 	631 1 2; equalDOF  406401 	641 1 2; 
equalDOF  405101 	511 1 2; equalDOF  405201 	521 1 2; equalDOF  405301 	531 1 2; equalDOF  405401 	541 1 2; 
equalDOF  404101 	411 1 2; equalDOF  404201 	421 1 2; equalDOF  404301 	431 1 2; equalDOF  404401 	441 1 2; 
equalDOF  403101 	311 1 2; equalDOF  403201 	321 1 2; equalDOF  403301 	331 1 2; equalDOF  403401 	341 1 2; 
equalDOF  402101 	211 1 2; equalDOF  402201 	221 1 2; equalDOF  402301 	231 1 2; equalDOF  402401 	241 1 2; 
equalDOF  11 	113 1 2; equalDOF  12 	123 1 2; equalDOF  13 	133 1 2; equalDOF  14 	143 1 2; 

# MRF Beam Joints
equalDOF  13140 	1314 1 2; equalDOF  13220 	1322 1 2; equalDOF  13240 	1324 1 2; equalDOF  13320 	1332 1 2; equalDOF  13340 	1334 1 2; equalDOF  13420 	1342 1 2; 
equalDOF  12140 	1214 1 2; equalDOF  12220 	1222 1 2; equalDOF  12240 	1224 1 2; equalDOF  12320 	1232 1 2; equalDOF  12340 	1234 1 2; equalDOF  12420 	1242 1 2; 
equalDOF  11140 	1114 1 2; equalDOF  11220 	1122 1 2; equalDOF  11240 	1124 1 2; equalDOF  11320 	1132 1 2; equalDOF  11340 	1134 1 2; equalDOF  11420 	1142 1 2; 
equalDOF  10140 	1014 1 2; equalDOF  10220 	1022 1 2; equalDOF  10240 	1024 1 2; equalDOF  10320 	1032 1 2; equalDOF  10340 	1034 1 2; equalDOF  10420 	1042 1 2; 
equalDOF  9140 	914 1 2; equalDOF  9220 	922 1 2; equalDOF  9240 	924 1 2; equalDOF  9320 	932 1 2; equalDOF  9340 	934 1 2; equalDOF  9420 	942 1 2; 
equalDOF  8140 	814 1 2; equalDOF  8220 	822 1 2; equalDOF  8240 	824 1 2; equalDOF  8320 	832 1 2; equalDOF  8340 	834 1 2; equalDOF  8420 	842 1 2; 
equalDOF  7140 	714 1 2; equalDOF  7220 	722 1 2; equalDOF  7240 	724 1 2; equalDOF  7320 	732 1 2; equalDOF  7340 	734 1 2; equalDOF  7420 	742 1 2; 
equalDOF  6140 	614 1 2; equalDOF  6220 	622 1 2; equalDOF  6240 	624 1 2; equalDOF  6320 	632 1 2; equalDOF  6340 	634 1 2; equalDOF  6420 	642 1 2; 
equalDOF  5140 	514 1 2; equalDOF  5220 	522 1 2; equalDOF  5240 	524 1 2; equalDOF  5320 	532 1 2; equalDOF  5340 	534 1 2; equalDOF  5420 	542 1 2; 
equalDOF  4140 	414 1 2; equalDOF  4220 	422 1 2; equalDOF  4240 	424 1 2; equalDOF  4320 	432 1 2; equalDOF  4340 	434 1 2; equalDOF  4420 	442 1 2; 
equalDOF  3140 	314 1 2; equalDOF  3220 	322 1 2; equalDOF  3240 	324 1 2; equalDOF  3320 	332 1 2; equalDOF  3340 	334 1 2; equalDOF  3420 	342 1 2; 
equalDOF  2140 	214 1 2; equalDOF  2220 	222 1 2; equalDOF  2240 	224 1 2; equalDOF  2320 	232 1 2; equalDOF  2340 	234 1 2; equalDOF  2420 	242 1 2; 

# EGF Beam Joints
equalDOF  135 	1354 1 2; equalDOF  136 	1362 1 2; 
equalDOF  125 	1254 1 2; equalDOF  126 	1262 1 2; 
equalDOF  115 	1154 1 2; equalDOF  116 	1162 1 2; 
equalDOF  105 	1054 1 2; equalDOF  106 	1062 1 2; 
equalDOF  95 	954 1 2; equalDOF  96 	962 1 2; 
equalDOF  85 	854 1 2; equalDOF  86 	862 1 2; 
equalDOF  75 	754 1 2; equalDOF  76 	762 1 2; 
equalDOF  65 	654 1 2; equalDOF  66 	662 1 2; 
equalDOF  55 	554 1 2; equalDOF  56 	562 1 2; 
equalDOF  45 	454 1 2; equalDOF  46 	462 1 2; 
equalDOF  35 	354 1 2; equalDOF  36 	362 1 2; 
equalDOF  25 	254 1 2; equalDOF  26 	262 1 2; 

# EGF Column Joints
equalDOF  135 	1351 1 2; equalDOF  136 	1361 1 2; 
equalDOF  125 	1253 1 2; equalDOF  126 	1263 1 2; 
equalDOF  115 	1153 1 2; equalDOF  116 	1163 1 2; 
equalDOF  105 	1053 1 2; equalDOF  106 	1063 1 2; 
equalDOF  95 	953 1 2; equalDOF  96 	963 1 2; 
equalDOF  85 	853 1 2; equalDOF  86 	863 1 2; 
equalDOF  75 	753 1 2; equalDOF  76 	763 1 2; 
equalDOF  65 	653 1 2; equalDOF  66 	663 1 2; 
equalDOF  55 	553 1 2; equalDOF  56 	563 1 2; 
equalDOF  45 	453 1 2; equalDOF  46 	463 1 2; 
equalDOF  35 	353 1 2; equalDOF  36 	363 1 2; 
equalDOF  25 	253 1 2; equalDOF  26 	263 1 2; 
equalDOF  125 	1251 1 2; equalDOF  126 	1261 1 2; 
equalDOF  115 	1151 1 2; equalDOF  116 	1161 1 2; 
equalDOF  105 	1051 1 2; equalDOF  106 	1061 1 2; 
equalDOF  95 	951 1 2; equalDOF  96 	961 1 2; 
equalDOF  85 	851 1 2; equalDOF  86 	861 1 2; 
equalDOF  75 	751 1 2; equalDOF  76 	761 1 2; 
equalDOF  65 	651 1 2; equalDOF  66 	661 1 2; 
equalDOF  55 	551 1 2; equalDOF  56 	561 1 2; 
equalDOF  45 	451 1 2; equalDOF  46 	461 1 2; 
equalDOF  35 	351 1 2; equalDOF  36 	361 1 2; 
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
recorder Drift -file $MainFolder/$SubFolder/SDR_MRF12.out  -iNode 412104 -jNode 413104 -dof 1 -perpDirn 2;
recorder Drift -file $MainFolder/$SubFolder/SDR_MRF11.out  -iNode 411104 -jNode 412104 -dof 1 -perpDirn 2;
recorder Drift -file $MainFolder/$SubFolder/SDR_MRF10.out  -iNode 410104 -jNode 411104 -dof 1 -perpDirn 2;
recorder Drift -file $MainFolder/$SubFolder/SDR_MRF9.out   -iNode 409104 -jNode 410104 -dof 1 -perpDirn 2;
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
recorder Node -file $MainFolder/$SubFolder/RFA_MRF13.out  -node 413103 -dof 1 accel;
recorder Node -file $MainFolder/$SubFolder/RFA_MRF12.out  -node 412103 -dof 1 accel;
recorder Node -file $MainFolder/$SubFolder/RFA_MRF11.out  -node 411103 -dof 1 accel;
recorder Node -file $MainFolder/$SubFolder/RFA_MRF10.out  -node 410103 -dof 1 accel;
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
mass 413103 0.2888  1.e-9 1.e-9; mass 413203 0.2888  1.e-9 1.e-9; mass 413303 0.2888  1.e-9 1.e-9; mass 413403 0.2888  1.e-9 1.e-9; mass 135 0.2888  1.e-9 1.e-9; mass 136 0.2888  1.e-9 1.e-9; 
mass 412103 0.3056  1.e-9 1.e-9; mass 412203 0.3056  1.e-9 1.e-9; mass 412303 0.3056  1.e-9 1.e-9; mass 412403 0.3056  1.e-9 1.e-9; mass 125 0.3056  1.e-9 1.e-9; mass 126 0.3056  1.e-9 1.e-9; 
mass 411103 0.3056  1.e-9 1.e-9; mass 411203 0.3056  1.e-9 1.e-9; mass 411303 0.3056  1.e-9 1.e-9; mass 411403 0.3056  1.e-9 1.e-9; mass 115 0.3056  1.e-9 1.e-9; mass 116 0.3056  1.e-9 1.e-9; 
mass 410103 0.3056  1.e-9 1.e-9; mass 410203 0.3056  1.e-9 1.e-9; mass 410303 0.3056  1.e-9 1.e-9; mass 410403 0.3056  1.e-9 1.e-9; mass 105 0.3056  1.e-9 1.e-9; mass 106 0.3056  1.e-9 1.e-9; 
mass 409103 0.3056  1.e-9 1.e-9; mass 409203 0.3056  1.e-9 1.e-9; mass 409303 0.3056  1.e-9 1.e-9; mass 409403 0.3056  1.e-9 1.e-9; mass 95 0.3056  1.e-9 1.e-9; mass 96 0.3056  1.e-9 1.e-9; 
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
set nEigen 12;
set lambdaN [eigen [expr $nEigen]];
set lambda1 [lindex $lambdaN 0];
set lambda2 [lindex $lambdaN 1];
set lambda3 [lindex $lambdaN 2];
set lambda4 [lindex $lambdaN 3];
set lambda5 [lindex $lambdaN 4];
set lambda6 [lindex $lambdaN 5];
set lambda7 [lindex $lambdaN 6];
set lambda8 [lindex $lambdaN 7];
set lambda9 [lindex $lambdaN 8];
set lambda10 [lindex $lambdaN 9];
set lambda11 [lindex $lambdaN 10];
set lambda12 [lindex $lambdaN 11];
set w1 [expr pow($lambda1,0.5)];
set w2 [expr pow($lambda2,0.5)];
set w3 [expr pow($lambda3,0.5)];
set w4 [expr pow($lambda4,0.5)];
set w5 [expr pow($lambda5,0.5)];
set w6 [expr pow($lambda6,0.5)];
set w7 [expr pow($lambda7,0.5)];
set w8 [expr pow($lambda8,0.5)];
set w9 [expr pow($lambda9,0.5)];
set w10 [expr pow($lambda10,0.5)];
set w11 [expr pow($lambda11,0.5)];
set w12 [expr pow($lambda12,0.5)];
set T1 [expr 2.0*$pi/$w1];
set T2 [expr 2.0*$pi/$w2];
set T3 [expr 2.0*$pi/$w3];
set T4 [expr 2.0*$pi/$w4];
set T5 [expr 2.0*$pi/$w5];
set T6 [expr 2.0*$pi/$w6];
set T7 [expr 2.0*$pi/$w7];
set T8 [expr 2.0*$pi/$w8];
set T9 [expr 2.0*$pi/$w9];
set T10 [expr 2.0*$pi/$w10];
set T11 [expr 2.0*$pi/$w11];
set T12 [expr 2.0*$pi/$w12];
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
load 413103 0. -34.969 0.; load 413203 0. -23.312 0.; load 413303 0. -23.312 0.; load 413403 0. -34.969 0.; 
load 412103 0. -42.337 0.; load 412203 0. -28.225 0.; load 412303 0. -28.225 0.; load 412403 0. -42.337 0.; 
load 411103 0. -42.337 0.; load 411203 0. -28.225 0.; load 411303 0. -28.225 0.; load 411403 0. -42.337 0.; 
load 410103 0. -42.337 0.; load 410203 0. -28.225 0.; load 410303 0. -28.225 0.; load 410403 0. -42.337 0.; 
load 409103 0. -42.337 0.; load 409203 0. -28.225 0.; load 409303 0. -28.225 0.; load 409403 0. -42.337 0.; 
load 408103 0. -42.337 0.; load 408203 0. -28.225 0.; load 408303 0. -28.225 0.; load 408403 0. -42.337 0.; 
load 407103 0. -42.337 0.; load 407203 0. -28.225 0.; load 407303 0. -28.225 0.; load 407403 0. -42.337 0.; 
load 406103 0. -42.337 0.; load 406203 0. -28.225 0.; load 406303 0. -28.225 0.; load 406403 0. -42.337 0.; 
load 405103 0. -42.337 0.; load 405203 0. -28.225 0.; load 405303 0. -28.225 0.; load 405403 0. -42.337 0.; 
load 404103 0. -42.337 0.; load 404203 0. -28.225 0.; load 404303 0. -28.225 0.; load 404403 0. -42.337 0.; 
load 403103 0. -42.337 0.; load 403203 0. -28.225 0.; load 403303 0. -28.225 0.; load 403403 0. -42.337 0.; 
load 402103 0. -43.125 0.; load 402203 0. -28.750 0.; load 402303 0. -28.750 0.; load 402403 0. -43.125 0.; 

# EGC/LC COLUMN LOADS
load 135 0. -310.443794 0.; load 136 0. -310.443794 0.; 
load 125 0. -344.887107 0.; load 126 0. -344.887107 0.; 
load 115 0. -344.887107 0.; load 116 0. -344.887107 0.; 
load 105 0. -344.887107 0.; load 106 0. -344.887107 0.; 
load 95 0. -344.887107 0.; load 96 0. -344.887107 0.; 
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

puts "Seismic Weight = 9883.6 kip";
puts "Seismic Mass = 21.9 kip.sec2/in";

if {$Animation == 1} {
	DisplayModel3D DeformedShape 5 50 50  2000 1500
}

###################################################################################################
#                                        Pushover Analysis                       		          #
###################################################################################################

if {$PO==1} {

	# Create Load Pattern
	pattern Plain 222 Linear {
	load 413103 -0.33516 0.0 0.0
	load 412103 -0.31787 0.0 0.0
	load 411103 -0.29412 0.0 0.0
	load 410103 -0.26684 0.0 0.0
	load 409103 -0.23792 0.0 0.0
	load 408103 -0.20885 0.0 0.0
	load 407103 -0.17757 0.0 0.0
	load 406103 -0.14534 0.0 0.0
	load 405103 -0.11328 0.0 0.0
	load 404103 -0.08248 0.0 0.0
	load 403103 -0.05207 0.0 0.0
	load 402103 -0.02330 0.0 0.0
	}

	# Displacement Control Parameters
	set CtrlNode 413104;
	set CtrlDOF 1;
	set Dmax [expr 0.100*$Floor13];
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
	region 1 -eleRange  502100  612400 -rayleigh 0.0 0.0 $a1_mod 0.0;
	region 2 -node  402103 402203 402303 402403 102500 102600 403103 403203 403303 403403 103500 103600 404103 404203 404303 404403 104500 104600 405103 405203 405303 405403 105500 105600 406103 406203 406303 406403 106500 106600 407103 407203 407303 407403 107500 107600 408103 408203 408303 408403 108500 108600 409103 409203 409303 409403 109500 109600 410103 410203 410303 410403 110500 110600 411103 411203 411303 411403 111500 111600 412103 412203 412303 412403 112500 112600 413103 413203 413303 413403 113500 113600  -rayleigh $a0 0.0 0.0 0.0;

	# GROUND MOTION ACCELERATION FILE INPUT
	set AccelSeries "Series -dt $dt -filePath $GMfile -factor  [expr $EqScale* $g]"
	pattern UniformExcitation  200 1 -accel $AccelSeries

	set SMFFloorNodes [list  402104 403104 404104 405104 406104 407104 408104 409104 410104 411104 412104 413104 ];
	DynamicAnalysisCollapseSolver   $dt	$dtAnalysis	$totTime $NStory	0.15   $SMFFloorNodes	180.00 156.00;

	puts "Ground Motion Done. End Time: [getTime]"

}

wipe all;
