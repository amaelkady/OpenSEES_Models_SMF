####################################################################################################
####################################################################################################
#                                        20-story MRF Building
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
set NStory 20;
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
set L_RBS21  [expr  0.625 *  8.99 +  0.750 * 23.90/2.];
set L_RBS20  [expr  0.625 *  8.99 +  0.750 * 23.90/2.];
set L_RBS19  [expr  0.625 * 13.00 +  0.750 * 25.70/2.];
set L_RBS18  [expr  0.625 * 13.00 +  0.750 * 25.70/2.];
set L_RBS17  [expr  0.625 * 13.00 +  0.750 * 25.70/2.];
set L_RBS16  [expr  0.625 * 11.60 +  0.750 * 33.50/2.];
set L_RBS15  [expr  0.625 * 11.60 +  0.750 * 33.50/2.];
set L_RBS14  [expr  0.625 * 11.60 +  0.750 * 33.50/2.];
set L_RBS13  [expr  0.625 * 11.50 +  0.750 * 33.80/2.];
set L_RBS12  [expr  0.625 * 11.50 +  0.750 * 33.80/2.];
set L_RBS11  [expr  0.625 * 11.50 +  0.750 * 33.80/2.];
set L_RBS10  [expr  0.625 * 11.50 +  0.750 * 33.80/2.];
set L_RBS9  [expr  0.625 * 11.50 +  0.750 * 33.80/2.];
set L_RBS8  [expr  0.625 * 11.50 +  0.750 * 33.80/2.];
set L_RBS7  [expr  0.625 * 11.50 +  0.750 * 33.80/2.];
set L_RBS6  [expr  0.625 * 11.50 +  0.750 * 33.80/2.];
set L_RBS5  [expr  0.625 * 11.50 +  0.750 * 33.80/2.];
set L_RBS4  [expr  0.625 * 11.60 +  0.750 * 33.50/2.];
set L_RBS3  [expr  0.625 * 11.60 +  0.750 * 33.50/2.];
set L_RBS2  [expr  0.625 * 11.60 +  0.750 * 33.50/2.];

# FRAME GRID LINES
set Floor21  3144.00;
set Floor20  2988.00;
set Floor19  2832.00;
set Floor18  2676.00;
set Floor17  2520.00;
set Floor16  2364.00;
set Floor15  2208.00;
set Floor14  2052.00;
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

set HBuilding 3144.00;
set WFrame 720.00;
variable HBuilding 3144.00;

####################################################################################################
#                                                  NODES                                           #
####################################################################################################

# COMMAND SYNTAX 
# node $NodeID  $X-Coordinate  $Y-Coordinate;

#SUPPORT NODES
node 110   $Axis1  $Floor1; node 120   $Axis2  $Floor1; node 130   $Axis3  $Floor1; node 140   $Axis4  $Floor1; node 150   $Axis5  $Floor1; node 160   $Axis6  $Floor1; 

# EGF COLUMN GRID NODES
node 2150   $Axis5  $Floor21; node 2160   $Axis6  $Floor21; 
node 2050   $Axis5  $Floor20; node 2060   $Axis6  $Floor20; 
node 1950   $Axis5  $Floor19; node 1960   $Axis6  $Floor19; 
node 1850   $Axis5  $Floor18; node 1860   $Axis6  $Floor18; 
node 1750   $Axis5  $Floor17; node 1760   $Axis6  $Floor17; 
node 1650   $Axis5  $Floor16; node 1660   $Axis6  $Floor16; 
node 1550   $Axis5  $Floor15; node 1560   $Axis6  $Floor15; 
node 1450   $Axis5  $Floor14; node 1460   $Axis6  $Floor14; 
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
node 2151  $Axis5  $Floor21; node 2161  $Axis6  $Floor21; 
node 2053  $Axis5  $Floor20; node 2063  $Axis6  $Floor20; 
node 2051  $Axis5  $Floor20; node 2061  $Axis6  $Floor20; 
node 1953  $Axis5  $Floor19; node 1963  $Axis6  $Floor19; 
node 1951  $Axis5  $Floor19; node 1961  $Axis6  $Floor19; 
node 1853  $Axis5  $Floor18; node 1863  $Axis6  $Floor18; 
node 1851  $Axis5  $Floor18; node 1861  $Axis6  $Floor18; 
node 1753  $Axis5  $Floor17; node 1763  $Axis6  $Floor17; 
node 1751  $Axis5  $Floor17; node 1761  $Axis6  $Floor17; 
node 1653  $Axis5  $Floor16; node 1663  $Axis6  $Floor16; 
node 1651  $Axis5  $Floor16; node 1661  $Axis6  $Floor16; 
node 1553  $Axis5  $Floor15; node 1563  $Axis6  $Floor15; 
node 1551  $Axis5  $Floor15; node 1561  $Axis6  $Floor15; 
node 1453  $Axis5  $Floor14; node 1463  $Axis6  $Floor14; 
node 1451  $Axis5  $Floor14; node 1461  $Axis6  $Floor14; 
node 1353  $Axis5  $Floor13; node 1363  $Axis6  $Floor13; 
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
node 2154  $Axis5  $Floor21; node 2162  $Axis6  $Floor21; 
node 2054  $Axis5  $Floor20; node 2062  $Axis6  $Floor20; 
node 1954  $Axis5  $Floor19; node 1962  $Axis6  $Floor19; 
node 1854  $Axis5  $Floor18; node 1862  $Axis6  $Floor18; 
node 1754  $Axis5  $Floor17; node 1762  $Axis6  $Floor17; 
node 1654  $Axis5  $Floor16; node 1662  $Axis6  $Floor16; 
node 1554  $Axis5  $Floor15; node 1562  $Axis6  $Floor15; 
node 1454  $Axis5  $Floor14; node 1462  $Axis6  $Floor14; 
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
node 2111  $Axis1 [expr $Floor21 - 23.90/2]; node 2121  $Axis2 [expr $Floor21 - 23.90/2]; node 2131  $Axis3 [expr $Floor21 - 23.90/2]; node 2141  $Axis4 [expr $Floor21 - 23.90/2]; 
node 2013  $Axis1 [expr $Floor20 + 23.90/2]; node 2023  $Axis2 [expr $Floor20 + 23.90/2]; node 2033  $Axis3 [expr $Floor20 + 23.90/2]; node 2043  $Axis4 [expr $Floor20 + 23.90/2]; 
node 2011  $Axis1 [expr $Floor20 - 23.90/2]; node 2021  $Axis2 [expr $Floor20 - 23.90/2]; node 2031  $Axis3 [expr $Floor20 - 23.90/2]; node 2041  $Axis4 [expr $Floor20 - 23.90/2]; 
node 1913  $Axis1 [expr $Floor19 + 25.70/2]; node 1923  $Axis2 [expr $Floor19 + 25.70/2]; node 1933  $Axis3 [expr $Floor19 + 25.70/2]; node 1943  $Axis4 [expr $Floor19 + 25.70/2]; 
node 1911  $Axis1 [expr $Floor19 - 25.70/2]; node 1921  $Axis2 [expr $Floor19 - 25.70/2]; node 1931  $Axis3 [expr $Floor19 - 25.70/2]; node 1941  $Axis4 [expr $Floor19 - 25.70/2]; 
node 1813  $Axis1 [expr $Floor18 + 25.70/2]; node 1823  $Axis2 [expr $Floor18 + 25.70/2]; node 1833  $Axis3 [expr $Floor18 + 25.70/2]; node 1843  $Axis4 [expr $Floor18 + 25.70/2]; 
node 1811  $Axis1 [expr $Floor18 - 25.70/2]; node 1821  $Axis2 [expr $Floor18 - 25.70/2]; node 1831  $Axis3 [expr $Floor18 - 25.70/2]; node 1841  $Axis4 [expr $Floor18 - 25.70/2]; 
node 1713  $Axis1 [expr $Floor17 + 25.70/2]; node 1723  $Axis2 [expr $Floor17 + 25.70/2]; node 1733  $Axis3 [expr $Floor17 + 25.70/2]; node 1743  $Axis4 [expr $Floor17 + 25.70/2]; 
node 1711  $Axis1 [expr $Floor17 - 25.70/2]; node 1721  $Axis2 [expr $Floor17 - 25.70/2]; node 1731  $Axis3 [expr $Floor17 - 25.70/2]; node 1741  $Axis4 [expr $Floor17 - 25.70/2]; 
node 1613  $Axis1 [expr $Floor16 + 33.50/2]; node 1623  $Axis2 [expr $Floor16 + 33.50/2]; node 1633  $Axis3 [expr $Floor16 + 33.50/2]; node 1643  $Axis4 [expr $Floor16 + 33.50/2]; 
node 1611  $Axis1 [expr $Floor16 - 33.50/2]; node 1621  $Axis2 [expr $Floor16 - 33.50/2]; node 1631  $Axis3 [expr $Floor16 - 33.50/2]; node 1641  $Axis4 [expr $Floor16 - 33.50/2]; 
node 1513  $Axis1 [expr $Floor15 + 33.50/2]; node 1523  $Axis2 [expr $Floor15 + 33.50/2]; node 1533  $Axis3 [expr $Floor15 + 33.50/2]; node 1543  $Axis4 [expr $Floor15 + 33.50/2]; 
node 1511  $Axis1 [expr $Floor15 - 33.50/2]; node 1521  $Axis2 [expr $Floor15 - 33.50/2]; node 1531  $Axis3 [expr $Floor15 - 33.50/2]; node 1541  $Axis4 [expr $Floor15 - 33.50/2]; 
node 1413  $Axis1 [expr $Floor14 + 33.50/2]; node 1423  $Axis2 [expr $Floor14 + 33.50/2]; node 1433  $Axis3 [expr $Floor14 + 33.50/2]; node 1443  $Axis4 [expr $Floor14 + 33.50/2]; 
node 1411  $Axis1 [expr $Floor14 - 33.50/2]; node 1421  $Axis2 [expr $Floor14 - 33.50/2]; node 1431  $Axis3 [expr $Floor14 - 33.50/2]; node 1441  $Axis4 [expr $Floor14 - 33.50/2]; 
node 1313  $Axis1 [expr $Floor13 + 33.80/2]; node 1323  $Axis2 [expr $Floor13 + 33.80/2]; node 1333  $Axis3 [expr $Floor13 + 33.80/2]; node 1343  $Axis4 [expr $Floor13 + 33.80/2]; 
node 1311  $Axis1 [expr $Floor13 - 33.80/2]; node 1321  $Axis2 [expr $Floor13 - 33.80/2]; node 1331  $Axis3 [expr $Floor13 - 33.80/2]; node 1341  $Axis4 [expr $Floor13 - 33.80/2]; 
node 1213  $Axis1 [expr $Floor12 + 33.80/2]; node 1223  $Axis2 [expr $Floor12 + 33.80/2]; node 1233  $Axis3 [expr $Floor12 + 33.80/2]; node 1243  $Axis4 [expr $Floor12 + 33.80/2]; 
node 1211  $Axis1 [expr $Floor12 - 33.80/2]; node 1221  $Axis2 [expr $Floor12 - 33.80/2]; node 1231  $Axis3 [expr $Floor12 - 33.80/2]; node 1241  $Axis4 [expr $Floor12 - 33.80/2]; 
node 1113  $Axis1 [expr $Floor11 + 33.80/2]; node 1123  $Axis2 [expr $Floor11 + 33.80/2]; node 1133  $Axis3 [expr $Floor11 + 33.80/2]; node 1143  $Axis4 [expr $Floor11 + 33.80/2]; 
node 1111  $Axis1 [expr $Floor11 - 33.80/2]; node 1121  $Axis2 [expr $Floor11 - 33.80/2]; node 1131  $Axis3 [expr $Floor11 - 33.80/2]; node 1141  $Axis4 [expr $Floor11 - 33.80/2]; 
node 1013  $Axis1 [expr $Floor10 + 33.80/2]; node 1023  $Axis2 [expr $Floor10 + 33.80/2]; node 1033  $Axis3 [expr $Floor10 + 33.80/2]; node 1043  $Axis4 [expr $Floor10 + 33.80/2]; 
node 1011  $Axis1 [expr $Floor10 - 33.80/2]; node 1021  $Axis2 [expr $Floor10 - 33.80/2]; node 1031  $Axis3 [expr $Floor10 - 33.80/2]; node 1041  $Axis4 [expr $Floor10 - 33.80/2]; 
node 913  $Axis1 [expr $Floor9 + 33.80/2]; node 923  $Axis2 [expr $Floor9 + 33.80/2]; node 933  $Axis3 [expr $Floor9 + 33.80/2]; node 943  $Axis4 [expr $Floor9 + 33.80/2]; 
node 911  $Axis1 [expr $Floor9 - 33.80/2]; node 921  $Axis2 [expr $Floor9 - 33.80/2]; node 931  $Axis3 [expr $Floor9 - 33.80/2]; node 941  $Axis4 [expr $Floor9 - 33.80/2]; 
node 813  $Axis1 [expr $Floor8 + 33.80/2]; node 823  $Axis2 [expr $Floor8 + 33.80/2]; node 833  $Axis3 [expr $Floor8 + 33.80/2]; node 843  $Axis4 [expr $Floor8 + 33.80/2]; 
node 811  $Axis1 [expr $Floor8 - 33.80/2]; node 821  $Axis2 [expr $Floor8 - 33.80/2]; node 831  $Axis3 [expr $Floor8 - 33.80/2]; node 841  $Axis4 [expr $Floor8 - 33.80/2]; 
node 713  $Axis1 [expr $Floor7 + 33.80/2]; node 723  $Axis2 [expr $Floor7 + 33.80/2]; node 733  $Axis3 [expr $Floor7 + 33.80/2]; node 743  $Axis4 [expr $Floor7 + 33.80/2]; 
node 711  $Axis1 [expr $Floor7 - 33.80/2]; node 721  $Axis2 [expr $Floor7 - 33.80/2]; node 731  $Axis3 [expr $Floor7 - 33.80/2]; node 741  $Axis4 [expr $Floor7 - 33.80/2]; 
node 613  $Axis1 [expr $Floor6 + 33.80/2]; node 623  $Axis2 [expr $Floor6 + 33.80/2]; node 633  $Axis3 [expr $Floor6 + 33.80/2]; node 643  $Axis4 [expr $Floor6 + 33.80/2]; 
node 611  $Axis1 [expr $Floor6 - 33.80/2]; node 621  $Axis2 [expr $Floor6 - 33.80/2]; node 631  $Axis3 [expr $Floor6 - 33.80/2]; node 641  $Axis4 [expr $Floor6 - 33.80/2]; 
node 513  $Axis1 [expr $Floor5 + 33.80/2]; node 523  $Axis2 [expr $Floor5 + 33.80/2]; node 533  $Axis3 [expr $Floor5 + 33.80/2]; node 543  $Axis4 [expr $Floor5 + 33.80/2]; 
node 511  $Axis1 [expr $Floor5 - 33.80/2]; node 521  $Axis2 [expr $Floor5 - 33.80/2]; node 531  $Axis3 [expr $Floor5 - 33.80/2]; node 541  $Axis4 [expr $Floor5 - 33.80/2]; 
node 413  $Axis1 [expr $Floor4 + 33.50/2]; node 423  $Axis2 [expr $Floor4 + 33.50/2]; node 433  $Axis3 [expr $Floor4 + 33.50/2]; node 443  $Axis4 [expr $Floor4 + 33.50/2]; 
node 411  $Axis1 [expr $Floor4 - 33.50/2]; node 421  $Axis2 [expr $Floor4 - 33.50/2]; node 431  $Axis3 [expr $Floor4 - 33.50/2]; node 441  $Axis4 [expr $Floor4 - 33.50/2]; 
node 313  $Axis1 [expr $Floor3 + 33.50/2]; node 323  $Axis2 [expr $Floor3 + 33.50/2]; node 333  $Axis3 [expr $Floor3 + 33.50/2]; node 343  $Axis4 [expr $Floor3 + 33.50/2]; 
node 311  $Axis1 [expr $Floor3 - 33.50/2]; node 321  $Axis2 [expr $Floor3 - 33.50/2]; node 331  $Axis3 [expr $Floor3 - 33.50/2]; node 341  $Axis4 [expr $Floor3 - 33.50/2]; 
node 213  $Axis1 [expr $Floor2 + 33.50/2]; node 223  $Axis2 [expr $Floor2 + 33.50/2]; node 233  $Axis3 [expr $Floor2 + 33.50/2]; node 243  $Axis4 [expr $Floor2 + 33.50/2]; 
node 211  $Axis1 [expr $Floor2 - 33.50/2]; node 221  $Axis2 [expr $Floor2 - 33.50/2]; node 231  $Axis3 [expr $Floor2 - 33.50/2]; node 241  $Axis4 [expr $Floor2 - 33.50/2]; 
node 113  $Axis1 $Floor1; node 123  $Axis2 $Floor1; node 133  $Axis3 $Floor1; node 143  $Axis4 $Floor1; 

# MF BEAM NODES
node 2114   [expr $Axis1 + $L_RBS21 + 14.70/2] $Floor21; node 2122   [expr $Axis2 - $L_RBS21 - 35.90/2] $Floor21; node 2124   [expr $Axis2 + $L_RBS21 + 35.90/2] $Floor21; node 2132   [expr $Axis3 - $L_RBS21 - 35.90/2] $Floor21; node 2134   [expr $Axis3 + $L_RBS21 + 35.90/2] $Floor21; node 2142   [expr $Axis4 - $L_RBS21 - 14.70/2] $Floor21; 
node 2014   [expr $Axis1 + $L_RBS20 + 15.50/2] $Floor20; node 2022   [expr $Axis2 - $L_RBS20 - 36.50/2] $Floor20; node 2024   [expr $Axis2 + $L_RBS20 + 36.50/2] $Floor20; node 2032   [expr $Axis3 - $L_RBS20 - 36.50/2] $Floor20; node 2034   [expr $Axis3 + $L_RBS20 + 36.50/2] $Floor20; node 2042   [expr $Axis4 - $L_RBS20 - 15.50/2] $Floor20; 
node 1914   [expr $Axis1 + $L_RBS19 + 15.50/2] $Floor19; node 1922   [expr $Axis2 - $L_RBS19 - 36.50/2] $Floor19; node 1924   [expr $Axis2 + $L_RBS19 + 36.50/2] $Floor19; node 1932   [expr $Axis3 - $L_RBS19 - 36.50/2] $Floor19; node 1934   [expr $Axis3 + $L_RBS19 + 36.50/2] $Floor19; node 1942   [expr $Axis4 - $L_RBS19 - 15.50/2] $Floor19; 
node 1814   [expr $Axis1 + $L_RBS18 + 16.00/2] $Floor18; node 1822   [expr $Axis2 - $L_RBS18 - 37.10/2] $Floor18; node 1824   [expr $Axis2 + $L_RBS18 + 37.10/2] $Floor18; node 1832   [expr $Axis3 - $L_RBS18 - 37.10/2] $Floor18; node 1834   [expr $Axis3 + $L_RBS18 + 37.10/2] $Floor18; node 1842   [expr $Axis4 - $L_RBS18 - 16.00/2] $Floor18; 
node 1714   [expr $Axis1 + $L_RBS17 + 16.00/2] $Floor17; node 1722   [expr $Axis2 - $L_RBS17 - 37.10/2] $Floor17; node 1724   [expr $Axis2 + $L_RBS17 + 37.10/2] $Floor17; node 1732   [expr $Axis3 - $L_RBS17 - 37.10/2] $Floor17; node 1734   [expr $Axis3 + $L_RBS17 + 37.10/2] $Floor17; node 1742   [expr $Axis4 - $L_RBS17 - 16.00/2] $Floor17; 
node 1614   [expr $Axis1 + $L_RBS16 + 16.70/2] $Floor16; node 1622   [expr $Axis2 - $L_RBS16 - 36.30/2] $Floor16; node 1624   [expr $Axis2 + $L_RBS16 + 36.30/2] $Floor16; node 1632   [expr $Axis3 - $L_RBS16 - 36.30/2] $Floor16; node 1634   [expr $Axis3 + $L_RBS16 + 36.30/2] $Floor16; node 1642   [expr $Axis4 - $L_RBS16 - 16.70/2] $Floor16; 
node 1514   [expr $Axis1 + $L_RBS15 + 16.70/2] $Floor15; node 1522   [expr $Axis2 - $L_RBS15 - 36.30/2] $Floor15; node 1524   [expr $Axis2 + $L_RBS15 + 36.30/2] $Floor15; node 1532   [expr $Axis3 - $L_RBS15 - 36.30/2] $Floor15; node 1534   [expr $Axis3 + $L_RBS15 + 36.30/2] $Floor15; node 1542   [expr $Axis4 - $L_RBS15 - 16.70/2] $Floor15; 
node 1414   [expr $Axis1 + $L_RBS14 + 17.10/2] $Floor14; node 1422   [expr $Axis2 - $L_RBS14 - 37.10/2] $Floor14; node 1424   [expr $Axis2 + $L_RBS14 + 37.10/2] $Floor14; node 1432   [expr $Axis3 - $L_RBS14 - 37.10/2] $Floor14; node 1434   [expr $Axis3 + $L_RBS14 + 37.10/2] $Floor14; node 1442   [expr $Axis4 - $L_RBS14 - 17.10/2] $Floor14; 
node 1314   [expr $Axis1 + $L_RBS13 + 17.10/2] $Floor13; node 1322   [expr $Axis2 - $L_RBS13 - 37.10/2] $Floor13; node 1324   [expr $Axis2 + $L_RBS13 + 37.10/2] $Floor13; node 1332   [expr $Axis3 - $L_RBS13 - 37.10/2] $Floor13; node 1334   [expr $Axis3 + $L_RBS13 + 37.10/2] $Floor13; node 1342   [expr $Axis4 - $L_RBS13 - 17.10/2] $Floor13; 
node 1214   [expr $Axis1 + $L_RBS12 + 17.90/2] $Floor12; node 1222   [expr $Axis2 - $L_RBS12 - 37.40/2] $Floor12; node 1224   [expr $Axis2 + $L_RBS12 + 37.40/2] $Floor12; node 1232   [expr $Axis3 - $L_RBS12 - 37.40/2] $Floor12; node 1234   [expr $Axis3 + $L_RBS12 + 37.40/2] $Floor12; node 1242   [expr $Axis4 - $L_RBS12 - 17.90/2] $Floor12; 
node 1114   [expr $Axis1 + $L_RBS11 + 17.90/2] $Floor11; node 1122   [expr $Axis2 - $L_RBS11 - 37.40/2] $Floor11; node 1124   [expr $Axis2 + $L_RBS11 + 37.40/2] $Floor11; node 1132   [expr $Axis3 - $L_RBS11 - 37.40/2] $Floor11; node 1134   [expr $Axis3 + $L_RBS11 + 37.40/2] $Floor11; node 1142   [expr $Axis4 - $L_RBS11 - 17.90/2] $Floor11; 
node 1014   [expr $Axis1 + $L_RBS10 + 17.90/2] $Floor10; node 1022   [expr $Axis2 - $L_RBS10 - 37.80/2] $Floor10; node 1024   [expr $Axis2 + $L_RBS10 + 37.80/2] $Floor10; node 1032   [expr $Axis3 - $L_RBS10 - 37.80/2] $Floor10; node 1034   [expr $Axis3 + $L_RBS10 + 37.80/2] $Floor10; node 1042   [expr $Axis4 - $L_RBS10 - 17.90/2] $Floor10; 
node 914   [expr $Axis1 + $L_RBS9 + 17.90/2] $Floor9; node 922   [expr $Axis2 - $L_RBS9 - 37.80/2] $Floor9; node 924   [expr $Axis2 + $L_RBS9 + 37.80/2] $Floor9; node 932   [expr $Axis3 - $L_RBS9 - 37.80/2] $Floor9; node 934   [expr $Axis3 + $L_RBS9 + 37.80/2] $Floor9; node 942   [expr $Axis4 - $L_RBS9 - 17.90/2] $Floor9; 
node 814   [expr $Axis1 + $L_RBS8 + 19.00/2] $Floor8; node 822   [expr $Axis2 - $L_RBS8 - 38.30/2] $Floor8; node 824   [expr $Axis2 + $L_RBS8 + 38.30/2] $Floor8; node 832   [expr $Axis3 - $L_RBS8 - 38.30/2] $Floor8; node 834   [expr $Axis3 + $L_RBS8 + 38.30/2] $Floor8; node 842   [expr $Axis4 - $L_RBS8 - 19.00/2] $Floor8; 
node 714   [expr $Axis1 + $L_RBS7 + 19.00/2] $Floor7; node 722   [expr $Axis2 - $L_RBS7 - 38.30/2] $Floor7; node 724   [expr $Axis2 + $L_RBS7 + 38.30/2] $Floor7; node 732   [expr $Axis3 - $L_RBS7 - 38.30/2] $Floor7; node 734   [expr $Axis3 + $L_RBS7 + 38.30/2] $Floor7; node 742   [expr $Axis4 - $L_RBS7 - 19.00/2] $Floor7; 
node 614   [expr $Axis1 + $L_RBS6 + 19.00/2] $Floor6; node 622   [expr $Axis2 - $L_RBS6 - 39.30/2] $Floor6; node 624   [expr $Axis2 + $L_RBS6 + 39.30/2] $Floor6; node 632   [expr $Axis3 - $L_RBS6 - 39.30/2] $Floor6; node 634   [expr $Axis3 + $L_RBS6 + 39.30/2] $Floor6; node 642   [expr $Axis4 - $L_RBS6 - 19.00/2] $Floor6; 
node 514   [expr $Axis1 + $L_RBS5 + 19.00/2] $Floor5; node 522   [expr $Axis2 - $L_RBS5 - 39.30/2] $Floor5; node 524   [expr $Axis2 + $L_RBS5 + 39.30/2] $Floor5; node 532   [expr $Axis3 - $L_RBS5 - 39.30/2] $Floor5; node 534   [expr $Axis3 + $L_RBS5 + 39.30/2] $Floor5; node 542   [expr $Axis4 - $L_RBS5 - 19.00/2] $Floor5; 
node 414   [expr $Axis1 + $L_RBS4 + 19.60/2] $Floor4; node 422   [expr $Axis2 - $L_RBS4 - 39.20/2] $Floor4; node 424   [expr $Axis2 + $L_RBS4 + 39.20/2] $Floor4; node 432   [expr $Axis3 - $L_RBS4 - 39.20/2] $Floor4; node 434   [expr $Axis3 + $L_RBS4 + 39.20/2] $Floor4; node 442   [expr $Axis4 - $L_RBS4 - 19.60/2] $Floor4; 
node 314   [expr $Axis1 + $L_RBS3 + 19.60/2] $Floor3; node 322   [expr $Axis2 - $L_RBS3 - 39.20/2] $Floor3; node 324   [expr $Axis2 + $L_RBS3 + 39.20/2] $Floor3; node 332   [expr $Axis3 - $L_RBS3 - 39.20/2] $Floor3; node 334   [expr $Axis3 + $L_RBS3 + 39.20/2] $Floor3; node 342   [expr $Axis4 - $L_RBS3 - 19.60/2] $Floor3; 
node 214   [expr $Axis1 + $L_RBS2 + 19.60/2] $Floor2; node 222   [expr $Axis2 - $L_RBS2 - 39.20/2] $Floor2; node 224   [expr $Axis2 + $L_RBS2 + 39.20/2] $Floor2; node 232   [expr $Axis3 - $L_RBS2 - 39.20/2] $Floor2; node 234   [expr $Axis3 + $L_RBS2 + 39.20/2] $Floor2; node 242   [expr $Axis4 - $L_RBS2 - 19.60/2] $Floor2; 

