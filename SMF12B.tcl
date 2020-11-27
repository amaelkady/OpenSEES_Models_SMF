####################################################################################################
####################################################################################################
#                                        12-story MRF Building
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
set  Composite 0;
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
set NStory 12;
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
set Composite 0;
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

set HBuilding 1896.00;
set WFrame 720.00;
variable HBuilding 1896.00;

####################################################################################################
#                                                  NODES                                           #
####################################################################################################

# COMMAND SYNTAX 
# node $NodeID  $X-Coordinate  $Y-Coordinate;

#SUPPORT NODES
node 110   $Axis1  $Floor1; node 120   $Axis2  $Floor1; node 130   $Axis3  $Floor1; node 140   $Axis4  $Floor1; node 150   $Axis5  $Floor1; node 160   $Axis6  $Floor1; 

# EGF COLUMN GRID NODES
node 1350   $Axis5  $Floor13; node 1360   $Axis6  $Floor13; 
node 1250   $Axis5  $Floor12; node 1260   $Axis6  $Floor12; 
node 1150   $Axis5  $Floor11; node 1160   $Axis6  $Floor11; 
node 1050   $Axis5  $Floor10; node 1060   $Axis6  $Floor10; 
node 950   $Axis5  $Floor9; node 960   $Axis6  $Floor9; 
node 850   $Axis5  $Floor8; node 860   $Axis6  $Floor8; 
node 750   $Axis5  $Floor7; node 760   $Axis6  $Floor7; 
node 650   $Axis5  $Floor6; node 660   $Axis6  $Floor6; 
node 550   $Axis5  $Floor5; node 560   $Axis6  $Floor5; 
node 450   $Axis5  $Floor4; node 460   $Axis6  $Floor4; 
node 350   $Axis5  $Floor3; node 360   $Axis6  $Floor3; 
node 250   $Axis5  $Floor2; node 260   $Axis6  $Floor2; 

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

# MF COLUMN NODES
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

# MF BEAM NODES
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

# BEAM SPRING NODES
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
node 111172 $Axis1 [expr ($Floor11 + 0.50 * 156)]; node 111272 $Axis2 [expr ($Floor11 + 0.50 * 156)]; node 111372 $Axis3 [expr ($Floor11 + 0.50 * 156)]; node 111472 $Axis4 [expr ($Floor11 + 0.50 * 156)]; node 111572 $Axis5 [expr ($Floor11 + 0.50 * 156)]; node 111672 $Axis6 [expr ($Floor11 + 0.50 * 156)]; 
node 111171 $Axis1 [expr ($Floor11 + 0.50 * 156)]; node 111271 $Axis2 [expr ($Floor11 + 0.50 * 156)]; node 111371 $Axis3 [expr ($Floor11 + 0.50 * 156)]; node 111471 $Axis4 [expr ($Floor11 + 0.50 * 156)]; node 111571 $Axis5 [expr ($Floor11 + 0.50 * 156)]; node 111671 $Axis6 [expr ($Floor11 + 0.50 * 156)]; 
node 109172 $Axis1 [expr ($Floor9 + 0.50 * 156)]; node 109272 $Axis2 [expr ($Floor9 + 0.50 * 156)]; node 109372 $Axis3 [expr ($Floor9 + 0.50 * 156)]; node 109472 $Axis4 [expr ($Floor9 + 0.50 * 156)]; node 109572 $Axis5 [expr ($Floor9 + 0.50 * 156)]; node 109672 $Axis6 [expr ($Floor9 + 0.50 * 156)]; 
node 109171 $Axis1 [expr ($Floor9 + 0.50 * 156)]; node 109271 $Axis2 [expr ($Floor9 + 0.50 * 156)]; node 109371 $Axis3 [expr ($Floor9 + 0.50 * 156)]; node 109471 $Axis4 [expr ($Floor9 + 0.50 * 156)]; node 109571 $Axis5 [expr ($Floor9 + 0.50 * 156)]; node 109671 $Axis6 [expr ($Floor9 + 0.50 * 156)]; 
node 107172 $Axis1 [expr ($Floor7 + 0.50 * 156)]; node 107272 $Axis2 [expr ($Floor7 + 0.50 * 156)]; node 107372 $Axis3 [expr ($Floor7 + 0.50 * 156)]; node 107472 $Axis4 [expr ($Floor7 + 0.50 * 156)]; node 107572 $Axis5 [expr ($Floor7 + 0.50 * 156)]; node 107672 $Axis6 [expr ($Floor7 + 0.50 * 156)]; 
node 107171 $Axis1 [expr ($Floor7 + 0.50 * 156)]; node 107271 $Axis2 [expr ($Floor7 + 0.50 * 156)]; node 107371 $Axis3 [expr ($Floor7 + 0.50 * 156)]; node 107471 $Axis4 [expr ($Floor7 + 0.50 * 156)]; node 107571 $Axis5 [expr ($Floor7 + 0.50 * 156)]; node 107671 $Axis6 [expr ($Floor7 + 0.50 * 156)]; 
node 105172 $Axis1 [expr ($Floor5 + 0.50 * 156)]; node 105272 $Axis2 [expr ($Floor5 + 0.50 * 156)]; node 105372 $Axis3 [expr ($Floor5 + 0.50 * 156)]; node 105472 $Axis4 [expr ($Floor5 + 0.50 * 156)]; node 105572 $Axis5 [expr ($Floor5 + 0.50 * 156)]; node 105672 $Axis6 [expr ($Floor5 + 0.50 * 156)]; 
node 105171 $Axis1 [expr ($Floor5 + 0.50 * 156)]; node 105271 $Axis2 [expr ($Floor5 + 0.50 * 156)]; node 105371 $Axis3 [expr ($Floor5 + 0.50 * 156)]; node 105471 $Axis4 [expr ($Floor5 + 0.50 * 156)]; node 105571 $Axis5 [expr ($Floor5 + 0.50 * 156)]; node 105671 $Axis6 [expr ($Floor5 + 0.50 * 156)]; 
node 103172 $Axis1 [expr ($Floor3 + 0.50 * 156)]; node 103272 $Axis2 [expr ($Floor3 + 0.50 * 156)]; node 103372 $Axis3 [expr ($Floor3 + 0.50 * 156)]; node 103472 $Axis4 [expr ($Floor3 + 0.50 * 156)]; node 103572 $Axis5 [expr ($Floor3 + 0.50 * 156)]; node 103672 $Axis6 [expr ($Floor3 + 0.50 * 156)]; 
node 103171 $Axis1 [expr ($Floor3 + 0.50 * 156)]; node 103271 $Axis2 [expr ($Floor3 + 0.50 * 156)]; node 103371 $Axis3 [expr ($Floor3 + 0.50 * 156)]; node 103471 $Axis4 [expr ($Floor3 + 0.50 * 156)]; node 103571 $Axis5 [expr ($Floor3 + 0.50 * 156)]; node 103671 $Axis6 [expr ($Floor3 + 0.50 * 156)]; 

###################################################################################################
#                                  PANEL ZONE NODES & ELEMENTS                                    #
###################################################################################################

# PANEL ZONE NODES AND ELASTIC ELEMENTS
# Command Syntax; 
# ConstructPanel_Rectangle Axis Floor X_Axis Y_Floor E A_Panel I_Panel d_Col d_Beam transfTag 
ConstructPanel_Rectangle  1 13 $Axis1 $Floor13 $E $A_Stiff $I_Stiff 24.10 24.10 $trans_selected; ConstructPanel_Rectangle  2 13 $Axis2 $Floor13 $E $A_Stiff $I_Stiff 24.30 24.10 $trans_selected; ConstructPanel_Rectangle  3 13 $Axis3 $Floor13 $E $A_Stiff $I_Stiff 24.30 24.10 $trans_selected; ConstructPanel_Rectangle  4 13 $Axis4 $Floor13 $E $A_Stiff $I_Stiff 24.10 24.10 $trans_selected; 
ConstructPanel_Rectangle  1 12 $Axis1 $Floor12 $E $A_Stiff $I_Stiff 24.50 24.10 $trans_selected; ConstructPanel_Rectangle  2 12 $Axis2 $Floor12 $E $A_Stiff $I_Stiff 24.50 24.10 $trans_selected; ConstructPanel_Rectangle  3 12 $Axis3 $Floor12 $E $A_Stiff $I_Stiff 24.50 24.10 $trans_selected; ConstructPanel_Rectangle  4 12 $Axis4 $Floor12 $E $A_Stiff $I_Stiff 24.50 24.10 $trans_selected; 
ConstructPanel_Rectangle  1 11 $Axis1 $Floor11 $E $A_Stiff $I_Stiff 24.50 26.90 $trans_selected; ConstructPanel_Rectangle  2 11 $Axis2 $Floor11 $E $A_Stiff $I_Stiff 24.50 26.90 $trans_selected; ConstructPanel_Rectangle  3 11 $Axis3 $Floor11 $E $A_Stiff $I_Stiff 24.50 26.90 $trans_selected; ConstructPanel_Rectangle  4 11 $Axis4 $Floor11 $E $A_Stiff $I_Stiff 24.50 26.90 $trans_selected; 
ConstructPanel_Rectangle  1 10 $Axis1 $Floor10 $E $A_Stiff $I_Stiff 24.50 26.90 $trans_selected; ConstructPanel_Rectangle  2 10 $Axis2 $Floor10 $E $A_Stiff $I_Stiff 25.20 26.90 $trans_selected; ConstructPanel_Rectangle  3 10 $Axis3 $Floor10 $E $A_Stiff $I_Stiff 25.20 26.90 $trans_selected; ConstructPanel_Rectangle  4 10 $Axis4 $Floor10 $E $A_Stiff $I_Stiff 24.50 26.90 $trans_selected; 
ConstructPanel_Rectangle  1 9 $Axis1 $Floor9 $E $A_Stiff $I_Stiff 24.50 30.00 $trans_selected; ConstructPanel_Rectangle  2 9 $Axis2 $Floor9 $E $A_Stiff $I_Stiff 25.20 30.00 $trans_selected; ConstructPanel_Rectangle  3 9 $Axis3 $Floor9 $E $A_Stiff $I_Stiff 25.20 30.00 $trans_selected; ConstructPanel_Rectangle  4 9 $Axis4 $Floor9 $E $A_Stiff $I_Stiff 24.50 30.00 $trans_selected; 
ConstructPanel_Rectangle  1 8 $Axis1 $Floor8 $E $A_Stiff $I_Stiff 25.00 30.00 $trans_selected; ConstructPanel_Rectangle  2 8 $Axis2 $Floor8 $E $A_Stiff $I_Stiff 25.70 30.00 $trans_selected; ConstructPanel_Rectangle  3 8 $Axis3 $Floor8 $E $A_Stiff $I_Stiff 25.70 30.00 $trans_selected; ConstructPanel_Rectangle  4 8 $Axis4 $Floor8 $E $A_Stiff $I_Stiff 25.00 30.00 $trans_selected; 
ConstructPanel_Rectangle  1 7 $Axis1 $Floor7 $E $A_Stiff $I_Stiff 25.00 30.00 $trans_selected; ConstructPanel_Rectangle  2 7 $Axis2 $Floor7 $E $A_Stiff $I_Stiff 25.70 30.00 $trans_selected; ConstructPanel_Rectangle  3 7 $Axis3 $Floor7 $E $A_Stiff $I_Stiff 25.70 30.00 $trans_selected; ConstructPanel_Rectangle  4 7 $Axis4 $Floor7 $E $A_Stiff $I_Stiff 25.00 30.00 $trans_selected; 
ConstructPanel_Rectangle  1 6 $Axis1 $Floor6 $E $A_Stiff $I_Stiff 25.50 30.00 $trans_selected; ConstructPanel_Rectangle  2 6 $Axis2 $Floor6 $E $A_Stiff $I_Stiff 26.30 30.00 $trans_selected; ConstructPanel_Rectangle  3 6 $Axis3 $Floor6 $E $A_Stiff $I_Stiff 26.30 30.00 $trans_selected; ConstructPanel_Rectangle  4 6 $Axis4 $Floor6 $E $A_Stiff $I_Stiff 25.50 30.00 $trans_selected; 
ConstructPanel_Rectangle  1 5 $Axis1 $Floor5 $E $A_Stiff $I_Stiff 25.50 30.30 $trans_selected; ConstructPanel_Rectangle  2 5 $Axis2 $Floor5 $E $A_Stiff $I_Stiff 26.30 30.30 $trans_selected; ConstructPanel_Rectangle  3 5 $Axis3 $Floor5 $E $A_Stiff $I_Stiff 26.30 30.30 $trans_selected; ConstructPanel_Rectangle  4 5 $Axis4 $Floor5 $E $A_Stiff $I_Stiff 25.50 30.30 $trans_selected; 
ConstructPanel_Rectangle  1 4 $Axis1 $Floor4 $E $A_Stiff $I_Stiff 26.00 30.30 $trans_selected; ConstructPanel_Rectangle  2 4 $Axis2 $Floor4 $E $A_Stiff $I_Stiff 26.70 30.30 $trans_selected; ConstructPanel_Rectangle  3 4 $Axis3 $Floor4 $E $A_Stiff $I_Stiff 26.70 30.30 $trans_selected; ConstructPanel_Rectangle  4 4 $Axis4 $Floor4 $E $A_Stiff $I_Stiff 26.00 30.30 $trans_selected; 
ConstructPanel_Rectangle  1 3 $Axis1 $Floor3 $E $A_Stiff $I_Stiff 26.00 30.30 $trans_selected; ConstructPanel_Rectangle  2 3 $Axis2 $Floor3 $E $A_Stiff $I_Stiff 26.70 30.30 $trans_selected; ConstructPanel_Rectangle  3 3 $Axis3 $Floor3 $E $A_Stiff $I_Stiff 26.70 30.30 $trans_selected; ConstructPanel_Rectangle  4 3 $Axis4 $Floor3 $E $A_Stiff $I_Stiff 26.00 30.30 $trans_selected; 
ConstructPanel_Rectangle  1 2 $Axis1 $Floor2 $E $A_Stiff $I_Stiff 26.00 30.20 $trans_selected; ConstructPanel_Rectangle  2 2 $Axis2 $Floor2 $E $A_Stiff $I_Stiff 26.70 30.20 $trans_selected; ConstructPanel_Rectangle  3 2 $Axis3 $Floor2 $E $A_Stiff $I_Stiff 26.70 30.20 $trans_selected; ConstructPanel_Rectangle  4 2 $Axis4 $Floor2 $E $A_Stiff $I_Stiff 26.00 30.20 $trans_selected; 