# BEAM SPRING NODES
node 21140   [expr $Axis1 + $L_RBS21 + 14.70/2] $Floor21; node 21220   [expr $Axis2 - $L_RBS21 - 35.90/2] $Floor21; node 21240   [expr $Axis2 + $L_RBS21 + 35.90/2] $Floor21; node 21320   [expr $Axis3 - $L_RBS21 - 35.90/2] $Floor21; node 21340   [expr $Axis3 + $L_RBS21 + 35.90/2] $Floor21; node 21420   [expr $Axis4 - $L_RBS21 - 14.70/2] $Floor21; 
node 20140   [expr $Axis1 + $L_RBS20 + 15.50/2] $Floor20; node 20220   [expr $Axis2 - $L_RBS20 - 36.50/2] $Floor20; node 20240   [expr $Axis2 + $L_RBS20 + 36.50/2] $Floor20; node 20320   [expr $Axis3 - $L_RBS20 - 36.50/2] $Floor20; node 20340   [expr $Axis3 + $L_RBS20 + 36.50/2] $Floor20; node 20420   [expr $Axis4 - $L_RBS20 - 15.50/2] $Floor20; 
node 19140   [expr $Axis1 + $L_RBS19 + 15.50/2] $Floor19; node 19220   [expr $Axis2 - $L_RBS19 - 36.50/2] $Floor19; node 19240   [expr $Axis2 + $L_RBS19 + 36.50/2] $Floor19; node 19320   [expr $Axis3 - $L_RBS19 - 36.50/2] $Floor19; node 19340   [expr $Axis3 + $L_RBS19 + 36.50/2] $Floor19; node 19420   [expr $Axis4 - $L_RBS19 - 15.50/2] $Floor19; 
node 18140   [expr $Axis1 + $L_RBS18 + 16.00/2] $Floor18; node 18220   [expr $Axis2 - $L_RBS18 - 37.10/2] $Floor18; node 18240   [expr $Axis2 + $L_RBS18 + 37.10/2] $Floor18; node 18320   [expr $Axis3 - $L_RBS18 - 37.10/2] $Floor18; node 18340   [expr $Axis3 + $L_RBS18 + 37.10/2] $Floor18; node 18420   [expr $Axis4 - $L_RBS18 - 16.00/2] $Floor18; 
node 17140   [expr $Axis1 + $L_RBS17 + 16.00/2] $Floor17; node 17220   [expr $Axis2 - $L_RBS17 - 37.10/2] $Floor17; node 17240   [expr $Axis2 + $L_RBS17 + 37.10/2] $Floor17; node 17320   [expr $Axis3 - $L_RBS17 - 37.10/2] $Floor17; node 17340   [expr $Axis3 + $L_RBS17 + 37.10/2] $Floor17; node 17420   [expr $Axis4 - $L_RBS17 - 16.00/2] $Floor17; 
node 16140   [expr $Axis1 + $L_RBS16 + 16.70/2] $Floor16; node 16220   [expr $Axis2 - $L_RBS16 - 36.30/2] $Floor16; node 16240   [expr $Axis2 + $L_RBS16 + 36.30/2] $Floor16; node 16320   [expr $Axis3 - $L_RBS16 - 36.30/2] $Floor16; node 16340   [expr $Axis3 + $L_RBS16 + 36.30/2] $Floor16; node 16420   [expr $Axis4 - $L_RBS16 - 16.70/2] $Floor16; 
node 15140   [expr $Axis1 + $L_RBS15 + 16.70/2] $Floor15; node 15220   [expr $Axis2 - $L_RBS15 - 36.30/2] $Floor15; node 15240   [expr $Axis2 + $L_RBS15 + 36.30/2] $Floor15; node 15320   [expr $Axis3 - $L_RBS15 - 36.30/2] $Floor15; node 15340   [expr $Axis3 + $L_RBS15 + 36.30/2] $Floor15; node 15420   [expr $Axis4 - $L_RBS15 - 16.70/2] $Floor15; 
node 14140   [expr $Axis1 + $L_RBS14 + 17.10/2] $Floor14; node 14220   [expr $Axis2 - $L_RBS14 - 37.10/2] $Floor14; node 14240   [expr $Axis2 + $L_RBS14 + 37.10/2] $Floor14; node 14320   [expr $Axis3 - $L_RBS14 - 37.10/2] $Floor14; node 14340   [expr $Axis3 + $L_RBS14 + 37.10/2] $Floor14; node 14420   [expr $Axis4 - $L_RBS14 - 17.10/2] $Floor14; 
node 13140   [expr $Axis1 + $L_RBS13 + 17.10/2] $Floor13; node 13220   [expr $Axis2 - $L_RBS13 - 37.10/2] $Floor13; node 13240   [expr $Axis2 + $L_RBS13 + 37.10/2] $Floor13; node 13320   [expr $Axis3 - $L_RBS13 - 37.10/2] $Floor13; node 13340   [expr $Axis3 + $L_RBS13 + 37.10/2] $Floor13; node 13420   [expr $Axis4 - $L_RBS13 - 17.10/2] $Floor13; 
node 12140   [expr $Axis1 + $L_RBS12 + 17.90/2] $Floor12; node 12220   [expr $Axis2 - $L_RBS12 - 37.40/2] $Floor12; node 12240   [expr $Axis2 + $L_RBS12 + 37.40/2] $Floor12; node 12320   [expr $Axis3 - $L_RBS12 - 37.40/2] $Floor12; node 12340   [expr $Axis3 + $L_RBS12 + 37.40/2] $Floor12; node 12420   [expr $Axis4 - $L_RBS12 - 17.90/2] $Floor12; 
node 11140   [expr $Axis1 + $L_RBS11 + 17.90/2] $Floor11; node 11220   [expr $Axis2 - $L_RBS11 - 37.40/2] $Floor11; node 11240   [expr $Axis2 + $L_RBS11 + 37.40/2] $Floor11; node 11320   [expr $Axis3 - $L_RBS11 - 37.40/2] $Floor11; node 11340   [expr $Axis3 + $L_RBS11 + 37.40/2] $Floor11; node 11420   [expr $Axis4 - $L_RBS11 - 17.90/2] $Floor11; 
node 10140   [expr $Axis1 + $L_RBS10 + 17.90/2] $Floor10; node 10220   [expr $Axis2 - $L_RBS10 - 37.80/2] $Floor10; node 10240   [expr $Axis2 + $L_RBS10 + 37.80/2] $Floor10; node 10320   [expr $Axis3 - $L_RBS10 - 37.80/2] $Floor10; node 10340   [expr $Axis3 + $L_RBS10 + 37.80/2] $Floor10; node 10420   [expr $Axis4 - $L_RBS10 - 17.90/2] $Floor10; 
node 9140   [expr $Axis1 + $L_RBS9 + 17.90/2] $Floor9; node 9220   [expr $Axis2 - $L_RBS9 - 37.80/2] $Floor9; node 9240   [expr $Axis2 + $L_RBS9 + 37.80/2] $Floor9; node 9320   [expr $Axis3 - $L_RBS9 - 37.80/2] $Floor9; node 9340   [expr $Axis3 + $L_RBS9 + 37.80/2] $Floor9; node 9420   [expr $Axis4 - $L_RBS9 - 17.90/2] $Floor9; 
node 8140   [expr $Axis1 + $L_RBS8 + 19.00/2] $Floor8; node 8220   [expr $Axis2 - $L_RBS8 - 38.30/2] $Floor8; node 8240   [expr $Axis2 + $L_RBS8 + 38.30/2] $Floor8; node 8320   [expr $Axis3 - $L_RBS8 - 38.30/2] $Floor8; node 8340   [expr $Axis3 + $L_RBS8 + 38.30/2] $Floor8; node 8420   [expr $Axis4 - $L_RBS8 - 19.00/2] $Floor8; 
node 7140   [expr $Axis1 + $L_RBS7 + 19.00/2] $Floor7; node 7220   [expr $Axis2 - $L_RBS7 - 38.30/2] $Floor7; node 7240   [expr $Axis2 + $L_RBS7 + 38.30/2] $Floor7; node 7320   [expr $Axis3 - $L_RBS7 - 38.30/2] $Floor7; node 7340   [expr $Axis3 + $L_RBS7 + 38.30/2] $Floor7; node 7420   [expr $Axis4 - $L_RBS7 - 19.00/2] $Floor7; 
node 6140   [expr $Axis1 + $L_RBS6 + 19.00/2] $Floor6; node 6220   [expr $Axis2 - $L_RBS6 - 39.30/2] $Floor6; node 6240   [expr $Axis2 + $L_RBS6 + 39.30/2] $Floor6; node 6320   [expr $Axis3 - $L_RBS6 - 39.30/2] $Floor6; node 6340   [expr $Axis3 + $L_RBS6 + 39.30/2] $Floor6; node 6420   [expr $Axis4 - $L_RBS6 - 19.00/2] $Floor6; 
node 5140   [expr $Axis1 + $L_RBS5 + 19.00/2] $Floor5; node 5220   [expr $Axis2 - $L_RBS5 - 39.30/2] $Floor5; node 5240   [expr $Axis2 + $L_RBS5 + 39.30/2] $Floor5; node 5320   [expr $Axis3 - $L_RBS5 - 39.30/2] $Floor5; node 5340   [expr $Axis3 + $L_RBS5 + 39.30/2] $Floor5; node 5420   [expr $Axis4 - $L_RBS5 - 19.00/2] $Floor5; 
node 4140   [expr $Axis1 + $L_RBS4 + 19.60/2] $Floor4; node 4220   [expr $Axis2 - $L_RBS4 - 39.20/2] $Floor4; node 4240   [expr $Axis2 + $L_RBS4 + 39.20/2] $Floor4; node 4320   [expr $Axis3 - $L_RBS4 - 39.20/2] $Floor4; node 4340   [expr $Axis3 + $L_RBS4 + 39.20/2] $Floor4; node 4420   [expr $Axis4 - $L_RBS4 - 19.60/2] $Floor4; 
node 3140   [expr $Axis1 + $L_RBS3 + 19.60/2] $Floor3; node 3220   [expr $Axis2 - $L_RBS3 - 39.20/2] $Floor3; node 3240   [expr $Axis2 + $L_RBS3 + 39.20/2] $Floor3; node 3320   [expr $Axis3 - $L_RBS3 - 39.20/2] $Floor3; node 3340   [expr $Axis3 + $L_RBS3 + 39.20/2] $Floor3; node 3420   [expr $Axis4 - $L_RBS3 - 19.60/2] $Floor3; 
node 2140   [expr $Axis1 + $L_RBS2 + 19.60/2] $Floor2; node 2220   [expr $Axis2 - $L_RBS2 - 39.20/2] $Floor2; node 2240   [expr $Axis2 + $L_RBS2 + 39.20/2] $Floor2; node 2320   [expr $Axis3 - $L_RBS2 - 39.20/2] $Floor2; node 2340   [expr $Axis3 + $L_RBS2 + 39.20/2] $Floor2; node 2420   [expr $Axis4 - $L_RBS2 - 19.60/2] $Floor2; 

# COLUMN SPLICE NODES
node 119172 $Axis1 [expr ($Floor19 + 0.50 * 156)]; node 119272 $Axis2 [expr ($Floor19 + 0.50 * 156)]; node 119372 $Axis3 [expr ($Floor19 + 0.50 * 156)]; node 119472 $Axis4 [expr ($Floor19 + 0.50 * 156)]; node 119572 $Axis5 [expr ($Floor19 + 0.50 * 156)]; node 119672 $Axis6 [expr ($Floor19 + 0.50 * 156)]; 
node 119171 $Axis1 [expr ($Floor19 + 0.50 * 156)]; node 119271 $Axis2 [expr ($Floor19 + 0.50 * 156)]; node 119371 $Axis3 [expr ($Floor19 + 0.50 * 156)]; node 119471 $Axis4 [expr ($Floor19 + 0.50 * 156)]; node 119571 $Axis5 [expr ($Floor19 + 0.50 * 156)]; node 119671 $Axis6 [expr ($Floor19 + 0.50 * 156)]; 
node 117172 $Axis1 [expr ($Floor17 + 0.50 * 156)]; node 117272 $Axis2 [expr ($Floor17 + 0.50 * 156)]; node 117372 $Axis3 [expr ($Floor17 + 0.50 * 156)]; node 117472 $Axis4 [expr ($Floor17 + 0.50 * 156)]; node 117572 $Axis5 [expr ($Floor17 + 0.50 * 156)]; node 117672 $Axis6 [expr ($Floor17 + 0.50 * 156)]; 
node 117171 $Axis1 [expr ($Floor17 + 0.50 * 156)]; node 117271 $Axis2 [expr ($Floor17 + 0.50 * 156)]; node 117371 $Axis3 [expr ($Floor17 + 0.50 * 156)]; node 117471 $Axis4 [expr ($Floor17 + 0.50 * 156)]; node 117571 $Axis5 [expr ($Floor17 + 0.50 * 156)]; node 117671 $Axis6 [expr ($Floor17 + 0.50 * 156)]; 
node 115172 $Axis1 [expr ($Floor15 + 0.50 * 156)]; node 115272 $Axis2 [expr ($Floor15 + 0.50 * 156)]; node 115372 $Axis3 [expr ($Floor15 + 0.50 * 156)]; node 115472 $Axis4 [expr ($Floor15 + 0.50 * 156)]; node 115572 $Axis5 [expr ($Floor15 + 0.50 * 156)]; node 115672 $Axis6 [expr ($Floor15 + 0.50 * 156)]; 
node 115171 $Axis1 [expr ($Floor15 + 0.50 * 156)]; node 115271 $Axis2 [expr ($Floor15 + 0.50 * 156)]; node 115371 $Axis3 [expr ($Floor15 + 0.50 * 156)]; node 115471 $Axis4 [expr ($Floor15 + 0.50 * 156)]; node 115571 $Axis5 [expr ($Floor15 + 0.50 * 156)]; node 115671 $Axis6 [expr ($Floor15 + 0.50 * 156)]; 
node 113172 $Axis1 [expr ($Floor13 + 0.50 * 156)]; node 113272 $Axis2 [expr ($Floor13 + 0.50 * 156)]; node 113372 $Axis3 [expr ($Floor13 + 0.50 * 156)]; node 113472 $Axis4 [expr ($Floor13 + 0.50 * 156)]; node 113572 $Axis5 [expr ($Floor13 + 0.50 * 156)]; node 113672 $Axis6 [expr ($Floor13 + 0.50 * 156)]; 
node 113171 $Axis1 [expr ($Floor13 + 0.50 * 156)]; node 113271 $Axis2 [expr ($Floor13 + 0.50 * 156)]; node 113371 $Axis3 [expr ($Floor13 + 0.50 * 156)]; node 113471 $Axis4 [expr ($Floor13 + 0.50 * 156)]; node 113571 $Axis5 [expr ($Floor13 + 0.50 * 156)]; node 113671 $Axis6 [expr ($Floor13 + 0.50 * 156)]; 
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
ConstructPanel_Rectangle  1 21 $Axis1 $Floor21 $E $A_Stiff $I_Stiff 14.70 23.90 $trans_selected; ConstructPanel_Rectangle  2 21 $Axis2 $Floor21 $E $A_Stiff $I_Stiff 35.90 23.90 $trans_selected; ConstructPanel_Rectangle  3 21 $Axis3 $Floor21 $E $A_Stiff $I_Stiff 35.90 23.90 $trans_selected; ConstructPanel_Rectangle  4 21 $Axis4 $Floor21 $E $A_Stiff $I_Stiff 14.70 23.90 $trans_selected; 
ConstructPanel_Rectangle  1 20 $Axis1 $Floor20 $E $A_Stiff $I_Stiff 15.50 23.90 $trans_selected; ConstructPanel_Rectangle  2 20 $Axis2 $Floor20 $E $A_Stiff $I_Stiff 36.50 23.90 $trans_selected; ConstructPanel_Rectangle  3 20 $Axis3 $Floor20 $E $A_Stiff $I_Stiff 36.50 23.90 $trans_selected; ConstructPanel_Rectangle  4 20 $Axis4 $Floor20 $E $A_Stiff $I_Stiff 15.50 23.90 $trans_selected; 
ConstructPanel_Rectangle  1 19 $Axis1 $Floor19 $E $A_Stiff $I_Stiff 15.50 25.70 $trans_selected; ConstructPanel_Rectangle  2 19 $Axis2 $Floor19 $E $A_Stiff $I_Stiff 36.50 25.70 $trans_selected; ConstructPanel_Rectangle  3 19 $Axis3 $Floor19 $E $A_Stiff $I_Stiff 36.50 25.70 $trans_selected; ConstructPanel_Rectangle  4 19 $Axis4 $Floor19 $E $A_Stiff $I_Stiff 15.50 25.70 $trans_selected; 
ConstructPanel_Rectangle  1 18 $Axis1 $Floor18 $E $A_Stiff $I_Stiff 16.00 25.70 $trans_selected; ConstructPanel_Rectangle  2 18 $Axis2 $Floor18 $E $A_Stiff $I_Stiff 37.10 25.70 $trans_selected; ConstructPanel_Rectangle  3 18 $Axis3 $Floor18 $E $A_Stiff $I_Stiff 37.10 25.70 $trans_selected; ConstructPanel_Rectangle  4 18 $Axis4 $Floor18 $E $A_Stiff $I_Stiff 16.00 25.70 $trans_selected; 
ConstructPanel_Rectangle  1 17 $Axis1 $Floor17 $E $A_Stiff $I_Stiff 16.00 25.70 $trans_selected; ConstructPanel_Rectangle  2 17 $Axis2 $Floor17 $E $A_Stiff $I_Stiff 37.10 25.70 $trans_selected; ConstructPanel_Rectangle  3 17 $Axis3 $Floor17 $E $A_Stiff $I_Stiff 37.10 25.70 $trans_selected; ConstructPanel_Rectangle  4 17 $Axis4 $Floor17 $E $A_Stiff $I_Stiff 16.00 25.70 $trans_selected; 
ConstructPanel_Rectangle  1 16 $Axis1 $Floor16 $E $A_Stiff $I_Stiff 16.70 33.50 $trans_selected; ConstructPanel_Rectangle  2 16 $Axis2 $Floor16 $E $A_Stiff $I_Stiff 36.30 33.50 $trans_selected; ConstructPanel_Rectangle  3 16 $Axis3 $Floor16 $E $A_Stiff $I_Stiff 36.30 33.50 $trans_selected; ConstructPanel_Rectangle  4 16 $Axis4 $Floor16 $E $A_Stiff $I_Stiff 16.70 33.50 $trans_selected; 
ConstructPanel_Rectangle  1 15 $Axis1 $Floor15 $E $A_Stiff $I_Stiff 16.70 33.50 $trans_selected; ConstructPanel_Rectangle  2 15 $Axis2 $Floor15 $E $A_Stiff $I_Stiff 36.30 33.50 $trans_selected; ConstructPanel_Rectangle  3 15 $Axis3 $Floor15 $E $A_Stiff $I_Stiff 36.30 33.50 $trans_selected; ConstructPanel_Rectangle  4 15 $Axis4 $Floor15 $E $A_Stiff $I_Stiff 16.70 33.50 $trans_selected; 
ConstructPanel_Rectangle  1 14 $Axis1 $Floor14 $E $A_Stiff $I_Stiff 17.10 33.50 $trans_selected; ConstructPanel_Rectangle  2 14 $Axis2 $Floor14 $E $A_Stiff $I_Stiff 37.10 33.50 $trans_selected; ConstructPanel_Rectangle  3 14 $Axis3 $Floor14 $E $A_Stiff $I_Stiff 37.10 33.50 $trans_selected; ConstructPanel_Rectangle  4 14 $Axis4 $Floor14 $E $A_Stiff $I_Stiff 17.10 33.50 $trans_selected; 
ConstructPanel_Rectangle  1 13 $Axis1 $Floor13 $E $A_Stiff $I_Stiff 17.10 33.80 $trans_selected; ConstructPanel_Rectangle  2 13 $Axis2 $Floor13 $E $A_Stiff $I_Stiff 37.10 33.80 $trans_selected; ConstructPanel_Rectangle  3 13 $Axis3 $Floor13 $E $A_Stiff $I_Stiff 37.10 33.80 $trans_selected; ConstructPanel_Rectangle  4 13 $Axis4 $Floor13 $E $A_Stiff $I_Stiff 17.10 33.80 $trans_selected; 
ConstructPanel_Rectangle  1 12 $Axis1 $Floor12 $E $A_Stiff $I_Stiff 17.90 33.80 $trans_selected; ConstructPanel_Rectangle  2 12 $Axis2 $Floor12 $E $A_Stiff $I_Stiff 37.40 33.80 $trans_selected; ConstructPanel_Rectangle  3 12 $Axis3 $Floor12 $E $A_Stiff $I_Stiff 37.40 33.80 $trans_selected; ConstructPanel_Rectangle  4 12 $Axis4 $Floor12 $E $A_Stiff $I_Stiff 17.90 33.80 $trans_selected; 
ConstructPanel_Rectangle  1 11 $Axis1 $Floor11 $E $A_Stiff $I_Stiff 17.90 33.80 $trans_selected; ConstructPanel_Rectangle  2 11 $Axis2 $Floor11 $E $A_Stiff $I_Stiff 37.40 33.80 $trans_selected; ConstructPanel_Rectangle  3 11 $Axis3 $Floor11 $E $A_Stiff $I_Stiff 37.40 33.80 $trans_selected; ConstructPanel_Rectangle  4 11 $Axis4 $Floor11 $E $A_Stiff $I_Stiff 17.90 33.80 $trans_selected; 
ConstructPanel_Rectangle  1 10 $Axis1 $Floor10 $E $A_Stiff $I_Stiff 17.90 33.80 $trans_selected; ConstructPanel_Rectangle  2 10 $Axis2 $Floor10 $E $A_Stiff $I_Stiff 37.80 33.80 $trans_selected; ConstructPanel_Rectangle  3 10 $Axis3 $Floor10 $E $A_Stiff $I_Stiff 37.80 33.80 $trans_selected; ConstructPanel_Rectangle  4 10 $Axis4 $Floor10 $E $A_Stiff $I_Stiff 17.90 33.80 $trans_selected; 
ConstructPanel_Rectangle  1 9 $Axis1 $Floor9 $E $A_Stiff $I_Stiff 17.90 33.80 $trans_selected; ConstructPanel_Rectangle  2 9 $Axis2 $Floor9 $E $A_Stiff $I_Stiff 37.80 33.80 $trans_selected; ConstructPanel_Rectangle  3 9 $Axis3 $Floor9 $E $A_Stiff $I_Stiff 37.80 33.80 $trans_selected; ConstructPanel_Rectangle  4 9 $Axis4 $Floor9 $E $A_Stiff $I_Stiff 17.90 33.80 $trans_selected; 
ConstructPanel_Rectangle  1 8 $Axis1 $Floor8 $E $A_Stiff $I_Stiff 19.00 33.80 $trans_selected; ConstructPanel_Rectangle  2 8 $Axis2 $Floor8 $E $A_Stiff $I_Stiff 38.30 33.80 $trans_selected; ConstructPanel_Rectangle  3 8 $Axis3 $Floor8 $E $A_Stiff $I_Stiff 38.30 33.80 $trans_selected; ConstructPanel_Rectangle  4 8 $Axis4 $Floor8 $E $A_Stiff $I_Stiff 19.00 33.80 $trans_selected; 
ConstructPanel_Rectangle  1 7 $Axis1 $Floor7 $E $A_Stiff $I_Stiff 19.00 33.80 $trans_selected; ConstructPanel_Rectangle  2 7 $Axis2 $Floor7 $E $A_Stiff $I_Stiff 38.30 33.80 $trans_selected; ConstructPanel_Rectangle  3 7 $Axis3 $Floor7 $E $A_Stiff $I_Stiff 38.30 33.80 $trans_selected; ConstructPanel_Rectangle  4 7 $Axis4 $Floor7 $E $A_Stiff $I_Stiff 19.00 33.80 $trans_selected; 
ConstructPanel_Rectangle  1 6 $Axis1 $Floor6 $E $A_Stiff $I_Stiff 19.00 33.80 $trans_selected; ConstructPanel_Rectangle  2 6 $Axis2 $Floor6 $E $A_Stiff $I_Stiff 39.30 33.80 $trans_selected; ConstructPanel_Rectangle  3 6 $Axis3 $Floor6 $E $A_Stiff $I_Stiff 39.30 33.80 $trans_selected; ConstructPanel_Rectangle  4 6 $Axis4 $Floor6 $E $A_Stiff $I_Stiff 19.00 33.80 $trans_selected; 
ConstructPanel_Rectangle  1 5 $Axis1 $Floor5 $E $A_Stiff $I_Stiff 19.00 33.80 $trans_selected; ConstructPanel_Rectangle  2 5 $Axis2 $Floor5 $E $A_Stiff $I_Stiff 39.30 33.80 $trans_selected; ConstructPanel_Rectangle  3 5 $Axis3 $Floor5 $E $A_Stiff $I_Stiff 39.30 33.80 $trans_selected; ConstructPanel_Rectangle  4 5 $Axis4 $Floor5 $E $A_Stiff $I_Stiff 19.00 33.80 $trans_selected; 
ConstructPanel_Rectangle  1 4 $Axis1 $Floor4 $E $A_Stiff $I_Stiff 19.60 33.50 $trans_selected; ConstructPanel_Rectangle  2 4 $Axis2 $Floor4 $E $A_Stiff $I_Stiff 39.20 33.50 $trans_selected; ConstructPanel_Rectangle  3 4 $Axis3 $Floor4 $E $A_Stiff $I_Stiff 39.20 33.50 $trans_selected; ConstructPanel_Rectangle  4 4 $Axis4 $Floor4 $E $A_Stiff $I_Stiff 19.60 33.50 $trans_selected; 
ConstructPanel_Rectangle  1 3 $Axis1 $Floor3 $E $A_Stiff $I_Stiff 19.60 33.50 $trans_selected; ConstructPanel_Rectangle  2 3 $Axis2 $Floor3 $E $A_Stiff $I_Stiff 39.20 33.50 $trans_selected; ConstructPanel_Rectangle  3 3 $Axis3 $Floor3 $E $A_Stiff $I_Stiff 39.20 33.50 $trans_selected; ConstructPanel_Rectangle  4 3 $Axis4 $Floor3 $E $A_Stiff $I_Stiff 19.60 33.50 $trans_selected; 
ConstructPanel_Rectangle  1 2 $Axis1 $Floor2 $E $A_Stiff $I_Stiff 19.60 33.50 $trans_selected; ConstructPanel_Rectangle  2 2 $Axis2 $Floor2 $E $A_Stiff $I_Stiff 39.20 33.50 $trans_selected; ConstructPanel_Rectangle  3 2 $Axis3 $Floor2 $E $A_Stiff $I_Stiff 39.20 33.50 $trans_selected; ConstructPanel_Rectangle  4 2 $Axis4 $Floor2 $E $A_Stiff $I_Stiff 19.60 33.50 $trans_selected; 