####################################################################################################
#                                          PANEL ZONE SPRINGS                                      #
####################################################################################################

# COMMAND SYNTAX 
# Spring_PZ    Element_ID Node_i Node_j E mu fy tw_Col tdp d_Col d_Beam tf_Col bf_Col Ic trib ts Response_ID transfTag
Spring_PZ    913100 413109 413110 $E $mu [expr $fy *   1.0]  0.47   0.06 24.10 24.10  0.77  9.02 2370.00 3.500 4.000 2 1; Spring_PZ    913200 413209 413210 $E $mu [expr $fy *   1.0]  0.52   0.56 24.30 24.10  0.88  9.07 2700.00 3.500 4.000 2 1; Spring_PZ    913300 413309 413310 $E $mu [expr $fy *   1.0]  0.52   0.56 24.30 24.10  0.88  9.07 2700.00 3.500 4.000 2 1; Spring_PZ    913400 413409 413410 $E $mu [expr $fy *   1.0]  0.47   0.06 24.10 24.10  0.77  9.02 2370.00 3.500 4.000 2 1; 
Spring_PZ    912100 412109 412110 $E $mu [expr $fy *   1.0]  0.47   0.06 24.10 24.10  0.77  9.02 2370.00 3.500 4.000 2 1; Spring_PZ    912200 412209 412210 $E $mu [expr $fy *   1.0]  0.52   0.56 24.30 24.10  0.88  9.07 2700.00 3.500 4.000 2 1; Spring_PZ    912300 412309 412310 $E $mu [expr $fy *   1.0]  0.52   0.56 24.30 24.10  0.88  9.07 2700.00 3.500 4.000 2 1; Spring_PZ    912400 412409 412410 $E $mu [expr $fy *   1.0]  0.47   0.06 24.10 24.10  0.77  9.02 2370.00 3.500 4.000 2 1; 
Spring_PZ    911100 411109 411110 $E $mu [expr $fy *   1.0]  0.60   0.00 24.50 26.90  0.96 12.90 4020.00 3.500 4.000 2 1; Spring_PZ    911200 411209 411210 $E $mu [expr $fy *   1.0]  0.60   0.56 24.50 26.90  0.96 12.90 4020.00 3.500 4.000 2 1; Spring_PZ    911300 411309 411310 $E $mu [expr $fy *   1.0]  0.60   0.56 24.50 26.90  0.96 12.90 4020.00 3.500 4.000 2 1; Spring_PZ    911400 411409 411410 $E $mu [expr $fy *   1.0]  0.60   0.00 24.50 26.90  0.96 12.90 4020.00 3.500 4.000 2 1; 
Spring_PZ    910100 410109 410110 $E $mu [expr $fy *   1.0]  0.60   0.00 24.50 26.90  0.96 12.90 4020.00 3.500 4.000 2 1; Spring_PZ    910200 410209 410210 $E $mu [expr $fy *   1.0]  0.60   0.56 24.50 26.90  0.96 12.90 4020.00 3.500 4.000 2 1; Spring_PZ    910300 410309 410310 $E $mu [expr $fy *   1.0]  0.60   0.56 24.50 26.90  0.96 12.90 4020.00 3.500 4.000 2 1; Spring_PZ    910400 410409 410410 $E $mu [expr $fy *   1.0]  0.60   0.00 24.50 26.90  0.96 12.90 4020.00 3.500 4.000 2 1; 
Spring_PZ    909100 409109 409110 $E $mu [expr $fy *   1.0]  0.60   0.06 24.50 30.00  0.96 12.90 4020.00 3.500 4.000 2 1; Spring_PZ    909200 409209 409210 $E $mu [expr $fy *   1.0]  0.75   0.63 25.20 30.00  1.34 12.90 5680.00 3.500 4.000 2 1; Spring_PZ    909300 409309 409310 $E $mu [expr $fy *   1.0]  0.75   0.63 25.20 30.00  1.34 12.90 5680.00 3.500 4.000 2 1; Spring_PZ    909400 409409 409410 $E $mu [expr $fy *   1.0]  0.60   0.06 24.50 30.00  0.96 12.90 4020.00 3.500 4.000 2 1; 
Spring_PZ    908100 408109 408110 $E $mu [expr $fy *   1.0]  0.60   0.06 24.50 30.00  0.96 12.90 4020.00 3.500 4.000 2 1; Spring_PZ    908200 408209 408210 $E $mu [expr $fy *   1.0]  0.75   0.63 25.20 30.00  1.34 12.90 5680.00 3.500 4.000 2 1; Spring_PZ    908300 408309 408310 $E $mu [expr $fy *   1.0]  0.75   0.63 25.20 30.00  1.34 12.90 5680.00 3.500 4.000 2 1; Spring_PZ    908400 408409 408410 $E $mu [expr $fy *   1.0]  0.60   0.06 24.50 30.00  0.96 12.90 4020.00 3.500 4.000 2 1; 
Spring_PZ    907100 407109 407110 $E $mu [expr $fy *   1.0]  0.70   0.00 25.00 30.00  1.22 13.00 5170.00 3.500 4.000 2 1; Spring_PZ    907200 407209 407210 $E $mu [expr $fy *   1.0]  0.87   0.44 25.70 30.00  1.57 13.00 6820.00 3.500 4.000 2 1; Spring_PZ    907300 407309 407310 $E $mu [expr $fy *   1.0]  0.87   0.44 25.70 30.00  1.57 13.00 6820.00 3.500 4.000 2 1; Spring_PZ    907400 407409 407410 $E $mu [expr $fy *   1.0]  0.70   0.00 25.00 30.00  1.22 13.00 5170.00 3.500 4.000 2 1; 
Spring_PZ    906100 406109 406110 $E $mu [expr $fy *   1.0]  0.70   0.00 25.00 30.00  1.22 13.00 5170.00 3.500 4.000 2 1; Spring_PZ    906200 406209 406210 $E $mu [expr $fy *   1.0]  0.87   0.44 25.70 30.00  1.57 13.00 6820.00 3.500 4.000 2 1; Spring_PZ    906300 406309 406310 $E $mu [expr $fy *   1.0]  0.87   0.44 25.70 30.00  1.57 13.00 6820.00 3.500 4.000 2 1; Spring_PZ    906400 406409 406410 $E $mu [expr $fy *   1.0]  0.70   0.00 25.00 30.00  1.22 13.00 5170.00 3.500 4.000 2 1; 
Spring_PZ    905100 405109 405110 $E $mu [expr $fy *   1.0]  0.81   0.00 25.50 30.30  1.46 13.00 6260.00 3.500 4.000 2 1; Spring_PZ    905200 405209 405210 $E $mu [expr $fy *   1.0]  1.04   0.38 26.30 30.30  1.89 13.20 8490.00 3.500 4.000 2 1; Spring_PZ    905300 405309 405310 $E $mu [expr $fy *   1.0]  1.04   0.38 26.30 30.30  1.89 13.20 8490.00 3.500 4.000 2 1; Spring_PZ    905400 405409 405410 $E $mu [expr $fy *   1.0]  0.81   0.00 25.50 30.30  1.46 13.00 6260.00 3.500 4.000 2 1; 
Spring_PZ    904100 404109 404110 $E $mu [expr $fy *   1.0]  0.81   0.00 25.50 30.30  1.46 13.00 6260.00 3.500 4.000 2 1; Spring_PZ    904200 404209 404210 $E $mu [expr $fy *   1.0]  1.04   0.38 26.30 30.30  1.89 13.20 8490.00 3.500 4.000 2 1; Spring_PZ    904300 404309 404310 $E $mu [expr $fy *   1.0]  1.04   0.38 26.30 30.30  1.89 13.20 8490.00 3.500 4.000 2 1; Spring_PZ    904400 404409 404410 $E $mu [expr $fy *   1.0]  0.81   0.00 25.50 30.30  1.46 13.00 6260.00 3.500 4.000 2 1; 
Spring_PZ    903100 403109 403110 $E $mu [expr $fy *   1.0]  0.96   0.00 26.00 30.30  1.73 13.10 7650.00 3.500 4.000 2 1; Spring_PZ    903200 403209 403210 $E $mu [expr $fy *   1.0]  1.16   0.19 26.70 30.30  2.09 13.30 9600.00 3.500 4.000 2 1; Spring_PZ    903300 403309 403310 $E $mu [expr $fy *   1.0]  1.16   0.19 26.70 30.30  2.09 13.30 9600.00 3.500 4.000 2 1; Spring_PZ    903400 403409 403410 $E $mu [expr $fy *   1.0]  0.96   0.00 26.00 30.30  1.73 13.10 7650.00 3.500 4.000 2 1; 
Spring_PZ    902100 402109 402110 $E $mu [expr $fy *   1.0]  0.96   0.00 26.00 30.20  1.73 13.10 7650.00 3.500 4.000 2 1; Spring_PZ    902200 402209 402210 $E $mu [expr $fy *   1.0]  1.16   0.06 26.70 30.20  2.09 13.30 9600.00 3.500 4.000 2 1; Spring_PZ    902300 402309 402310 $E $mu [expr $fy *   1.0]  1.16   0.06 26.70 30.20  2.09 13.30 9600.00 3.500 4.000 2 1; Spring_PZ    902400 402409 402410 $E $mu [expr $fy *   1.0]  0.96   0.00 26.00 30.20  1.73 13.10 7650.00 3.500 4.000 2 1; 

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
element ModElasticBeam2d   612100     1213     1311  24.7000 $E [expr ($n+1)/$n*2370.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   612200     1223     1321  27.7000 $E [expr ($n+1)/$n*2700.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   612300     1233     1331  27.7000 $E [expr ($n+1)/$n*2700.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   612400     1243     1341  24.7000 $E [expr ($n+1)/$n*2370.0000] $K11_2 $K33_2 $K44_2 $trans_selected; 
element ModElasticBeam2d   611102   111172     1211 24.7000 $E [expr ($n+1)/$n*2370.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   611202   111272     1221 27.7000 $E [expr ($n+1)/$n*2700.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   611302   111372     1231 27.7000 $E [expr ($n+1)/$n*2700.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   611402   111472     1241 24.7000 $E [expr ($n+1)/$n*2370.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  
element ModElasticBeam2d   611101     1113   111171 38.5000 $E [expr ($n+1)/$n*4020.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   611201     1123   111271 38.5000 $E [expr ($n+1)/$n*4020.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   611301     1133   111371 38.5000 $E [expr ($n+1)/$n*4020.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   611401     1143   111471 38.5000 $E [expr ($n+1)/$n*4020.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  
element ModElasticBeam2d   610100     1013     1111  38.5000 $E [expr ($n+1)/$n*4020.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   610200     1023     1121  38.5000 $E [expr ($n+1)/$n*4020.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   610300     1033     1131  38.5000 $E [expr ($n+1)/$n*4020.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   610400     1043     1141  38.5000 $E [expr ($n+1)/$n*4020.0000] $K11_2 $K33_2 $K44_2 $trans_selected; 
element ModElasticBeam2d   609102   109172     1011 38.5000 $E [expr ($n+1)/$n*4020.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   609202   109272     1021 38.5000 $E [expr ($n+1)/$n*4020.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   609302   109372     1031 38.5000 $E [expr ($n+1)/$n*4020.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   609402   109472     1041 38.5000 $E [expr ($n+1)/$n*4020.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  
element ModElasticBeam2d   609101      913   109171 38.5000 $E [expr ($n+1)/$n*4020.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   609201      923   109271 51.7000 $E [expr ($n+1)/$n*5680.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   609301      933   109371 51.7000 $E [expr ($n+1)/$n*5680.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   609401      943   109471 38.5000 $E [expr ($n+1)/$n*4020.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  
element ModElasticBeam2d   608100      813      911  38.5000 $E [expr ($n+1)/$n*4020.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   608200      823      921  51.7000 $E [expr ($n+1)/$n*5680.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   608300      833      931  51.7000 $E [expr ($n+1)/$n*5680.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   608400      843      941  38.5000 $E [expr ($n+1)/$n*4020.0000] $K11_2 $K33_2 $K44_2 $trans_selected; 
element ModElasticBeam2d   607102   107172      811 38.5000 $E [expr ($n+1)/$n*4020.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   607202   107272      821 51.7000 $E [expr ($n+1)/$n*5680.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   607302   107372      831 51.7000 $E [expr ($n+1)/$n*5680.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   607402   107472      841 38.5000 $E [expr ($n+1)/$n*4020.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  
element ModElasticBeam2d   607101      713   107171 47.7000 $E [expr ($n+1)/$n*5170.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   607201      723   107271 60.7000 $E [expr ($n+1)/$n*6820.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   607301      733   107371 60.7000 $E [expr ($n+1)/$n*6820.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   607401      743   107471 47.7000 $E [expr ($n+1)/$n*5170.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  
element ModElasticBeam2d   606100      613      711  47.7000 $E [expr ($n+1)/$n*5170.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   606200      623      721  60.7000 $E [expr ($n+1)/$n*6820.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   606300      633      731  60.7000 $E [expr ($n+1)/$n*6820.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   606400      643      741  47.7000 $E [expr ($n+1)/$n*5170.0000] $K11_2 $K33_2 $K44_2 $trans_selected; 
element ModElasticBeam2d   605102   105172      611 47.7000 $E [expr ($n+1)/$n*5170.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   605202   105272      621 60.7000 $E [expr ($n+1)/$n*6820.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   605302   105372      631 60.7000 $E [expr ($n+1)/$n*6820.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   605402   105472      641 47.7000 $E [expr ($n+1)/$n*5170.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  
element ModElasticBeam2d   605101      513   105171 56.3000 $E [expr ($n+1)/$n*6260.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   605201      523   105271 73.5000 $E [expr ($n+1)/$n*8490.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   605301      533   105371 73.5000 $E [expr ($n+1)/$n*8490.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   605401      543   105471 56.3000 $E [expr ($n+1)/$n*6260.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  
element ModElasticBeam2d   604100      413      511  56.3000 $E [expr ($n+1)/$n*6260.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   604200      423      521  73.5000 $E [expr ($n+1)/$n*8490.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   604300      433      531  73.5000 $E [expr ($n+1)/$n*8490.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   604400      443      541  56.3000 $E [expr ($n+1)/$n*6260.0000] $K11_2 $K33_2 $K44_2 $trans_selected; 
element ModElasticBeam2d   603102   103172      411 56.3000 $E [expr ($n+1)/$n*6260.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   603202   103272      421 73.5000 $E [expr ($n+1)/$n*8490.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   603302   103372      431 73.5000 $E [expr ($n+1)/$n*8490.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   603402   103472      441 56.3000 $E [expr ($n+1)/$n*6260.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  
element ModElasticBeam2d   603101      313   103171 67.2000 $E [expr ($n+1)/$n*7650.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   603201      323   103271 82.0000 $E [expr ($n+1)/$n*9600.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   603301      333   103371 82.0000 $E [expr ($n+1)/$n*9600.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   603401      343   103471 67.2000 $E [expr ($n+1)/$n*7650.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  
element ModElasticBeam2d   602100      213      311  67.2000 $E [expr ($n+1)/$n*7650.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   602200      223      321  82.0000 $E [expr ($n+1)/$n*9600.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   602300      233      331  82.0000 $E [expr ($n+1)/$n*9600.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   602400      243      341  67.2000 $E [expr ($n+1)/$n*7650.0000] $K11_2 $K33_2 $K44_2 $trans_selected; 
element ModElasticBeam2d   601100      113      211  67.2000 $E [expr ($n+1)/$n*7650.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   601200      123      221  82.0000 $E [expr ($n+1)/$n*9600.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   601300      133      231  82.0000 $E [expr ($n+1)/$n*9600.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   601400      143      241  67.2000 $E [expr ($n+1)/$n*7650.0000] $K11_2 $K33_2 $K44_2 $trans_selected; 

# BEAMS
element ModElasticBeam2d   513100     1314     1322  24.7000 $E [expr ($n+1)/$n*0.90*$Comp_I*2370.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   513200     1324     1332  24.7000 $E [expr ($n+1)/$n*0.90*$Comp_I*2370.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   513300     1334     1342  24.7000 $E [expr ($n+1)/$n*0.90*$Comp_I*2370.0000] $K11_2 $K33_2 $K44_2 $trans_selected; 
element ModElasticBeam2d   512100     1214     1222  24.7000 $E [expr ($n+1)/$n*0.90*$Comp_I*2370.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   512200     1224     1232  24.7000 $E [expr ($n+1)/$n*0.90*$Comp_I*2370.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   512300     1234     1242  24.7000 $E [expr ($n+1)/$n*0.90*$Comp_I*2370.0000] $K11_2 $K33_2 $K44_2 $trans_selected; 
element ModElasticBeam2d   511100     1114     1122  27.7000 $E [expr ($n+1)/$n*0.90*$Comp_I*3270.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   511200     1124     1132  27.7000 $E [expr ($n+1)/$n*0.90*$Comp_I*3270.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   511300     1134     1142  27.7000 $E [expr ($n+1)/$n*0.90*$Comp_I*3270.0000] $K11_2 $K33_2 $K44_2 $trans_selected; 
element ModElasticBeam2d   510100     1014     1022  27.7000 $E [expr ($n+1)/$n*0.90*$Comp_I*3270.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   510200     1024     1032  27.7000 $E [expr ($n+1)/$n*0.90*$Comp_I*3270.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   510300     1034     1042  27.7000 $E [expr ($n+1)/$n*0.90*$Comp_I*3270.0000] $K11_2 $K33_2 $K44_2 $trans_selected; 
element ModElasticBeam2d   509100      914      922  34.2000 $E [expr ($n+1)/$n*0.90*$Comp_I*4930.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   509200      924      932  34.2000 $E [expr ($n+1)/$n*0.90*$Comp_I*4930.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   509300      934      942  34.2000 $E [expr ($n+1)/$n*0.90*$Comp_I*4930.0000] $K11_2 $K33_2 $K44_2 $trans_selected; 
element ModElasticBeam2d   508100      814      822  34.2000 $E [expr ($n+1)/$n*0.90*$Comp_I*4930.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   508200      824      832  34.2000 $E [expr ($n+1)/$n*0.90*$Comp_I*4930.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   508300      834      842  34.2000 $E [expr ($n+1)/$n*0.90*$Comp_I*4930.0000] $K11_2 $K33_2 $K44_2 $trans_selected; 
element ModElasticBeam2d   507100      714      722  34.2000 $E [expr ($n+1)/$n*0.90*$Comp_I*4930.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   507200      724      732  34.2000 $E [expr ($n+1)/$n*0.90*$Comp_I*4930.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   507300      734      742  34.2000 $E [expr ($n+1)/$n*0.90*$Comp_I*4930.0000] $K11_2 $K33_2 $K44_2 $trans_selected; 
element ModElasticBeam2d   506100      614      622  34.2000 $E [expr ($n+1)/$n*0.90*$Comp_I*4930.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   506200      624      632  34.2000 $E [expr ($n+1)/$n*0.90*$Comp_I*4930.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   506300      634      642  34.2000 $E [expr ($n+1)/$n*0.90*$Comp_I*4930.0000] $K11_2 $K33_2 $K44_2 $trans_selected; 
element ModElasticBeam2d   505100      514      522  38.9000 $E [expr ($n+1)/$n*0.90*$Comp_I*5770.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   505200      524      532  38.9000 $E [expr ($n+1)/$n*0.90*$Comp_I*5770.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   505300      534      542  38.9000 $E [expr ($n+1)/$n*0.90*$Comp_I*5770.0000] $K11_2 $K33_2 $K44_2 $trans_selected; 
element ModElasticBeam2d   504100      414      422  38.9000 $E [expr ($n+1)/$n*0.90*$Comp_I*5770.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   504200      424      432  38.9000 $E [expr ($n+1)/$n*0.90*$Comp_I*5770.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   504300      434      442  38.9000 $E [expr ($n+1)/$n*0.90*$Comp_I*5770.0000] $K11_2 $K33_2 $K44_2 $trans_selected; 
element ModElasticBeam2d   503100      314      322  38.9000 $E [expr ($n+1)/$n*0.90*$Comp_I*5770.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   503200      324      332  38.9000 $E [expr ($n+1)/$n*0.90*$Comp_I*5770.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   503300      334      342  38.9000 $E [expr ($n+1)/$n*0.90*$Comp_I*5770.0000] $K11_2 $K33_2 $K44_2 $trans_selected; 
element ModElasticBeam2d   502100      214      222  36.5000 $E [expr ($n+1)/$n*0.90*$Comp_I*5360.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   502200      224      232  36.5000 $E [expr ($n+1)/$n*0.90*$Comp_I*5360.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   502300      234      242  36.5000 $E [expr ($n+1)/$n*0.90*$Comp_I*5360.0000] $K11_2 $K33_2 $K44_2 $trans_selected; 

####################################################################################################
#                                      ELASTIC RBS ELEMENTS                                        #
####################################################################################################

element elasticBeamColumn 513104 413104 13140 21.227 $E [expr $Comp_I*1897.290] 1; element elasticBeamColumn 513202 413202 13220 21.227 $E [expr $Comp_I*1897.290] 1; element elasticBeamColumn 513204 413204 13240 21.227 $E [expr $Comp_I*1897.290] 1; element elasticBeamColumn 513302 413302 13320 21.227 $E [expr $Comp_I*1897.290] 1; element elasticBeamColumn 513304 413304 13340 21.227 $E [expr $Comp_I*1897.290] 1; element elasticBeamColumn 513402 413402 13420 21.227 $E [expr $Comp_I*1897.290] 1; 
element elasticBeamColumn 512104 412104 12140 21.227 $E [expr $Comp_I*1897.290] 1; element elasticBeamColumn 512202 412202 12220 21.227 $E [expr $Comp_I*1897.290] 1; element elasticBeamColumn 512204 412204 12240 21.227 $E [expr $Comp_I*1897.290] 1; element elasticBeamColumn 512302 412302 12320 21.227 $E [expr $Comp_I*1897.290] 1; element elasticBeamColumn 512304 412304 12340 21.227 $E [expr $Comp_I*1897.290] 1; element elasticBeamColumn 512402 412402 12420 21.227 $E [expr $Comp_I*1897.290] 1; 
element elasticBeamColumn 511104 411104 11140 23.979 $E [expr $Comp_I*2633.412] 1; element elasticBeamColumn 511202 411202 11220 23.979 $E [expr $Comp_I*2633.412] 1; element elasticBeamColumn 511204 411204 11240 23.979 $E [expr $Comp_I*2633.412] 1; element elasticBeamColumn 511302 411302 11320 23.979 $E [expr $Comp_I*2633.412] 1; element elasticBeamColumn 511304 411304 11340 23.979 $E [expr $Comp_I*2633.412] 1; element elasticBeamColumn 511402 411402 11420 23.979 $E [expr $Comp_I*2633.412] 1; 
element elasticBeamColumn 510104 410104 10140 23.979 $E [expr $Comp_I*2633.412] 1; element elasticBeamColumn 510202 410202 10220 23.979 $E [expr $Comp_I*2633.412] 1; element elasticBeamColumn 510204 410204 10240 23.979 $E [expr $Comp_I*2633.412] 1; element elasticBeamColumn 510302 410302 10320 23.979 $E [expr $Comp_I*2633.412] 1; element elasticBeamColumn 510304 410304 10340 23.979 $E [expr $Comp_I*2633.412] 1; element elasticBeamColumn 510402 410402 10420 23.979 $E [expr $Comp_I*2633.412] 1; 
element elasticBeamColumn 509104 409104 9140 29.738 $E [expr $Comp_I*3981.760] 1; element elasticBeamColumn 509202 409202 9220 29.738 $E [expr $Comp_I*3981.760] 1; element elasticBeamColumn 509204 409204 9240 29.738 $E [expr $Comp_I*3981.760] 1; element elasticBeamColumn 509302 409302 9320 29.738 $E [expr $Comp_I*3981.760] 1; element elasticBeamColumn 509304 409304 9340 29.738 $E [expr $Comp_I*3981.760] 1; element elasticBeamColumn 509402 409402 9420 29.738 $E [expr $Comp_I*3981.760] 1; 
element elasticBeamColumn 508104 408104 8140 29.738 $E [expr $Comp_I*3981.760] 1; element elasticBeamColumn 508202 408202 8220 29.738 $E [expr $Comp_I*3981.760] 1; element elasticBeamColumn 508204 408204 8240 29.738 $E [expr $Comp_I*3981.760] 1; element elasticBeamColumn 508302 408302 8320 29.738 $E [expr $Comp_I*3981.760] 1; element elasticBeamColumn 508304 408304 8340 29.738 $E [expr $Comp_I*3981.760] 1; element elasticBeamColumn 508402 408402 8420 29.738 $E [expr $Comp_I*3981.760] 1; 
element elasticBeamColumn 507104 407104 7140 29.738 $E [expr $Comp_I*3981.760] 1; element elasticBeamColumn 507202 407202 7220 29.738 $E [expr $Comp_I*3981.760] 1; element elasticBeamColumn 507204 407204 7240 29.738 $E [expr $Comp_I*3981.760] 1; element elasticBeamColumn 507302 407302 7320 29.738 $E [expr $Comp_I*3981.760] 1; element elasticBeamColumn 507304 407304 7340 29.738 $E [expr $Comp_I*3981.760] 1; element elasticBeamColumn 507402 407402 7420 29.738 $E [expr $Comp_I*3981.760] 1; 
element elasticBeamColumn 506104 406104 6140 29.738 $E [expr $Comp_I*3981.760] 1; element elasticBeamColumn 506202 406202 6220 29.738 $E [expr $Comp_I*3981.760] 1; element elasticBeamColumn 506204 406204 6240 29.738 $E [expr $Comp_I*3981.760] 1; element elasticBeamColumn 506302 406302 6320 29.738 $E [expr $Comp_I*3981.760] 1; element elasticBeamColumn 506304 406304 6340 29.738 $E [expr $Comp_I*3981.760] 1; element elasticBeamColumn 506402 406402 6420 29.738 $E [expr $Comp_I*3981.760] 1; 
element elasticBeamColumn 505104 405104 5140 33.650 $E [expr $Comp_I*4642.794] 1; element elasticBeamColumn 505202 405202 5220 33.650 $E [expr $Comp_I*4642.794] 1; element elasticBeamColumn 505204 405204 5240 33.650 $E [expr $Comp_I*4642.794] 1; element elasticBeamColumn 505302 405302 5320 33.650 $E [expr $Comp_I*4642.794] 1; element elasticBeamColumn 505304 405304 5340 33.650 $E [expr $Comp_I*4642.794] 1; element elasticBeamColumn 505402 405402 5420 33.650 $E [expr $Comp_I*4642.794] 1; 
element elasticBeamColumn 504104 404104 4140 33.650 $E [expr $Comp_I*4642.794] 1; element elasticBeamColumn 504202 404202 4220 33.650 $E [expr $Comp_I*4642.794] 1; element elasticBeamColumn 504204 404204 4240 33.650 $E [expr $Comp_I*4642.794] 1; element elasticBeamColumn 504302 404302 4320 33.650 $E [expr $Comp_I*4642.794] 1; element elasticBeamColumn 504304 404304 4340 33.650 $E [expr $Comp_I*4642.794] 1; element elasticBeamColumn 504402 404402 4420 33.650 $E [expr $Comp_I*4642.794] 1; 
element elasticBeamColumn 503104 403104 3140 33.650 $E [expr $Comp_I*4642.794] 1; element elasticBeamColumn 503202 403202 3220 33.650 $E [expr $Comp_I*4642.794] 1; element elasticBeamColumn 503204 403204 3240 33.650 $E [expr $Comp_I*4642.794] 1; element elasticBeamColumn 503302 403302 3320 33.650 $E [expr $Comp_I*4642.794] 1; element elasticBeamColumn 503304 403304 3340 33.650 $E [expr $Comp_I*4642.794] 1; element elasticBeamColumn 503402 403402 3420 33.650 $E [expr $Comp_I*4642.794] 1; 
element elasticBeamColumn 502104 402104 2140 31.617 $E [expr $Comp_I*4313.898] 1; element elasticBeamColumn 502202 402202 2220 31.617 $E [expr $Comp_I*4313.898] 1; element elasticBeamColumn 502204 402204 2240 31.617 $E [expr $Comp_I*4313.898] 1; element elasticBeamColumn 502302 402302 2320 31.617 $E [expr $Comp_I*4313.898] 1; element elasticBeamColumn 502304 402304 2340 31.617 $E [expr $Comp_I*4313.898] 1; element elasticBeamColumn 502402 402402 2420 31.617 $E [expr $Comp_I*4313.898] 1; 

###################################################################################################
#                                           MF BEAM SPRINGS                                       #
###################################################################################################

# Command Syntax 
# Spring_IMK SpringID iNode jNode E fy Ix d htw bftf ry L Ls Lb My PgPye CompositeFLAG MFconnection Units; 

Spring_IMK 913104 1314 13140 $E $fy [expr $Comp_I*1424.581] 24.100 45.900 5.860 1.950 186.450 93.225 107.900 8519.618 0.0 $Composite 0 2; Spring_IMK 913202 13220 1322 $E $fy [expr $Comp_I*1424.581] 24.100 45.900 5.860 1.950 186.450 93.225 107.900 8519.618 0.0 $Composite 0 2; Spring_IMK 913204 1324 13240 $E $fy [expr $Comp_I*1424.581] 24.100 45.900 5.860 1.950 186.450 93.225 107.900 8519.618 0.0 $Composite 0 2; Spring_IMK 913302 13320 1332 $E $fy [expr $Comp_I*1424.581] 24.100 45.900 5.860 1.950 186.350 93.175 107.850 8519.618 0.0 $Composite 0 2; Spring_IMK 913304 1334 13340 $E $fy [expr $Comp_I*1424.581] 24.100 45.900 5.860 1.950 186.350 93.175 107.850 8519.618 0.0 $Composite 0 2; Spring_IMK 913402 13420 1342 $E $fy [expr $Comp_I*1424.581] 24.100 45.900 5.860 1.950 186.450 93.225 107.900 8519.618 0.0 $Composite 0 2; 
Spring_IMK 912104 1214 12140 $E $fy [expr $Comp_I*1424.581] 24.100 45.900 5.860 1.950 186.450 93.225 107.900 8519.618 0.0 $Composite 0 2; Spring_IMK 912202 12220 1222 $E $fy [expr $Comp_I*1424.581] 24.100 45.900 5.860 1.950 186.450 93.225 107.900 8519.618 0.0 $Composite 0 2; Spring_IMK 912204 1224 12240 $E $fy [expr $Comp_I*1424.581] 24.100 45.900 5.860 1.950 186.450 93.225 107.900 8519.618 0.0 $Composite 0 2; Spring_IMK 912302 12320 1232 $E $fy [expr $Comp_I*1424.581] 24.100 45.900 5.860 1.950 186.350 93.175 107.850 8519.618 0.0 $Composite 0 2; Spring_IMK 912304 1234 12340 $E $fy [expr $Comp_I*1424.581] 24.100 45.900 5.860 1.950 186.350 93.175 107.850 8519.618 0.0 $Composite 0 2; Spring_IMK 912402 12420 1242 $E $fy [expr $Comp_I*1424.581] 24.100 45.900 5.860 1.950 186.450 93.225 107.900 8519.618 0.0 $Composite 0 2; 
Spring_IMK 911104 1114 11140 $E $fy [expr $Comp_I*1996.823] 26.900 49.500 6.700 2.120 182.838 91.419 107.750 10673.670 0.0 $Composite 0 2; Spring_IMK 911202 11220 1122 $E $fy [expr $Comp_I*1996.823] 26.900 49.500 6.700 2.120 182.838 91.419 107.750 10673.670 0.0 $Composite 0 2; Spring_IMK 911204 1124 11240 $E $fy [expr $Comp_I*1996.823] 26.900 49.500 6.700 2.120 182.838 91.419 107.750 10673.670 0.0 $Composite 0 2; Spring_IMK 911302 11320 1132 $E $fy [expr $Comp_I*1996.823] 26.900 49.500 6.700 2.120 182.838 91.419 107.750 10673.670 0.0 $Composite 0 2; Spring_IMK 911304 1134 11340 $E $fy [expr $Comp_I*1996.823] 26.900 49.500 6.700 2.120 182.838 91.419 107.750 10673.670 0.0 $Composite 0 2; Spring_IMK 911402 11420 1142 $E $fy [expr $Comp_I*1996.823] 26.900 49.500 6.700 2.120 182.838 91.419 107.750 10673.670 0.0 $Composite 0 2; 
Spring_IMK 910104 1014 10140 $E $fy [expr $Comp_I*1996.823] 26.900 49.500 6.700 2.120 182.838 91.419 107.750 10673.670 0.0 $Composite 0 2; Spring_IMK 910202 10220 1022 $E $fy [expr $Comp_I*1996.823] 26.900 49.500 6.700 2.120 182.838 91.419 107.750 10673.670 0.0 $Composite 0 2; Spring_IMK 910204 1024 10240 $E $fy [expr $Comp_I*1996.823] 26.900 49.500 6.700 2.120 182.838 91.419 107.750 10673.670 0.0 $Composite 0 2; Spring_IMK 910302 10320 1032 $E $fy [expr $Comp_I*1996.823] 26.900 49.500 6.700 2.120 182.838 91.419 107.750 10673.670 0.0 $Composite 0 2; Spring_IMK 910304 1034 10340 $E $fy [expr $Comp_I*1996.823] 26.900 49.500 6.700 2.120 182.838 91.419 107.750 10673.670 0.0 $Composite 0 2; Spring_IMK 910402 10420 1042 $E $fy [expr $Comp_I*1996.823] 26.900 49.500 6.700 2.120 182.838 91.419 107.750 10673.670 0.0 $Composite 0 2; 
Spring_IMK 909104 914 9140 $E $fy [expr $Comp_I*3033.519] 30.000 47.800 6.170 2.190 179.525 89.763 107.575 14714.059 0.0 $Composite 0 2; Spring_IMK 909202 9220 922 $E $fy [expr $Comp_I*3033.519] 30.000 47.800 6.170 2.190 179.525 89.763 107.575 14714.059 0.0 $Composite 0 2; Spring_IMK 909204 924 9240 $E $fy [expr $Comp_I*3033.519] 30.000 47.800 6.170 2.190 179.525 89.763 107.575 14714.059 0.0 $Composite 0 2; Spring_IMK 909302 9320 932 $E $fy [expr $Comp_I*3033.519] 30.000 47.800 6.170 2.190 179.175 89.588 107.400 14714.059 0.0 $Composite 0 2; Spring_IMK 909304 934 9340 $E $fy [expr $Comp_I*3033.519] 30.000 47.800 6.170 2.190 179.175 89.588 107.400 14714.059 0.0 $Composite 0 2; Spring_IMK 909402 9420 942 $E $fy [expr $Comp_I*3033.519] 30.000 47.800 6.170 2.190 179.525 89.763 107.575 14714.059 0.0 $Composite 0 2; 
Spring_IMK 908104 814 8140 $E $fy [expr $Comp_I*3033.519] 30.000 47.800 6.170 2.190 179.525 89.763 107.575 14714.059 0.0 $Composite 0 2; Spring_IMK 908202 8220 822 $E $fy [expr $Comp_I*3033.519] 30.000 47.800 6.170 2.190 179.525 89.763 107.575 14714.059 0.0 $Composite 0 2; Spring_IMK 908204 824 8240 $E $fy [expr $Comp_I*3033.519] 30.000 47.800 6.170 2.190 179.525 89.763 107.575 14714.059 0.0 $Composite 0 2; Spring_IMK 908302 8320 832 $E $fy [expr $Comp_I*3033.519] 30.000 47.800 6.170 2.190 179.175 89.588 107.400 14714.059 0.0 $Composite 0 2; Spring_IMK 908304 834 8340 $E $fy [expr $Comp_I*3033.519] 30.000 47.800 6.170 2.190 179.175 89.588 107.400 14714.059 0.0 $Composite 0 2; Spring_IMK 908402 8420 842 $E $fy [expr $Comp_I*3033.519] 30.000 47.800 6.170 2.190 179.525 89.763 107.575 14714.059 0.0 $Composite 0 2; 
Spring_IMK 907104 714 7140 $E $fy [expr $Comp_I*3033.519] 30.000 47.800 6.170 2.190 179.025 89.513 107.325 14714.059 0.0 $Composite 0 2; Spring_IMK 907202 7220 722 $E $fy [expr $Comp_I*3033.519] 30.000 47.800 6.170 2.190 179.025 89.513 107.325 14714.059 0.0 $Composite 0 2; Spring_IMK 907204 724 7240 $E $fy [expr $Comp_I*3033.519] 30.000 47.800 6.170 2.190 179.025 89.513 107.325 14714.059 0.0 $Composite 0 2; Spring_IMK 907302 7320 732 $E $fy [expr $Comp_I*3033.519] 30.000 47.800 6.170 2.190 178.675 89.338 107.150 14714.059 0.0 $Composite 0 2; Spring_IMK 907304 734 7340 $E $fy [expr $Comp_I*3033.519] 30.000 47.800 6.170 2.190 178.675 89.338 107.150 14714.059 0.0 $Composite 0 2; Spring_IMK 907402 7420 742 $E $fy [expr $Comp_I*3033.519] 30.000 47.800 6.170 2.190 179.025 89.513 107.325 14714.059 0.0 $Composite 0 2; 
Spring_IMK 906104 614 6140 $E $fy [expr $Comp_I*3033.519] 30.000 47.800 6.170 2.190 179.025 89.513 107.325 14714.059 0.0 $Composite 0 2; Spring_IMK 906202 6220 622 $E $fy [expr $Comp_I*3033.519] 30.000 47.800 6.170 2.190 179.025 89.513 107.325 14714.059 0.0 $Composite 0 2; Spring_IMK 906204 624 6240 $E $fy [expr $Comp_I*3033.519] 30.000 47.800 6.170 2.190 179.025 89.513 107.325 14714.059 0.0 $Composite 0 2; Spring_IMK 906302 6320 632 $E $fy [expr $Comp_I*3033.519] 30.000 47.800 6.170 2.190 178.675 89.338 107.150 14714.059 0.0 $Composite 0 2; Spring_IMK 906304 634 6340 $E $fy [expr $Comp_I*3033.519] 30.000 47.800 6.170 2.190 178.675 89.338 107.150 14714.059 0.0 $Composite 0 2; Spring_IMK 906402 6420 642 $E $fy [expr $Comp_I*3033.519] 30.000 47.800 6.170 2.190 179.025 89.513 107.325 14714.059 0.0 $Composite 0 2; 
Spring_IMK 905104 514 5140 $E $fy [expr $Comp_I*3515.589] 30.300 43.900 5.270 2.250 178.250 89.125 107.050 16756.191 0.0 $Composite 0 2; Spring_IMK 905202 5220 522 $E $fy [expr $Comp_I*3515.589] 30.300 43.900 5.270 2.250 178.250 89.125 107.050 16756.191 0.0 $Composite 0 2; Spring_IMK 905204 524 5240 $E $fy [expr $Comp_I*3515.589] 30.300 43.900 5.270 2.250 178.250 89.125 107.050 16756.191 0.0 $Composite 0 2; Spring_IMK 905302 5320 532 $E $fy [expr $Comp_I*3515.589] 30.300 43.900 5.270 2.250 177.850 88.925 106.850 16756.191 0.0 $Composite 0 2; Spring_IMK 905304 534 5340 $E $fy [expr $Comp_I*3515.589] 30.300 43.900 5.270 2.250 177.850 88.925 106.850 16756.191 0.0 $Composite 0 2; Spring_IMK 905402 5420 542 $E $fy [expr $Comp_I*3515.589] 30.300 43.900 5.270 2.250 178.250 89.125 107.050 16756.191 0.0 $Composite 0 2; 
Spring_IMK 904104 414 4140 $E $fy [expr $Comp_I*3515.589] 30.300 43.900 5.270 2.250 178.250 89.125 107.050 16756.191 0.0 $Composite 0 2; Spring_IMK 904202 4220 422 $E $fy [expr $Comp_I*3515.589] 30.300 43.900 5.270 2.250 178.250 89.125 107.050 16756.191 0.0 $Composite 0 2; Spring_IMK 904204 424 4240 $E $fy [expr $Comp_I*3515.589] 30.300 43.900 5.270 2.250 178.250 89.125 107.050 16756.191 0.0 $Composite 0 2; Spring_IMK 904302 4320 432 $E $fy [expr $Comp_I*3515.589] 30.300 43.900 5.270 2.250 177.850 88.925 106.850 16756.191 0.0 $Composite 0 2; Spring_IMK 904304 434 4340 $E $fy [expr $Comp_I*3515.589] 30.300 43.900 5.270 2.250 177.850 88.925 106.850 16756.191 0.0 $Composite 0 2; Spring_IMK 904402 4420 442 $E $fy [expr $Comp_I*3515.589] 30.300 43.900 5.270 2.250 178.250 89.125 107.050 16756.191 0.0 $Composite 0 2; 
Spring_IMK 903104 314 3140 $E $fy [expr $Comp_I*3515.589] 30.300 43.900 5.270 2.250 177.800 88.900 106.825 16756.191 0.0 $Composite 0 2; Spring_IMK 903202 3220 322 $E $fy [expr $Comp_I*3515.589] 30.300 43.900 5.270 2.250 177.800 88.900 106.825 16756.191 0.0 $Composite 0 2; Spring_IMK 903204 324 3240 $E $fy [expr $Comp_I*3515.589] 30.300 43.900 5.270 2.250 177.800 88.900 106.825 16756.191 0.0 $Composite 0 2; Spring_IMK 903302 3320 332 $E $fy [expr $Comp_I*3515.589] 30.300 43.900 5.270 2.250 177.450 88.725 106.650 16756.191 0.0 $Composite 0 2; Spring_IMK 903304 334 3340 $E $fy [expr $Comp_I*3515.589] 30.300 43.900 5.270 2.250 177.450 88.725 106.650 16756.191 0.0 $Composite 0 2; Spring_IMK 903402 3420 342 $E $fy [expr $Comp_I*3515.589] 30.300 43.900 5.270 2.250 177.800 88.900 106.825 16756.191 0.0 $Composite 0 2; 
Spring_IMK 902104 214 2140 $E $fy [expr $Comp_I*3267.797] 30.200 46.200 5.650 2.230 177.875 88.938 106.825 15752.523 0.0 $Composite 0 2; Spring_IMK 902202 2220 222 $E $fy [expr $Comp_I*3267.797] 30.200 46.200 5.650 2.230 177.875 88.938 106.825 15752.523 0.0 $Composite 0 2; Spring_IMK 902204 224 2240 $E $fy [expr $Comp_I*3267.797] 30.200 46.200 5.650 2.230 177.875 88.938 106.825 15752.523 0.0 $Composite 0 2; Spring_IMK 902302 2320 232 $E $fy [expr $Comp_I*3267.797] 30.200 46.200 5.650 2.230 177.525 88.763 106.650 15752.523 0.0 $Composite 0 2; Spring_IMK 902304 234 2340 $E $fy [expr $Comp_I*3267.797] 30.200 46.200 5.650 2.230 177.525 88.763 106.650 15752.523 0.0 $Composite 0 2; Spring_IMK 902402 2420 242 $E $fy [expr $Comp_I*3267.797] 30.200 46.200 5.650 2.230 177.875 88.938 106.825 15752.523 0.0 $Composite 0 2; 

###################################################################################################
#                                           MF COLUMN SPRINGS                                     #
###################################################################################################

Spring_IMK  913101  413101    1311 $E $fy 2370.0000 24.1000 45.9000 5.8600 1.9500 131.9000 65.9500 131.9000 13552.0000 0.0172  0 0 2; Spring_IMK  913201  413201    1321 $E $fy 2700.0000 24.3000 41.9000 5.1800 1.9800 131.9000 65.9500 131.9000 15367.0000 0.0230  0 0 2; Spring_IMK  913301  413301    1331 $E $fy 2700.0000 24.3000 41.9000 5.1800 1.9800 131.9000 65.9500 131.9000 15367.0000 0.0230  0 0 2; Spring_IMK  913401  413401    1341 $E $fy 2370.0000 24.1000 45.9000 5.8600 1.9500 131.9000 65.9500 131.9000 13552.0000 0.0172  0 0 2; 
Spring_IMK  912103  412103    1213 $E $fy 2370.0000 24.1000 45.9000 5.8600 1.9500 131.9000 65.9500 131.9000 13552.0000 0.0172  0 0 2; Spring_IMK  912203  412203    1223 $E $fy 2700.0000 24.3000 41.9000 5.1800 1.9800 131.9000 65.9500 131.9000 15367.0000 0.0230  0 0 2; Spring_IMK  912303  412303    1233 $E $fy 2700.0000 24.3000 41.9000 5.1800 1.9800 131.9000 65.9500 131.9000 15367.0000 0.0230  0 0 2; Spring_IMK  912403  412403    1243 $E $fy 2370.0000 24.1000 45.9000 5.8600 1.9500 131.9000 65.9500 131.9000 13552.0000 0.0172  0 0 2; 
Spring_IMK  912101  412101    1211 $E $fy 2370.0000 24.1000 45.9000 5.8600 1.9500 131.9000 65.9500 131.9000 13552.0000 0.0379  0 0 2; Spring_IMK  912201  412201    1221 $E $fy 2700.0000 24.3000 41.9000 5.1800 1.9800 131.9000 65.9500 131.9000 15367.0000 0.0507  0 0 2; Spring_IMK  912301  412301    1231 $E $fy 2700.0000 24.3000 41.9000 5.1800 1.9800 131.9000 65.9500 131.9000 15367.0000 0.0507  0 0 2; Spring_IMK  912401  412401    1241 $E $fy 2370.0000 24.1000 45.9000 5.8600 1.9500 131.9000 65.9500 131.9000 13552.0000 0.0379  0 0 2; 
Spring_IMK  911103  411103    1113 $E $fy 4020.0000 24.5000 35.6000 6.7000 2.9700 130.5000 65.2500 130.5000 22385.0000 0.0243  0 0 2; Spring_IMK  911203  411203    1123 $E $fy 4020.0000 24.5000 35.6000 6.7000 2.9700 130.5000 65.2500 130.5000 22385.0000 0.0365  0 0 2; Spring_IMK  911303  411303    1133 $E $fy 4020.0000 24.5000 35.6000 6.7000 2.9700 130.5000 65.2500 130.5000 22385.0000 0.0365  0 0 2; Spring_IMK  911403  411403    1143 $E $fy 4020.0000 24.5000 35.6000 6.7000 2.9700 130.5000 65.2500 130.5000 22385.0000 0.0243  0 0 2; 
Spring_IMK  911101  411101    1111 $E $fy 4020.0000 24.5000 35.6000 6.7000 2.9700 129.1000 64.5500 129.1000 22385.0000 0.0377  0 0 2; Spring_IMK  911201  411201    1121 $E $fy 4020.0000 24.5000 35.6000 6.7000 2.9700 129.1000 64.5500 129.1000 22385.0000 0.0565  0 0 2; Spring_IMK  911301  411301    1131 $E $fy 4020.0000 24.5000 35.6000 6.7000 2.9700 129.1000 64.5500 129.1000 22385.0000 0.0565  0 0 2; Spring_IMK  911401  411401    1141 $E $fy 4020.0000 24.5000 35.6000 6.7000 2.9700 129.1000 64.5500 129.1000 22385.0000 0.0377  0 0 2; 
Spring_IMK  910103  410103    1013 $E $fy 4020.0000 24.5000 35.6000 6.7000 2.9700 129.1000 64.5500 129.1000 22385.0000 0.0377  0 0 2; Spring_IMK  910203  410203    1023 $E $fy 4020.0000 24.5000 35.6000 6.7000 2.9700 129.1000 64.5500 129.1000 22385.0000 0.0565  0 0 2; Spring_IMK  910303  410303    1033 $E $fy 4020.0000 24.5000 35.6000 6.7000 2.9700 129.1000 64.5500 129.1000 22385.0000 0.0565  0 0 2; Spring_IMK  910403  410403    1043 $E $fy 4020.0000 24.5000 35.6000 6.7000 2.9700 129.1000 64.5500 129.1000 22385.0000 0.0377  0 0 2; 
Spring_IMK  910101  410101    1011 $E $fy 4020.0000 24.5000 35.6000 6.7000 2.9700 129.1000 64.5500 129.1000 22385.0000 0.0510  0 0 2; Spring_IMK  910201  410201    1021 $E $fy 4020.0000 24.5000 35.6000 6.7000 2.9700 129.1000 64.5500 129.1000 22385.0000 0.0765  0 0 2; Spring_IMK  910301  410301    1031 $E $fy 4020.0000 24.5000 35.6000 6.7000 2.9700 129.1000 64.5500 129.1000 22385.0000 0.0765  0 0 2; Spring_IMK  910401  410401    1041 $E $fy 4020.0000 24.5000 35.6000 6.7000 2.9700 129.1000 64.5500 129.1000 22385.0000 0.0510  0 0 2; 
Spring_IMK  909103  409103     913 $E $fy 4020.0000 24.5000 35.6000 6.7000 2.9700 127.5500 63.7750 127.5500 22385.0000 0.0510  0 0 2; Spring_IMK  909203  409203     923 $E $fy 5680.0000 25.2000 28.7000 4.8100 3.0400 127.5500 63.7750 127.5500 30915.5000 0.0570  0 0 2; Spring_IMK  909303  409303     933 $E $fy 5680.0000 25.2000 28.7000 4.8100 3.0400 127.5500 63.7750 127.5500 30915.5000 0.0570  0 0 2; Spring_IMK  909403  409403     943 $E $fy 4020.0000 24.5000 35.6000 6.7000 2.9700 127.5500 63.7750 127.5500 22385.0000 0.0510  0 0 2; 
Spring_IMK  909101  409101     911 $E $fy 4020.0000 24.5000 35.6000 6.7000 2.9700 126.0000 63.0000 126.0000 22385.0000 0.0643  0 0 2; Spring_IMK  909201  409201     921 $E $fy 5680.0000 25.2000 28.7000 4.8100 3.0400 126.0000 63.0000 126.0000 30915.5000 0.0719  0 0 2; Spring_IMK  909301  409301     931 $E $fy 5680.0000 25.2000 28.7000 4.8100 3.0400 126.0000 63.0000 126.0000 30915.5000 0.0719  0 0 2; Spring_IMK  909401  409401     941 $E $fy 4020.0000 24.5000 35.6000 6.7000 2.9700 126.0000 63.0000 126.0000 22385.0000 0.0643  0 0 2; 
Spring_IMK  908103  408103     813 $E $fy 4020.0000 24.5000 35.6000 6.7000 2.9700 126.0000 63.0000 126.0000 22385.0000 0.0643  0 0 2; Spring_IMK  908203  408203     823 $E $fy 5680.0000 25.2000 28.7000 4.8100 3.0400 126.0000 63.0000 126.0000 30915.5000 0.0719  0 0 2; Spring_IMK  908303  408303     833 $E $fy 5680.0000 25.2000 28.7000 4.8100 3.0400 126.0000 63.0000 126.0000 30915.5000 0.0719  0 0 2; Spring_IMK  908403  408403     843 $E $fy 4020.0000 24.5000 35.6000 6.7000 2.9700 126.0000 63.0000 126.0000 22385.0000 0.0643  0 0 2; 
Spring_IMK  908101  408101     811 $E $fy 4020.0000 24.5000 35.6000 6.7000 2.9700 126.0000 63.0000 126.0000 22385.0000 0.0777  0 0 2; Spring_IMK  908201  408201     821 $E $fy 5680.0000 25.2000 28.7000 4.8100 3.0400 126.0000 63.0000 126.0000 30915.5000 0.0867  0 0 2; Spring_IMK  908301  408301     831 $E $fy 5680.0000 25.2000 28.7000 4.8100 3.0400 126.0000 63.0000 126.0000 30915.5000 0.0867  0 0 2; Spring_IMK  908401  408401     841 $E $fy 4020.0000 24.5000 35.6000 6.7000 2.9700 126.0000 63.0000 126.0000 22385.0000 0.0777  0 0 2; 
Spring_IMK  907103  407103     713 $E $fy 5170.0000 25.0000 30.6000 5.3100 3.0500 126.0000 63.0000 126.0000 28314.0000 0.0627  0 0 2; Spring_IMK  907203  407203     723 $E $fy 6820.0000 25.7000 24.8000 4.1400 3.0800 126.0000 63.0000 126.0000 36663.0000 0.0739  0 0 2; Spring_IMK  907303  407303     733 $E $fy 6820.0000 25.7000 24.8000 4.1400 3.0800 126.0000 63.0000 126.0000 36663.0000 0.0739  0 0 2; Spring_IMK  907403  407403     743 $E $fy 5170.0000 25.0000 30.6000 5.3100 3.0500 126.0000 63.0000 126.0000 28314.0000 0.0627  0 0 2; 
Spring_IMK  907101  407101     711 $E $fy 5170.0000 25.0000 30.6000 5.3100 3.0500 126.0000 63.0000 126.0000 28314.0000 0.0734  0 0 2; Spring_IMK  907201  407201     721 $E $fy 6820.0000 25.7000 24.8000 4.1400 3.0800 126.0000 63.0000 126.0000 36663.0000 0.0866  0 0 2; Spring_IMK  907301  407301     731 $E $fy 6820.0000 25.7000 24.8000 4.1400 3.0800 126.0000 63.0000 126.0000 36663.0000 0.0866  0 0 2; Spring_IMK  907401  407401     741 $E $fy 5170.0000 25.0000 30.6000 5.3100 3.0500 126.0000 63.0000 126.0000 28314.0000 0.0734  0 0 2; 
Spring_IMK  906103  406103     613 $E $fy 5170.0000 25.0000 30.6000 5.3100 3.0500 126.0000 63.0000 126.0000 28314.0000 0.0734  0 0 2; Spring_IMK  906203  406203     623 $E $fy 6820.0000 25.7000 24.8000 4.1400 3.0800 126.0000 63.0000 126.0000 36663.0000 0.0866  0 0 2; Spring_IMK  906303  406303     633 $E $fy 6820.0000 25.7000 24.8000 4.1400 3.0800 126.0000 63.0000 126.0000 36663.0000 0.0866  0 0 2; Spring_IMK  906403  406403     643 $E $fy 5170.0000 25.0000 30.6000 5.3100 3.0500 126.0000 63.0000 126.0000 28314.0000 0.0734  0 0 2; 
Spring_IMK  906101  406101     611 $E $fy 5170.0000 25.0000 30.6000 5.3100 3.0500 126.0000 63.0000 126.0000 28314.0000 0.0842  0 0 2; Spring_IMK  906201  406201     621 $E $fy 6820.0000 25.7000 24.8000 4.1400 3.0800 126.0000 63.0000 126.0000 36663.0000 0.0992  0 0 2; Spring_IMK  906301  406301     631 $E $fy 6820.0000 25.7000 24.8000 4.1400 3.0800 126.0000 63.0000 126.0000 36663.0000 0.0992  0 0 2; Spring_IMK  906401  406401     641 $E $fy 5170.0000 25.0000 30.6000 5.3100 3.0500 126.0000 63.0000 126.0000 28314.0000 0.0842  0 0 2; 
Spring_IMK  905103  405103     513 $E $fy 6260.0000 25.5000 26.6000 4.4300 3.0700 125.8500 62.9250 125.8500 33819.5000 0.0713  0 0 2; Spring_IMK  905203  405203     523 $E $fy 8490.0000 26.3000 20.7000 3.4900 3.1400 125.8500 62.9250 125.8500 45012.0000 0.0820  0 0 2; Spring_IMK  905303  405303     533 $E $fy 8490.0000 26.3000 20.7000 3.4900 3.1400 125.8500 62.9250 125.8500 45012.0000 0.0820  0 0 2; Spring_IMK  905403  405403     543 $E $fy 6260.0000 25.5000 26.6000 4.4300 3.0700 125.8500 62.9250 125.8500 33819.5000 0.0713  0 0 2; 
Spring_IMK  905101  405101     511 $E $fy 6260.0000 25.5000 26.6000 4.4300 3.0700 125.7000 62.8500 125.7000 33819.5000 0.0804  0 0 2; Spring_IMK  905201  405201     521 $E $fy 8490.0000 26.3000 20.7000 3.4900 3.1400 125.7000 62.8500 125.7000 45012.0000 0.0924  0 0 2; Spring_IMK  905301  405301     531 $E $fy 8490.0000 26.3000 20.7000 3.4900 3.1400 125.7000 62.8500 125.7000 45012.0000 0.0924  0 0 2; Spring_IMK  905401  405401     541 $E $fy 6260.0000 25.5000 26.6000 4.4300 3.0700 125.7000 62.8500 125.7000 33819.5000 0.0804  0 0 2; 
Spring_IMK  904103  404103     413 $E $fy 6260.0000 25.5000 26.6000 4.4300 3.0700 125.7000 62.8500 125.7000 33819.5000 0.0804  0 0 2; Spring_IMK  904203  404203     423 $E $fy 8490.0000 26.3000 20.7000 3.4900 3.1400 125.7000 62.8500 125.7000 45012.0000 0.0924  0 0 2; Spring_IMK  904303  404303     433 $E $fy 8490.0000 26.3000 20.7000 3.4900 3.1400 125.7000 62.8500 125.7000 45012.0000 0.0924  0 0 2; Spring_IMK  904403  404403     443 $E $fy 6260.0000 25.5000 26.6000 4.4300 3.0700 125.7000 62.8500 125.7000 33819.5000 0.0804  0 0 2; 
Spring_IMK  904101  404101     411 $E $fy 6260.0000 25.5000 26.6000 4.4300 3.0700 125.7000 62.8500 125.7000 33819.5000 0.0896  0 0 2; Spring_IMK  904201  404201     421 $E $fy 8490.0000 26.3000 20.7000 3.4900 3.1400 125.7000 62.8500 125.7000 45012.0000 0.1029  0 0 2; Spring_IMK  904301  404301     431 $E $fy 8490.0000 26.3000 20.7000 3.4900 3.1400 125.7000 62.8500 125.7000 45012.0000 0.1029  0 0 2; Spring_IMK  904401  404401     441 $E $fy 6260.0000 25.5000 26.6000 4.4300 3.0700 125.7000 62.8500 125.7000 33819.5000 0.0896  0 0 2; 
Spring_IMK  903103  403103     313 $E $fy 7650.0000 26.0000 22.5000 3.7900 3.1100 125.7000 62.8500 125.7000 40837.5000 0.0750  0 0 2; Spring_IMK  903203  403203     323 $E $fy 9600.0000 26.7000 18.6000 3.1800 3.1700 125.7000 62.8500 125.7000 50517.5000 0.0922  0 0 2; Spring_IMK  903303  403303     333 $E $fy 9600.0000 26.7000 18.6000 3.1800 3.1700 125.7000 62.8500 125.7000 50517.5000 0.0922  0 0 2; Spring_IMK  903403  403403     343 $E $fy 7650.0000 26.0000 22.5000 3.7900 3.1100 125.7000 62.8500 125.7000 40837.5000 0.0750  0 0 2; 
Spring_IMK  903101  403101     311 $E $fy 7650.0000 26.0000 22.5000 3.7900 3.1100 125.7000 62.8500 125.7000 40837.5000 0.0827  0 0 2; Spring_IMK  903201  403201     321 $E $fy 9600.0000 26.7000 18.6000 3.1800 3.1700 125.7000 62.8500 125.7000 50517.5000 0.1016  0 0 2; Spring_IMK  903301  403301     331 $E $fy 9600.0000 26.7000 18.6000 3.1800 3.1700 125.7000 62.8500 125.7000 50517.5000 0.1016  0 0 2; Spring_IMK  903401  403401     341 $E $fy 7650.0000 26.0000 22.5000 3.7900 3.1100 125.7000 62.8500 125.7000 40837.5000 0.0827  0 0 2; 
Spring_IMK  902103  402103     213 $E $fy 7650.0000 26.0000 22.5000 3.7900 3.1100 125.7500 62.8750 125.7500 40837.5000 0.0827  0 0 2; Spring_IMK  902203  402203     223 $E $fy 9600.0000 26.7000 18.6000 3.1800 3.1700 125.7500 62.8750 125.7500 50517.5000 0.1016  0 0 2; Spring_IMK  902303  402303     233 $E $fy 9600.0000 26.7000 18.6000 3.1800 3.1700 125.7500 62.8750 125.7500 50517.5000 0.1016  0 0 2; Spring_IMK  902403  402403     243 $E $fy 7650.0000 26.0000 22.5000 3.7900 3.1100 125.7500 62.8750 125.7500 40837.5000 0.0827  0 0 2; 
Spring_IMK  902101  402101     211 $E $fy 7650.0000 26.0000 22.5000 3.7900 3.1100 164.9000 82.4500 164.9000 40837.5000 0.0905  0 0 2; Spring_IMK  902201  402201     221 $E $fy 9600.0000 26.7000 18.6000 3.1800 3.1700 164.9000 82.4500 164.9000 50517.5000 0.1112  0 0 2; Spring_IMK  902301  402301     231 $E $fy 9600.0000 26.7000 18.6000 3.1800 3.1700 164.9000 82.4500 164.9000 50517.5000 0.1112  0 0 2; Spring_IMK  902401  402401     241 $E $fy 7650.0000 26.0000 22.5000 3.7900 3.1100 164.9000 82.4500 164.9000 40837.5000 0.0905  0 0 2; 
Spring_IMK  901103     110     113 $E $fy 7650.0000 26.0000 22.5000 3.7900 3.1100 164.9000 82.4500 164.9000 40837.5000 0.0905  0 0 2; Spring_IMK  901203     120     123 $E $fy 9600.0000 26.7000 18.6000 3.1800 3.1700 164.9000 82.4500 164.9000 50517.5000 0.1112  0 0 2; Spring_IMK  901303     130     133 $E $fy 9600.0000 26.7000 18.6000 3.1800 3.1700 164.9000 82.4500 164.9000 50517.5000 0.1112  0 0 2; Spring_IMK  901403     140     143 $E $fy 7650.0000 26.0000 22.5000 3.7900 3.1100 164.9000 82.4500 164.9000 40837.5000 0.0905  0 0 2; 

###################################################################################################
#                                          COLUMN SPLICE SPRINGS                                  #
###################################################################################################

Spring_Rigid 911107 111171 111172; 
Spring_Rigid 911207 111271 111272; 
Spring_Rigid 911307 111371 111372; 
Spring_Rigid 911407 111471 111472; 
Spring_Rigid 911507 111571 111572; 
Spring_Rigid 911607 111671 111672; 
Spring_Rigid 909107 109171 109172; 
Spring_Rigid 909207 109271 109272; 
Spring_Rigid 909307 109371 109372; 
Spring_Rigid 909407 109471 109472; 
Spring_Rigid 909507 109571 109572; 
Spring_Rigid 909607 109671 109672; 
Spring_Rigid 907107 107171 107172; 
Spring_Rigid 907207 107271 107272; 
Spring_Rigid 907307 107371 107372; 
Spring_Rigid 907407 107471 107472; 
Spring_Rigid 907507 107571 107572; 
Spring_Rigid 907607 107671 107672; 
Spring_Rigid 905107 105171 105172; 
Spring_Rigid 905207 105271 105272; 
Spring_Rigid 905307 105371 105372; 
Spring_Rigid 905407 105471 105472; 
Spring_Rigid 905507 105571 105572; 
Spring_Rigid 905607 105671 105672; 
Spring_Rigid 903107 103171 103172; 
Spring_Rigid 903207 103271 103272; 
Spring_Rigid 903307 103371 103372; 
Spring_Rigid 903407 103471 103472; 
Spring_Rigid 903507 103571 103572; 
Spring_Rigid 903607 103671 103672; 

####################################################################################################
#                                              FLOOR LINKS                                         #
####################################################################################################

# Command Syntax 
# element truss $ElementID $iNode $jNode $Area $matID
element truss 1013 413404 1350 $A_Stiff 99;
element truss 1012 412404 1250 $A_Stiff 99;
element truss 1011 411404 1150 $A_Stiff 99;
element truss 1010 410404 1050 $A_Stiff 99;
element truss 1009 409404 950 $A_Stiff 99;
element truss 1008 408404 850 $A_Stiff 99;
element truss 1007 407404 750 $A_Stiff 99;
element truss 1006 406404 650 $A_Stiff 99;
element truss 1005 405404 550 $A_Stiff 99;
element truss 1004 404404 450 $A_Stiff 99;
element truss 1003 403404 350 $A_Stiff 99;
element truss 1002 402404 250 $A_Stiff 99;

####################################################################################################
#                                          EGF COLUMNS AND BEAMS                                   #
####################################################################################################

# GRAVITY COLUMNS
element elasticBeamColumn  612500    1253    1351 100000.0000 $E 100000000.0000 $trans_PDelta; element elasticBeamColumn  612600    1263    1361 100000.0000 $E 100000000.0000 $trans_PDelta; 
element elasticBeamColumn  611502  111572    1251 100000.0000 $E 100000000.0000 $trans_PDelta; element elasticBeamColumn  611602  111672    1261 100000.0000 $E 100000000.0000 $trans_PDelta; 
element elasticBeamColumn  611501    1153  111571 100000.0000 $E 100000000.0000 $trans_PDelta; element elasticBeamColumn  611601    1163  111671 100000.0000 $E 100000000.0000 $trans_PDelta; 
element elasticBeamColumn  610500    1053    1151 100000.0000 $E 100000000.0000 $trans_PDelta; element elasticBeamColumn  610600    1063    1161 100000.0000 $E 100000000.0000 $trans_PDelta; 
element elasticBeamColumn  609502  109572    1051 100000.0000 $E 100000000.0000 $trans_PDelta; element elasticBeamColumn  609602  109672    1061 100000.0000 $E 100000000.0000 $trans_PDelta; 
element elasticBeamColumn  609501     953  109571 100000.0000 $E 100000000.0000 $trans_PDelta; element elasticBeamColumn  609601     963  109671 100000.0000 $E 100000000.0000 $trans_PDelta; 
element elasticBeamColumn  608500     853     951 100000.0000 $E 100000000.0000 $trans_PDelta; element elasticBeamColumn  608600     863     961 100000.0000 $E 100000000.0000 $trans_PDelta; 
element elasticBeamColumn  607502  107572     851 100000.0000 $E 100000000.0000 $trans_PDelta; element elasticBeamColumn  607602  107672     861 100000.0000 $E 100000000.0000 $trans_PDelta; 
element elasticBeamColumn  607501     753  107571 100000.0000 $E 100000000.0000 $trans_PDelta; element elasticBeamColumn  607601     763  107671 100000.0000 $E 100000000.0000 $trans_PDelta; 
element elasticBeamColumn  606500     653     751 100000.0000 $E 100000000.0000 $trans_PDelta; element elasticBeamColumn  606600     663     761 100000.0000 $E 100000000.0000 $trans_PDelta; 
element elasticBeamColumn  605502  105572     651 100000.0000 $E 100000000.0000 $trans_PDelta; element elasticBeamColumn  605602  105672     661 100000.0000 $E 100000000.0000 $trans_PDelta; 
element elasticBeamColumn  605501     553  105571 100000.0000 $E 100000000.0000 $trans_PDelta; element elasticBeamColumn  605601     563  105671 100000.0000 $E 100000000.0000 $trans_PDelta; 
element elasticBeamColumn  604500     453     551 100000.0000 $E 100000000.0000 $trans_PDelta; element elasticBeamColumn  604600     463     561 100000.0000 $E 100000000.0000 $trans_PDelta; 
element elasticBeamColumn  603502  103572     451 100000.0000 $E 100000000.0000 $trans_PDelta; element elasticBeamColumn  603602  103672     461 100000.0000 $E 100000000.0000 $trans_PDelta; 
element elasticBeamColumn  603501     353  103571 100000.0000 $E 100000000.0000 $trans_PDelta; element elasticBeamColumn  603601     363  103671 100000.0000 $E 100000000.0000 $trans_PDelta; 
element elasticBeamColumn  602500     253     351 100000.0000 $E 100000000.0000 $trans_PDelta; element elasticBeamColumn  602600     263     361 100000.0000 $E 100000000.0000 $trans_PDelta; 
element elasticBeamColumn  601500     153     251 100000.0000 $E 100000000.0000 $trans_PDelta; element elasticBeamColumn  601600     163     261 100000.0000 $E 100000000.0000 $trans_PDelta; 

# GRAVITY BEAMS
element elasticBeamColumn  513400    1354    1362 100000.0000 $E 100000000.0000 $trans_PDelta;
element elasticBeamColumn  512400    1254    1262 100000.0000 $E 100000000.0000 $trans_PDelta;
element elasticBeamColumn  511400    1154    1162 100000.0000 $E 100000000.0000 $trans_PDelta;
element elasticBeamColumn  510400    1054    1062 100000.0000 $E 100000000.0000 $trans_PDelta;
element elasticBeamColumn  509400     954     962 100000.0000 $E 100000000.0000 $trans_PDelta;
element elasticBeamColumn  508400     854     862 100000.0000 $E 100000000.0000 $trans_PDelta;
element elasticBeamColumn  507400     754     762 100000.0000 $E 100000000.0000 $trans_PDelta;
element elasticBeamColumn  506400     654     662 100000.0000 $E 100000000.0000 $trans_PDelta;
element elasticBeamColumn  505400     554     562 100000.0000 $E 100000000.0000 $trans_PDelta;
element elasticBeamColumn  504400     454     462 100000.0000 $E 100000000.0000 $trans_PDelta;
element elasticBeamColumn  503400     354     362 100000.0000 $E 100000000.0000 $trans_PDelta;
element elasticBeamColumn  502400     254     262 100000.0000 $E 100000000.0000 $trans_PDelta;

# GRAVITY COLUMNS SPRINGS
Spring_Zero  913501    1350    1351; Spring_Zero  913601    1360    1361; 
Spring_Zero  912503    1250    1253; Spring_Zero  912603    1260    1263; 
Spring_Zero  912501    1250    1251; Spring_Zero  912601    1260    1261; 
Spring_Zero  911503    1150    1153; Spring_Zero  911603    1160    1163; 
Spring_Zero  911501    1150    1151; Spring_Zero  911601    1160    1161; 
Spring_Zero  910503    1050    1053; Spring_Zero  910603    1060    1063; 
Spring_Zero  910501    1050    1051; Spring_Zero  910601    1060    1061; 
Spring_Zero  909503     950     953; Spring_Zero  909603     960     963; 
Spring_Zero  909501     950     951; Spring_Zero  909601     960     961; 
Spring_Zero  908503     850     853; Spring_Zero  908603     860     863; 
Spring_Zero  908501     850     851; Spring_Zero  908601     860     861; 
Spring_Zero  907503     750     753; Spring_Zero  907603     760     763; 
Spring_Zero  907501     750     751; Spring_Zero  907601     760     761; 
Spring_Zero  906503     650     653; Spring_Zero  906603     660     663; 
Spring_Zero  906501     650     651; Spring_Zero  906601     660     661; 
Spring_Zero  905503     550     553; Spring_Zero  905603     560     563; 
Spring_Zero  905501     550     551; Spring_Zero  905601     560     561; 
Spring_Zero  904503     450     453; Spring_Zero  904603     460     463; 
Spring_Zero  904501     450     451; Spring_Zero  904601     460     461; 
Spring_Zero  903503     350     353; Spring_Zero  903603     360     363; 
Spring_Zero  903501     350     351; Spring_Zero  903601     360     361; 
Spring_Zero  902503     250     253; Spring_Zero  902603     260     263; 
Spring_Zero  902501     250     251; Spring_Zero  902601     260     261; 
Spring_Zero  901503     150     153; Spring_Zero  901603     160     163; 

# GRAVITY BEAMS SPRINGS
Spring_Rigid  913504    1350    1354; Spring_Rigid  913602    1360    1362; 
Spring_Rigid  912504    1250    1254; Spring_Rigid  912602    1260    1262; 
Spring_Rigid  911504    1150    1154; Spring_Rigid  911602    1160    1162; 
Spring_Rigid  910504    1050    1054; Spring_Rigid  910602    1060    1062; 
Spring_Rigid  909504     950     954; Spring_Rigid  909602     960     962; 
Spring_Rigid  908504     850     854; Spring_Rigid  908602     860     862; 
Spring_Rigid  907504     750     754; Spring_Rigid  907602     760     762; 
Spring_Rigid  906504     650     654; Spring_Rigid  906602     660     662; 
Spring_Rigid  905504     550     554; Spring_Rigid  905602     560     562; 
Spring_Rigid  904504     450     454; Spring_Rigid  904602     460     462; 
Spring_Rigid  903504     350     354; Spring_Rigid  903602     360     362; 
Spring_Rigid  902504     250     254; Spring_Rigid  902602     260     262; 

###################################################################################################
#                                       BOUNDARY CONDITIONS                                       #
###################################################################################################

# MF SUPPORTS
fix 110 1 1 1; 
fix 120 1 1 1; 
fix 130 1 1 1; 
fix 140 1 1 1; 

# EGF SUPPORTS
fix 150 1 1 0; fix 160 1 1 0; 

# MF FLOOR MOVEMENT
equalDOF 413104 413204 1; equalDOF 413104 413304 1; equalDOF 413104 413404 1; 
equalDOF 412104 412204 1; equalDOF 412104 412304 1; equalDOF 412104 412404 1; 
equalDOF 411104 411204 1; equalDOF 411104 411304 1; equalDOF 411104 411404 1; 
equalDOF 410104 410204 1; equalDOF 410104 410304 1; equalDOF 410104 410404 1; 
equalDOF 409104 409204 1; equalDOF 409104 409304 1; equalDOF 409104 409404 1; 
equalDOF 408104 408204 1; equalDOF 408104 408304 1; equalDOF 408104 408404 1; 
equalDOF 407104 407204 1; equalDOF 407104 407304 1; equalDOF 407104 407404 1; 
equalDOF 406104 406204 1; equalDOF 406104 406304 1; equalDOF 406104 406404 1; 
equalDOF 405104 405204 1; equalDOF 405104 405304 1; equalDOF 405104 405404 1; 
equalDOF 404104 404204 1; equalDOF 404104 404304 1; equalDOF 404104 404404 1; 
equalDOF 403104 403204 1; equalDOF 403104 403304 1; equalDOF 403104 403404 1; 
equalDOF 402104 402204 1; equalDOF 402104 402304 1; equalDOF 402104 402404 1; 

# EGF FLOOR MOVEMENT
equalDOF 1350 1360 1;
equalDOF 1250 1260 1;
equalDOF 1150 1160 1;
equalDOF 1050 1060 1;
equalDOF 950 960 1;
equalDOF 850 860 1;
equalDOF 750 760 1;
equalDOF 650 660 1;
equalDOF 550 560 1;
equalDOF 450 460 1;
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
recorder Node -file $MainFolder/EigenAnalysis/EigenVectorsMode1.out -node 402104 403104 404104 405104 406104 407104 408104 409104 410104 411104 412104 413104  -dof 1 "eigen  1";
recorder Node -file $MainFolder/EigenAnalysis/EigenVectorsMode2.out -node 402104 403104 404104 405104 406104 407104 408104 409104 410104 411104 412104 413104  -dof 1 "eigen  2";
recorder Node -file $MainFolder/EigenAnalysis/EigenVectorsMode3.out -node 402104 403104 404104 405104 406104 407104 408104 409104 410104 411104 412104 413104  -dof 1 "eigen  3";
recorder Node -file $MainFolder/EigenAnalysis/EigenVectorsMode4.out -node 402104 403104 404104 405104 406104 407104 408104 409104 410104 411104 412104 413104  -dof 1 "eigen  4";
recorder Node -file $MainFolder/EigenAnalysis/EigenVectorsMode5.out -node 402104 403104 404104 405104 406104 407104 408104 409104 410104 411104 412104 413104  -dof 1 "eigen  5";
recorder Node -file $MainFolder/EigenAnalysis/EigenVectorsMode6.out -node 402104 403104 404104 405104 406104 407104 408104 409104 410104 411104 412104 413104  -dof 1 "eigen  6";
recorder Node -file $MainFolder/EigenAnalysis/EigenVectorsMode7.out -node 402104 403104 404104 405104 406104 407104 408104 409104 410104 411104 412104 413104  -dof 1 "eigen  7";
recorder Node -file $MainFolder/EigenAnalysis/EigenVectorsMode8.out -node 402104 403104 404104 405104 406104 407104 408104 409104 410104 411104 412104 413104  -dof 1 "eigen  8";
recorder Node -file $MainFolder/EigenAnalysis/EigenVectorsMode9.out -node 402104 403104 404104 405104 406104 407104 408104 409104 410104 411104 412104 413104  -dof 1 "eigen  9";
recorder Node -file $MainFolder/EigenAnalysis/EigenVectorsMode10.out -node 402104 403104 404104 405104 406104 407104 408104 409104 410104 411104 412104 413104  -dof 1 "eigen  10";
recorder Node -file $MainFolder/EigenAnalysis/EigenVectorsMode11.out -node 402104 403104 404104 405104 406104 407104 408104 409104 410104 411104 412104 413104  -dof 1 "eigen  11";
recorder Node -file $MainFolder/EigenAnalysis/EigenVectorsMode12.out -node 402104 403104 404104 405104 406104 407104 408104 409104 410104 411104 412104 413104  -dof 1 "eigen  12";

# TIME
recorder Node -file $MainFolder/$SubFolder/Time.out  -time -node 110 -dof 1 disp;

# SUPPORT REACTIONS
recorder Node -file $MainFolder/$SubFolder/Support1.out -node     110 -dof 1 2 6 reaction; recorder Node -file $MainFolder/$SubFolder/Support2.out -node     120 -dof 1 2 6 reaction; recorder Node -file $MainFolder/$SubFolder/Support3.out -node     130 -dof 1 2 6 reaction; recorder Node -file $MainFolder/$SubFolder/Support4.out -node     140 -dof 1 2 6 reaction; recorder Node -file $MainFolder/$SubFolder/Support5.out -node     150 -dof 1 2 6 reaction; recorder Node -file $MainFolder/$SubFolder/Support6.out -node     160 -dof 1 2 6 reaction; 

# STORY DRIFT RATIO
recorder Drift -file $MainFolder/$SubFolder/SDR12_MF.out -iNode  412104 -jNode  413104 -dof 1 -perpDirn 2; 
recorder Drift -file $MainFolder/$SubFolder/SDR11_MF.out -iNode  411104 -jNode  412104 -dof 1 -perpDirn 2; 
recorder Drift -file $MainFolder/$SubFolder/SDR10_MF.out -iNode  410104 -jNode  411104 -dof 1 -perpDirn 2; 
recorder Drift -file $MainFolder/$SubFolder/SDR9_MF.out -iNode  409104 -jNode  410104 -dof 1 -perpDirn 2; 
recorder Drift -file $MainFolder/$SubFolder/SDR8_MF.out -iNode  408104 -jNode  409104 -dof 1 -perpDirn 2; 
recorder Drift -file $MainFolder/$SubFolder/SDR7_MF.out -iNode  407104 -jNode  408104 -dof 1 -perpDirn 2; 
recorder Drift -file $MainFolder/$SubFolder/SDR6_MF.out -iNode  406104 -jNode  407104 -dof 1 -perpDirn 2; 
recorder Drift -file $MainFolder/$SubFolder/SDR5_MF.out -iNode  405104 -jNode  406104 -dof 1 -perpDirn 2; 
recorder Drift -file $MainFolder/$SubFolder/SDR4_MF.out -iNode  404104 -jNode  405104 -dof 1 -perpDirn 2; 
recorder Drift -file $MainFolder/$SubFolder/SDR3_MF.out -iNode  403104 -jNode  404104 -dof 1 -perpDirn 2; 
recorder Drift -file $MainFolder/$SubFolder/SDR2_MF.out -iNode  402104 -jNode  403104 -dof 1 -perpDirn 2; 
recorder Drift -file $MainFolder/$SubFolder/SDR1_MF.out -iNode     110 -jNode  402104 -dof 1 -perpDirn 2; 

# COLUMN ELASTIC ELEMENT FORCES
recorder Element -file $MainFolder/$SubFolder/Column121.out -ele  612100 force; recorder Element -file $MainFolder/$SubFolder/Column122.out -ele  612200 force; recorder Element -file $MainFolder/$SubFolder/Column123.out -ele  612300 force; recorder Element -file $MainFolder/$SubFolder/Column124.out -ele  612400 force; recorder Element -file $MainFolder/$SubFolder/Column125.out -ele  612500 force; recorder Element -file $MainFolder/$SubFolder/Column126.out -ele  612600 force; 
recorder Element -file $MainFolder/$SubFolder/Column111.out -ele  611101 force; recorder Element -file $MainFolder/$SubFolder/Column112.out -ele  611201 force; recorder Element -file $MainFolder/$SubFolder/Column113.out -ele  611301 force; recorder Element -file $MainFolder/$SubFolder/Column114.out -ele  611401 force; recorder Element -file $MainFolder/$SubFolder/Column115.out -ele  611501 force; recorder Element -file $MainFolder/$SubFolder/Column116.out -ele  611601 force; 
recorder Element -file $MainFolder/$SubFolder/Column101.out -ele  610100 force; recorder Element -file $MainFolder/$SubFolder/Column102.out -ele  610200 force; recorder Element -file $MainFolder/$SubFolder/Column103.out -ele  610300 force; recorder Element -file $MainFolder/$SubFolder/Column104.out -ele  610400 force; recorder Element -file $MainFolder/$SubFolder/Column105.out -ele  610500 force; recorder Element -file $MainFolder/$SubFolder/Column106.out -ele  610600 force; 
recorder Element -file $MainFolder/$SubFolder/Column91.out -ele  609101 force; recorder Element -file $MainFolder/$SubFolder/Column92.out -ele  609201 force; recorder Element -file $MainFolder/$SubFolder/Column93.out -ele  609301 force; recorder Element -file $MainFolder/$SubFolder/Column94.out -ele  609401 force; recorder Element -file $MainFolder/$SubFolder/Column95.out -ele  609501 force; recorder Element -file $MainFolder/$SubFolder/Column96.out -ele  609601 force; 
recorder Element -file $MainFolder/$SubFolder/Column81.out -ele  608100 force; recorder Element -file $MainFolder/$SubFolder/Column82.out -ele  608200 force; recorder Element -file $MainFolder/$SubFolder/Column83.out -ele  608300 force; recorder Element -file $MainFolder/$SubFolder/Column84.out -ele  608400 force; recorder Element -file $MainFolder/$SubFolder/Column85.out -ele  608500 force; recorder Element -file $MainFolder/$SubFolder/Column86.out -ele  608600 force; 
recorder Element -file $MainFolder/$SubFolder/Column71.out -ele  607101 force; recorder Element -file $MainFolder/$SubFolder/Column72.out -ele  607201 force; recorder Element -file $MainFolder/$SubFolder/Column73.out -ele  607301 force; recorder Element -file $MainFolder/$SubFolder/Column74.out -ele  607401 force; recorder Element -file $MainFolder/$SubFolder/Column75.out -ele  607501 force; recorder Element -file $MainFolder/$SubFolder/Column76.out -ele  607601 force; 
recorder Element -file $MainFolder/$SubFolder/Column61.out -ele  606100 force; recorder Element -file $MainFolder/$SubFolder/Column62.out -ele  606200 force; recorder Element -file $MainFolder/$SubFolder/Column63.out -ele  606300 force; recorder Element -file $MainFolder/$SubFolder/Column64.out -ele  606400 force; recorder Element -file $MainFolder/$SubFolder/Column65.out -ele  606500 force; recorder Element -file $MainFolder/$SubFolder/Column66.out -ele  606600 force; 
recorder Element -file $MainFolder/$SubFolder/Column51.out -ele  605101 force; recorder Element -file $MainFolder/$SubFolder/Column52.out -ele  605201 force; recorder Element -file $MainFolder/$SubFolder/Column53.out -ele  605301 force; recorder Element -file $MainFolder/$SubFolder/Column54.out -ele  605401 force; recorder Element -file $MainFolder/$SubFolder/Column55.out -ele  605501 force; recorder Element -file $MainFolder/$SubFolder/Column56.out -ele  605601 force; 
recorder Element -file $MainFolder/$SubFolder/Column41.out -ele  604100 force; recorder Element -file $MainFolder/$SubFolder/Column42.out -ele  604200 force; recorder Element -file $MainFolder/$SubFolder/Column43.out -ele  604300 force; recorder Element -file $MainFolder/$SubFolder/Column44.out -ele  604400 force; recorder Element -file $MainFolder/$SubFolder/Column45.out -ele  604500 force; recorder Element -file $MainFolder/$SubFolder/Column46.out -ele  604600 force; 
recorder Element -file $MainFolder/$SubFolder/Column31.out -ele  603101 force; recorder Element -file $MainFolder/$SubFolder/Column32.out -ele  603201 force; recorder Element -file $MainFolder/$SubFolder/Column33.out -ele  603301 force; recorder Element -file $MainFolder/$SubFolder/Column34.out -ele  603401 force; recorder Element -file $MainFolder/$SubFolder/Column35.out -ele  603501 force; recorder Element -file $MainFolder/$SubFolder/Column36.out -ele  603601 force; 
recorder Element -file $MainFolder/$SubFolder/Column21.out -ele  602100 force; recorder Element -file $MainFolder/$SubFolder/Column22.out -ele  602200 force; recorder Element -file $MainFolder/$SubFolder/Column23.out -ele  602300 force; recorder Element -file $MainFolder/$SubFolder/Column24.out -ele  602400 force; recorder Element -file $MainFolder/$SubFolder/Column25.out -ele  602500 force; recorder Element -file $MainFolder/$SubFolder/Column26.out -ele  602600 force; 
recorder Element -file $MainFolder/$SubFolder/Column11.out -ele  601100 force; recorder Element -file $MainFolder/$SubFolder/Column12.out -ele  601200 force; recorder Element -file $MainFolder/$SubFolder/Column13.out -ele  601300 force; recorder Element -file $MainFolder/$SubFolder/Column14.out -ele  601400 force; recorder Element -file $MainFolder/$SubFolder/Column15.out -ele  601500 force; recorder Element -file $MainFolder/$SubFolder/Column16.out -ele  601600 force; 

###################################################################################################
#                                              NODAL MASS                                         #
###################################################################################################

set g 386.10;
mass 413104 0.1476  1.e-9 1.e-9; mass 413204 0.1709  1.e-9 1.e-9; mass 413304 0.1709  1.e-9 1.e-9; mass 413404 0.1709  1.e-9 1.e-9; mass 1350 0.5361  1.e-9 1.e-9; mass 1360 0.5361  1.e-9 1.e-9; 
mass 412104 0.2486  1.e-9 1.e-9; mass 412204 0.2720  1.e-9 1.e-9; mass 412304 0.2720  1.e-9 1.e-9; mass 412404 0.2720  1.e-9 1.e-9; mass 1250 0.3846  1.e-9 1.e-9; mass 1260 0.3846  1.e-9 1.e-9; 
mass 411104 0.2486  1.e-9 1.e-9; mass 411204 0.2720  1.e-9 1.e-9; mass 411304 0.2720  1.e-9 1.e-9; mass 411404 0.2720  1.e-9 1.e-9; mass 1150 0.3846  1.e-9 1.e-9; mass 1160 0.3846  1.e-9 1.e-9; 
mass 410104 0.2486  1.e-9 1.e-9; mass 410204 0.2720  1.e-9 1.e-9; mass 410304 0.2720  1.e-9 1.e-9; mass 410404 0.2720  1.e-9 1.e-9; mass 1050 0.3846  1.e-9 1.e-9; mass 1060 0.3846  1.e-9 1.e-9; 
mass 409104 0.2486  1.e-9 1.e-9; mass 409204 0.2720  1.e-9 1.e-9; mass 409304 0.2720  1.e-9 1.e-9; mass 409404 0.2720  1.e-9 1.e-9; mass 950 0.3846  1.e-9 1.e-9; mass 960 0.3846  1.e-9 1.e-9; 
mass 408104 0.2486  1.e-9 1.e-9; mass 408204 0.2720  1.e-9 1.e-9; mass 408304 0.2720  1.e-9 1.e-9; mass 408404 0.2720  1.e-9 1.e-9; mass 850 0.3846  1.e-9 1.e-9; mass 860 0.3846  1.e-9 1.e-9; 
mass 407104 0.2486  1.e-9 1.e-9; mass 407204 0.2720  1.e-9 1.e-9; mass 407304 0.2720  1.e-9 1.e-9; mass 407404 0.2720  1.e-9 1.e-9; mass 750 0.3846  1.e-9 1.e-9; mass 760 0.3846  1.e-9 1.e-9; 
mass 406104 0.2486  1.e-9 1.e-9; mass 406204 0.2720  1.e-9 1.e-9; mass 406304 0.2720  1.e-9 1.e-9; mass 406404 0.2720  1.e-9 1.e-9; mass 650 0.3846  1.e-9 1.e-9; mass 660 0.3846  1.e-9 1.e-9; 
mass 405104 0.2486  1.e-9 1.e-9; mass 405204 0.2720  1.e-9 1.e-9; mass 405304 0.2720  1.e-9 1.e-9; mass 405404 0.2720  1.e-9 1.e-9; mass 550 0.3846  1.e-9 1.e-9; mass 560 0.3846  1.e-9 1.e-9; 
mass 404104 0.2486  1.e-9 1.e-9; mass 404204 0.2720  1.e-9 1.e-9; mass 404304 0.2720  1.e-9 1.e-9; mass 404404 0.2720  1.e-9 1.e-9; mass 450 0.3846  1.e-9 1.e-9; mass 460 0.3846  1.e-9 1.e-9; 
mass 403104 0.2486  1.e-9 1.e-9; mass 403204 0.2720  1.e-9 1.e-9; mass 403304 0.2720  1.e-9 1.e-9; mass 403404 0.2720  1.e-9 1.e-9; mass 350 0.3846  1.e-9 1.e-9; mass 360 0.3846  1.e-9 1.e-9; 
mass 402104 0.2797  1.e-9 1.e-9; mass 402204 0.3030  1.e-9 1.e-9; mass 402304 0.3030  1.e-9 1.e-9; mass 402404 0.3030  1.e-9 1.e-9; mass 250 0.3380  1.e-9 1.e-9; mass 260 0.3380  1.e-9 1.e-9; 

constraints Plain;

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
set T1 [expr round(2.0*$pi/$w1 *1000.)/1000.];
set T2 [expr round(2.0*$pi/$w2 *1000.)/1000.];
set T3 [expr round(2.0*$pi/$w3 *1000.)/1000.];
set T4 [expr round(2.0*$pi/$w4 *1000.)/1000.];
set T5 [expr round(2.0*$pi/$w5 *1000.)/1000.];
set T6 [expr round(2.0*$pi/$w6 *1000.)/1000.];
set T7 [expr round(2.0*$pi/$w7 *1000.)/1000.];
set T8 [expr round(2.0*$pi/$w8 *1000.)/1000.];
set T9 [expr round(2.0*$pi/$w9 *1000.)/1000.];
set T10 [expr round(2.0*$pi/$w10 *1000.)/1000.];
set T11 [expr round(2.0*$pi/$w11 *1000.)/1000.];
set T12 [expr round(2.0*$pi/$w12 *1000.)/1000.];
puts "T1 = $T1 s";
puts "T2 = $T2 s";
puts "T3 = $T3 s";
set fileX [open "EigenPeriod.out" w];
puts $fileX $T1;puts $fileX $T2;puts $fileX $T3;puts $fileX $T4;puts $fileX $T5;puts $fileX $T6;puts $fileX $T7;puts $fileX $T8;puts $fileX $T9;puts $fileX $T10;puts $fileX $T11;puts $fileX $T12;close $fileX;


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
set a0 [expr $zeta*2.0*$w1*$w3/($w1 + $w3)];
set a1 [expr $zeta*2.0/($w1 + $w3)];
set a1_mod [expr $a1*(1.0+$n)/$n];
region 1 -ele  604100 604200 604300 604400 603102 603202 603302 603402 603101 603201 603301 603401 602100 602200 602300 602400 601100 601200 601300 601400 505100 505200 505300 504100 504200 504300 503100 503200 503300 502100 502200 502300  -rayleigh 0.0 0.0 $a1_mod 0.0;
region 2 -node  402104 402204 402304 402404 250 260 403104 403204 403304 403404 350 360 404104 404204 404304 404404 450 460 405104 405204 405304 405404 550 560 406104 406204 406304 406404 650 660 407104 407204 407304 407404 750 760 408104 408204 408304 408404 850 860 409104 409204 409304 409404 950 960 410104 410204 410304 410404 1050 1060 411104 411204 411304 411404 1150 1160 412104 412204 412304 412404 1250 1260 413104 413204 413304 413404 1350 1360  -rayleigh $a0 0.0 0.0 0.0;
region 3 -eleRange  900000  999999 -rayleigh 0.0 0.0 [expr $a1_mod/10] 0.0;

# GROUND MOTION ACCELERATION FILE INPUT
set AccelSeries "Series -dt $GMdt -filePath $GMfile -factor  [expr $EqSF * $g]"
pattern UniformExcitation  200 1 -accel $AccelSeries

set MF_FloorNodes [list  402104 403104 404104 405104 406104 407104 408104 409104 410104 411104 412104 413104 ];
set EGF_FloorNodes [list  250 350 450 550 650 750 850 950 1050 1150 1250 1350 ];
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