####################################################################################################
#                                          PANEL ZONE SPRINGS                                      #
####################################################################################################

# COMMAND SYNTAX 
# Spring_PZ    Element_ID Node_i Node_j E mu fy tw_Col tdp d_Col d_Beam tf_Col bf_Col Ic trib ts Response_ID transfTag
Spring_PZ    921100 421109 421110 $E $mu [expr $fy *   1.0]  0.65   0.06 14.70 23.90  1.03 14.70 1530.00 3.500 4.000 2 1; Spring_PZ    921200 421209 421210 $E $mu [expr $fy *   1.0]  0.63   0.00 35.90 23.90  0.94 12.00 9040.00 3.500 4.000 0 1; Spring_PZ    921300 421309 421310 $E $mu [expr $fy *   1.0]  0.63   0.00 35.90 23.90  0.94 12.00 9040.00 3.500 4.000 0 1; Spring_PZ    921400 421409 421410 $E $mu [expr $fy *   1.0]  0.65   0.06 14.70 23.90  1.03 14.70 1530.00 3.500 4.000 2 1; 
Spring_PZ    920100 420109 420110 $E $mu [expr $fy *   1.0]  0.65   0.06 14.70 23.90  1.03 14.70 1530.00 3.500 4.000 2 1; Spring_PZ    920200 420209 420210 $E $mu [expr $fy *   1.0]  0.63   0.00 35.90 23.90  0.94 12.00 9040.00 3.500 4.000 0 1; Spring_PZ    920300 420309 420310 $E $mu [expr $fy *   1.0]  0.63   0.00 35.90 23.90  0.94 12.00 9040.00 3.500 4.000 0 1; Spring_PZ    920400 420409 420410 $E $mu [expr $fy *   1.0]  0.65   0.06 14.70 23.90  1.03 14.70 1530.00 3.500 4.000 2 1; 
Spring_PZ    919100 419109 419110 $E $mu [expr $fy *   1.0]  0.89   1.00 15.50 25.70  1.44 15.70 2400.00 3.500 4.000 2 1; Spring_PZ    919200 419209 419210 $E $mu [expr $fy *   1.0]  0.77   1.00 36.50 25.70  1.26 12.10 12100.00 3.500 4.000 0 1; Spring_PZ    919300 419309 419310 $E $mu [expr $fy *   1.0]  0.77   1.00 36.50 25.70  1.26 12.10 12100.00 3.500 4.000 0 1; Spring_PZ    919400 419409 419410 $E $mu [expr $fy *   1.0]  0.89   1.00 15.50 25.70  1.44 15.70 2400.00 3.500 4.000 2 1; 
Spring_PZ    918100 418109 418110 $E $mu [expr $fy *   1.0]  0.89   1.00 15.50 25.70  1.44 15.70 2400.00 3.500 4.000 2 1; Spring_PZ    918200 418209 418210 $E $mu [expr $fy *   1.0]  0.77   1.00 36.50 25.70  1.26 12.10 12100.00 3.500 4.000 0 1; Spring_PZ    918300 418309 418310 $E $mu [expr $fy *   1.0]  0.77   1.00 36.50 25.70  1.26 12.10 12100.00 3.500 4.000 0 1; Spring_PZ    918400 418409 418410 $E $mu [expr $fy *   1.0]  0.89   1.00 15.50 25.70  1.44 15.70 2400.00 3.500 4.000 2 1; 
Spring_PZ    917100 417109 417110 $E $mu [expr $fy *   1.0]  1.07   0.06 16.00 25.70  1.72 15.90 3010.00 3.500 4.000 2 1; Spring_PZ    917200 417209 417210 $E $mu [expr $fy *   1.0]  0.87   0.81 37.10 25.70  1.57 12.10 15000.00 3.500 4.000 0 1; Spring_PZ    917300 417309 417310 $E $mu [expr $fy *   1.0]  0.87   0.81 37.10 25.70  1.57 12.10 15000.00 3.500 4.000 0 1; Spring_PZ    917400 417409 417410 $E $mu [expr $fy *   1.0]  1.07   0.06 16.00 25.70  1.72 15.90 3010.00 3.500 4.000 2 1; 
Spring_PZ    916100 416109 416110 $E $mu [expr $fy *   1.0]  1.07   0.13 16.00 33.50  1.72 15.90 3010.00 3.500 4.000 2 1; Spring_PZ    916200 416209 416210 $E $mu [expr $fy *   1.0]  0.87   0.31 37.10 33.50  1.57 12.10 15000.00 3.500 4.000 0 1; Spring_PZ    916300 416309 416310 $E $mu [expr $fy *   1.0]  0.87   0.31 37.10 33.50  1.57 12.10 15000.00 3.500 4.000 0 1; Spring_PZ    916400 416409 416410 $E $mu [expr $fy *   1.0]  1.07   0.13 16.00 33.50  1.72 15.90 3010.00 3.500 4.000 2 1; 
Spring_PZ    915100 415109 415110 $E $mu [expr $fy *   1.0]  1.29   0.00 16.70 33.50  2.07 16.10 3840.00 3.500 4.000 2 1; Spring_PZ    915200 415209 415210 $E $mu [expr $fy *   1.0]  0.84   0.38 36.30 33.50  1.44 16.60 17300.00 3.500 4.000 0 1; Spring_PZ    915300 415309 415310 $E $mu [expr $fy *   1.0]  0.84   0.38 36.30 33.50  1.44 16.60 17300.00 3.500 4.000 0 1; Spring_PZ    915400 415409 415410 $E $mu [expr $fy *   1.0]  1.29   0.00 16.70 33.50  2.07 16.10 3840.00 3.500 4.000 2 1; 
Spring_PZ    914100 414109 414110 $E $mu [expr $fy *   1.0]  1.29   0.00 16.70 33.50  2.07 16.10 3840.00 3.500 4.000 2 1; Spring_PZ    914200 414209 414210 $E $mu [expr $fy *   1.0]  0.84   0.38 36.30 33.50  1.44 16.60 17300.00 3.500 4.000 0 1; Spring_PZ    914300 414309 414310 $E $mu [expr $fy *   1.0]  0.84   0.38 36.30 33.50  1.44 16.60 17300.00 3.500 4.000 0 1; Spring_PZ    914400 414409 414410 $E $mu [expr $fy *   1.0]  1.29   0.00 16.70 33.50  2.07 16.10 3840.00 3.500 4.000 2 1; 
Spring_PZ    913100 413109 413110 $E $mu [expr $fy *   1.0]  1.41   0.00 17.10 33.80  2.26 16.20 4330.00 3.500 4.000 2 1; Spring_PZ    913200 413209 413210 $E $mu [expr $fy *   1.0]  1.02   0.25 37.10 33.80  1.85 16.60 22500.00 3.500 4.000 0 1; Spring_PZ    913300 413309 413310 $E $mu [expr $fy *   1.0]  1.02   0.25 37.10 33.80  1.85 16.60 22500.00 3.500 4.000 0 1; Spring_PZ    913400 413409 413410 $E $mu [expr $fy *   1.0]  1.41   0.00 17.10 33.80  2.26 16.20 4330.00 3.500 4.000 2 1; 
Spring_PZ    912100 412109 412110 $E $mu [expr $fy *   1.0]  1.41   0.00 17.10 33.80  2.26 16.20 4330.00 3.500 4.000 2 1; Spring_PZ    912200 412209 412210 $E $mu [expr $fy *   1.0]  1.02   0.25 37.10 33.80  1.85 16.60 22500.00 3.500 4.000 0 1; Spring_PZ    912300 412309 412310 $E $mu [expr $fy *   1.0]  1.02   0.25 37.10 33.80  1.85 16.60 22500.00 3.500 4.000 0 1; Spring_PZ    912400 412409 412410 $E $mu [expr $fy *   1.0]  1.41   0.00 17.10 33.80  2.26 16.20 4330.00 3.500 4.000 2 1; 
Spring_PZ    911100 411109 411110 $E $mu [expr $fy *   1.0]  1.66   0.00 17.90 33.80  2.66 16.50 5440.00 3.500 4.000 2 1; Spring_PZ    911200 411209 411210 $E $mu [expr $fy *   1.0]  1.12   0.13 37.40 33.80  2.01 16.70 24800.00 3.500 4.000 0 1; Spring_PZ    911300 411309 411310 $E $mu [expr $fy *   1.0]  1.12   0.13 37.40 33.80  2.01 16.70 24800.00 3.500 4.000 0 1; Spring_PZ    911400 411409 411410 $E $mu [expr $fy *   1.0]  1.66   0.00 17.90 33.80  2.66 16.50 5440.00 3.500 4.000 2 1; 
Spring_PZ    910100 410109 410110 $E $mu [expr $fy *   1.0]  1.66   0.00 17.90 33.80  2.66 16.50 5440.00 3.500 4.000 2 1; Spring_PZ    910200 410209 410210 $E $mu [expr $fy *   1.0]  1.12   0.13 37.40 33.80  2.01 16.70 24800.00 3.500 4.000 0 1; Spring_PZ    910300 410309 410310 $E $mu [expr $fy *   1.0]  1.12   0.13 37.40 33.80  2.01 16.70 24800.00 3.500 4.000 0 1; Spring_PZ    910400 410409 410410 $E $mu [expr $fy *   1.0]  1.66   0.00 17.90 33.80  2.66 16.50 5440.00 3.500 4.000 2 1; 
Spring_PZ    909100 409109 409110 $E $mu [expr $fy *   1.0]  1.66   0.00 17.90 33.80  2.66 16.50 5440.00 3.500 4.000 2 1; Spring_PZ    909200 409209 409210 $E $mu [expr $fy *   1.0]  1.22   0.00 37.80 33.80  2.20 16.80 27500.00 3.500 4.000 0 1; Spring_PZ    909300 409309 409310 $E $mu [expr $fy *   1.0]  1.22   0.00 37.80 33.80  2.20 16.80 27500.00 3.500 4.000 0 1; Spring_PZ    909400 409409 409410 $E $mu [expr $fy *   1.0]  1.66   0.00 17.90 33.80  2.66 16.50 5440.00 3.500 4.000 2 1; 
Spring_PZ    908100 408109 408110 $E $mu [expr $fy *   1.0]  1.66   0.00 17.90 33.80  2.66 16.50 5440.00 3.500 4.000 2 1; Spring_PZ    908200 408209 408210 $E $mu [expr $fy *   1.0]  1.22   0.00 37.80 33.80  2.20 16.80 27500.00 3.500 4.000 0 1; Spring_PZ    908300 408309 408310 $E $mu [expr $fy *   1.0]  1.22   0.00 37.80 33.80  2.20 16.80 27500.00 3.500 4.000 0 1; Spring_PZ    908400 408409 408410 $E $mu [expr $fy *   1.0]  1.66   0.00 17.90 33.80  2.66 16.50 5440.00 3.500 4.000 2 1; 
Spring_PZ    907100 407109 407110 $E $mu [expr $fy *   1.0]  2.02   0.00 19.00 33.80  3.21 16.80 7190.00 3.500 4.000 2 1; Spring_PZ    907200 407209 407210 $E $mu [expr $fy *   1.0]  1.36   0.00 38.30 33.80  2.44 17.00 31000.00 3.500 4.000 0 1; Spring_PZ    907300 407309 407310 $E $mu [expr $fy *   1.0]  1.36   0.00 38.30 33.80  2.44 17.00 31000.00 3.500 4.000 0 1; Spring_PZ    907400 407409 407410 $E $mu [expr $fy *   1.0]  2.02   0.00 19.00 33.80  3.21 16.80 7190.00 3.500 4.000 2 1; 
Spring_PZ    906100 406109 406110 $E $mu [expr $fy *   1.0]  2.02   0.00 19.00 33.80  3.21 16.80 7190.00 3.500 4.000 2 1; Spring_PZ    906200 406209 406210 $E $mu [expr $fy *   1.0]  1.36   0.00 38.30 33.80  2.44 17.00 31000.00 3.500 4.000 0 1; Spring_PZ    906300 406309 406310 $E $mu [expr $fy *   1.0]  1.36   0.00 38.30 33.80  2.44 17.00 31000.00 3.500 4.000 0 1; Spring_PZ    906400 406409 406410 $E $mu [expr $fy *   1.0]  2.02   0.00 19.00 33.80  3.21 16.80 7190.00 3.500 4.000 2 1; 
Spring_PZ    905100 405109 405110 $E $mu [expr $fy *   1.0]  2.02   0.00 19.00 33.80  3.21 16.80 7190.00 3.500 4.000 2 1; Spring_PZ    905200 405209 405210 $E $mu [expr $fy *   1.0]  1.50   0.00 39.30 33.80  2.68 17.10 36000.00 3.500 4.000 0 1; Spring_PZ    905300 405309 405310 $E $mu [expr $fy *   1.0]  1.50   0.00 39.30 33.80  2.68 17.10 36000.00 3.500 4.000 0 1; Spring_PZ    905400 405409 405410 $E $mu [expr $fy *   1.0]  2.02   0.00 19.00 33.80  3.21 16.80 7190.00 3.500 4.000 2 1; 
Spring_PZ    904100 404109 404110 $E $mu [expr $fy *   1.0]  2.02   0.00 19.00 33.50  3.21 16.80 7190.00 3.500 4.000 2 1; Spring_PZ    904200 404209 404210 $E $mu [expr $fy *   1.0]  1.50   0.00 39.30 33.50  2.68 17.10 36000.00 3.500 4.000 0 1; Spring_PZ    904300 404309 404310 $E $mu [expr $fy *   1.0]  1.50   0.00 39.30 33.50  2.68 17.10 36000.00 3.500 4.000 0 1; Spring_PZ    904400 404409 404410 $E $mu [expr $fy *   1.0]  2.02   0.00 19.00 33.50  3.21 16.80 7190.00 3.500 4.000 2 1; 
Spring_PZ    903100 403109 403110 $E $mu [expr $fy *   1.0]  2.19   0.00 19.60 33.50  3.50 17.00 8210.00 3.500 4.000 2 1; Spring_PZ    903200 403209 403210 $E $mu [expr $fy *   1.0]  1.61   0.00 39.20 33.50  2.91 17.20 38300.00 3.500 4.000 0 1; Spring_PZ    903300 403309 403310 $E $mu [expr $fy *   1.0]  1.61   0.00 39.20 33.50  2.91 17.20 38300.00 3.500 4.000 0 1; Spring_PZ    903400 403409 403410 $E $mu [expr $fy *   1.0]  2.19   0.00 19.60 33.50  3.50 17.00 8210.00 3.500 4.000 2 1; 
Spring_PZ    902100 402109 402110 $E $mu [expr $fy *   1.0]  2.19   0.00 19.60 33.50  3.50 17.00 8210.00 3.500 4.000 2 1; Spring_PZ    902200 402209 402210 $E $mu [expr $fy *   1.0]  1.61   0.00 39.20 33.50  2.91 17.20 38300.00 3.500 4.000 0 1; Spring_PZ    902300 402309 402310 $E $mu [expr $fy *   1.0]  1.61   0.00 39.20 33.50  2.91 17.20 38300.00 3.500 4.000 0 1; Spring_PZ    902400 402409 402410 $E $mu [expr $fy *   1.0]  2.19   0.00 19.60 33.50  3.50 17.00 8210.00 3.500 4.000 2 1; 

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
element ModElasticBeam2d   620100     2013     2111  38.8000 $E [expr ($n+1)/$n*1530.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   620200     2023     2121  44.2000 $E [expr ($n+1)/$n*9040.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   620300     2033     2131  44.2000 $E [expr ($n+1)/$n*9040.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   620400     2043     2141  38.8000 $E [expr ($n+1)/$n*1530.0000] $K11_2 $K33_2 $K44_2 $trans_selected; 
element ModElasticBeam2d   619102   119172     2011 38.8000 $E [expr ($n+1)/$n*1530.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   619202   119272     2021 44.2000 $E [expr ($n+1)/$n*9040.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   619302   119372     2031 44.2000 $E [expr ($n+1)/$n*9040.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   619402   119472     2041 38.8000 $E [expr ($n+1)/$n*1530.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  
element ModElasticBeam2d   619101     1913   119171 56.8000 $E [expr ($n+1)/$n*2400.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   619201     1923   119271 57.0000 $E [expr ($n+1)/$n*12100.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   619301     1933   119371 57.0000 $E [expr ($n+1)/$n*12100.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   619401     1943   119471 56.8000 $E [expr ($n+1)/$n*2400.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  
element ModElasticBeam2d   618100     1813     1911  56.8000 $E [expr ($n+1)/$n*2400.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   618200     1823     1921  57.0000 $E [expr ($n+1)/$n*12100.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   618300     1833     1931  57.0000 $E [expr ($n+1)/$n*12100.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   618400     1843     1941  56.8000 $E [expr ($n+1)/$n*2400.0000] $K11_2 $K33_2 $K44_2 $trans_selected; 
element ModElasticBeam2d   617102   117172     1811 56.8000 $E [expr ($n+1)/$n*2400.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   617202   117272     1821 57.0000 $E [expr ($n+1)/$n*12100.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   617302   117372     1831 57.0000 $E [expr ($n+1)/$n*12100.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   617402   117472     1841 56.8000 $E [expr ($n+1)/$n*2400.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  
element ModElasticBeam2d   617101     1713   117171 68.5000 $E [expr ($n+1)/$n*3010.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   617201     1723   117271 68.1000 $E [expr ($n+1)/$n*15000.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   617301     1733   117371 68.1000 $E [expr ($n+1)/$n*15000.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   617401     1743   117471 68.5000 $E [expr ($n+1)/$n*3010.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  
element ModElasticBeam2d   616100     1613     1711  68.5000 $E [expr ($n+1)/$n*3010.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   616200     1623     1721  68.1000 $E [expr ($n+1)/$n*15000.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   616300     1633     1731  68.1000 $E [expr ($n+1)/$n*15000.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   616400     1643     1741  68.5000 $E [expr ($n+1)/$n*3010.0000] $K11_2 $K33_2 $K44_2 $trans_selected; 
element ModElasticBeam2d   615102   115172     1611 68.5000 $E [expr ($n+1)/$n*3010.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   615202   115272     1621 68.1000 $E [expr ($n+1)/$n*15000.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   615302   115372     1631 68.1000 $E [expr ($n+1)/$n*15000.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   615402   115472     1641 68.5000 $E [expr ($n+1)/$n*3010.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  
element ModElasticBeam2d   615101     1513   115171 83.3000 $E [expr ($n+1)/$n*3840.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   615201     1523   115271 76.5000 $E [expr ($n+1)/$n*17300.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   615301     1533   115371 76.5000 $E [expr ($n+1)/$n*17300.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   615401     1543   115471 83.3000 $E [expr ($n+1)/$n*3840.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  
element ModElasticBeam2d   614100     1413     1511  83.3000 $E [expr ($n+1)/$n*3840.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   614200     1423     1521  76.5000 $E [expr ($n+1)/$n*17300.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   614300     1433     1531  76.5000 $E [expr ($n+1)/$n*17300.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   614400     1443     1541  83.3000 $E [expr ($n+1)/$n*3840.0000] $K11_2 $K33_2 $K44_2 $trans_selected; 
element ModElasticBeam2d   613102   113172     1411 83.3000 $E [expr ($n+1)/$n*3840.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   613202   113272     1421 76.5000 $E [expr ($n+1)/$n*17300.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   613302   113372     1431 76.5000 $E [expr ($n+1)/$n*17300.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   613402   113472     1441 83.3000 $E [expr ($n+1)/$n*3840.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  
element ModElasticBeam2d   613101     1313   113171 91.4000 $E [expr ($n+1)/$n*4330.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   613201     1323   113271 96.4000 $E [expr ($n+1)/$n*22500.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   613301     1333   113371 96.4000 $E [expr ($n+1)/$n*22500.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   613401     1343   113471 91.4000 $E [expr ($n+1)/$n*4330.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  
element ModElasticBeam2d   612100     1213     1311  91.4000 $E [expr ($n+1)/$n*4330.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   612200     1223     1321  96.4000 $E [expr ($n+1)/$n*22500.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   612300     1233     1331  96.4000 $E [expr ($n+1)/$n*22500.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   612400     1243     1341  91.4000 $E [expr ($n+1)/$n*4330.0000] $K11_2 $K33_2 $K44_2 $trans_selected; 
element ModElasticBeam2d   611102   111172     1211 91.4000 $E [expr ($n+1)/$n*4330.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   611202   111272     1221 96.4000 $E [expr ($n+1)/$n*22500.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   611302   111372     1231 96.4000 $E [expr ($n+1)/$n*22500.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   611402   111472     1241 91.4000 $E [expr ($n+1)/$n*4330.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  
element ModElasticBeam2d   611101     1113   111171 109.0000 $E [expr ($n+1)/$n*5440.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   611201     1123   111271 105.0000 $E [expr ($n+1)/$n*24800.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   611301     1133   111371 105.0000 $E [expr ($n+1)/$n*24800.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   611401     1143   111471 109.0000 $E [expr ($n+1)/$n*5440.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  
element ModElasticBeam2d   610100     1013     1111  109.0000 $E [expr ($n+1)/$n*5440.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   610200     1023     1121  105.0000 $E [expr ($n+1)/$n*24800.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   610300     1033     1131  105.0000 $E [expr ($n+1)/$n*24800.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   610400     1043     1141  109.0000 $E [expr ($n+1)/$n*5440.0000] $K11_2 $K33_2 $K44_2 $trans_selected; 
element ModElasticBeam2d   609102   109172     1011 109.0000 $E [expr ($n+1)/$n*5440.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   609202   109272     1021 105.0000 $E [expr ($n+1)/$n*24800.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   609302   109372     1031 105.0000 $E [expr ($n+1)/$n*24800.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   609402   109472     1041 109.0000 $E [expr ($n+1)/$n*5440.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  
element ModElasticBeam2d   609101      913   109171 109.0000 $E [expr ($n+1)/$n*5440.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   609201      923   109271 116.0000 $E [expr ($n+1)/$n*27500.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   609301      933   109371 116.0000 $E [expr ($n+1)/$n*27500.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   609401      943   109471 109.0000 $E [expr ($n+1)/$n*5440.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  
element ModElasticBeam2d   608100      813      911  109.0000 $E [expr ($n+1)/$n*5440.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   608200      823      921  116.0000 $E [expr ($n+1)/$n*27500.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   608300      833      931  116.0000 $E [expr ($n+1)/$n*27500.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   608400      843      941  109.0000 $E [expr ($n+1)/$n*5440.0000] $K11_2 $K33_2 $K44_2 $trans_selected; 
element ModElasticBeam2d   607102   107172      811 109.0000 $E [expr ($n+1)/$n*5440.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   607202   107272      821 116.0000 $E [expr ($n+1)/$n*27500.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   607302   107372      831 116.0000 $E [expr ($n+1)/$n*27500.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   607402   107472      841 109.0000 $E [expr ($n+1)/$n*5440.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  
element ModElasticBeam2d   607101      713   107171 134.0000 $E [expr ($n+1)/$n*7190.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   607201      723   107271 129.0000 $E [expr ($n+1)/$n*31000.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   607301      733   107371 129.0000 $E [expr ($n+1)/$n*31000.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   607401      743   107471 134.0000 $E [expr ($n+1)/$n*7190.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  
element ModElasticBeam2d   606100      613      711  134.0000 $E [expr ($n+1)/$n*7190.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   606200      623      721  129.0000 $E [expr ($n+1)/$n*31000.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   606300      633      731  129.0000 $E [expr ($n+1)/$n*31000.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   606400      643      741  134.0000 $E [expr ($n+1)/$n*7190.0000] $K11_2 $K33_2 $K44_2 $trans_selected; 
element ModElasticBeam2d   605102   105172      611 134.0000 $E [expr ($n+1)/$n*7190.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   605202   105272      621 129.0000 $E [expr ($n+1)/$n*31000.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   605302   105372      631 129.0000 $E [expr ($n+1)/$n*31000.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   605402   105472      641 134.0000 $E [expr ($n+1)/$n*7190.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  
element ModElasticBeam2d   605101      513   105171 134.0000 $E [expr ($n+1)/$n*7190.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   605201      523   105271 143.0000 $E [expr ($n+1)/$n*36000.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   605301      533   105371 143.0000 $E [expr ($n+1)/$n*36000.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   605401      543   105471 134.0000 $E [expr ($n+1)/$n*7190.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  
element ModElasticBeam2d   604100      413      511  134.0000 $E [expr ($n+1)/$n*7190.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   604200      423      521  143.0000 $E [expr ($n+1)/$n*36000.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   604300      433      531  143.0000 $E [expr ($n+1)/$n*36000.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   604400      443      541  134.0000 $E [expr ($n+1)/$n*7190.0000] $K11_2 $K33_2 $K44_2 $trans_selected; 
element ModElasticBeam2d   603102   103172      411 134.0000 $E [expr ($n+1)/$n*7190.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   603202   103272      421 143.0000 $E [expr ($n+1)/$n*36000.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   603302   103372      431 143.0000 $E [expr ($n+1)/$n*36000.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   603402   103472      441 134.0000 $E [expr ($n+1)/$n*7190.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  
element ModElasticBeam2d   603101      313   103171 147.0000 $E [expr ($n+1)/$n*8210.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   603201      323   103271 155.0000 $E [expr ($n+1)/$n*38300.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   603301      333   103371 155.0000 $E [expr ($n+1)/$n*38300.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  element ModElasticBeam2d   603401      343   103471 147.0000 $E [expr ($n+1)/$n*8210.0000] $K33_1 $K11_1 $K44_1 $trans_selected;  
element ModElasticBeam2d   602100      213      311  147.0000 $E [expr ($n+1)/$n*8210.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   602200      223      321  155.0000 $E [expr ($n+1)/$n*38300.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   602300      233      331  155.0000 $E [expr ($n+1)/$n*38300.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   602400      243      341  147.0000 $E [expr ($n+1)/$n*8210.0000] $K11_2 $K33_2 $K44_2 $trans_selected; 
element ModElasticBeam2d   601100      113      211  147.0000 $E [expr ($n+1)/$n*8210.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   601200      123      221  155.0000 $E [expr ($n+1)/$n*38300.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   601300      133      231  155.0000 $E [expr ($n+1)/$n*38300.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   601400      143      241  147.0000 $E [expr ($n+1)/$n*8210.0000] $K11_2 $K33_2 $K44_2 $trans_selected; 

# BEAMS
element ModElasticBeam2d   521100     2114     2122  22.4000 $E [expr ($n+1)/$n*0.90*$Comp_I*2100.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   521200     2124     2132  22.4000 $E [expr ($n+1)/$n*0.90*$Comp_I*2100.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   521300     2134     2142  22.4000 $E [expr ($n+1)/$n*0.90*$Comp_I*2100.0000] $K11_2 $K33_2 $K44_2 $trans_selected; 
element ModElasticBeam2d   520100     2014     2022  22.4000 $E [expr ($n+1)/$n*0.90*$Comp_I*2100.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   520200     2024     2032  22.4000 $E [expr ($n+1)/$n*0.90*$Comp_I*2100.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   520300     2034     2042  22.4000 $E [expr ($n+1)/$n*0.90*$Comp_I*2100.0000] $K11_2 $K33_2 $K44_2 $trans_selected; 
element ModElasticBeam2d   519100     1914     1922  60.7000 $E [expr ($n+1)/$n*0.90*$Comp_I*6820.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   519200     1924     1932  60.7000 $E [expr ($n+1)/$n*0.90*$Comp_I*6820.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   519300     1934     1942  60.7000 $E [expr ($n+1)/$n*0.90*$Comp_I*6820.0000] $K11_2 $K33_2 $K44_2 $trans_selected; 
element ModElasticBeam2d   518100     1814     1822  60.7000 $E [expr ($n+1)/$n*0.90*$Comp_I*6820.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   518200     1824     1832  60.7000 $E [expr ($n+1)/$n*0.90*$Comp_I*6820.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   518300     1834     1842  60.7000 $E [expr ($n+1)/$n*0.90*$Comp_I*6820.0000] $K11_2 $K33_2 $K44_2 $trans_selected; 
element ModElasticBeam2d   517100     1714     1722  60.7000 $E [expr ($n+1)/$n*0.90*$Comp_I*6820.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   517200     1724     1732  60.7000 $E [expr ($n+1)/$n*0.90*$Comp_I*6820.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   517300     1734     1742  60.7000 $E [expr ($n+1)/$n*0.90*$Comp_I*6820.0000] $K11_2 $K33_2 $K44_2 $trans_selected; 
element ModElasticBeam2d   516100     1614     1622  44.8000 $E [expr ($n+1)/$n*0.90*$Comp_I*8160.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   516200     1624     1632  44.8000 $E [expr ($n+1)/$n*0.90*$Comp_I*8160.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   516300     1634     1642  44.8000 $E [expr ($n+1)/$n*0.90*$Comp_I*8160.0000] $K11_2 $K33_2 $K44_2 $trans_selected; 
element ModElasticBeam2d   515100     1514     1522  44.8000 $E [expr ($n+1)/$n*0.90*$Comp_I*8160.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   515200     1524     1532  44.8000 $E [expr ($n+1)/$n*0.90*$Comp_I*8160.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   515300     1534     1542  44.8000 $E [expr ($n+1)/$n*0.90*$Comp_I*8160.0000] $K11_2 $K33_2 $K44_2 $trans_selected; 
element ModElasticBeam2d   514100     1414     1422  44.8000 $E [expr ($n+1)/$n*0.90*$Comp_I*8160.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   514200     1424     1432  44.8000 $E [expr ($n+1)/$n*0.90*$Comp_I*8160.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   514300     1434     1442  44.8000 $E [expr ($n+1)/$n*0.90*$Comp_I*8160.0000] $K11_2 $K33_2 $K44_2 $trans_selected; 
element ModElasticBeam2d   513100     1314     1322  49.5000 $E [expr ($n+1)/$n*0.90*$Comp_I*9290.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   513200     1324     1332  49.5000 $E [expr ($n+1)/$n*0.90*$Comp_I*9290.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   513300     1334     1342  49.5000 $E [expr ($n+1)/$n*0.90*$Comp_I*9290.0000] $K11_2 $K33_2 $K44_2 $trans_selected; 
element ModElasticBeam2d   512100     1214     1222  49.5000 $E [expr ($n+1)/$n*0.90*$Comp_I*9290.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   512200     1224     1232  49.5000 $E [expr ($n+1)/$n*0.90*$Comp_I*9290.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   512300     1234     1242  49.5000 $E [expr ($n+1)/$n*0.90*$Comp_I*9290.0000] $K11_2 $K33_2 $K44_2 $trans_selected; 
element ModElasticBeam2d   511100     1114     1122  49.5000 $E [expr ($n+1)/$n*0.90*$Comp_I*9290.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   511200     1124     1132  49.5000 $E [expr ($n+1)/$n*0.90*$Comp_I*9290.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   511300     1134     1142  49.5000 $E [expr ($n+1)/$n*0.90*$Comp_I*9290.0000] $K11_2 $K33_2 $K44_2 $trans_selected; 
element ModElasticBeam2d   510100     1014     1022  49.5000 $E [expr ($n+1)/$n*0.90*$Comp_I*9290.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   510200     1024     1032  49.5000 $E [expr ($n+1)/$n*0.90*$Comp_I*9290.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   510300     1034     1042  49.5000 $E [expr ($n+1)/$n*0.90*$Comp_I*9290.0000] $K11_2 $K33_2 $K44_2 $trans_selected; 
element ModElasticBeam2d   509100      914      922  49.5000 $E [expr ($n+1)/$n*0.90*$Comp_I*9290.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   509200      924      932  49.5000 $E [expr ($n+1)/$n*0.90*$Comp_I*9290.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   509300      934      942  49.5000 $E [expr ($n+1)/$n*0.90*$Comp_I*9290.0000] $K11_2 $K33_2 $K44_2 $trans_selected; 
element ModElasticBeam2d   508100      814      822  49.5000 $E [expr ($n+1)/$n*0.90*$Comp_I*9290.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   508200      824      832  49.5000 $E [expr ($n+1)/$n*0.90*$Comp_I*9290.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   508300      834      842  49.5000 $E [expr ($n+1)/$n*0.90*$Comp_I*9290.0000] $K11_2 $K33_2 $K44_2 $trans_selected; 
element ModElasticBeam2d   507100      714      722  49.5000 $E [expr ($n+1)/$n*0.90*$Comp_I*9290.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   507200      724      732  49.5000 $E [expr ($n+1)/$n*0.90*$Comp_I*9290.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   507300      734      742  49.5000 $E [expr ($n+1)/$n*0.90*$Comp_I*9290.0000] $K11_2 $K33_2 $K44_2 $trans_selected; 
element ModElasticBeam2d   506100      614      622  49.5000 $E [expr ($n+1)/$n*0.90*$Comp_I*9290.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   506200      624      632  49.5000 $E [expr ($n+1)/$n*0.90*$Comp_I*9290.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   506300      634      642  49.5000 $E [expr ($n+1)/$n*0.90*$Comp_I*9290.0000] $K11_2 $K33_2 $K44_2 $trans_selected; 
element ModElasticBeam2d   505100      514      522  49.5000 $E [expr ($n+1)/$n*0.90*$Comp_I*9290.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   505200      524      532  49.5000 $E [expr ($n+1)/$n*0.90*$Comp_I*9290.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   505300      534      542  49.5000 $E [expr ($n+1)/$n*0.90*$Comp_I*9290.0000] $K11_2 $K33_2 $K44_2 $trans_selected; 
element ModElasticBeam2d   504100      414      422  44.8000 $E [expr ($n+1)/$n*0.90*$Comp_I*8160.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   504200      424      432  44.8000 $E [expr ($n+1)/$n*0.90*$Comp_I*8160.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   504300      434      442  44.8000 $E [expr ($n+1)/$n*0.90*$Comp_I*8160.0000] $K11_2 $K33_2 $K44_2 $trans_selected; 
element ModElasticBeam2d   503100      314      322  44.8000 $E [expr ($n+1)/$n*0.90*$Comp_I*8160.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   503200      324      332  44.8000 $E [expr ($n+1)/$n*0.90*$Comp_I*8160.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   503300      334      342  44.8000 $E [expr ($n+1)/$n*0.90*$Comp_I*8160.0000] $K11_2 $K33_2 $K44_2 $trans_selected; 
element ModElasticBeam2d   502100      214      222  44.8000 $E [expr ($n+1)/$n*0.90*$Comp_I*8160.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   502200      224      232  44.8000 $E [expr ($n+1)/$n*0.90*$Comp_I*8160.0000] $K11_2 $K33_2 $K44_2 $trans_selected; element ModElasticBeam2d   502300      234      242  44.8000 $E [expr ($n+1)/$n*0.90*$Comp_I*8160.0000] $K11_2 $K33_2 $K44_2 $trans_selected; 

####################################################################################################
#                                      ELASTIC RBS ELEMENTS                                        #
####################################################################################################

element elasticBeamColumn 521104 421104 21140 19.343 $E [expr $Comp_I*1687.877] 1; element elasticBeamColumn 521202 421202 21220 19.343 $E [expr $Comp_I*1687.877] 1; element elasticBeamColumn 521204 421204 21240 19.343 $E [expr $Comp_I*1687.877] 1; element elasticBeamColumn 521302 421302 21320 19.343 $E [expr $Comp_I*1687.877] 1; element elasticBeamColumn 521304 421304 21340 19.343 $E [expr $Comp_I*1687.877] 1; element elasticBeamColumn 521402 421402 21420 19.343 $E [expr $Comp_I*1687.877] 1; 
element elasticBeamColumn 520104 420104 20140 19.343 $E [expr $Comp_I*1687.877] 1; element elasticBeamColumn 520202 420202 20220 19.343 $E [expr $Comp_I*1687.877] 1; element elasticBeamColumn 520204 420204 20240 19.343 $E [expr $Comp_I*1687.877] 1; element elasticBeamColumn 520302 420302 20320 19.343 $E [expr $Comp_I*1687.877] 1; element elasticBeamColumn 520304 420304 20340 19.343 $E [expr $Comp_I*1687.877] 1; element elasticBeamColumn 520402 420402 20420 19.343 $E [expr $Comp_I*1687.877] 1; 
element elasticBeamColumn 519104 419104 19140 50.495 $E [expr $Comp_I*5332.421] 1; element elasticBeamColumn 519202 419202 19220 50.495 $E [expr $Comp_I*5332.421] 1; element elasticBeamColumn 519204 419204 19240 50.495 $E [expr $Comp_I*5332.421] 1; element elasticBeamColumn 519302 419302 19320 50.495 $E [expr $Comp_I*5332.421] 1; element elasticBeamColumn 519304 419304 19340 50.495 $E [expr $Comp_I*5332.421] 1; element elasticBeamColumn 519402 419402 19420 50.495 $E [expr $Comp_I*5332.421] 1; 
element elasticBeamColumn 518104 418104 18140 50.495 $E [expr $Comp_I*5332.421] 1; element elasticBeamColumn 518202 418202 18220 50.495 $E [expr $Comp_I*5332.421] 1; element elasticBeamColumn 518204 418204 18240 50.495 $E [expr $Comp_I*5332.421] 1; element elasticBeamColumn 518302 418302 18320 50.495 $E [expr $Comp_I*5332.421] 1; element elasticBeamColumn 518304 418304 18340 50.495 $E [expr $Comp_I*5332.421] 1; element elasticBeamColumn 518402 418402 18420 50.495 $E [expr $Comp_I*5332.421] 1; 
element elasticBeamColumn 517104 417104 17140 50.495 $E [expr $Comp_I*5332.421] 1; element elasticBeamColumn 517202 417202 17220 50.495 $E [expr $Comp_I*5332.421] 1; element elasticBeamColumn 517204 417204 17240 50.495 $E [expr $Comp_I*5332.421] 1; element elasticBeamColumn 517302 417302 17320 50.495 $E [expr $Comp_I*5332.421] 1; element elasticBeamColumn 517304 417304 17340 50.495 $E [expr $Comp_I*5332.421] 1; element elasticBeamColumn 517402 417402 17420 50.495 $E [expr $Comp_I*5332.421] 1; 
element elasticBeamColumn 516104 416104 16140 38.652 $E [expr $Comp_I*6541.957] 1; element elasticBeamColumn 516202 416202 16220 38.652 $E [expr $Comp_I*6541.957] 1; element elasticBeamColumn 516204 416204 16240 38.652 $E [expr $Comp_I*6541.957] 1; element elasticBeamColumn 516302 416302 16320 38.652 $E [expr $Comp_I*6541.957] 1; element elasticBeamColumn 516304 416304 16340 38.652 $E [expr $Comp_I*6541.957] 1; element elasticBeamColumn 516402 416402 16420 38.652 $E [expr $Comp_I*6541.957] 1; 
element elasticBeamColumn 515104 415104 15140 38.652 $E [expr $Comp_I*6541.957] 1; element elasticBeamColumn 515202 415202 15220 38.652 $E [expr $Comp_I*6541.957] 1; element elasticBeamColumn 515204 415204 15240 38.652 $E [expr $Comp_I*6541.957] 1; element elasticBeamColumn 515302 415302 15320 38.652 $E [expr $Comp_I*6541.957] 1; element elasticBeamColumn 515304 415304 15340 38.652 $E [expr $Comp_I*6541.957] 1; element elasticBeamColumn 515402 415402 15420 38.652 $E [expr $Comp_I*6541.957] 1; 
element elasticBeamColumn 514104 414104 14140 38.652 $E [expr $Comp_I*6541.957] 1; element elasticBeamColumn 514202 414202 14220 38.652 $E [expr $Comp_I*6541.957] 1; element elasticBeamColumn 514204 414204 14240 38.652 $E [expr $Comp_I*6541.957] 1; element elasticBeamColumn 514302 414302 14320 38.652 $E [expr $Comp_I*6541.957] 1; element elasticBeamColumn 514304 414304 14340 38.652 $E [expr $Comp_I*6541.957] 1; element elasticBeamColumn 514402 414402 14420 38.652 $E [expr $Comp_I*6541.957] 1; 
element elasticBeamColumn 513104 413104 13140 42.485 $E [expr $Comp_I*7427.601] 1; element elasticBeamColumn 513202 413202 13220 42.485 $E [expr $Comp_I*7427.601] 1; element elasticBeamColumn 513204 413204 13240 42.485 $E [expr $Comp_I*7427.601] 1; element elasticBeamColumn 513302 413302 13320 42.485 $E [expr $Comp_I*7427.601] 1; element elasticBeamColumn 513304 413304 13340 42.485 $E [expr $Comp_I*7427.601] 1; element elasticBeamColumn 513402 413402 13420 42.485 $E [expr $Comp_I*7427.601] 1; 
element elasticBeamColumn 512104 412104 12140 42.485 $E [expr $Comp_I*7427.601] 1; element elasticBeamColumn 512202 412202 12220 42.485 $E [expr $Comp_I*7427.601] 1; element elasticBeamColumn 512204 412204 12240 42.485 $E [expr $Comp_I*7427.601] 1; element elasticBeamColumn 512302 412302 12320 42.485 $E [expr $Comp_I*7427.601] 1; element elasticBeamColumn 512304 412304 12340 42.485 $E [expr $Comp_I*7427.601] 1; element elasticBeamColumn 512402 412402 12420 42.485 $E [expr $Comp_I*7427.601] 1; 
element elasticBeamColumn 511104 411104 11140 42.485 $E [expr $Comp_I*7427.601] 1; element elasticBeamColumn 511202 411202 11220 42.485 $E [expr $Comp_I*7427.601] 1; element elasticBeamColumn 511204 411204 11240 42.485 $E [expr $Comp_I*7427.601] 1; element elasticBeamColumn 511302 411302 11320 42.485 $E [expr $Comp_I*7427.601] 1; element elasticBeamColumn 511304 411304 11340 42.485 $E [expr $Comp_I*7427.601] 1; element elasticBeamColumn 511402 411402 11420 42.485 $E [expr $Comp_I*7427.601] 1; 
element elasticBeamColumn 510104 410104 10140 42.485 $E [expr $Comp_I*7427.601] 1; element elasticBeamColumn 510202 410202 10220 42.485 $E [expr $Comp_I*7427.601] 1; element elasticBeamColumn 510204 410204 10240 42.485 $E [expr $Comp_I*7427.601] 1; element elasticBeamColumn 510302 410302 10320 42.485 $E [expr $Comp_I*7427.601] 1; element elasticBeamColumn 510304 410304 10340 42.485 $E [expr $Comp_I*7427.601] 1; element elasticBeamColumn 510402 410402 10420 42.485 $E [expr $Comp_I*7427.601] 1; 
element elasticBeamColumn 509104 409104 9140 42.485 $E [expr $Comp_I*7427.601] 1; element elasticBeamColumn 509202 409202 9220 42.485 $E [expr $Comp_I*7427.601] 1; element elasticBeamColumn 509204 409204 9240 42.485 $E [expr $Comp_I*7427.601] 1; element elasticBeamColumn 509302 409302 9320 42.485 $E [expr $Comp_I*7427.601] 1; element elasticBeamColumn 509304 409304 9340 42.485 $E [expr $Comp_I*7427.601] 1; element elasticBeamColumn 509402 409402 9420 42.485 $E [expr $Comp_I*7427.601] 1; 
element elasticBeamColumn 508104 408104 8140 42.485 $E [expr $Comp_I*7427.601] 1; element elasticBeamColumn 508202 408202 8220 42.485 $E [expr $Comp_I*7427.601] 1; element elasticBeamColumn 508204 408204 8240 42.485 $E [expr $Comp_I*7427.601] 1; element elasticBeamColumn 508302 408302 8320 42.485 $E [expr $Comp_I*7427.601] 1; element elasticBeamColumn 508304 408304 8340 42.485 $E [expr $Comp_I*7427.601] 1; element elasticBeamColumn 508402 408402 8420 42.485 $E [expr $Comp_I*7427.601] 1; 
element elasticBeamColumn 507104 407104 7140 42.485 $E [expr $Comp_I*7427.601] 1; element elasticBeamColumn 507202 407202 7220 42.485 $E [expr $Comp_I*7427.601] 1; element elasticBeamColumn 507204 407204 7240 42.485 $E [expr $Comp_I*7427.601] 1; element elasticBeamColumn 507302 407302 7320 42.485 $E [expr $Comp_I*7427.601] 1; element elasticBeamColumn 507304 407304 7340 42.485 $E [expr $Comp_I*7427.601] 1; element elasticBeamColumn 507402 407402 7420 42.485 $E [expr $Comp_I*7427.601] 1; 
element elasticBeamColumn 506104 406104 6140 42.485 $E [expr $Comp_I*7427.601] 1; element elasticBeamColumn 506202 406202 6220 42.485 $E [expr $Comp_I*7427.601] 1; element elasticBeamColumn 506204 406204 6240 42.485 $E [expr $Comp_I*7427.601] 1; element elasticBeamColumn 506302 406302 6320 42.485 $E [expr $Comp_I*7427.601] 1; element elasticBeamColumn 506304 406304 6340 42.485 $E [expr $Comp_I*7427.601] 1; element elasticBeamColumn 506402 406402 6420 42.485 $E [expr $Comp_I*7427.601] 1; 
element elasticBeamColumn 505104 405104 5140 42.485 $E [expr $Comp_I*7427.601] 1; element elasticBeamColumn 505202 405202 5220 42.485 $E [expr $Comp_I*7427.601] 1; element elasticBeamColumn 505204 405204 5240 42.485 $E [expr $Comp_I*7427.601] 1; element elasticBeamColumn 505302 405302 5320 42.485 $E [expr $Comp_I*7427.601] 1; element elasticBeamColumn 505304 405304 5340 42.485 $E [expr $Comp_I*7427.601] 1; element elasticBeamColumn 505402 405402 5420 42.485 $E [expr $Comp_I*7427.601] 1; 
element elasticBeamColumn 504104 404104 4140 38.652 $E [expr $Comp_I*6541.957] 1; element elasticBeamColumn 504202 404202 4220 38.652 $E [expr $Comp_I*6541.957] 1; element elasticBeamColumn 504204 404204 4240 38.652 $E [expr $Comp_I*6541.957] 1; element elasticBeamColumn 504302 404302 4320 38.652 $E [expr $Comp_I*6541.957] 1; element elasticBeamColumn 504304 404304 4340 38.652 $E [expr $Comp_I*6541.957] 1; element elasticBeamColumn 504402 404402 4420 38.652 $E [expr $Comp_I*6541.957] 1; 
element elasticBeamColumn 503104 403104 3140 38.652 $E [expr $Comp_I*6541.957] 1; element elasticBeamColumn 503202 403202 3220 38.652 $E [expr $Comp_I*6541.957] 1; element elasticBeamColumn 503204 403204 3240 38.652 $E [expr $Comp_I*6541.957] 1; element elasticBeamColumn 503302 403302 3320 38.652 $E [expr $Comp_I*6541.957] 1; element elasticBeamColumn 503304 403304 3340 38.652 $E [expr $Comp_I*6541.957] 1; element elasticBeamColumn 503402 403402 3420 38.652 $E [expr $Comp_I*6541.957] 1; 
element elasticBeamColumn 502104 402104 2140 38.652 $E [expr $Comp_I*6541.957] 1; element elasticBeamColumn 502202 402202 2220 38.652 $E [expr $Comp_I*6541.957] 1; element elasticBeamColumn 502204 402204 2240 38.652 $E [expr $Comp_I*6541.957] 1; element elasticBeamColumn 502302 402302 2320 38.652 $E [expr $Comp_I*6541.957] 1; element elasticBeamColumn 502304 402304 2340 38.652 $E [expr $Comp_I*6541.957] 1; element elasticBeamColumn 502402 402402 2420 38.652 $E [expr $Comp_I*6541.957] 1; 

###################################################################################################
#                                           MF BEAM SPRINGS                                       #
###################################################################################################

# Command Syntax 
# Spring_IMK SpringID iNode jNode E fy Ix d htw bftf ry L Ls Lb My PgPye CompositeFLAG MFconnection Units; 

Spring_IMK 921104 2114 21140 $E $fy [expr $Comp_I*1275.753] 23.900 49.000 6.610 1.920 185.538 92.769 107.350 7675.026 0.0 $Composite 0 2; Spring_IMK 921202 21220 2122 $E $fy [expr $Comp_I*1275.753] 23.900 49.000 6.610 1.920 185.538 92.769 107.350 7675.026 0.0 $Composite 0 2; Spring_IMK 921204 2124 21240 $E $fy [expr $Comp_I*1275.753] 23.900 49.000 6.610 1.920 185.538 92.769 107.350 7675.026 0.0 $Composite 0 2; Spring_IMK 921302 21320 2132 $E $fy [expr $Comp_I*1275.753] 23.900 49.000 6.610 1.920 174.938 87.469 102.050 7675.026 0.0 $Composite 0 2; Spring_IMK 921304 2134 21340 $E $fy [expr $Comp_I*1275.753] 23.900 49.000 6.610 1.920 174.938 87.469 102.050 7675.026 0.0 $Composite 0 2; Spring_IMK 921402 21420 2142 $E $fy [expr $Comp_I*1275.753] 23.900 49.000 6.610 1.920 185.538 92.769 107.350 7675.026 0.0 $Composite 0 2; 
Spring_IMK 920104 2014 20140 $E $fy [expr $Comp_I*1275.753] 23.900 49.000 6.610 1.920 185.538 92.769 107.350 7675.026 0.0 $Composite 0 2; Spring_IMK 920202 20220 2022 $E $fy [expr $Comp_I*1275.753] 23.900 49.000 6.610 1.920 185.538 92.769 107.350 7675.026 0.0 $Composite 0 2; Spring_IMK 920204 2024 20240 $E $fy [expr $Comp_I*1275.753] 23.900 49.000 6.610 1.920 185.538 92.769 107.350 7675.026 0.0 $Composite 0 2; Spring_IMK 920302 20320 2032 $E $fy [expr $Comp_I*1275.753] 23.900 49.000 6.610 1.920 174.938 87.469 102.050 7675.026 0.0 $Composite 0 2; Spring_IMK 920304 2034 20340 $E $fy [expr $Comp_I*1275.753] 23.900 49.000 6.610 1.920 174.938 87.469 102.050 7675.026 0.0 $Composite 0 2; Spring_IMK 920402 20420 2042 $E $fy [expr $Comp_I*1275.753] 23.900 49.000 6.610 1.920 185.538 92.769 107.350 7675.026 0.0 $Composite 0 2; 
Spring_IMK 919104 1914 19140 $E $fy [expr $Comp_I*3844.842] 25.700 24.800 4.140 3.080 178.475 89.237 107.000 21595.116 0.0 $Composite 0 2; Spring_IMK 919202 19220 1922 $E $fy [expr $Comp_I*3844.842] 25.700 24.800 4.140 3.080 178.475 89.237 107.000 21595.116 0.0 $Composite 0 2; Spring_IMK 919204 1924 19240 $E $fy [expr $Comp_I*3844.842] 25.700 24.800 4.140 3.080 178.475 89.237 107.000 21595.116 0.0 $Composite 0 2; Spring_IMK 919302 19320 1932 $E $fy [expr $Comp_I*3844.842] 25.700 24.800 4.140 3.080 167.975 83.987 101.750 21595.116 0.0 $Composite 0 2; Spring_IMK 919304 1934 19340 $E $fy [expr $Comp_I*3844.842] 25.700 24.800 4.140 3.080 167.975 83.987 101.750 21595.116 0.0 $Composite 0 2; Spring_IMK 919402 19420 1942 $E $fy [expr $Comp_I*3844.842] 25.700 24.800 4.140 3.080 178.475 89.237 107.000 21595.116 0.0 $Composite 0 2; 
Spring_IMK 918104 1814 18140 $E $fy [expr $Comp_I*3844.842] 25.700 24.800 4.140 3.080 178.475 89.237 107.000 21595.116 0.0 $Composite 0 2; Spring_IMK 918202 18220 1822 $E $fy [expr $Comp_I*3844.842] 25.700 24.800 4.140 3.080 178.475 89.237 107.000 21595.116 0.0 $Composite 0 2; Spring_IMK 918204 1824 18240 $E $fy [expr $Comp_I*3844.842] 25.700 24.800 4.140 3.080 178.475 89.237 107.000 21595.116 0.0 $Composite 0 2; Spring_IMK 918302 18320 1832 $E $fy [expr $Comp_I*3844.842] 25.700 24.800 4.140 3.080 167.975 83.987 101.750 21595.116 0.0 $Composite 0 2; Spring_IMK 918304 1834 18340 $E $fy [expr $Comp_I*3844.842] 25.700 24.800 4.140 3.080 167.975 83.987 101.750 21595.116 0.0 $Composite 0 2; Spring_IMK 918402 18420 1842 $E $fy [expr $Comp_I*3844.842] 25.700 24.800 4.140 3.080 178.475 89.237 107.000 21595.116 0.0 $Composite 0 2; 
Spring_IMK 917104 1714 17140 $E $fy [expr $Comp_I*3844.842] 25.700 24.800 4.140 3.080 177.925 88.962 106.725 21595.116 0.0 $Composite 0 2; Spring_IMK 917202 17220 1722 $E $fy [expr $Comp_I*3844.842] 25.700 24.800 4.140 3.080 177.925 88.962 106.725 21595.116 0.0 $Composite 0 2; Spring_IMK 917204 1724 17240 $E $fy [expr $Comp_I*3844.842] 25.700 24.800 4.140 3.080 177.925 88.962 106.725 21595.116 0.0 $Composite 0 2; Spring_IMK 917302 17320 1732 $E $fy [expr $Comp_I*3844.842] 25.700 24.800 4.140 3.080 167.375 83.687 101.450 21595.116 0.0 $Composite 0 2; Spring_IMK 917304 1734 17340 $E $fy [expr $Comp_I*3844.842] 25.700 24.800 4.140 3.080 167.375 83.687 101.450 21595.116 0.0 $Composite 0 2; Spring_IMK 917402 17420 1742 $E $fy [expr $Comp_I*3844.842] 25.700 24.800 4.140 3.080 177.925 88.962 106.725 21595.116 0.0 $Composite 0 2; 
Spring_IMK 916104 1614 16140 $E $fy [expr $Comp_I*4923.914] 33.500 47.200 5.480 2.470 173.825 86.912 106.725 21523.658 0.0 $Composite 0 2; Spring_IMK 916202 16220 1622 $E $fy [expr $Comp_I*4923.914] 33.500 47.200 5.480 2.470 173.825 86.912 106.725 21523.658 0.0 $Composite 0 2; Spring_IMK 916204 1624 16240 $E $fy [expr $Comp_I*4923.914] 33.500 47.200 5.480 2.470 173.825 86.912 106.725 21523.658 0.0 $Composite 0 2; Spring_IMK 916302 16320 1632 $E $fy [expr $Comp_I*4923.914] 33.500 47.200 5.480 2.470 163.275 81.637 101.450 21523.658 0.0 $Composite 0 2; Spring_IMK 916304 1634 16340 $E $fy [expr $Comp_I*4923.914] 33.500 47.200 5.480 2.470 163.275 81.637 101.450 21523.658 0.0 $Composite 0 2; Spring_IMK 916402 16420 1642 $E $fy [expr $Comp_I*4923.914] 33.500 47.200 5.480 2.470 173.825 86.912 106.725 21523.658 0.0 $Composite 0 2; 
Spring_IMK 915104 1514 15140 $E $fy [expr $Comp_I*4923.914] 33.500 47.200 5.480 2.470 173.875 86.938 106.750 21523.658 0.0 $Composite 0 2; Spring_IMK 915202 15220 1522 $E $fy [expr $Comp_I*4923.914] 33.500 47.200 5.480 2.470 173.875 86.938 106.750 21523.658 0.0 $Composite 0 2; Spring_IMK 915204 1524 15240 $E $fy [expr $Comp_I*4923.914] 33.500 47.200 5.480 2.470 173.875 86.938 106.750 21523.658 0.0 $Composite 0 2; Spring_IMK 915302 15320 1532 $E $fy [expr $Comp_I*4923.914] 33.500 47.200 5.480 2.470 164.075 82.037 101.850 21523.658 0.0 $Composite 0 2; Spring_IMK 915304 1534 15340 $E $fy [expr $Comp_I*4923.914] 33.500 47.200 5.480 2.470 164.075 82.037 101.850 21523.658 0.0 $Composite 0 2; Spring_IMK 915402 15420 1542 $E $fy [expr $Comp_I*4923.914] 33.500 47.200 5.480 2.470 173.875 86.938 106.750 21523.658 0.0 $Composite 0 2; 
Spring_IMK 914104 1414 14140 $E $fy [expr $Comp_I*4923.914] 33.500 47.200 5.480 2.470 173.875 86.938 106.750 21523.658 0.0 $Composite 0 2; Spring_IMK 914202 14220 1422 $E $fy [expr $Comp_I*4923.914] 33.500 47.200 5.480 2.470 173.875 86.938 106.750 21523.658 0.0 $Composite 0 2; Spring_IMK 914204 1424 14240 $E $fy [expr $Comp_I*4923.914] 33.500 47.200 5.480 2.470 173.875 86.938 106.750 21523.658 0.0 $Composite 0 2; Spring_IMK 914302 14320 1432 $E $fy [expr $Comp_I*4923.914] 33.500 47.200 5.480 2.470 164.075 82.037 101.850 21523.658 0.0 $Composite 0 2; Spring_IMK 914304 1434 14340 $E $fy [expr $Comp_I*4923.914] 33.500 47.200 5.480 2.470 164.075 82.037 101.850 21523.658 0.0 $Composite 0 2; Spring_IMK 914402 14420 1442 $E $fy [expr $Comp_I*4923.914] 33.500 47.200 5.480 2.470 173.875 86.938 106.750 21523.658 0.0 $Composite 0 2; 
Spring_IMK 913104 1314 13140 $E $fy [expr $Comp_I*5565.201] 33.800 44.700 4.710 2.500 173.175 86.587 106.450 23793.229 0.0 $Composite 0 2; Spring_IMK 913202 13220 1322 $E $fy [expr $Comp_I*5565.201] 33.800 44.700 4.710 2.500 173.175 86.587 106.450 23793.229 0.0 $Composite 0 2; Spring_IMK 913204 1324 13240 $E $fy [expr $Comp_I*5565.201] 33.800 44.700 4.710 2.500 173.175 86.587 106.450 23793.229 0.0 $Composite 0 2; Spring_IMK 913302 13320 1332 $E $fy [expr $Comp_I*5565.201] 33.800 44.700 4.710 2.500 163.175 81.587 101.450 23793.229 0.0 $Composite 0 2; Spring_IMK 913304 1334 13340 $E $fy [expr $Comp_I*5565.201] 33.800 44.700 4.710 2.500 163.175 81.587 101.450 23793.229 0.0 $Composite 0 2; Spring_IMK 913402 13420 1342 $E $fy [expr $Comp_I*5565.201] 33.800 44.700 4.710 2.500 173.175 86.587 106.450 23793.229 0.0 $Composite 0 2; 
Spring_IMK 912104 1214 12140 $E $fy [expr $Comp_I*5565.201] 33.800 44.700 4.710 2.500 173.175 86.587 106.450 23793.229 0.0 $Composite 0 2; Spring_IMK 912202 12220 1222 $E $fy [expr $Comp_I*5565.201] 33.800 44.700 4.710 2.500 173.175 86.587 106.450 23793.229 0.0 $Composite 0 2; Spring_IMK 912204 1224 12240 $E $fy [expr $Comp_I*5565.201] 33.800 44.700 4.710 2.500 173.175 86.587 106.450 23793.229 0.0 $Composite 0 2; Spring_IMK 912302 12320 1232 $E $fy [expr $Comp_I*5565.201] 33.800 44.700 4.710 2.500 163.175 81.587 101.450 23793.229 0.0 $Composite 0 2; Spring_IMK 912304 1234 12340 $E $fy [expr $Comp_I*5565.201] 33.800 44.700 4.710 2.500 163.175 81.587 101.450 23793.229 0.0 $Composite 0 2; Spring_IMK 912402 12420 1242 $E $fy [expr $Comp_I*5565.201] 33.800 44.700 4.710 2.500 173.175 86.587 106.450 23793.229 0.0 $Composite 0 2; 
Spring_IMK 911104 1114 11140 $E $fy [expr $Comp_I*5565.201] 33.800 44.700 4.710 2.500 172.625 86.313 106.175 23793.229 0.0 $Composite 0 2; Spring_IMK 911202 11220 1122 $E $fy [expr $Comp_I*5565.201] 33.800 44.700 4.710 2.500 172.625 86.313 106.175 23793.229 0.0 $Composite 0 2; Spring_IMK 911204 1124 11240 $E $fy [expr $Comp_I*5565.201] 33.800 44.700 4.710 2.500 172.625 86.313 106.175 23793.229 0.0 $Composite 0 2; Spring_IMK 911302 11320 1132 $E $fy [expr $Comp_I*5565.201] 33.800 44.700 4.710 2.500 162.875 81.438 101.300 23793.229 0.0 $Composite 0 2; Spring_IMK 911304 1134 11340 $E $fy [expr $Comp_I*5565.201] 33.800 44.700 4.710 2.500 162.875 81.438 101.300 23793.229 0.0 $Composite 0 2; Spring_IMK 911402 11420 1142 $E $fy [expr $Comp_I*5565.201] 33.800 44.700 4.710 2.500 172.625 86.313 106.175 23793.229 0.0 $Composite 0 2; 
Spring_IMK 910104 1014 10140 $E $fy [expr $Comp_I*5565.201] 33.800 44.700 4.710 2.500 172.625 86.313 106.175 23793.229 0.0 $Composite 0 2; Spring_IMK 910202 10220 1022 $E $fy [expr $Comp_I*5565.201] 33.800 44.700 4.710 2.500 172.625 86.313 106.175 23793.229 0.0 $Composite 0 2; Spring_IMK 910204 1024 10240 $E $fy [expr $Comp_I*5565.201] 33.800 44.700 4.710 2.500 172.625 86.313 106.175 23793.229 0.0 $Composite 0 2; Spring_IMK 910302 10320 1032 $E $fy [expr $Comp_I*5565.201] 33.800 44.700 4.710 2.500 162.875 81.438 101.300 23793.229 0.0 $Composite 0 2; Spring_IMK 910304 1034 10340 $E $fy [expr $Comp_I*5565.201] 33.800 44.700 4.710 2.500 162.875 81.438 101.300 23793.229 0.0 $Composite 0 2; Spring_IMK 910402 10420 1042 $E $fy [expr $Comp_I*5565.201] 33.800 44.700 4.710 2.500 172.625 86.313 106.175 23793.229 0.0 $Composite 0 2; 
Spring_IMK 909104 914 9140 $E $fy [expr $Comp_I*5565.201] 33.800 44.700 4.710 2.500 172.425 86.213 106.075 23793.229 0.0 $Composite 0 2; Spring_IMK 909202 9220 922 $E $fy [expr $Comp_I*5565.201] 33.800 44.700 4.710 2.500 172.425 86.213 106.075 23793.229 0.0 $Composite 0 2; Spring_IMK 909204 924 9240 $E $fy [expr $Comp_I*5565.201] 33.800 44.700 4.710 2.500 172.425 86.213 106.075 23793.229 0.0 $Composite 0 2; Spring_IMK 909302 9320 932 $E $fy [expr $Comp_I*5565.201] 33.800 44.700 4.710 2.500 162.475 81.237 101.100 23793.229 0.0 $Composite 0 2; Spring_IMK 909304 934 9340 $E $fy [expr $Comp_I*5565.201] 33.800 44.700 4.710 2.500 162.475 81.237 101.100 23793.229 0.0 $Composite 0 2; Spring_IMK 909402 9420 942 $E $fy [expr $Comp_I*5565.201] 33.800 44.700 4.710 2.500 172.425 86.213 106.075 23793.229 0.0 $Composite 0 2; 
Spring_IMK 908104 814 8140 $E $fy [expr $Comp_I*5565.201] 33.800 44.700 4.710 2.500 172.425 86.213 106.075 23793.229 0.0 $Composite 0 2; Spring_IMK 908202 8220 822 $E $fy [expr $Comp_I*5565.201] 33.800 44.700 4.710 2.500 172.425 86.213 106.075 23793.229 0.0 $Composite 0 2; Spring_IMK 908204 824 8240 $E $fy [expr $Comp_I*5565.201] 33.800 44.700 4.710 2.500 172.425 86.213 106.075 23793.229 0.0 $Composite 0 2; Spring_IMK 908302 8320 832 $E $fy [expr $Comp_I*5565.201] 33.800 44.700 4.710 2.500 162.475 81.237 101.100 23793.229 0.0 $Composite 0 2; Spring_IMK 908304 834 8340 $E $fy [expr $Comp_I*5565.201] 33.800 44.700 4.710 2.500 162.475 81.237 101.100 23793.229 0.0 $Composite 0 2; Spring_IMK 908402 8420 842 $E $fy [expr $Comp_I*5565.201] 33.800 44.700 4.710 2.500 172.425 86.213 106.075 23793.229 0.0 $Composite 0 2; 
Spring_IMK 907104 714 7140 $E $fy [expr $Comp_I*5565.201] 33.800 44.700 4.710 2.500 171.625 85.813 105.675 23793.229 0.0 $Composite 0 2; Spring_IMK 907202 7220 722 $E $fy [expr $Comp_I*5565.201] 33.800 44.700 4.710 2.500 171.625 85.813 105.675 23793.229 0.0 $Composite 0 2; Spring_IMK 907204 724 7240 $E $fy [expr $Comp_I*5565.201] 33.800 44.700 4.710 2.500 171.625 85.813 105.675 23793.229 0.0 $Composite 0 2; Spring_IMK 907302 7320 732 $E $fy [expr $Comp_I*5565.201] 33.800 44.700 4.710 2.500 161.975 80.987 100.850 23793.229 0.0 $Composite 0 2; Spring_IMK 907304 734 7340 $E $fy [expr $Comp_I*5565.201] 33.800 44.700 4.710 2.500 161.975 80.987 100.850 23793.229 0.0 $Composite 0 2; Spring_IMK 907402 7420 742 $E $fy [expr $Comp_I*5565.201] 33.800 44.700 4.710 2.500 171.625 85.813 105.675 23793.229 0.0 $Composite 0 2; 
Spring_IMK 906104 614 6140 $E $fy [expr $Comp_I*5565.201] 33.800 44.700 4.710 2.500 171.625 85.813 105.675 23793.229 0.0 $Composite 0 2; Spring_IMK 906202 6220 622 $E $fy [expr $Comp_I*5565.201] 33.800 44.700 4.710 2.500 171.625 85.813 105.675 23793.229 0.0 $Composite 0 2; Spring_IMK 906204 624 6240 $E $fy [expr $Comp_I*5565.201] 33.800 44.700 4.710 2.500 171.625 85.813 105.675 23793.229 0.0 $Composite 0 2; Spring_IMK 906302 6320 632 $E $fy [expr $Comp_I*5565.201] 33.800 44.700 4.710 2.500 161.975 80.987 100.850 23793.229 0.0 $Composite 0 2; Spring_IMK 906304 634 6340 $E $fy [expr $Comp_I*5565.201] 33.800 44.700 4.710 2.500 161.975 80.987 100.850 23793.229 0.0 $Composite 0 2; Spring_IMK 906402 6420 642 $E $fy [expr $Comp_I*5565.201] 33.800 44.700 4.710 2.500 171.625 85.813 105.675 23793.229 0.0 $Composite 0 2; 
Spring_IMK 905104 514 5140 $E $fy [expr $Comp_I*5565.201] 33.800 44.700 4.710 2.500 171.125 85.563 105.425 23793.229 0.0 $Composite 0 2; Spring_IMK 905202 5220 522 $E $fy [expr $Comp_I*5565.201] 33.800 44.700 4.710 2.500 171.125 85.563 105.425 23793.229 0.0 $Composite 0 2; Spring_IMK 905204 524 5240 $E $fy [expr $Comp_I*5565.201] 33.800 44.700 4.710 2.500 171.125 85.563 105.425 23793.229 0.0 $Composite 0 2; Spring_IMK 905302 5320 532 $E $fy [expr $Comp_I*5565.201] 33.800 44.700 4.710 2.500 160.975 80.487 100.350 23793.229 0.0 $Composite 0 2; Spring_IMK 905304 534 5340 $E $fy [expr $Comp_I*5565.201] 33.800 44.700 4.710 2.500 160.975 80.487 100.350 23793.229 0.0 $Composite 0 2; Spring_IMK 905402 5420 542 $E $fy [expr $Comp_I*5565.201] 33.800 44.700 4.710 2.500 171.125 85.563 105.425 23793.229 0.0 $Composite 0 2; 
Spring_IMK 904104 414 4140 $E $fy [expr $Comp_I*4923.914] 33.500 47.200 5.480 2.470 171.225 85.612 105.425 21523.658 0.0 $Composite 0 2; Spring_IMK 904202 4220 422 $E $fy [expr $Comp_I*4923.914] 33.500 47.200 5.480 2.470 171.225 85.612 105.425 21523.658 0.0 $Composite 0 2; Spring_IMK 904204 424 4240 $E $fy [expr $Comp_I*4923.914] 33.500 47.200 5.480 2.470 171.225 85.612 105.425 21523.658 0.0 $Composite 0 2; Spring_IMK 904302 4320 432 $E $fy [expr $Comp_I*4923.914] 33.500 47.200 5.480 2.470 161.075 80.537 100.350 21523.658 0.0 $Composite 0 2; Spring_IMK 904304 434 4340 $E $fy [expr $Comp_I*4923.914] 33.500 47.200 5.480 2.470 161.075 80.537 100.350 21523.658 0.0 $Composite 0 2; Spring_IMK 904402 4420 442 $E $fy [expr $Comp_I*4923.914] 33.500 47.200 5.480 2.470 171.225 85.612 105.425 21523.658 0.0 $Composite 0 2; 
Spring_IMK 903104 314 3140 $E $fy [expr $Comp_I*4923.914] 33.500 47.200 5.480 2.470 170.975 85.487 105.300 21523.658 0.0 $Composite 0 2; Spring_IMK 903202 3220 322 $E $fy [expr $Comp_I*4923.914] 33.500 47.200 5.480 2.470 170.975 85.487 105.300 21523.658 0.0 $Composite 0 2; Spring_IMK 903204 324 3240 $E $fy [expr $Comp_I*4923.914] 33.500 47.200 5.480 2.470 170.975 85.487 105.300 21523.658 0.0 $Composite 0 2; Spring_IMK 903302 3320 332 $E $fy [expr $Comp_I*4923.914] 33.500 47.200 5.480 2.470 161.175 80.588 100.400 21523.658 0.0 $Composite 0 2; Spring_IMK 903304 334 3340 $E $fy [expr $Comp_I*4923.914] 33.500 47.200 5.480 2.470 161.175 80.588 100.400 21523.658 0.0 $Composite 0 2; Spring_IMK 903402 3420 342 $E $fy [expr $Comp_I*4923.914] 33.500 47.200 5.480 2.470 170.975 85.487 105.300 21523.658 0.0 $Composite 0 2; 
Spring_IMK 902104 214 2140 $E $fy [expr $Comp_I*4923.914] 33.500 47.200 5.480 2.470 170.975 85.487 105.300 21523.658 0.0 $Composite 0 2; Spring_IMK 902202 2220 222 $E $fy [expr $Comp_I*4923.914] 33.500 47.200 5.480 2.470 170.975 85.487 105.300 21523.658 0.0 $Composite 0 2; Spring_IMK 902204 224 2240 $E $fy [expr $Comp_I*4923.914] 33.500 47.200 5.480 2.470 170.975 85.487 105.300 21523.658 0.0 $Composite 0 2; Spring_IMK 902302 2320 232 $E $fy [expr $Comp_I*4923.914] 33.500 47.200 5.480 2.470 161.175 80.588 100.400 21523.658 0.0 $Composite 0 2; Spring_IMK 902304 234 2340 $E $fy [expr $Comp_I*4923.914] 33.500 47.200 5.480 2.470 161.175 80.588 100.400 21523.658 0.0 $Composite 0 2; Spring_IMK 902402 2420 242 $E $fy [expr $Comp_I*4923.914] 33.500 47.200 5.480 2.470 170.975 85.487 105.300 21523.658 0.0 $Composite 0 2; 

###################################################################################################
#                                           MF COLUMN SPRINGS                                     #
###################################################################################################

Spring_IMK  921101  421101    2111 $E $fy 1530.0000 14.7000 17.7000 7.1500 3.7600 132.1000 66.0500 132.1000 14157.0000 0.0109  0 0 2; Spring_IMK  921201  421201    2121 $E $fy 9040.0000 35.9000 51.9000 6.3700 2.4700 132.1000 66.0500 132.1000 35150.5000 0.0144  0 0 2; Spring_IMK  921301  421301    2131 $E $fy 9040.0000 35.9000 51.9000 6.3700 2.4700 132.1000 66.0500 132.1000 35150.5000 0.0144  0 0 2; Spring_IMK  921401  421401    2141 $E $fy 1530.0000 14.7000 17.7000 7.1500 3.7600 132.1000 66.0500 132.1000 14157.0000 0.0109  0 0 2; 
Spring_IMK  920103  420103    2013 $E $fy 1530.0000 14.7000 17.7000 7.1500 3.7600 132.1000 66.0500 132.1000 14157.0000 0.0109  0 0 2; Spring_IMK  920203  420203    2023 $E $fy 9040.0000 35.9000 51.9000 6.3700 2.4700 132.1000 66.0500 132.1000 35150.5000 0.0144  0 0 2; Spring_IMK  920303  420303    2033 $E $fy 9040.0000 35.9000 51.9000 6.3700 2.4700 132.1000 66.0500 132.1000 35150.5000 0.0144  0 0 2; Spring_IMK  920403  420403    2043 $E $fy 1530.0000 14.7000 17.7000 7.1500 3.7600 132.1000 66.0500 132.1000 14157.0000 0.0109  0 0 2; 
Spring_IMK  920101  420101    2011 $E $fy 1530.0000 14.7000 17.7000 7.1500 3.7600 132.1000 66.0500 132.1000 14157.0000 0.0242  0 0 2; Spring_IMK  920201  420201    2021 $E $fy 9040.0000 35.9000 51.9000 6.3700 2.4700 132.1000 66.0500 132.1000 35150.5000 0.0318  0 0 2; Spring_IMK  920301  420301    2031 $E $fy 9040.0000 35.9000 51.9000 6.3700 2.4700 132.1000 66.0500 132.1000 35150.5000 0.0318  0 0 2; Spring_IMK  920401  420401    2041 $E $fy 1530.0000 14.7000 17.7000 7.1500 3.7600 132.1000 66.0500 132.1000 14157.0000 0.0242  0 0 2; 
Spring_IMK  919103  419103    1913 $E $fy 2400.0000 15.5000 12.8000 5.4500 4.0500 131.2000 65.6000 131.2000 21477.5000 0.0165  0 0 2; Spring_IMK  919203  419203    1923 $E $fy 12100.0000 36.5000 42.4000 4.8100 2.5600 131.2000 65.6000 131.2000 46403.5000 0.0247  0 0 2; Spring_IMK  919303  419303    1933 $E $fy 12100.0000 36.5000 42.4000 4.8100 2.5600 131.2000 65.6000 131.2000 46403.5000 0.0247  0 0 2; Spring_IMK  919403  419403    1943 $E $fy 2400.0000 15.5000 12.8000 5.4500 4.0500 131.2000 65.6000 131.2000 21477.5000 0.0165  0 0 2; 
Spring_IMK  919101  419101    1911 $E $fy 2400.0000 15.5000 12.8000 5.4500 4.0500 130.3000 65.1500 130.3000 21477.5000 0.0255  0 0 2; Spring_IMK  919201  419201    1921 $E $fy 12100.0000 36.5000 42.4000 4.8100 2.5600 130.3000 65.1500 130.3000 46403.5000 0.0382  0 0 2; Spring_IMK  919301  419301    1931 $E $fy 12100.0000 36.5000 42.4000 4.8100 2.5600 130.3000 65.1500 130.3000 46403.5000 0.0382  0 0 2; Spring_IMK  919401  419401    1941 $E $fy 2400.0000 15.5000 12.8000 5.4500 4.0500 130.3000 65.1500 130.3000 21477.5000 0.0255  0 0 2; 
Spring_IMK  918103  418103    1813 $E $fy 2400.0000 15.5000 12.8000 5.4500 4.0500 130.3000 65.1500 130.3000 21477.5000 0.0255  0 0 2; Spring_IMK  918203  418203    1823 $E $fy 12100.0000 36.5000 42.4000 4.8100 2.5600 130.3000 65.1500 130.3000 46403.5000 0.0382  0 0 2; Spring_IMK  918303  418303    1833 $E $fy 12100.0000 36.5000 42.4000 4.8100 2.5600 130.3000 65.1500 130.3000 46403.5000 0.0382  0 0 2; Spring_IMK  918403  418403    1843 $E $fy 2400.0000 15.5000 12.8000 5.4500 4.0500 130.3000 65.1500 130.3000 21477.5000 0.0255  0 0 2; 
Spring_IMK  918101  418101    1811 $E $fy 2400.0000 15.5000 12.8000 5.4500 4.0500 130.3000 65.1500 130.3000 21477.5000 0.0346  0 0 2; Spring_IMK  918201  418201    1821 $E $fy 12100.0000 36.5000 42.4000 4.8100 2.5600 130.3000 65.1500 130.3000 46403.5000 0.0517  0 0 2; Spring_IMK  918301  418301    1831 $E $fy 12100.0000 36.5000 42.4000 4.8100 2.5600 130.3000 65.1500 130.3000 46403.5000 0.0517  0 0 2; Spring_IMK  918401  418401    1841 $E $fy 2400.0000 15.5000 12.8000 5.4500 4.0500 130.3000 65.1500 130.3000 21477.5000 0.0346  0 0 2; 
Spring_IMK  917103  417103    1713 $E $fy 3010.0000 16.0000 10.7000 4.6200 4.1000 130.3000 65.1500 130.3000 26378.0000 0.0287  0 0 2; Spring_IMK  917203  417203    1723 $E $fy 15000.0000 37.1000 37.3000 3.8600 2.6200 130.3000 65.1500 130.3000 56628.0000 0.0432  0 0 2; Spring_IMK  917303  417303    1733 $E $fy 15000.0000 37.1000 37.3000 3.8600 2.6200 130.3000 65.1500 130.3000 56628.0000 0.0432  0 0 2; Spring_IMK  917403  417403    1743 $E $fy 3010.0000 16.0000 10.7000 4.6200 4.1000 130.3000 65.1500 130.3000 26378.0000 0.0287  0 0 2; 
Spring_IMK  917101  417101    1711 $E $fy 3010.0000 16.0000 10.7000 4.6200 4.1000 130.3000 65.1500 130.3000 26378.0000 0.0362  0 0 2; Spring_IMK  917201  417201    1721 $E $fy 15000.0000 37.1000 37.3000 3.8600 2.6200 130.3000 65.1500 130.3000 56628.0000 0.0546  0 0 2; Spring_IMK  917301  417301    1731 $E $fy 15000.0000 37.1000 37.3000 3.8600 2.6200 130.3000 65.1500 130.3000 56628.0000 0.0546  0 0 2; Spring_IMK  917401  417401    1741 $E $fy 3010.0000 16.0000 10.7000 4.6200 4.1000 130.3000 65.1500 130.3000 26378.0000 0.0362  0 0 2; 
Spring_IMK  916103  416103    1613 $E $fy 3010.0000 16.0000 10.7000 4.6200 4.1000 126.4000 63.2000 126.4000 26378.0000 0.0362  0 0 2; Spring_IMK  916203  416203    1623 $E $fy 15000.0000 37.1000 37.3000 3.8600 2.6200 126.4000 63.2000 126.4000 56628.0000 0.0546  0 0 2; Spring_IMK  916303  416303    1633 $E $fy 15000.0000 37.1000 37.3000 3.8600 2.6200 126.4000 63.2000 126.4000 56628.0000 0.0546  0 0 2; Spring_IMK  916403  416403    1643 $E $fy 3010.0000 16.0000 10.7000 4.6200 4.1000 126.4000 63.2000 126.4000 26378.0000 0.0362  0 0 2; 
Spring_IMK  916101  416101    1611 $E $fy 3010.0000 16.0000 10.7000 4.6200 4.1000 122.5000 61.2500 122.5000 26378.0000 0.0436  0 0 2; Spring_IMK  916201  416201    1621 $E $fy 15000.0000 37.1000 37.3000 3.8600 2.6200 122.5000 61.2500 122.5000 56628.0000 0.0659  0 0 2; Spring_IMK  916301  416301    1631 $E $fy 15000.0000 37.1000 37.3000 3.8600 2.6200 122.5000 61.2500 122.5000 56628.0000 0.0659  0 0 2; Spring_IMK  916401  416401    1641 $E $fy 3010.0000 16.0000 10.7000 4.6200 4.1000 122.5000 61.2500 122.5000 26378.0000 0.0436  0 0 2; 
Spring_IMK  915103  415103    1513 $E $fy 3840.0000 16.7000 8.8400 3.8900 4.1700 122.5000 61.2500 122.5000 32791.0000 0.0359  0 0 2; Spring_IMK  915203  415203    1523 $E $fy 17300.0000 36.3000 37.5000 5.7500 3.7800 122.5000 61.2500 122.5000 65340.0000 0.0586  0 0 2; Spring_IMK  915303  415303    1533 $E $fy 17300.0000 36.3000 37.5000 5.7500 3.7800 122.5000 61.2500 122.5000 65340.0000 0.0586  0 0 2; Spring_IMK  915403  415403    1543 $E $fy 3840.0000 16.7000 8.8400 3.8900 4.1700 122.5000 61.2500 122.5000 32791.0000 0.0359  0 0 2; 
Spring_IMK  915101  415101    1511 $E $fy 3840.0000 16.7000 8.8400 3.8900 4.1700 122.5000 61.2500 122.5000 32791.0000 0.0421  0 0 2; Spring_IMK  915201  415201    1521 $E $fy 17300.0000 36.3000 37.5000 5.7500 3.7800 122.5000 61.2500 122.5000 65340.0000 0.0687  0 0 2; Spring_IMK  915301  415301    1531 $E $fy 17300.0000 36.3000 37.5000 5.7500 3.7800 122.5000 61.2500 122.5000 65340.0000 0.0687  0 0 2; Spring_IMK  915401  415401    1541 $E $fy 3840.0000 16.7000 8.8400 3.8900 4.1700 122.5000 61.2500 122.5000 32791.0000 0.0421  0 0 2; 
Spring_IMK  914103  414103    1413 $E $fy 3840.0000 16.7000 8.8400 3.8900 4.1700 122.5000 61.2500 122.5000 32791.0000 0.0421  0 0 2; Spring_IMK  914203  414203    1423 $E $fy 17300.0000 36.3000 37.5000 5.7500 3.7800 122.5000 61.2500 122.5000 65340.0000 0.0687  0 0 2; Spring_IMK  914303  414303    1433 $E $fy 17300.0000 36.3000 37.5000 5.7500 3.7800 122.5000 61.2500 122.5000 65340.0000 0.0687  0 0 2; Spring_IMK  914403  414403    1443 $E $fy 3840.0000 16.7000 8.8400 3.8900 4.1700 122.5000 61.2500 122.5000 32791.0000 0.0421  0 0 2; 
Spring_IMK  914101  414101    1411 $E $fy 3840.0000 16.7000 8.8400 3.8900 4.1700 122.5000 61.2500 122.5000 32791.0000 0.0482  0 0 2; Spring_IMK  914201  414201    1421 $E $fy 17300.0000 36.3000 37.5000 5.7500 3.7800 122.5000 61.2500 122.5000 65340.0000 0.0787  0 0 2; Spring_IMK  914301  414301    1431 $E $fy 17300.0000 36.3000 37.5000 5.7500 3.7800 122.5000 61.2500 122.5000 65340.0000 0.0787  0 0 2; Spring_IMK  914401  414401    1441 $E $fy 3840.0000 16.7000 8.8400 3.8900 4.1700 122.5000 61.2500 122.5000 32791.0000 0.0482  0 0 2; 
Spring_IMK  913103  413103    1313 $E $fy 4330.0000 17.1000 8.0900 3.5900 4.2000 122.3500 61.1750 122.3500 36481.5000 0.0439  0 0 2; Spring_IMK  913203  413203    1323 $E $fy 22500.0000 37.1000 30.9000 4.4900 3.8400 122.3500 61.1750 122.3500 83490.0000 0.0625  0 0 2; Spring_IMK  913303  413303    1333 $E $fy 22500.0000 37.1000 30.9000 4.4900 3.8400 122.3500 61.1750 122.3500 83490.0000 0.0625  0 0 2; Spring_IMK  913403  413403    1343 $E $fy 4330.0000 17.1000 8.0900 3.5900 4.2000 122.3500 61.1750 122.3500 36481.5000 0.0439  0 0 2; 
Spring_IMK  913101  413101    1311 $E $fy 4330.0000 17.1000 8.0900 3.5900 4.2000 122.2000 61.1000 122.2000 36481.5000 0.0496  0 0 2; Spring_IMK  913201  413201    1321 $E $fy 22500.0000 37.1000 30.9000 4.4900 3.8400 122.2000 61.1000 122.2000 83490.0000 0.0705  0 0 2; Spring_IMK  913301  413301    1331 $E $fy 22500.0000 37.1000 30.9000 4.4900 3.8400 122.2000 61.1000 122.2000 83490.0000 0.0705  0 0 2; Spring_IMK  913401  413401    1341 $E $fy 4330.0000 17.1000 8.0900 3.5900 4.2000 122.2000 61.1000 122.2000 36481.5000 0.0496  0 0 2; 
Spring_IMK  912103  412103    1213 $E $fy 4330.0000 17.1000 8.0900 3.5900 4.2000 122.2000 61.1000 122.2000 36481.5000 0.0496  0 0 2; Spring_IMK  912203  412203    1223 $E $fy 22500.0000 37.1000 30.9000 4.4900 3.8400 122.2000 61.1000 122.2000 83490.0000 0.0705  0 0 2; Spring_IMK  912303  412303    1233 $E $fy 22500.0000 37.1000 30.9000 4.4900 3.8400 122.2000 61.1000 122.2000 83490.0000 0.0705  0 0 2; Spring_IMK  912403  412403    1243 $E $fy 4330.0000 17.1000 8.0900 3.5900 4.2000 122.2000 61.1000 122.2000 36481.5000 0.0496  0 0 2; 
Spring_IMK  912101  412101    1211 $E $fy 4330.0000 17.1000 8.0900 3.5900 4.2000 122.2000 61.1000 122.2000 36481.5000 0.0552  0 0 2; Spring_IMK  912201  412201    1221 $E $fy 22500.0000 37.1000 30.9000 4.4900 3.8400 122.2000 61.1000 122.2000 83490.0000 0.0785  0 0 2; Spring_IMK  912301  412301    1231 $E $fy 22500.0000 37.1000 30.9000 4.4900 3.8400 122.2000 61.1000 122.2000 83490.0000 0.0785  0 0 2; Spring_IMK  912401  412401    1241 $E $fy 4330.0000 17.1000 8.0900 3.5900 4.2000 122.2000 61.1000 122.2000 36481.5000 0.0552  0 0 2; 
Spring_IMK  911103  411103    1113 $E $fy 5440.0000 17.9000 6.8900 3.1000 4.2700 122.2000 61.1000 122.2000 44528.0000 0.0463  0 0 2; Spring_IMK  911203  411203    1123 $E $fy 24800.0000 37.4000 28.1000 4.1600 3.8600 122.2000 61.1000 122.2000 91355.0000 0.0720  0 0 2; Spring_IMK  911303  411303    1133 $E $fy 24800.0000 37.4000 28.1000 4.1600 3.8600 122.2000 61.1000 122.2000 91355.0000 0.0720  0 0 2; Spring_IMK  911403  411403    1143 $E $fy 5440.0000 17.9000 6.8900 3.1000 4.2700 122.2000 61.1000 122.2000 44528.0000 0.0463  0 0 2; 
Spring_IMK  911101  411101    1111 $E $fy 5440.0000 17.9000 6.8900 3.1000 4.2700 122.2000 61.1000 122.2000 44528.0000 0.0510  0 0 2; Spring_IMK  911201  411201    1121 $E $fy 24800.0000 37.4000 28.1000 4.1600 3.8600 122.2000 61.1000 122.2000 91355.0000 0.0794  0 0 2; Spring_IMK  911301  411301    1131 $E $fy 24800.0000 37.4000 28.1000 4.1600 3.8600 122.2000 61.1000 122.2000 91355.0000 0.0794  0 0 2; Spring_IMK  911401  411401    1141 $E $fy 5440.0000 17.9000 6.8900 3.1000 4.2700 122.2000 61.1000 122.2000 44528.0000 0.0510  0 0 2; 
Spring_IMK  910103  410103    1013 $E $fy 5440.0000 17.9000 6.8900 3.1000 4.2700 122.2000 61.1000 122.2000 44528.0000 0.0510  0 0 2; Spring_IMK  910203  410203    1023 $E $fy 24800.0000 37.4000 28.1000 4.1600 3.8600 122.2000 61.1000 122.2000 91355.0000 0.0794  0 0 2; Spring_IMK  910303  410303    1033 $E $fy 24800.0000 37.4000 28.1000 4.1600 3.8600 122.2000 61.1000 122.2000 91355.0000 0.0794  0 0 2; Spring_IMK  910403  410403    1043 $E $fy 5440.0000 17.9000 6.8900 3.1000 4.2700 122.2000 61.1000 122.2000 44528.0000 0.0510  0 0 2; 
Spring_IMK  910101  410101    1011 $E $fy 5440.0000 17.9000 6.8900 3.1000 4.2700 122.2000 61.1000 122.2000 44528.0000 0.0557  0 0 2; Spring_IMK  910201  410201    1021 $E $fy 24800.0000 37.4000 28.1000 4.1600 3.8600 122.2000 61.1000 122.2000 91355.0000 0.0867  0 0 2; Spring_IMK  910301  410301    1031 $E $fy 24800.0000 37.4000 28.1000 4.1600 3.8600 122.2000 61.1000 122.2000 91355.0000 0.0867  0 0 2; Spring_IMK  910401  410401    1041 $E $fy 5440.0000 17.9000 6.8900 3.1000 4.2700 122.2000 61.1000 122.2000 44528.0000 0.0557  0 0 2; 
Spring_IMK  909103  409103     913 $E $fy 5440.0000 17.9000 6.8900 3.1000 4.2700 122.2000 61.1000 122.2000 44528.0000 0.0557  0 0 2; Spring_IMK  909203  409203     923 $E $fy 27500.0000 37.8000 25.8000 3.8200 3.9000 122.2000 61.1000 122.2000 101035.0000 0.0785  0 0 2; Spring_IMK  909303  409303     933 $E $fy 27500.0000 37.8000 25.8000 3.8200 3.9000 122.2000 61.1000 122.2000 101035.0000 0.0785  0 0 2; Spring_IMK  909403  409403     943 $E $fy 5440.0000 17.9000 6.8900 3.1000 4.2700 122.2000 61.1000 122.2000 44528.0000 0.0557  0 0 2; 
Spring_IMK  909101  409101     911 $E $fy 5440.0000 17.9000 6.8900 3.1000 4.2700 122.2000 61.1000 122.2000 44528.0000 0.0604  0 0 2; Spring_IMK  909201  409201     921 $E $fy 27500.0000 37.8000 25.8000 3.8200 3.9000 122.2000 61.1000 122.2000 101035.0000 0.0851  0 0 2; Spring_IMK  909301  409301     931 $E $fy 27500.0000 37.8000 25.8000 3.8200 3.9000 122.2000 61.1000 122.2000 101035.0000 0.0851  0 0 2; Spring_IMK  909401  409401     941 $E $fy 5440.0000 17.9000 6.8900 3.1000 4.2700 122.2000 61.1000 122.2000 44528.0000 0.0604  0 0 2; 
Spring_IMK  908103  408103     813 $E $fy 5440.0000 17.9000 6.8900 3.1000 4.2700 122.2000 61.1000 122.2000 44528.0000 0.0604  0 0 2; Spring_IMK  908203  408203     823 $E $fy 27500.0000 37.8000 25.8000 3.8200 3.9000 122.2000 61.1000 122.2000 101035.0000 0.0851  0 0 2; Spring_IMK  908303  408303     833 $E $fy 27500.0000 37.8000 25.8000 3.8200 3.9000 122.2000 61.1000 122.2000 101035.0000 0.0851  0 0 2; Spring_IMK  908403  408403     843 $E $fy 5440.0000 17.9000 6.8900 3.1000 4.2700 122.2000 61.1000 122.2000 44528.0000 0.0604  0 0 2; 
Spring_IMK  908101  408101     811 $E $fy 5440.0000 17.9000 6.8900 3.1000 4.2700 122.2000 61.1000 122.2000 44528.0000 0.0651  0 0 2; Spring_IMK  908201  408201     821 $E $fy 27500.0000 37.8000 25.8000 3.8200 3.9000 122.2000 61.1000 122.2000 101035.0000 0.0917  0 0 2; Spring_IMK  908301  408301     831 $E $fy 27500.0000 37.8000 25.8000 3.8200 3.9000 122.2000 61.1000 122.2000 101035.0000 0.0917  0 0 2; Spring_IMK  908401  408401     841 $E $fy 5440.0000 17.9000 6.8900 3.1000 4.2700 122.2000 61.1000 122.2000 44528.0000 0.0651  0 0 2; 
Spring_IMK  907103  407103     713 $E $fy 7190.0000 19.0000 5.6600 2.6200 4.3800 122.2000 61.1000 122.2000 56628.0000 0.0529  0 0 2; Spring_IMK  907203  407203     723 $E $fy 31000.0000 38.3000 23.1000 3.4800 3.9300 122.2000 61.1000 122.2000 113135.0000 0.0825  0 0 2; Spring_IMK  907303  407303     733 $E $fy 31000.0000 38.3000 23.1000 3.4800 3.9300 122.2000 61.1000 122.2000 113135.0000 0.0825  0 0 2; Spring_IMK  907403  407403     743 $E $fy 7190.0000 19.0000 5.6600 2.6200 4.3800 122.2000 61.1000 122.2000 56628.0000 0.0529  0 0 2; 
Spring_IMK  907101  407101     711 $E $fy 7190.0000 19.0000 5.6600 2.6200 4.3800 122.2000 61.1000 122.2000 56628.0000 0.0568  0 0 2; Spring_IMK  907201  407201     721 $E $fy 31000.0000 38.3000 23.1000 3.4800 3.9300 122.2000 61.1000 122.2000 113135.0000 0.0885  0 0 2; Spring_IMK  907301  407301     731 $E $fy 31000.0000 38.3000 23.1000 3.4800 3.9300 122.2000 61.1000 122.2000 113135.0000 0.0885  0 0 2; Spring_IMK  907401  407401     741 $E $fy 7190.0000 19.0000 5.6600 2.6200 4.3800 122.2000 61.1000 122.2000 56628.0000 0.0568  0 0 2; 
Spring_IMK  906103  406103     613 $E $fy 7190.0000 19.0000 5.6600 2.6200 4.3800 122.2000 61.1000 122.2000 56628.0000 0.0568  0 0 2; Spring_IMK  906203  406203     623 $E $fy 31000.0000 38.3000 23.1000 3.4800 3.9300 122.2000 61.1000 122.2000 113135.0000 0.0885  0 0 2; Spring_IMK  906303  406303     633 $E $fy 31000.0000 38.3000 23.1000 3.4800 3.9300 122.2000 61.1000 122.2000 113135.0000 0.0885  0 0 2; Spring_IMK  906403  406403     643 $E $fy 7190.0000 19.0000 5.6600 2.6200 4.3800 122.2000 61.1000 122.2000 56628.0000 0.0568  0 0 2; 
Spring_IMK  906101  406101     611 $E $fy 7190.0000 19.0000 5.6600 2.6200 4.3800 122.2000 61.1000 122.2000 56628.0000 0.0606  0 0 2; Spring_IMK  906201  406201     621 $E $fy 31000.0000 38.3000 23.1000 3.4800 3.9300 122.2000 61.1000 122.2000 113135.0000 0.0944  0 0 2; Spring_IMK  906301  406301     631 $E $fy 31000.0000 38.3000 23.1000 3.4800 3.9300 122.2000 61.1000 122.2000 113135.0000 0.0944  0 0 2; Spring_IMK  906401  406401     641 $E $fy 7190.0000 19.0000 5.6600 2.6200 4.3800 122.2000 61.1000 122.2000 56628.0000 0.0606  0 0 2; 
Spring_IMK  905103  405103     513 $E $fy 7190.0000 19.0000 5.6600 2.6200 4.3800 122.2000 61.1000 122.2000 56628.0000 0.0606  0 0 2; Spring_IMK  905203  405203     523 $E $fy 36000.0000 39.3000 21.4000 3.1900 3.9600 122.2000 61.1000 122.2000 128865.0000 0.0852  0 0 2; Spring_IMK  905303  405303     533 $E $fy 36000.0000 39.3000 21.4000 3.1900 3.9600 122.2000 61.1000 122.2000 128865.0000 0.0852  0 0 2; Spring_IMK  905403  405403     543 $E $fy 7190.0000 19.0000 5.6600 2.6200 4.3800 122.2000 61.1000 122.2000 56628.0000 0.0606  0 0 2; 
Spring_IMK  905101  405101     511 $E $fy 7190.0000 19.0000 5.6600 2.6200 4.3800 122.2000 61.1000 122.2000 56628.0000 0.0644  0 0 2; Spring_IMK  905201  405201     521 $E $fy 36000.0000 39.3000 21.4000 3.1900 3.9600 122.2000 61.1000 122.2000 128865.0000 0.0906  0 0 2; Spring_IMK  905301  405301     531 $E $fy 36000.0000 39.3000 21.4000 3.1900 3.9600 122.2000 61.1000 122.2000 128865.0000 0.0906  0 0 2; Spring_IMK  905401  405401     541 $E $fy 7190.0000 19.0000 5.6600 2.6200 4.3800 122.2000 61.1000 122.2000 56628.0000 0.0644  0 0 2; 
Spring_IMK  904103  404103     413 $E $fy 7190.0000 19.0000 5.6600 2.6200 4.3800 122.3500 61.1750 122.3500 56628.0000 0.0644  0 0 2; Spring_IMK  904203  404203     423 $E $fy 36000.0000 39.3000 21.4000 3.1900 3.9600 122.3500 61.1750 122.3500 128865.0000 0.0906  0 0 2; Spring_IMK  904303  404303     433 $E $fy 36000.0000 39.3000 21.4000 3.1900 3.9600 122.3500 61.1750 122.3500 128865.0000 0.0906  0 0 2; Spring_IMK  904403  404403     443 $E $fy 7190.0000 19.0000 5.6600 2.6200 4.3800 122.3500 61.1750 122.3500 56628.0000 0.0644  0 0 2; 
Spring_IMK  904101  404101     411 $E $fy 7190.0000 19.0000 5.6600 2.6200 4.3800 122.5000 61.2500 122.5000 56628.0000 0.0683  0 0 2; Spring_IMK  904201  404201     421 $E $fy 36000.0000 39.3000 21.4000 3.1900 3.9600 122.5000 61.2500 122.5000 128865.0000 0.0960  0 0 2; Spring_IMK  904301  404301     431 $E $fy 36000.0000 39.3000 21.4000 3.1900 3.9600 122.5000 61.2500 122.5000 128865.0000 0.0960  0 0 2; Spring_IMK  904401  404401     441 $E $fy 7190.0000 19.0000 5.6600 2.6200 4.3800 122.5000 61.2500 122.5000 56628.0000 0.0683  0 0 2; 
Spring_IMK  903103  403103     313 $E $fy 8210.0000 19.6000 5.2100 2.4300 4.4300 122.5000 61.2500 122.5000 63525.0000 0.0622  0 0 2; Spring_IMK  903203  403203     323 $E $fy 38300.0000 39.2000 19.6000 2.9600 4.0100 122.5000 61.2500 122.5000 137940.0000 0.0885  0 0 2; Spring_IMK  903303  403303     333 $E $fy 38300.0000 39.2000 19.6000 2.9600 4.0100 122.5000 61.2500 122.5000 137940.0000 0.0885  0 0 2; Spring_IMK  903403  403403     343 $E $fy 8210.0000 19.6000 5.2100 2.4300 4.4300 122.5000 61.2500 122.5000 63525.0000 0.0622  0 0 2; 
Spring_IMK  903101  403101     311 $E $fy 8210.0000 19.6000 5.2100 2.4300 4.4300 122.5000 61.2500 122.5000 63525.0000 0.0657  0 0 2; Spring_IMK  903201  403201     321 $E $fy 38300.0000 39.2000 19.6000 2.9600 4.0100 122.5000 61.2500 122.5000 137940.0000 0.0935  0 0 2; Spring_IMK  903301  403301     331 $E $fy 38300.0000 39.2000 19.6000 2.9600 4.0100 122.5000 61.2500 122.5000 137940.0000 0.0935  0 0 2; Spring_IMK  903401  403401     341 $E $fy 8210.0000 19.6000 5.2100 2.4300 4.4300 122.5000 61.2500 122.5000 63525.0000 0.0657  0 0 2; 
Spring_IMK  902103  402103     213 $E $fy 8210.0000 19.6000 5.2100 2.4300 4.4300 122.5000 61.2500 122.5000 63525.0000 0.0657  0 0 2; Spring_IMK  902203  402203     223 $E $fy 38300.0000 39.2000 19.6000 2.9600 4.0100 122.5000 61.2500 122.5000 137940.0000 0.0935  0 0 2; Spring_IMK  902303  402303     233 $E $fy 38300.0000 39.2000 19.6000 2.9600 4.0100 122.5000 61.2500 122.5000 137940.0000 0.0935  0 0 2; Spring_IMK  902403  402403     243 $E $fy 8210.0000 19.6000 5.2100 2.4300 4.4300 122.5000 61.2500 122.5000 63525.0000 0.0657  0 0 2; 
Spring_IMK  902101  402101     211 $E $fy 8210.0000 19.6000 5.2100 2.4300 4.4300 163.2500 81.6250 163.2500 63525.0000 0.0693  0 0 2; Spring_IMK  902201  402201     221 $E $fy 38300.0000 39.2000 19.6000 2.9600 4.0100 163.2500 81.6250 163.2500 137940.0000 0.0986  0 0 2; Spring_IMK  902301  402301     231 $E $fy 38300.0000 39.2000 19.6000 2.9600 4.0100 163.2500 81.6250 163.2500 137940.0000 0.0986  0 0 2; Spring_IMK  902401  402401     241 $E $fy 8210.0000 19.6000 5.2100 2.4300 4.4300 163.2500 81.6250 163.2500 63525.0000 0.0693  0 0 2; 
Spring_IMK  901103     110     113 $E $fy 8210.0000 19.6000 5.2100 2.4300 4.4300 163.2500 81.6250 163.2500 63525.0000 0.0693  0 0 2; Spring_IMK  901203     120     123 $E $fy 38300.0000 39.2000 19.6000 2.9600 4.0100 163.2500 81.6250 163.2500 137940.0000 0.0986  0 0 2; Spring_IMK  901303     130     133 $E $fy 38300.0000 39.2000 19.6000 2.9600 4.0100 163.2500 81.6250 163.2500 137940.0000 0.0986  0 0 2; Spring_IMK  901403     140     143 $E $fy 8210.0000 19.6000 5.2100 2.4300 4.4300 163.2500 81.6250 163.2500 63525.0000 0.0693  0 0 2; 

###################################################################################################
#                                          COLUMN SPLICE SPRINGS                                  #
###################################################################################################

Spring_Rigid 919107 119171 119172; 
Spring_Rigid 919207 119271 119272; 
Spring_Rigid 919307 119371 119372; 
Spring_Rigid 919407 119471 119472; 
Spring_Rigid 919507 119571 119572; 
Spring_Rigid 919607 119671 119672; 
Spring_Rigid 917107 117171 117172; 
Spring_Rigid 917207 117271 117272; 
Spring_Rigid 917307 117371 117372; 
Spring_Rigid 917407 117471 117472; 
Spring_Rigid 917507 117571 117572; 
Spring_Rigid 917607 117671 117672; 
Spring_Rigid 915107 115171 115172; 
Spring_Rigid 915207 115271 115272; 
Spring_Rigid 915307 115371 115372; 
Spring_Rigid 915407 115471 115472; 
Spring_Rigid 915507 115571 115572; 
Spring_Rigid 915607 115671 115672; 
Spring_Rigid 913107 113171 113172; 
Spring_Rigid 913207 113271 113272; 
Spring_Rigid 913307 113371 113372; 
Spring_Rigid 913407 113471 113472; 
Spring_Rigid 913507 113571 113572; 
Spring_Rigid 913607 113671 113672; 
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
element truss 1021 421404 2150 $A_Stiff 99;
element truss 1020 420404 2050 $A_Stiff 99;
element truss 1019 419404 1950 $A_Stiff 99;
element truss 1018 418404 1850 $A_Stiff 99;
element truss 1017 417404 1750 $A_Stiff 99;
element truss 1016 416404 1650 $A_Stiff 99;
element truss 1015 415404 1550 $A_Stiff 99;
element truss 1014 414404 1450 $A_Stiff 99;
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
element elasticBeamColumn  620500    2053    2151 66.2500 $E [expr (905.0000  + 1636.0000)] $trans_PDelta; element elasticBeamColumn  620600    2063    2161 66.2500 $E [expr (905.0000  + 1636.0000)] $trans_PDelta; 
element elasticBeamColumn  619502  119572    2051 66.2500 $E [expr (905.0000  + 1636.0000)] $trans_PDelta; element elasticBeamColumn  619602  119672    2061 66.2500 $E [expr (905.0000  + 1636.0000)] $trans_PDelta; 
element elasticBeamColumn  619501    1953  119571 66.2500 $E [expr (905.0000  + 2612.0000)] $trans_PDelta; element elasticBeamColumn  619601    1963  119671 66.2500 $E [expr (905.0000  + 2612.0000)] $trans_PDelta; 
element elasticBeamColumn  618500    1853    1951 66.2500 $E [expr (905.0000  + 2612.0000)] $trans_PDelta; element elasticBeamColumn  618600    1863    1961 66.2500 $E [expr (905.0000  + 2612.0000)] $trans_PDelta; 
element elasticBeamColumn  617502  117572    1851 66.2500 $E [expr (905.0000  + 2612.0000)] $trans_PDelta; element elasticBeamColumn  617602  117672    1861 66.2500 $E [expr (905.0000  + 2612.0000)] $trans_PDelta; 
element elasticBeamColumn  617501    1753  117571 66.2500 $E [expr (905.0000  + 3236.0000)] $trans_PDelta; element elasticBeamColumn  617601    1763  117671 66.2500 $E [expr (905.0000  + 3236.0000)] $trans_PDelta; 
element elasticBeamColumn  616500    1653    1751 66.2500 $E [expr (905.0000  + 3236.0000)] $trans_PDelta; element elasticBeamColumn  616600    1663    1761 66.2500 $E [expr (905.0000  + 3236.0000)] $trans_PDelta; 
element elasticBeamColumn  615502  115572    1651 66.2500 $E [expr (905.0000  + 3236.0000)] $trans_PDelta; element elasticBeamColumn  615602  115672    1661 66.2500 $E [expr (905.0000  + 3236.0000)] $trans_PDelta; 
element elasticBeamColumn  615501    1553  115571 66.2500 $E [expr (905.0000  + 5060.0000)] $trans_PDelta; element elasticBeamColumn  615601    1563  115671 66.2500 $E [expr (905.0000  + 5060.0000)] $trans_PDelta; 
element elasticBeamColumn  614500    1453    1551 66.2500 $E [expr (905.0000  + 5060.0000)] $trans_PDelta; element elasticBeamColumn  614600    1463    1561 66.2500 $E [expr (905.0000  + 5060.0000)] $trans_PDelta; 
element elasticBeamColumn  613502  113572    1451 66.2500 $E [expr (905.0000  + 5060.0000)] $trans_PDelta; element elasticBeamColumn  613602  113672    1461 66.2500 $E [expr (905.0000  + 5060.0000)] $trans_PDelta; 
element elasticBeamColumn  613501    1353  113571 66.2500 $E [expr (905.0000  + 6060.0000)] $trans_PDelta; element elasticBeamColumn  613601    1363  113671 66.2500 $E [expr (905.0000  + 6060.0000)] $trans_PDelta; 
element elasticBeamColumn  612500    1253    1351 66.2500 $E [expr (905.0000  + 6060.0000)] $trans_PDelta; element elasticBeamColumn  612600    1263    1361 66.2500 $E [expr (905.0000  + 6060.0000)] $trans_PDelta; 
element elasticBeamColumn  611502  111572    1251 66.2500 $E [expr (905.0000  + 6060.0000)] $trans_PDelta; element elasticBeamColumn  611602  111672    1261 66.2500 $E [expr (905.0000  + 6060.0000)] $trans_PDelta; 
element elasticBeamColumn  611501    1153  111571 66.2500 $E [expr (905.0000  + 7120.0000)] $trans_PDelta; element elasticBeamColumn  611601    1163  111671 66.2500 $E [expr (905.0000  + 7120.0000)] $trans_PDelta; 
element elasticBeamColumn  610500    1053    1151 66.2500 $E [expr (905.0000  + 7120.0000)] $trans_PDelta; element elasticBeamColumn  610600    1063    1161 66.2500 $E [expr (905.0000  + 7120.0000)] $trans_PDelta; 
element elasticBeamColumn  609502  109572    1051 66.2500 $E [expr (905.0000  + 7120.0000)] $trans_PDelta; element elasticBeamColumn  609602  109672    1061 66.2500 $E [expr (905.0000  + 7120.0000)] $trans_PDelta; 
element elasticBeamColumn  609501     953  109571 66.2500 $E [expr (905.0000  + 7480.0000)] $trans_PDelta; element elasticBeamColumn  609601     963  109671 66.2500 $E [expr (905.0000  + 7480.0000)] $trans_PDelta; 
element elasticBeamColumn  608500     853     951 66.2500 $E [expr (905.0000  + 7480.0000)] $trans_PDelta; element elasticBeamColumn  608600     863     961 66.2500 $E [expr (905.0000  + 7480.0000)] $trans_PDelta; 
element elasticBeamColumn  607502  107572     851 66.2500 $E [expr (905.0000  + 7480.0000)] $trans_PDelta; element elasticBeamColumn  607602  107672     861 66.2500 $E [expr (905.0000  + 7480.0000)] $trans_PDelta; 
element elasticBeamColumn  607501     753  107571 66.2500 $E [expr (905.0000  + 9100.0000)] $trans_PDelta; element elasticBeamColumn  607601     763  107671 66.2500 $E [expr (905.0000  + 9100.0000)] $trans_PDelta; 
element elasticBeamColumn  606500     653     751 66.2500 $E [expr (905.0000  + 9100.0000)] $trans_PDelta; element elasticBeamColumn  606600     663     761 66.2500 $E [expr (905.0000  + 9100.0000)] $trans_PDelta; 
element elasticBeamColumn  605502  105572     651 66.2500 $E [expr (905.0000  + 9100.0000)] $trans_PDelta; element elasticBeamColumn  605602  105672     661 66.2500 $E [expr (905.0000  + 9100.0000)] $trans_PDelta; 
element elasticBeamColumn  605501     553  105571 66.2500 $E [expr (905.0000  + 9620.0000)] $trans_PDelta; element elasticBeamColumn  605601     563  105671 66.2500 $E [expr (905.0000  + 9620.0000)] $trans_PDelta; 
element elasticBeamColumn  604500     453     551 66.2500 $E [expr (905.0000  + 9620.0000)] $trans_PDelta; element elasticBeamColumn  604600     463     561 66.2500 $E [expr (905.0000  + 9620.0000)] $trans_PDelta; 
element elasticBeamColumn  603502  103572     451 66.2500 $E [expr (905.0000  + 9620.0000)] $trans_PDelta; element elasticBeamColumn  603602  103672     461 66.2500 $E [expr (905.0000  + 9620.0000)] $trans_PDelta; 
element elasticBeamColumn  603501     353  103571 66.2500 $E [expr (905.0000  + 10740.0000)] $trans_PDelta; element elasticBeamColumn  603601     363  103671 66.2500 $E [expr (905.0000  + 10740.0000)] $trans_PDelta; 
element elasticBeamColumn  602500     253     351 66.2500 $E [expr (905.0000  + 10740.0000)] $trans_PDelta; element elasticBeamColumn  602600     263     361 66.2500 $E [expr (905.0000  + 10740.0000)] $trans_PDelta; 
element elasticBeamColumn  601500     153     251 66.2500 $E [expr (905.0000  + 10740.0000)] $trans_PDelta; element elasticBeamColumn  601600     163     261 66.2500 $E [expr (905.0000  + 10740.0000)] $trans_PDelta; 

# GRAVITY BEAMS
element elasticBeamColumn  521400    2154    2162 97.8000 $E [expr $Comp_I_GC * 8160.0000] $trans_PDelta;
element elasticBeamColumn  520400    2054    2062 97.8000 $E [expr $Comp_I_GC * 8160.0000] $trans_PDelta;
element elasticBeamColumn  519400    1954    1962 97.8000 $E [expr $Comp_I_GC * 8160.0000] $trans_PDelta;
element elasticBeamColumn  518400    1854    1862 97.8000 $E [expr $Comp_I_GC * 8160.0000] $trans_PDelta;
element elasticBeamColumn  517400    1754    1762 97.8000 $E [expr $Comp_I_GC * 8160.0000] $trans_PDelta;
element elasticBeamColumn  516400    1654    1662 97.8000 $E [expr $Comp_I_GC * 8160.0000] $trans_PDelta;
element elasticBeamColumn  515400    1554    1562 97.8000 $E [expr $Comp_I_GC * 8160.0000] $trans_PDelta;
element elasticBeamColumn  514400    1454    1462 97.8000 $E [expr $Comp_I_GC * 8160.0000] $trans_PDelta;
element elasticBeamColumn  513400    1354    1362 97.8000 $E [expr $Comp_I_GC * 8160.0000] $trans_PDelta;
element elasticBeamColumn  512400    1254    1262 97.8000 $E [expr $Comp_I_GC * 8160.0000] $trans_PDelta;
element elasticBeamColumn  511400    1154    1162 97.8000 $E [expr $Comp_I_GC * 8160.0000] $trans_PDelta;
element elasticBeamColumn  510400    1054    1062 97.8000 $E [expr $Comp_I_GC * 8160.0000] $trans_PDelta;
element elasticBeamColumn  509400     954     962 97.8000 $E [expr $Comp_I_GC * 8160.0000] $trans_PDelta;
element elasticBeamColumn  508400     854     862 97.8000 $E [expr $Comp_I_GC * 8160.0000] $trans_PDelta;
element elasticBeamColumn  507400     754     762 97.8000 $E [expr $Comp_I_GC * 8160.0000] $trans_PDelta;
element elasticBeamColumn  506400     654     662 97.8000 $E [expr $Comp_I_GC * 8160.0000] $trans_PDelta;
element elasticBeamColumn  505400     554     562 97.8000 $E [expr $Comp_I_GC * 8160.0000] $trans_PDelta;
element elasticBeamColumn  504400     454     462 97.8000 $E [expr $Comp_I_GC * 8160.0000] $trans_PDelta;
element elasticBeamColumn  503400     354     362 97.8000 $E [expr $Comp_I_GC * 8160.0000] $trans_PDelta;
element elasticBeamColumn  502400     254     262 97.8000 $E [expr $Comp_I_GC * 8160.0000] $trans_PDelta;

# GRAVITY COLUMNS SPRINGS
Spring_IMK   921501    2150    2151 $E $fy [expr (905.0000 + 1636.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 33686.4000 0 $Composite 0 2; Spring_IMK   921601    2160    2161 $E $fy [expr (905.0000 + 1636.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 33686.4000 0 $Composite 0 2; 
Spring_IMK   920503    2050    2053 $E $fy [expr (905.0000 + 1636.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 33686.4000 0 $Composite 0 2; Spring_IMK   920603    2060    2063 $E $fy [expr (905.0000 + 1636.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 33686.4000 0 $Composite 0 2; 
Spring_IMK   920501    2050    2051 $E $fy [expr (905.0000 + 1636.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 33686.4000 0 $Composite 0 2; Spring_IMK   920601    2060    2061 $E $fy [expr (905.0000 + 1636.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 33686.4000 0 $Composite 0 2; 
Spring_IMK   919503    1950    1953 $E $fy [expr (905.0000 + 2612.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 45036.2000 0 $Composite 0 2; Spring_IMK   919603    1960    1963 $E $fy [expr (905.0000 + 2612.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 45036.2000 0 $Composite 0 2; 
Spring_IMK   919501    1950    1951 $E $fy [expr (905.0000 + 2612.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 45036.2000 0 $Composite 0 2; Spring_IMK   919601    1960    1961 $E $fy [expr (905.0000 + 2612.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 45036.2000 0 $Composite 0 2; 
Spring_IMK   918503    1850    1853 $E $fy [expr (905.0000 + 2612.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 45036.2000 0 $Composite 0 2; Spring_IMK   918603    1860    1863 $E $fy [expr (905.0000 + 2612.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 45036.2000 0 $Composite 0 2; 
Spring_IMK   918501    1850    1851 $E $fy [expr (905.0000 + 2612.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 45036.2000 0 $Composite 0 2; Spring_IMK   918601    1860    1861 $E $fy [expr (905.0000 + 2612.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 45036.2000 0 $Composite 0 2; 
Spring_IMK   917503    1750    1753 $E $fy [expr (905.0000 + 3236.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 52937.5000 0 $Composite 0 2; Spring_IMK   917603    1760    1763 $E $fy [expr (905.0000 + 3236.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 52937.5000 0 $Composite 0 2; 
Spring_IMK   917501    1750    1751 $E $fy [expr (905.0000 + 3236.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 52937.5000 0 $Composite 0 2; Spring_IMK   917601    1760    1761 $E $fy [expr (905.0000 + 3236.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 52937.5000 0 $Composite 0 2; 
Spring_IMK   916503    1650    1653 $E $fy [expr (905.0000 + 3236.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 52937.5000 0 $Composite 0 2; Spring_IMK   916603    1660    1663 $E $fy [expr (905.0000 + 3236.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 52937.5000 0 $Composite 0 2; 
Spring_IMK   916501    1650    1651 $E $fy [expr (905.0000 + 3236.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 52937.5000 0 $Composite 0 2; Spring_IMK   916601    1660    1661 $E $fy [expr (905.0000 + 3236.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 52937.5000 0 $Composite 0 2; 
Spring_IMK   915503    1550    1553 $E $fy [expr (905.0000 + 5060.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 69272.5000 0 $Composite 0 2; Spring_IMK   915603    1560    1563 $E $fy [expr (905.0000 + 5060.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 69272.5000 0 $Composite 0 2; 
Spring_IMK   915501    1550    1551 $E $fy [expr (905.0000 + 5060.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 69272.5000 0 $Composite 0 2; Spring_IMK   915601    1560    1561 $E $fy [expr (905.0000 + 5060.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 69272.5000 0 $Composite 0 2; 
Spring_IMK   914503    1450    1453 $E $fy [expr (905.0000 + 5060.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 69272.5000 0 $Composite 0 2; Spring_IMK   914603    1460    1463 $E $fy [expr (905.0000 + 5060.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 69272.5000 0 $Composite 0 2; 
Spring_IMK   914501    1450    1451 $E $fy [expr (905.0000 + 5060.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 69272.5000 0 $Composite 0 2; Spring_IMK   914601    1460    1461 $E $fy [expr (905.0000 + 5060.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 69272.5000 0 $Composite 0 2; 
Spring_IMK   913503    1350    1353 $E $fy [expr (905.0000 + 6060.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 80283.5000 0 $Composite 0 2; Spring_IMK   913603    1360    1363 $E $fy [expr (905.0000 + 6060.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 80283.5000 0 $Composite 0 2; 
Spring_IMK   913501    1350    1351 $E $fy [expr (905.0000 + 6060.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 80283.5000 0 $Composite 0 2; Spring_IMK   913601    1360    1361 $E $fy [expr (905.0000 + 6060.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 80283.5000 0 $Composite 0 2; 
Spring_IMK   912503    1250    1253 $E $fy [expr (905.0000 + 6060.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 80283.5000 0 $Composite 0 2; Spring_IMK   912603    1260    1263 $E $fy [expr (905.0000 + 6060.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 80283.5000 0 $Composite 0 2; 
Spring_IMK   912501    1250    1251 $E $fy [expr (905.0000 + 6060.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 80283.5000 0 $Composite 0 2; Spring_IMK   912601    1260    1261 $E $fy [expr (905.0000 + 6060.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 80283.5000 0 $Composite 0 2; 
Spring_IMK   911503    1150    1153 $E $fy [expr (905.0000 + 7120.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 91536.5000 0 $Composite 0 2; Spring_IMK   911603    1160    1163 $E $fy [expr (905.0000 + 7120.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 91536.5000 0 $Composite 0 2; 
Spring_IMK   911501    1150    1151 $E $fy [expr (905.0000 + 7120.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 91536.5000 0 $Composite 0 2; Spring_IMK   911601    1160    1161 $E $fy [expr (905.0000 + 7120.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 91536.5000 0 $Composite 0 2; 
Spring_IMK   910503    1050    1053 $E $fy [expr (905.0000 + 7120.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 91536.5000 0 $Composite 0 2; Spring_IMK   910603    1060    1063 $E $fy [expr (905.0000 + 7120.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 91536.5000 0 $Composite 0 2; 
Spring_IMK   910501    1050    1051 $E $fy [expr (905.0000 + 7120.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 91536.5000 0 $Composite 0 2; Spring_IMK   910601    1060    1061 $E $fy [expr (905.0000 + 7120.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 91536.5000 0 $Composite 0 2; 
Spring_IMK   909503     950     953 $E $fy [expr (905.0000 + 7480.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 95529.5000 0 $Composite 0 2; Spring_IMK   909603     960     963 $E $fy [expr (905.0000 + 7480.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 95529.5000 0 $Composite 0 2; 
Spring_IMK   909501     950     951 $E $fy [expr (905.0000 + 7480.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 95529.5000 0 $Composite 0 2; Spring_IMK   909601     960     961 $E $fy [expr (905.0000 + 7480.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 95529.5000 0 $Composite 0 2; 
Spring_IMK   908503     850     853 $E $fy [expr (905.0000 + 7480.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 95529.5000 0 $Composite 0 2; Spring_IMK   908603     860     863 $E $fy [expr (905.0000 + 7480.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 95529.5000 0 $Composite 0 2; 
Spring_IMK   908501     850     851 $E $fy [expr (905.0000 + 7480.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 95529.5000 0 $Composite 0 2; Spring_IMK   908601     860     861 $E $fy [expr (905.0000 + 7480.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 95529.5000 0 $Composite 0 2; 
Spring_IMK   907503     750     753 $E $fy [expr (905.0000 + 9100.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 112469.5000 0 $Composite 0 2; Spring_IMK   907603     760     763 $E $fy [expr (905.0000 + 9100.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 112469.5000 0 $Composite 0 2; 
Spring_IMK   907501     750     751 $E $fy [expr (905.0000 + 9100.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 112469.5000 0 $Composite 0 2; Spring_IMK   907601     760     761 $E $fy [expr (905.0000 + 9100.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 112469.5000 0 $Composite 0 2; 
Spring_IMK   906503     650     653 $E $fy [expr (905.0000 + 9100.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 112469.5000 0 $Composite 0 2; Spring_IMK   906603     660     663 $E $fy [expr (905.0000 + 9100.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 112469.5000 0 $Composite 0 2; 
Spring_IMK   906501     650     651 $E $fy [expr (905.0000 + 9100.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 112469.5000 0 $Composite 0 2; Spring_IMK   906601     660     661 $E $fy [expr (905.0000 + 9100.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 112469.5000 0 $Composite 0 2; 
Spring_IMK   905503     550     553 $E $fy [expr (905.0000 + 9620.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 117914.5000 0 $Composite 0 2; Spring_IMK   905603     560     563 $E $fy [expr (905.0000 + 9620.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 117914.5000 0 $Composite 0 2; 
Spring_IMK   905501     550     551 $E $fy [expr (905.0000 + 9620.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 117914.5000 0 $Composite 0 2; Spring_IMK   905601     560     561 $E $fy [expr (905.0000 + 9620.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 117914.5000 0 $Composite 0 2; 
Spring_IMK   904503     450     453 $E $fy [expr (905.0000 + 9620.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 117914.5000 0 $Composite 0 2; Spring_IMK   904603     460     463 $E $fy [expr (905.0000 + 9620.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 117914.5000 0 $Composite 0 2; 
Spring_IMK   904501     450     451 $E $fy [expr (905.0000 + 9620.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 117914.5000 0 $Composite 0 2; Spring_IMK   904601     460     461 $E $fy [expr (905.0000 + 9620.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 117914.5000 0 $Composite 0 2; 
Spring_IMK   903503     350     353 $E $fy [expr (905.0000 + 10740.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 129530.5000 0 $Composite 0 2; Spring_IMK   903603     360     363 $E $fy [expr (905.0000 + 10740.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 129530.5000 0 $Composite 0 2; 
Spring_IMK   903501     350     351 $E $fy [expr (905.0000 + 10740.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 129530.5000 0 $Composite 0 2; Spring_IMK   903601     360     361 $E $fy [expr (905.0000 + 10740.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 129530.5000 0 $Composite 0 2; 
Spring_IMK   902503     250     253 $E $fy [expr (905.0000 + 10740.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 129530.5000 0 $Composite 0 2; Spring_IMK   902603     260     263 $E $fy [expr (905.0000 + 10740.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 129530.5000 0 $Composite 0 2; 
Spring_IMK   902501     250     251 $E $fy [expr (905.0000 + 10740.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 129530.5000 0 $Composite 0 2; Spring_IMK   902601     260     261 $E $fy [expr (905.0000 + 10740.0000)] 14.0000 25.9000 10.2000 3.7000 156.0000 78.0000 156.0000 129530.5000 0 $Composite 0 2; 
Spring_IMK   901503     150     153 $E $fy 10740.0000 14.0000 25.9000 10.2000 3.7000 180.0000 90.0000 180.0000 118096.0000 0 $Composite 0 2; Spring_IMK   901603     160     163 $E $fy 10740.0000 14.0000 25.9000 10.2000 3.7000 180.0000 90.0000 180.0000 118096.0000 0 $Composite 0 2; 

# GRAVITY BEAMS SPRINGS
set gap 0.08;
Spring_Pinching   921504    2150    2154 49005.0000 $gap 1; Spring_Pinching   921602    2160    2162 49005.0000 $gap 1; 
Spring_Pinching   920504    2050    2054 49005.0000 $gap 1; Spring_Pinching   920602    2060    2062 49005.0000 $gap 1; 
Spring_Pinching   919504    1950    1954 49005.0000 $gap 1; Spring_Pinching   919602    1960    1962 49005.0000 $gap 1; 
Spring_Pinching   918504    1850    1854 49005.0000 $gap 1; Spring_Pinching   918602    1860    1862 49005.0000 $gap 1; 
Spring_Pinching   917504    1750    1754 49005.0000 $gap 1; Spring_Pinching   917602    1760    1762 49005.0000 $gap 1; 
Spring_Pinching   916504    1650    1654 49005.0000 $gap 1; Spring_Pinching   916602    1660    1662 49005.0000 $gap 1; 
Spring_Pinching   915504    1550    1554 49005.0000 $gap 1; Spring_Pinching   915602    1560    1562 49005.0000 $gap 1; 
Spring_Pinching   914504    1450    1454 49005.0000 $gap 1; Spring_Pinching   914602    1460    1462 49005.0000 $gap 1; 
Spring_Pinching   913504    1350    1354 49005.0000 $gap 1; Spring_Pinching   913602    1360    1362 49005.0000 $gap 1; 
Spring_Pinching   912504    1250    1254 49005.0000 $gap 1; Spring_Pinching   912602    1260    1262 49005.0000 $gap 1; 
Spring_Pinching   911504    1150    1154 49005.0000 $gap 1; Spring_Pinching   911602    1160    1162 49005.0000 $gap 1; 
Spring_Pinching   910504    1050    1054 49005.0000 $gap 1; Spring_Pinching   910602    1060    1062 49005.0000 $gap 1; 
Spring_Pinching   909504     950     954 49005.0000 $gap 1; Spring_Pinching   909602     960     962 49005.0000 $gap 1; 
Spring_Pinching   908504     850     854 49005.0000 $gap 1; Spring_Pinching   908602     860     862 49005.0000 $gap 1; 
Spring_Pinching   907504     750     754 49005.0000 $gap 1; Spring_Pinching   907602     760     762 49005.0000 $gap 1; 
Spring_Pinching   906504     650     654 49005.0000 $gap 1; Spring_Pinching   906602     660     662 49005.0000 $gap 1; 
Spring_Pinching   905504     550     554 49005.0000 $gap 1; Spring_Pinching   905602     560     562 49005.0000 $gap 1; 
Spring_Pinching   904504     450     454 49005.0000 $gap 1; Spring_Pinching   904602     460     462 49005.0000 $gap 1; 
Spring_Pinching   903504     350     354 49005.0000 $gap 1; Spring_Pinching   903602     360     362 49005.0000 $gap 1; 
Spring_Pinching   902504     250     254 49005.0000 $gap 1; Spring_Pinching   902602     260     262 49005.0000 $gap 1; 

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
equalDOF 421104 421204 1; equalDOF 421104 421304 1; equalDOF 421104 421404 1; 
equalDOF 420104 420204 1; equalDOF 420104 420304 1; equalDOF 420104 420404 1; 
equalDOF 419104 419204 1; equalDOF 419104 419304 1; equalDOF 419104 419404 1; 
equalDOF 418104 418204 1; equalDOF 418104 418304 1; equalDOF 418104 418404 1; 
equalDOF 417104 417204 1; equalDOF 417104 417304 1; equalDOF 417104 417404 1; 
equalDOF 416104 416204 1; equalDOF 416104 416304 1; equalDOF 416104 416404 1; 
equalDOF 415104 415204 1; equalDOF 415104 415304 1; equalDOF 415104 415404 1; 
equalDOF 414104 414204 1; equalDOF 414104 414304 1; equalDOF 414104 414404 1; 
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
equalDOF 2150 2160 1;
equalDOF 2050 2060 1;
equalDOF 1950 1960 1;
equalDOF 1850 1860 1;
equalDOF 1750 1760 1;
equalDOF 1650 1660 1;
equalDOF 1550 1560 1;
equalDOF 1450 1460 1;
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
recorder Node -file $MainFolder/EigenAnalysis/EigenVectorsMode1.out -node 402104 403104 404104 405104 406104 407104 408104 409104 410104 411104 412104 413104 414104 415104 416104 417104 418104 419104 420104 421104  -dof 1 "eigen  1";
recorder Node -file $MainFolder/EigenAnalysis/EigenVectorsMode2.out -node 402104 403104 404104 405104 406104 407104 408104 409104 410104 411104 412104 413104 414104 415104 416104 417104 418104 419104 420104 421104  -dof 1 "eigen  2";
recorder Node -file $MainFolder/EigenAnalysis/EigenVectorsMode3.out -node 402104 403104 404104 405104 406104 407104 408104 409104 410104 411104 412104 413104 414104 415104 416104 417104 418104 419104 420104 421104  -dof 1 "eigen  3";
recorder Node -file $MainFolder/EigenAnalysis/EigenVectorsMode4.out -node 402104 403104 404104 405104 406104 407104 408104 409104 410104 411104 412104 413104 414104 415104 416104 417104 418104 419104 420104 421104  -dof 1 "eigen  4";
recorder Node -file $MainFolder/EigenAnalysis/EigenVectorsMode5.out -node 402104 403104 404104 405104 406104 407104 408104 409104 410104 411104 412104 413104 414104 415104 416104 417104 418104 419104 420104 421104  -dof 1 "eigen  5";
recorder Node -file $MainFolder/EigenAnalysis/EigenVectorsMode6.out -node 402104 403104 404104 405104 406104 407104 408104 409104 410104 411104 412104 413104 414104 415104 416104 417104 418104 419104 420104 421104  -dof 1 "eigen  6";
recorder Node -file $MainFolder/EigenAnalysis/EigenVectorsMode7.out -node 402104 403104 404104 405104 406104 407104 408104 409104 410104 411104 412104 413104 414104 415104 416104 417104 418104 419104 420104 421104  -dof 1 "eigen  7";
recorder Node -file $MainFolder/EigenAnalysis/EigenVectorsMode8.out -node 402104 403104 404104 405104 406104 407104 408104 409104 410104 411104 412104 413104 414104 415104 416104 417104 418104 419104 420104 421104  -dof 1 "eigen  8";
recorder Node -file $MainFolder/EigenAnalysis/EigenVectorsMode9.out -node 402104 403104 404104 405104 406104 407104 408104 409104 410104 411104 412104 413104 414104 415104 416104 417104 418104 419104 420104 421104  -dof 1 "eigen  9";
recorder Node -file $MainFolder/EigenAnalysis/EigenVectorsMode10.out -node 402104 403104 404104 405104 406104 407104 408104 409104 410104 411104 412104 413104 414104 415104 416104 417104 418104 419104 420104 421104  -dof 1 "eigen  10";
recorder Node -file $MainFolder/EigenAnalysis/EigenVectorsMode11.out -node 402104 403104 404104 405104 406104 407104 408104 409104 410104 411104 412104 413104 414104 415104 416104 417104 418104 419104 420104 421104  -dof 1 "eigen  11";
recorder Node -file $MainFolder/EigenAnalysis/EigenVectorsMode12.out -node 402104 403104 404104 405104 406104 407104 408104 409104 410104 411104 412104 413104 414104 415104 416104 417104 418104 419104 420104 421104  -dof 1 "eigen  12";
recorder Node -file $MainFolder/EigenAnalysis/EigenVectorsMode13.out -node 402104 403104 404104 405104 406104 407104 408104 409104 410104 411104 412104 413104 414104 415104 416104 417104 418104 419104 420104 421104  -dof 1 "eigen  13";
recorder Node -file $MainFolder/EigenAnalysis/EigenVectorsMode14.out -node 402104 403104 404104 405104 406104 407104 408104 409104 410104 411104 412104 413104 414104 415104 416104 417104 418104 419104 420104 421104  -dof 1 "eigen  14";
recorder Node -file $MainFolder/EigenAnalysis/EigenVectorsMode15.out -node 402104 403104 404104 405104 406104 407104 408104 409104 410104 411104 412104 413104 414104 415104 416104 417104 418104 419104 420104 421104  -dof 1 "eigen  15";
recorder Node -file $MainFolder/EigenAnalysis/EigenVectorsMode16.out -node 402104 403104 404104 405104 406104 407104 408104 409104 410104 411104 412104 413104 414104 415104 416104 417104 418104 419104 420104 421104  -dof 1 "eigen  16";
recorder Node -file $MainFolder/EigenAnalysis/EigenVectorsMode17.out -node 402104 403104 404104 405104 406104 407104 408104 409104 410104 411104 412104 413104 414104 415104 416104 417104 418104 419104 420104 421104  -dof 1 "eigen  17";
recorder Node -file $MainFolder/EigenAnalysis/EigenVectorsMode18.out -node 402104 403104 404104 405104 406104 407104 408104 409104 410104 411104 412104 413104 414104 415104 416104 417104 418104 419104 420104 421104  -dof 1 "eigen  18";
recorder Node -file $MainFolder/EigenAnalysis/EigenVectorsMode19.out -node 402104 403104 404104 405104 406104 407104 408104 409104 410104 411104 412104 413104 414104 415104 416104 417104 418104 419104 420104 421104  -dof 1 "eigen  19";
recorder Node -file $MainFolder/EigenAnalysis/EigenVectorsMode20.out -node 402104 403104 404104 405104 406104 407104 408104 409104 410104 411104 412104 413104 414104 415104 416104 417104 418104 419104 420104 421104  -dof 1 "eigen  20";

# TIME
recorder Node -file $MainFolder/$SubFolder/Time.out  -time -node 110 -dof 1 disp;

# SUPPORT REACTIONS
recorder Node -file $MainFolder/$SubFolder/Support1.out -node     110 -dof 1 2 6 reaction; recorder Node -file $MainFolder/$SubFolder/Support2.out -node     120 -dof 1 2 6 reaction; recorder Node -file $MainFolder/$SubFolder/Support3.out -node     130 -dof 1 2 6 reaction; recorder Node -file $MainFolder/$SubFolder/Support4.out -node     140 -dof 1 2 6 reaction; recorder Node -file $MainFolder/$SubFolder/Support5.out -node     150 -dof 1 2 6 reaction; recorder Node -file $MainFolder/$SubFolder/Support6.out -node     160 -dof 1 2 6 reaction; 

# STORY DRIFT RATIO
recorder Drift -file $MainFolder/$SubFolder/SDR20_MF.out -iNode  420104 -jNode  421104 -dof 1 -perpDirn 2; 
recorder Drift -file $MainFolder/$SubFolder/SDR19_MF.out -iNode  419104 -jNode  420104 -dof 1 -perpDirn 2; 
recorder Drift -file $MainFolder/$SubFolder/SDR18_MF.out -iNode  418104 -jNode  419104 -dof 1 -perpDirn 2; 
recorder Drift -file $MainFolder/$SubFolder/SDR17_MF.out -iNode  417104 -jNode  418104 -dof 1 -perpDirn 2; 
recorder Drift -file $MainFolder/$SubFolder/SDR16_MF.out -iNode  416104 -jNode  417104 -dof 1 -perpDirn 2; 
recorder Drift -file $MainFolder/$SubFolder/SDR15_MF.out -iNode  415104 -jNode  416104 -dof 1 -perpDirn 2; 
recorder Drift -file $MainFolder/$SubFolder/SDR14_MF.out -iNode  414104 -jNode  415104 -dof 1 -perpDirn 2; 
recorder Drift -file $MainFolder/$SubFolder/SDR13_MF.out -iNode  413104 -jNode  414104 -dof 1 -perpDirn 2; 
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
recorder Element -file $MainFolder/$SubFolder/Column201.out -ele  620100 force; recorder Element -file $MainFolder/$SubFolder/Column202.out -ele  620200 force; recorder Element -file $MainFolder/$SubFolder/Column203.out -ele  620300 force; recorder Element -file $MainFolder/$SubFolder/Column204.out -ele  620400 force; recorder Element -file $MainFolder/$SubFolder/Column205.out -ele  620500 force; recorder Element -file $MainFolder/$SubFolder/Column206.out -ele  620600 force; 
recorder Element -file $MainFolder/$SubFolder/Column191.out -ele  619101 force; recorder Element -file $MainFolder/$SubFolder/Column192.out -ele  619201 force; recorder Element -file $MainFolder/$SubFolder/Column193.out -ele  619301 force; recorder Element -file $MainFolder/$SubFolder/Column194.out -ele  619401 force; recorder Element -file $MainFolder/$SubFolder/Column195.out -ele  619501 force; recorder Element -file $MainFolder/$SubFolder/Column196.out -ele  619601 force; 
recorder Element -file $MainFolder/$SubFolder/Column181.out -ele  618100 force; recorder Element -file $MainFolder/$SubFolder/Column182.out -ele  618200 force; recorder Element -file $MainFolder/$SubFolder/Column183.out -ele  618300 force; recorder Element -file $MainFolder/$SubFolder/Column184.out -ele  618400 force; recorder Element -file $MainFolder/$SubFolder/Column185.out -ele  618500 force; recorder Element -file $MainFolder/$SubFolder/Column186.out -ele  618600 force; 
recorder Element -file $MainFolder/$SubFolder/Column171.out -ele  617101 force; recorder Element -file $MainFolder/$SubFolder/Column172.out -ele  617201 force; recorder Element -file $MainFolder/$SubFolder/Column173.out -ele  617301 force; recorder Element -file $MainFolder/$SubFolder/Column174.out -ele  617401 force; recorder Element -file $MainFolder/$SubFolder/Column175.out -ele  617501 force; recorder Element -file $MainFolder/$SubFolder/Column176.out -ele  617601 force; 
recorder Element -file $MainFolder/$SubFolder/Column161.out -ele  616100 force; recorder Element -file $MainFolder/$SubFolder/Column162.out -ele  616200 force; recorder Element -file $MainFolder/$SubFolder/Column163.out -ele  616300 force; recorder Element -file $MainFolder/$SubFolder/Column164.out -ele  616400 force; recorder Element -file $MainFolder/$SubFolder/Column165.out -ele  616500 force; recorder Element -file $MainFolder/$SubFolder/Column166.out -ele  616600 force; 
recorder Element -file $MainFolder/$SubFolder/Column151.out -ele  615101 force; recorder Element -file $MainFolder/$SubFolder/Column152.out -ele  615201 force; recorder Element -file $MainFolder/$SubFolder/Column153.out -ele  615301 force; recorder Element -file $MainFolder/$SubFolder/Column154.out -ele  615401 force; recorder Element -file $MainFolder/$SubFolder/Column155.out -ele  615501 force; recorder Element -file $MainFolder/$SubFolder/Column156.out -ele  615601 force; 
recorder Element -file $MainFolder/$SubFolder/Column141.out -ele  614100 force; recorder Element -file $MainFolder/$SubFolder/Column142.out -ele  614200 force; recorder Element -file $MainFolder/$SubFolder/Column143.out -ele  614300 force; recorder Element -file $MainFolder/$SubFolder/Column144.out -ele  614400 force; recorder Element -file $MainFolder/$SubFolder/Column145.out -ele  614500 force; recorder Element -file $MainFolder/$SubFolder/Column146.out -ele  614600 force; 
recorder Element -file $MainFolder/$SubFolder/Column131.out -ele  613101 force; recorder Element -file $MainFolder/$SubFolder/Column132.out -ele  613201 force; recorder Element -file $MainFolder/$SubFolder/Column133.out -ele  613301 force; recorder Element -file $MainFolder/$SubFolder/Column134.out -ele  613401 force; recorder Element -file $MainFolder/$SubFolder/Column135.out -ele  613501 force; recorder Element -file $MainFolder/$SubFolder/Column136.out -ele  613601 force; 
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
mass 421104 0.1476  1.e-9 1.e-9; mass 421204 0.1709  1.e-9 1.e-9; mass 421304 0.1709  1.e-9 1.e-9; mass 421404 0.1709  1.e-9 1.e-9; mass 2150 0.5361  1.e-9 1.e-9; mass 2160 0.5361  1.e-9 1.e-9; 
mass 420104 0.2486  1.e-9 1.e-9; mass 420204 0.2720  1.e-9 1.e-9; mass 420304 0.2720  1.e-9 1.e-9; mass 420404 0.2720  1.e-9 1.e-9; mass 2050 0.3846  1.e-9 1.e-9; mass 2060 0.3846  1.e-9 1.e-9; 
mass 419104 0.2486  1.e-9 1.e-9; mass 419204 0.2720  1.e-9 1.e-9; mass 419304 0.2720  1.e-9 1.e-9; mass 419404 0.2720  1.e-9 1.e-9; mass 1950 0.3846  1.e-9 1.e-9; mass 1960 0.3846  1.e-9 1.e-9; 
mass 418104 0.2486  1.e-9 1.e-9; mass 418204 0.2720  1.e-9 1.e-9; mass 418304 0.2720  1.e-9 1.e-9; mass 418404 0.2720  1.e-9 1.e-9; mass 1850 0.3846  1.e-9 1.e-9; mass 1860 0.3846  1.e-9 1.e-9; 
mass 417104 0.2486  1.e-9 1.e-9; mass 417204 0.2720  1.e-9 1.e-9; mass 417304 0.2720  1.e-9 1.e-9; mass 417404 0.2720  1.e-9 1.e-9; mass 1750 0.3846  1.e-9 1.e-9; mass 1760 0.3846  1.e-9 1.e-9; 
mass 416104 0.2486  1.e-9 1.e-9; mass 416204 0.2720  1.e-9 1.e-9; mass 416304 0.2720  1.e-9 1.e-9; mass 416404 0.2720  1.e-9 1.e-9; mass 1650 0.3846  1.e-9 1.e-9; mass 1660 0.3846  1.e-9 1.e-9; 
mass 415104 0.2486  1.e-9 1.e-9; mass 415204 0.2720  1.e-9 1.e-9; mass 415304 0.2720  1.e-9 1.e-9; mass 415404 0.2720  1.e-9 1.e-9; mass 1550 0.3846  1.e-9 1.e-9; mass 1560 0.3846  1.e-9 1.e-9; 
mass 414104 0.2486  1.e-9 1.e-9; mass 414204 0.2720  1.e-9 1.e-9; mass 414304 0.2720  1.e-9 1.e-9; mass 414404 0.2720  1.e-9 1.e-9; mass 1450 0.3846  1.e-9 1.e-9; mass 1460 0.3846  1.e-9 1.e-9; 
mass 413104 0.2486  1.e-9 1.e-9; mass 413204 0.2720  1.e-9 1.e-9; mass 413304 0.2720  1.e-9 1.e-9; mass 413404 0.2720  1.e-9 1.e-9; mass 1350 0.3846  1.e-9 1.e-9; mass 1360 0.3846  1.e-9 1.e-9; 
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
set nEigen 20;
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
set lambda13 [lindex $lambdaN 12];
set lambda14 [lindex $lambdaN 13];
set lambda15 [lindex $lambdaN 14];
set lambda16 [lindex $lambdaN 15];
set lambda17 [lindex $lambdaN 16];
set lambda18 [lindex $lambdaN 17];
set lambda19 [lindex $lambdaN 18];
set lambda20 [lindex $lambdaN 19];
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
set w13 [expr pow($lambda13,0.5)];
set w14 [expr pow($lambda14,0.5)];
set w15 [expr pow($lambda15,0.5)];
set w16 [expr pow($lambda16,0.5)];
set w17 [expr pow($lambda17,0.5)];
set w18 [expr pow($lambda18,0.5)];
set w19 [expr pow($lambda19,0.5)];
set w20 [expr pow($lambda20,0.5)];
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
set T13 [expr round(2.0*$pi/$w13 *1000.)/1000.];
set T14 [expr round(2.0*$pi/$w14 *1000.)/1000.];
set T15 [expr round(2.0*$pi/$w15 *1000.)/1000.];
set T16 [expr round(2.0*$pi/$w16 *1000.)/1000.];
set T17 [expr round(2.0*$pi/$w17 *1000.)/1000.];
set T18 [expr round(2.0*$pi/$w18 *1000.)/1000.];
set T19 [expr round(2.0*$pi/$w19 *1000.)/1000.];
set T20 [expr round(2.0*$pi/$w20 *1000.)/1000.];
puts "T1 = $T1 s";
puts "T2 = $T2 s";
puts "T3 = $T3 s";
set fileX [open "EigenPeriod.out" w];
puts $fileX $T1;puts $fileX $T2;puts $fileX $T3;puts $fileX $T4;puts $fileX $T5;puts $fileX $T6;puts $fileX $T7;puts $fileX $T8;puts $fileX $T9;puts $fileX $T10;puts $fileX $T11;puts $fileX $T12;puts $fileX $T13;puts $fileX $T14;puts $fileX $T15;puts $fileX $T16;puts $fileX $T17;puts $fileX $T18;puts $fileX $T19;puts $fileX $T20;close $fileX;

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
region 2 -node  402104 402204 402304 402404 250 260 403104 403204 403304 403404 350 360 404104 404204 404304 404404 450 460 405104 405204 405304 405404 550 560 406104 406204 406304 406404 650 660 407104 407204 407304 407404 750 760 408104 408204 408304 408404 850 860 409104 409204 409304 409404 950 960 410104 410204 410304 410404 1050 1060 411104 411204 411304 411404 1150 1160 412104 412204 412304 412404 1250 1260 413104 413204 413304 413404 1350 1360 414104 414204 414304 414404 1450 1460 415104 415204 415304 415404 1550 1560 416104 416204 416304 416404 1650 1660 417104 417204 417304 417404 1750 1760 418104 418204 418304 418404 1850 1860 419104 419204 419304 419404 1950 1960 420104 420204 420304 420404 2050 2060 421104 421204 421304 421404 2150 2160  -rayleigh $a0 0.0 0.0 0.0;
region 3 -eleRange  900000  999999 -rayleigh 0.0 0.0 [expr $a1_mod/10] 0.0;

# GROUND MOTION ACCELERATION FILE INPUT
set AccelSeries "Series -dt $GMdt -filePath $GMfile -factor  [expr $EqSF * $g]"
pattern UniformExcitation  200 1 -accel $AccelSeries

set MF_FloorNodes [list  402104 403104 404104 405104 406104 407104 408104 409104 410104 411104 412104 413104 414104 415104 416104 417104 418104 419104 420104 421104 ];
set EGF_FloorNodes [list  250 350 450 550 650 750 850 950 1050 1150 1250 1350 1450 1550 1650 1750 1850 1950 2050 2150 ];
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
