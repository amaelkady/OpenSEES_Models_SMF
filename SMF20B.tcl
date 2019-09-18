# 20-story MRF Building
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
set NStory 20;
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
set HBuilding 3144.00;
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
set WFrame 720.00;

####################################################################################################
#                                				NODES       				                        #
####################################################################################################

#SUPPORT NODES
node 11   $Axis1  $Floor1; node 12   $Axis2  $Floor1; node 13   $Axis3  $Floor1; node 14   $Axis4  $Floor1; node 15   $Axis5  $Floor1; node 16   $Axis6  $Floor1; 

# LEANING/GRAVITY COLUMN NODES
node 215   $Axis5  $Floor21; node 216   $Axis6  $Floor21; 
node 205   $Axis5  $Floor20; node 206   $Axis6  $Floor20; 
node 195   $Axis5  $Floor19; node 196   $Axis6  $Floor19; 
node 185   $Axis5  $Floor18; node 186   $Axis6  $Floor18; 
node 175   $Axis5  $Floor17; node 176   $Axis6  $Floor17; 
node 165   $Axis5  $Floor16; node 166   $Axis6  $Floor16; 
node 155   $Axis5  $Floor15; node 156   $Axis6  $Floor15; 
node 145   $Axis5  $Floor14; node 146   $Axis6  $Floor14; 
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

# MRF COLUMN NODES
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

# BEAM PLASTIC HINGE NODES
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
node 119170 $Axis1 [expr ($Floor19+$Floor20)/2]; node 119270 $Axis2 [expr ($Floor19+$Floor20)/2]; node 119370 $Axis3 [expr ($Floor19+$Floor20)/2]; node 119470 $Axis4 [expr ($Floor19+$Floor20)/2]; node 119570 $Axis5 [expr ($Floor19+$Floor20)/2]; node 119670 $Axis6 [expr ($Floor19+$Floor20)/2]; 
node 117170 $Axis1 [expr ($Floor17+$Floor18)/2]; node 117270 $Axis2 [expr ($Floor17+$Floor18)/2]; node 117370 $Axis3 [expr ($Floor17+$Floor18)/2]; node 117470 $Axis4 [expr ($Floor17+$Floor18)/2]; node 117570 $Axis5 [expr ($Floor17+$Floor18)/2]; node 117670 $Axis6 [expr ($Floor17+$Floor18)/2]; 
node 115170 $Axis1 [expr ($Floor15+$Floor16)/2]; node 115270 $Axis2 [expr ($Floor15+$Floor16)/2]; node 115370 $Axis3 [expr ($Floor15+$Floor16)/2]; node 115470 $Axis4 [expr ($Floor15+$Floor16)/2]; node 115570 $Axis5 [expr ($Floor15+$Floor16)/2]; node 115670 $Axis6 [expr ($Floor15+$Floor16)/2]; 
node 113170 $Axis1 [expr ($Floor13+$Floor14)/2]; node 113270 $Axis2 [expr ($Floor13+$Floor14)/2]; node 113370 $Axis3 [expr ($Floor13+$Floor14)/2]; node 113470 $Axis4 [expr ($Floor13+$Floor14)/2]; node 113570 $Axis5 [expr ($Floor13+$Floor14)/2]; node 113670 $Axis6 [expr ($Floor13+$Floor14)/2]; 
node 111170 $Axis1 [expr ($Floor11+$Floor12)/2]; node 111270 $Axis2 [expr ($Floor11+$Floor12)/2]; node 111370 $Axis3 [expr ($Floor11+$Floor12)/2]; node 111470 $Axis4 [expr ($Floor11+$Floor12)/2]; node 111570 $Axis5 [expr ($Floor11+$Floor12)/2]; node 111670 $Axis6 [expr ($Floor11+$Floor12)/2]; 
node 109170 $Axis1 [expr ($Floor9+$Floor10)/2]; node 109270 $Axis2 [expr ($Floor9+$Floor10)/2]; node 109370 $Axis3 [expr ($Floor9+$Floor10)/2]; node 109470 $Axis4 [expr ($Floor9+$Floor10)/2]; node 109570 $Axis5 [expr ($Floor9+$Floor10)/2]; node 109670 $Axis6 [expr ($Floor9+$Floor10)/2]; 
node 107170 $Axis1 [expr ($Floor7+$Floor8)/2]; node 107270 $Axis2 [expr ($Floor7+$Floor8)/2]; node 107370 $Axis3 [expr ($Floor7+$Floor8)/2]; node 107470 $Axis4 [expr ($Floor7+$Floor8)/2]; node 107570 $Axis5 [expr ($Floor7+$Floor8)/2]; node 107670 $Axis6 [expr ($Floor7+$Floor8)/2]; 
node 105170 $Axis1 [expr ($Floor5+$Floor6)/2]; node 105270 $Axis2 [expr ($Floor5+$Floor6)/2]; node 105370 $Axis3 [expr ($Floor5+$Floor6)/2]; node 105470 $Axis4 [expr ($Floor5+$Floor6)/2]; node 105570 $Axis5 [expr ($Floor5+$Floor6)/2]; node 105670 $Axis6 [expr ($Floor5+$Floor6)/2]; 
node 103170 $Axis1 [expr ($Floor3+$Floor4)/2]; node 103270 $Axis2 [expr ($Floor3+$Floor4)/2]; node 103370 $Axis3 [expr ($Floor3+$Floor4)/2]; node 103470 $Axis4 [expr ($Floor3+$Floor4)/2]; node 103570 $Axis5 [expr ($Floor3+$Floor4)/2]; node 103670 $Axis6 [expr ($Floor3+$Floor4)/2]; 

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

# PANEL ZONE NODES AND ELASTIC ELEMENTS
# CROSS PANEL ZONE NODES AND ELASTIC ELEMENTS
# Command Syntax; 
# ConstructPanel Axis Floor X_Axis Y_Floor E A_Panel I_Panel d_Col d_Beam transfTag 
ConstructPanel  1 21 $Axis1 $Floor21 $E $A_Stiff $I_Stiff 14.70 23.90 1; ConstructPanel  2 21 $Axis2 $Floor21 $E $A_Stiff $I_Stiff 35.90 23.90 1; ConstructPanel  3 21 $Axis3 $Floor21 $E $A_Stiff $I_Stiff 35.90 23.90 1; ConstructPanel  4 21 $Axis4 $Floor21 $E $A_Stiff $I_Stiff 14.70 23.90 1; 
ConstructPanel  1 20 $Axis1 $Floor20 $E $A_Stiff $I_Stiff 14.70 23.90 1; ConstructPanel  2 20 $Axis2 $Floor20 $E $A_Stiff $I_Stiff 35.90 23.90 1; ConstructPanel  3 20 $Axis3 $Floor20 $E $A_Stiff $I_Stiff 35.90 23.90 1; ConstructPanel  4 20 $Axis4 $Floor20 $E $A_Stiff $I_Stiff 14.70 23.90 1; 
ConstructPanel  1 19 $Axis1 $Floor19 $E $A_Stiff $I_Stiff 15.50 25.70 1; ConstructPanel  2 19 $Axis2 $Floor19 $E $A_Stiff $I_Stiff 36.50 25.70 1; ConstructPanel  3 19 $Axis3 $Floor19 $E $A_Stiff $I_Stiff 36.50 25.70 1; ConstructPanel  4 19 $Axis4 $Floor19 $E $A_Stiff $I_Stiff 15.50 25.70 1; 
ConstructPanel  1 18 $Axis1 $Floor18 $E $A_Stiff $I_Stiff 15.50 25.70 1; ConstructPanel  2 18 $Axis2 $Floor18 $E $A_Stiff $I_Stiff 36.50 25.70 1; ConstructPanel  3 18 $Axis3 $Floor18 $E $A_Stiff $I_Stiff 36.50 25.70 1; ConstructPanel  4 18 $Axis4 $Floor18 $E $A_Stiff $I_Stiff 15.50 25.70 1; 
ConstructPanel  1 17 $Axis1 $Floor17 $E $A_Stiff $I_Stiff 16.00 25.70 1; ConstructPanel  2 17 $Axis2 $Floor17 $E $A_Stiff $I_Stiff 37.10 25.70 1; ConstructPanel  3 17 $Axis3 $Floor17 $E $A_Stiff $I_Stiff 37.10 25.70 1; ConstructPanel  4 17 $Axis4 $Floor17 $E $A_Stiff $I_Stiff 16.00 25.70 1; 
ConstructPanel  1 16 $Axis1 $Floor16 $E $A_Stiff $I_Stiff 16.00 33.50 1; ConstructPanel  2 16 $Axis2 $Floor16 $E $A_Stiff $I_Stiff 37.10 33.50 1; ConstructPanel  3 16 $Axis3 $Floor16 $E $A_Stiff $I_Stiff 37.10 33.50 1; ConstructPanel  4 16 $Axis4 $Floor16 $E $A_Stiff $I_Stiff 16.00 33.50 1; 
ConstructPanel  1 15 $Axis1 $Floor15 $E $A_Stiff $I_Stiff 16.70 33.50 1; ConstructPanel  2 15 $Axis2 $Floor15 $E $A_Stiff $I_Stiff 36.30 33.50 1; ConstructPanel  3 15 $Axis3 $Floor15 $E $A_Stiff $I_Stiff 36.30 33.50 1; ConstructPanel  4 15 $Axis4 $Floor15 $E $A_Stiff $I_Stiff 16.70 33.50 1; 
ConstructPanel  1 14 $Axis1 $Floor14 $E $A_Stiff $I_Stiff 16.70 33.50 1; ConstructPanel  2 14 $Axis2 $Floor14 $E $A_Stiff $I_Stiff 36.30 33.50 1; ConstructPanel  3 14 $Axis3 $Floor14 $E $A_Stiff $I_Stiff 36.30 33.50 1; ConstructPanel  4 14 $Axis4 $Floor14 $E $A_Stiff $I_Stiff 16.70 33.50 1; 
ConstructPanel  1 13 $Axis1 $Floor13 $E $A_Stiff $I_Stiff 17.10 33.80 1; ConstructPanel  2 13 $Axis2 $Floor13 $E $A_Stiff $I_Stiff 37.10 33.80 1; ConstructPanel  3 13 $Axis3 $Floor13 $E $A_Stiff $I_Stiff 37.10 33.80 1; ConstructPanel  4 13 $Axis4 $Floor13 $E $A_Stiff $I_Stiff 17.10 33.80 1; 
ConstructPanel  1 12 $Axis1 $Floor12 $E $A_Stiff $I_Stiff 17.10 33.80 1; ConstructPanel  2 12 $Axis2 $Floor12 $E $A_Stiff $I_Stiff 37.10 33.80 1; ConstructPanel  3 12 $Axis3 $Floor12 $E $A_Stiff $I_Stiff 37.10 33.80 1; ConstructPanel  4 12 $Axis4 $Floor12 $E $A_Stiff $I_Stiff 17.10 33.80 1; 
ConstructPanel  1 11 $Axis1 $Floor11 $E $A_Stiff $I_Stiff 17.90 33.80 1; ConstructPanel  2 11 $Axis2 $Floor11 $E $A_Stiff $I_Stiff 37.40 33.80 1; ConstructPanel  3 11 $Axis3 $Floor11 $E $A_Stiff $I_Stiff 37.40 33.80 1; ConstructPanel  4 11 $Axis4 $Floor11 $E $A_Stiff $I_Stiff 17.90 33.80 1; 
ConstructPanel  1 10 $Axis1 $Floor10 $E $A_Stiff $I_Stiff 17.90 33.80 1; ConstructPanel  2 10 $Axis2 $Floor10 $E $A_Stiff $I_Stiff 37.40 33.80 1; ConstructPanel  3 10 $Axis3 $Floor10 $E $A_Stiff $I_Stiff 37.40 33.80 1; ConstructPanel  4 10 $Axis4 $Floor10 $E $A_Stiff $I_Stiff 17.90 33.80 1; 
ConstructPanel  1 9 $Axis1 $Floor9 $E $A_Stiff $I_Stiff 17.90 33.80 1; ConstructPanel  2 9 $Axis2 $Floor9 $E $A_Stiff $I_Stiff 37.80 33.80 1; ConstructPanel  3 9 $Axis3 $Floor9 $E $A_Stiff $I_Stiff 37.80 33.80 1; ConstructPanel  4 9 $Axis4 $Floor9 $E $A_Stiff $I_Stiff 17.90 33.80 1; 
ConstructPanel  1 8 $Axis1 $Floor8 $E $A_Stiff $I_Stiff 17.90 33.80 1; ConstructPanel  2 8 $Axis2 $Floor8 $E $A_Stiff $I_Stiff 37.80 33.80 1; ConstructPanel  3 8 $Axis3 $Floor8 $E $A_Stiff $I_Stiff 37.80 33.80 1; ConstructPanel  4 8 $Axis4 $Floor8 $E $A_Stiff $I_Stiff 17.90 33.80 1; 
ConstructPanel  1 7 $Axis1 $Floor7 $E $A_Stiff $I_Stiff 19.00 33.80 1; ConstructPanel  2 7 $Axis2 $Floor7 $E $A_Stiff $I_Stiff 38.30 33.80 1; ConstructPanel  3 7 $Axis3 $Floor7 $E $A_Stiff $I_Stiff 38.30 33.80 1; ConstructPanel  4 7 $Axis4 $Floor7 $E $A_Stiff $I_Stiff 19.00 33.80 1; 
ConstructPanel  1 6 $Axis1 $Floor6 $E $A_Stiff $I_Stiff 19.00 33.80 1; ConstructPanel  2 6 $Axis2 $Floor6 $E $A_Stiff $I_Stiff 38.30 33.80 1; ConstructPanel  3 6 $Axis3 $Floor6 $E $A_Stiff $I_Stiff 38.30 33.80 1; ConstructPanel  4 6 $Axis4 $Floor6 $E $A_Stiff $I_Stiff 19.00 33.80 1; 
ConstructPanel  1 5 $Axis1 $Floor5 $E $A_Stiff $I_Stiff 19.00 33.80 1; ConstructPanel  2 5 $Axis2 $Floor5 $E $A_Stiff $I_Stiff 39.30 33.80 1; ConstructPanel  3 5 $Axis3 $Floor5 $E $A_Stiff $I_Stiff 39.30 33.80 1; ConstructPanel  4 5 $Axis4 $Floor5 $E $A_Stiff $I_Stiff 19.00 33.80 1; 
ConstructPanel  1 4 $Axis1 $Floor4 $E $A_Stiff $I_Stiff 19.00 33.50 1; ConstructPanel  2 4 $Axis2 $Floor4 $E $A_Stiff $I_Stiff 39.30 33.50 1; ConstructPanel  3 4 $Axis3 $Floor4 $E $A_Stiff $I_Stiff 39.30 33.50 1; ConstructPanel  4 4 $Axis4 $Floor4 $E $A_Stiff $I_Stiff 19.00 33.50 1; 
ConstructPanel  1 3 $Axis1 $Floor3 $E $A_Stiff $I_Stiff 19.60 33.50 1; ConstructPanel  2 3 $Axis2 $Floor3 $E $A_Stiff $I_Stiff 39.20 33.50 1; ConstructPanel  3 3 $Axis3 $Floor3 $E $A_Stiff $I_Stiff 39.20 33.50 1; ConstructPanel  4 3 $Axis4 $Floor3 $E $A_Stiff $I_Stiff 19.60 33.50 1; 
ConstructPanel  1 2 $Axis1 $Floor2 $E $A_Stiff $I_Stiff 19.60 33.50 1; ConstructPanel  2 2 $Axis2 $Floor2 $E $A_Stiff $I_Stiff 39.20 33.50 1; ConstructPanel  3 2 $Axis3 $Floor2 $E $A_Stiff $I_Stiff 39.20 33.50 1; ConstructPanel  4 2 $Axis4 $Floor2 $E $A_Stiff $I_Stiff 19.60 33.50 1; 

####################################################################################################
#                                   		PANEL ZONE SPRINGS	                                    #
####################################################################################################

# Command Syntax; 
# Spring_Panel Element_ID Node_i Node_j E Fy tp d_Colum d_Beam tf_Column bf_Column SH_Panel Response_ID transfTag Units
Spring_Panel 921100 421109 421110 $E $Fy [expr  0.65 +  0.06] 14.70 23.90  1.03 14.70  0.03 2 1 2; Spring_Panel 921200 421209 421210 $E $Fy [expr  0.63 +  0.00] 35.90 23.90  0.94 12.00  0.03 2 1 2; Spring_Panel 921300 421309 421310 $E $Fy [expr  0.63 +  0.00] 35.90 23.90  0.94 12.00  0.03 2 1 2; Spring_Panel 921400 421409 421410 $E $Fy [expr  0.65 +  0.06] 14.70 23.90  1.03 14.70  0.03 2 1 2; 
Spring_Panel 920100 420109 420110 $E $Fy [expr  0.65 +  0.06] 14.70 23.90  1.03 14.70  0.03 2 1 2; Spring_Panel 920200 420209 420210 $E $Fy [expr  0.63 +  0.00] 35.90 23.90  0.94 12.00  0.03 2 1 2; Spring_Panel 920300 420309 420310 $E $Fy [expr  0.63 +  0.00] 35.90 23.90  0.94 12.00  0.03 2 1 2; Spring_Panel 920400 420409 420410 $E $Fy [expr  0.65 +  0.06] 14.70 23.90  1.03 14.70  0.03 2 1 2; 
Spring_Panel 919100 419109 419110 $E $Fy [expr  0.89 +  1.00] 15.50 25.70  1.44 15.70  0.03 2 1 2; Spring_Panel 919200 419209 419210 $E $Fy [expr  0.77 +  1.00] 36.50 25.70  1.26 12.10  0.03 2 1 2; Spring_Panel 919300 419309 419310 $E $Fy [expr  0.77 +  1.00] 36.50 25.70  1.26 12.10  0.03 2 1 2; Spring_Panel 919400 419409 419410 $E $Fy [expr  0.89 +  1.00] 15.50 25.70  1.44 15.70  0.03 2 1 2; 
Spring_Panel 918100 418109 418110 $E $Fy [expr  0.89 +  1.00] 15.50 25.70  1.44 15.70  0.03 2 1 2; Spring_Panel 918200 418209 418210 $E $Fy [expr  0.77 +  1.00] 36.50 25.70  1.26 12.10  0.03 2 1 2; Spring_Panel 918300 418309 418310 $E $Fy [expr  0.77 +  1.00] 36.50 25.70  1.26 12.10  0.03 2 1 2; Spring_Panel 918400 418409 418410 $E $Fy [expr  0.89 +  1.00] 15.50 25.70  1.44 15.70  0.03 2 1 2; 
Spring_Panel 917100 417109 417110 $E $Fy [expr  1.07 +  0.06] 16.00 25.70  1.72 15.90  0.03 2 1 2; Spring_Panel 917200 417209 417210 $E $Fy [expr  0.87 +  0.81] 37.10 25.70  1.57 12.10  0.03 2 1 2; Spring_Panel 917300 417309 417310 $E $Fy [expr  0.87 +  0.81] 37.10 25.70  1.57 12.10  0.03 2 1 2; Spring_Panel 917400 417409 417410 $E $Fy [expr  1.07 +  0.06] 16.00 25.70  1.72 15.90  0.03 2 1 2; 
Spring_Panel 916100 416109 416110 $E $Fy [expr  1.07 +  0.13] 16.00 33.50  1.72 15.90  0.03 2 1 2; Spring_Panel 916200 416209 416210 $E $Fy [expr  0.87 +  0.31] 37.10 33.50  1.57 12.10  0.03 2 1 2; Spring_Panel 916300 416309 416310 $E $Fy [expr  0.87 +  0.31] 37.10 33.50  1.57 12.10  0.03 2 1 2; Spring_Panel 916400 416409 416410 $E $Fy [expr  1.07 +  0.13] 16.00 33.50  1.72 15.90  0.03 2 1 2; 
Spring_Panel 915100 415109 415110 $E $Fy [expr  1.29 +  0.00] 16.70 33.50  2.07 16.10  0.03 2 1 2; Spring_Panel 915200 415209 415210 $E $Fy [expr  0.84 +  0.38] 36.30 33.50  1.44 16.60  0.03 2 1 2; Spring_Panel 915300 415309 415310 $E $Fy [expr  0.84 +  0.38] 36.30 33.50  1.44 16.60  0.03 2 1 2; Spring_Panel 915400 415409 415410 $E $Fy [expr  1.29 +  0.00] 16.70 33.50  2.07 16.10  0.03 2 1 2; 
Spring_Panel 914100 414109 414110 $E $Fy [expr  1.29 +  0.00] 16.70 33.50  2.07 16.10  0.03 2 1 2; Spring_Panel 914200 414209 414210 $E $Fy [expr  0.84 +  0.38] 36.30 33.50  1.44 16.60  0.03 2 1 2; Spring_Panel 914300 414309 414310 $E $Fy [expr  0.84 +  0.38] 36.30 33.50  1.44 16.60  0.03 2 1 2; Spring_Panel 914400 414409 414410 $E $Fy [expr  1.29 +  0.00] 16.70 33.50  2.07 16.10  0.03 2 1 2; 
Spring_Panel 913100 413109 413110 $E $Fy [expr  1.41 +  0.00] 17.10 33.80  2.26 16.20  0.03 2 1 2; Spring_Panel 913200 413209 413210 $E $Fy [expr  1.02 +  0.25] 37.10 33.80  1.85 16.60  0.03 2 1 2; Spring_Panel 913300 413309 413310 $E $Fy [expr  1.02 +  0.25] 37.10 33.80  1.85 16.60  0.03 2 1 2; Spring_Panel 913400 413409 413410 $E $Fy [expr  1.41 +  0.00] 17.10 33.80  2.26 16.20  0.03 2 1 2; 
Spring_Panel 912100 412109 412110 $E $Fy [expr  1.41 +  0.00] 17.10 33.80  2.26 16.20  0.03 2 1 2; Spring_Panel 912200 412209 412210 $E $Fy [expr  1.02 +  0.25] 37.10 33.80  1.85 16.60  0.03 2 1 2; Spring_Panel 912300 412309 412310 $E $Fy [expr  1.02 +  0.25] 37.10 33.80  1.85 16.60  0.03 2 1 2; Spring_Panel 912400 412409 412410 $E $Fy [expr  1.41 +  0.00] 17.10 33.80  2.26 16.20  0.03 2 1 2; 
Spring_Panel 911100 411109 411110 $E $Fy [expr  1.66 +  0.00] 17.90 33.80  2.66 16.50  0.03 2 1 2; Spring_Panel 911200 411209 411210 $E $Fy [expr  1.12 +  0.13] 37.40 33.80  2.01 16.70  0.03 2 1 2; Spring_Panel 911300 411309 411310 $E $Fy [expr  1.12 +  0.13] 37.40 33.80  2.01 16.70  0.03 2 1 2; Spring_Panel 911400 411409 411410 $E $Fy [expr  1.66 +  0.00] 17.90 33.80  2.66 16.50  0.03 2 1 2; 
Spring_Panel 910100 410109 410110 $E $Fy [expr  1.66 +  0.00] 17.90 33.80  2.66 16.50  0.03 2 1 2; Spring_Panel 910200 410209 410210 $E $Fy [expr  1.12 +  0.13] 37.40 33.80  2.01 16.70  0.03 2 1 2; Spring_Panel 910300 410309 410310 $E $Fy [expr  1.12 +  0.13] 37.40 33.80  2.01 16.70  0.03 2 1 2; Spring_Panel 910400 410409 410410 $E $Fy [expr  1.66 +  0.00] 17.90 33.80  2.66 16.50  0.03 2 1 2; 
Spring_Panel 909100 409109 409110 $E $Fy [expr  1.66 +  0.00] 17.90 33.80  2.66 16.50  0.03 2 1 2; Spring_Panel 909200 409209 409210 $E $Fy [expr  1.22 +  0.00] 37.80 33.80  2.20 16.80  0.03 2 1 2; Spring_Panel 909300 409309 409310 $E $Fy [expr  1.22 +  0.00] 37.80 33.80  2.20 16.80  0.03 2 1 2; Spring_Panel 909400 409409 409410 $E $Fy [expr  1.66 +  0.00] 17.90 33.80  2.66 16.50  0.03 2 1 2; 
Spring_Panel 908100 408109 408110 $E $Fy [expr  1.66 +  0.00] 17.90 33.80  2.66 16.50  0.03 2 1 2; Spring_Panel 908200 408209 408210 $E $Fy [expr  1.22 +  0.00] 37.80 33.80  2.20 16.80  0.03 2 1 2; Spring_Panel 908300 408309 408310 $E $Fy [expr  1.22 +  0.00] 37.80 33.80  2.20 16.80  0.03 2 1 2; Spring_Panel 908400 408409 408410 $E $Fy [expr  1.66 +  0.00] 17.90 33.80  2.66 16.50  0.03 2 1 2; 
Spring_Panel 907100 407109 407110 $E $Fy [expr  2.02 +  0.00] 19.00 33.80  3.21 16.80  0.03 2 1 2; Spring_Panel 907200 407209 407210 $E $Fy [expr  1.36 +  0.00] 38.30 33.80  2.44 17.00  0.03 2 1 2; Spring_Panel 907300 407309 407310 $E $Fy [expr  1.36 +  0.00] 38.30 33.80  2.44 17.00  0.03 2 1 2; Spring_Panel 907400 407409 407410 $E $Fy [expr  2.02 +  0.00] 19.00 33.80  3.21 16.80  0.03 2 1 2; 
Spring_Panel 906100 406109 406110 $E $Fy [expr  2.02 +  0.00] 19.00 33.80  3.21 16.80  0.03 2 1 2; Spring_Panel 906200 406209 406210 $E $Fy [expr  1.36 +  0.00] 38.30 33.80  2.44 17.00  0.03 2 1 2; Spring_Panel 906300 406309 406310 $E $Fy [expr  1.36 +  0.00] 38.30 33.80  2.44 17.00  0.03 2 1 2; Spring_Panel 906400 406409 406410 $E $Fy [expr  2.02 +  0.00] 19.00 33.80  3.21 16.80  0.03 2 1 2; 
Spring_Panel 905100 405109 405110 $E $Fy [expr  2.02 +  0.00] 19.00 33.80  3.21 16.80  0.03 2 1 2; Spring_Panel 905200 405209 405210 $E $Fy [expr  1.50 +  0.00] 39.30 33.80  2.68 17.10  0.03 2 1 2; Spring_Panel 905300 405309 405310 $E $Fy [expr  1.50 +  0.00] 39.30 33.80  2.68 17.10  0.03 2 1 2; Spring_Panel 905400 405409 405410 $E $Fy [expr  2.02 +  0.00] 19.00 33.80  3.21 16.80  0.03 2 1 2; 
Spring_Panel 904100 404109 404110 $E $Fy [expr  2.02 +  0.00] 19.00 33.50  3.21 16.80  0.03 2 1 2; Spring_Panel 904200 404209 404210 $E $Fy [expr  1.50 +  0.00] 39.30 33.50  2.68 17.10  0.03 2 1 2; Spring_Panel 904300 404309 404310 $E $Fy [expr  1.50 +  0.00] 39.30 33.50  2.68 17.10  0.03 2 1 2; Spring_Panel 904400 404409 404410 $E $Fy [expr  2.02 +  0.00] 19.00 33.50  3.21 16.80  0.03 2 1 2; 
Spring_Panel 903100 403109 403110 $E $Fy [expr  2.19 +  0.00] 19.60 33.50  3.50 17.00  0.03 2 1 2; Spring_Panel 903200 403209 403210 $E $Fy [expr  1.61 +  0.00] 39.20 33.50  2.91 17.20  0.03 2 1 2; Spring_Panel 903300 403309 403310 $E $Fy [expr  1.61 +  0.00] 39.20 33.50  2.91 17.20  0.03 2 1 2; Spring_Panel 903400 403409 403410 $E $Fy [expr  2.19 +  0.00] 19.60 33.50  3.50 17.00  0.03 2 1 2; 
Spring_Panel 902100 402109 402110 $E $Fy [expr  2.19 +  0.00] 19.60 33.50  3.50 17.00  0.03 2 1 2; Spring_Panel 902200 402209 402210 $E $Fy [expr  1.61 +  0.00] 39.20 33.50  2.91 17.20  0.03 2 1 2; Spring_Panel 902300 402309 402310 $E $Fy [expr  1.61 +  0.00] 39.20 33.50  2.91 17.20  0.03 2 1 2; Spring_Panel 902400 402409 402410 $E $Fy [expr  2.19 +  0.00] 19.60 33.50  3.50 17.00  0.03 2 1 2; 

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
element ModElasticBeam2d 620100 2013 2111  38.8000 $E [expr ($n+1)/$n*1530.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 620200 2023 2121  44.2000 $E [expr ($n+1)/$n*9040.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 620300 2033 2131  44.2000 $E [expr ($n+1)/$n*9040.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 620400 2043 2141  38.8000 $E [expr ($n+1)/$n*1530.0000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 619102 119170 2011 38.8000 $E [expr ($n+1)/$n*1530.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 619202 119270 2021 44.2000 $E [expr ($n+1)/$n*9040.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 619302 119370 2031 44.2000 $E [expr ($n+1)/$n*9040.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 619402 119470 2041 38.8000 $E [expr ($n+1)/$n*1530.0000] $K33_1 $K11_1 $K44_1 1;  
element ModElasticBeam2d 619101 1913 119170 56.8000 $E [expr ($n+1)/$n*2400.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 619201 1923 119270 57.0000 $E [expr ($n+1)/$n*12100.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 619301 1933 119370 57.0000 $E [expr ($n+1)/$n*12100.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 619401 1943 119470 56.8000 $E [expr ($n+1)/$n*2400.0000] $K33_1 $K11_1 $K44_1 1;  
element ModElasticBeam2d 618100 1813 1911  56.8000 $E [expr ($n+1)/$n*2400.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 618200 1823 1921  57.0000 $E [expr ($n+1)/$n*12100.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 618300 1833 1931  57.0000 $E [expr ($n+1)/$n*12100.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 618400 1843 1941  56.8000 $E [expr ($n+1)/$n*2400.0000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 617102 117170 1811 56.8000 $E [expr ($n+1)/$n*2400.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 617202 117270 1821 57.0000 $E [expr ($n+1)/$n*12100.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 617302 117370 1831 57.0000 $E [expr ($n+1)/$n*12100.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 617402 117470 1841 56.8000 $E [expr ($n+1)/$n*2400.0000] $K33_1 $K11_1 $K44_1 1;  
element ModElasticBeam2d 617101 1713 117170 68.5000 $E [expr ($n+1)/$n*3010.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 617201 1723 117270 68.1000 $E [expr ($n+1)/$n*15000.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 617301 1733 117370 68.1000 $E [expr ($n+1)/$n*15000.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 617401 1743 117470 68.5000 $E [expr ($n+1)/$n*3010.0000] $K33_1 $K11_1 $K44_1 1;  
element ModElasticBeam2d 616100 1613 1711  68.5000 $E [expr ($n+1)/$n*3010.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 616200 1623 1721  68.1000 $E [expr ($n+1)/$n*15000.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 616300 1633 1731  68.1000 $E [expr ($n+1)/$n*15000.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 616400 1643 1741  68.5000 $E [expr ($n+1)/$n*3010.0000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 615102 115170 1611 68.5000 $E [expr ($n+1)/$n*3010.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 615202 115270 1621 68.1000 $E [expr ($n+1)/$n*15000.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 615302 115370 1631 68.1000 $E [expr ($n+1)/$n*15000.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 615402 115470 1641 68.5000 $E [expr ($n+1)/$n*3010.0000] $K33_1 $K11_1 $K44_1 1;  
element ModElasticBeam2d 615101 1513 115170 83.3000 $E [expr ($n+1)/$n*3840.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 615201 1523 115270 76.5000 $E [expr ($n+1)/$n*17300.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 615301 1533 115370 76.5000 $E [expr ($n+1)/$n*17300.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 615401 1543 115470 83.3000 $E [expr ($n+1)/$n*3840.0000] $K33_1 $K11_1 $K44_1 1;  
element ModElasticBeam2d 614100 1413 1511  83.3000 $E [expr ($n+1)/$n*3840.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 614200 1423 1521  76.5000 $E [expr ($n+1)/$n*17300.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 614300 1433 1531  76.5000 $E [expr ($n+1)/$n*17300.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 614400 1443 1541  83.3000 $E [expr ($n+1)/$n*3840.0000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 613102 113170 1411 83.3000 $E [expr ($n+1)/$n*3840.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 613202 113270 1421 76.5000 $E [expr ($n+1)/$n*17300.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 613302 113370 1431 76.5000 $E [expr ($n+1)/$n*17300.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 613402 113470 1441 83.3000 $E [expr ($n+1)/$n*3840.0000] $K33_1 $K11_1 $K44_1 1;  
element ModElasticBeam2d 613101 1313 113170 91.4000 $E [expr ($n+1)/$n*4330.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 613201 1323 113270 96.4000 $E [expr ($n+1)/$n*22500.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 613301 1333 113370 96.4000 $E [expr ($n+1)/$n*22500.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 613401 1343 113470 91.4000 $E [expr ($n+1)/$n*4330.0000] $K33_1 $K11_1 $K44_1 1;  
element ModElasticBeam2d 612100 1213 1311  91.4000 $E [expr ($n+1)/$n*4330.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 612200 1223 1321  96.4000 $E [expr ($n+1)/$n*22500.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 612300 1233 1331  96.4000 $E [expr ($n+1)/$n*22500.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 612400 1243 1341  91.4000 $E [expr ($n+1)/$n*4330.0000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 611102 111170 1211 91.4000 $E [expr ($n+1)/$n*4330.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 611202 111270 1221 96.4000 $E [expr ($n+1)/$n*22500.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 611302 111370 1231 96.4000 $E [expr ($n+1)/$n*22500.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 611402 111470 1241 91.4000 $E [expr ($n+1)/$n*4330.0000] $K33_1 $K11_1 $K44_1 1;  
element ModElasticBeam2d 611101 1113 111170 109.0000 $E [expr ($n+1)/$n*5440.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 611201 1123 111270 105.0000 $E [expr ($n+1)/$n*24800.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 611301 1133 111370 105.0000 $E [expr ($n+1)/$n*24800.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 611401 1143 111470 109.0000 $E [expr ($n+1)/$n*5440.0000] $K33_1 $K11_1 $K44_1 1;  
element ModElasticBeam2d 610100 1013 1111  109.0000 $E [expr ($n+1)/$n*5440.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 610200 1023 1121  105.0000 $E [expr ($n+1)/$n*24800.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 610300 1033 1131  105.0000 $E [expr ($n+1)/$n*24800.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 610400 1043 1141  109.0000 $E [expr ($n+1)/$n*5440.0000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 609102 109170 1011 109.0000 $E [expr ($n+1)/$n*5440.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 609202 109270 1021 105.0000 $E [expr ($n+1)/$n*24800.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 609302 109370 1031 105.0000 $E [expr ($n+1)/$n*24800.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 609402 109470 1041 109.0000 $E [expr ($n+1)/$n*5440.0000] $K33_1 $K11_1 $K44_1 1;  
element ModElasticBeam2d 609101 913 109170 109.0000 $E [expr ($n+1)/$n*5440.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 609201 923 109270 116.0000 $E [expr ($n+1)/$n*27500.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 609301 933 109370 116.0000 $E [expr ($n+1)/$n*27500.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 609401 943 109470 109.0000 $E [expr ($n+1)/$n*5440.0000] $K33_1 $K11_1 $K44_1 1;  
element ModElasticBeam2d 608100 813 911  109.0000 $E [expr ($n+1)/$n*5440.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 608200 823 921  116.0000 $E [expr ($n+1)/$n*27500.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 608300 833 931  116.0000 $E [expr ($n+1)/$n*27500.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 608400 843 941  109.0000 $E [expr ($n+1)/$n*5440.0000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 607102 107170 811 109.0000 $E [expr ($n+1)/$n*5440.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 607202 107270 821 116.0000 $E [expr ($n+1)/$n*27500.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 607302 107370 831 116.0000 $E [expr ($n+1)/$n*27500.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 607402 107470 841 109.0000 $E [expr ($n+1)/$n*5440.0000] $K33_1 $K11_1 $K44_1 1;  
element ModElasticBeam2d 607101 713 107170 134.0000 $E [expr ($n+1)/$n*7190.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 607201 723 107270 129.0000 $E [expr ($n+1)/$n*31000.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 607301 733 107370 129.0000 $E [expr ($n+1)/$n*31000.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 607401 743 107470 134.0000 $E [expr ($n+1)/$n*7190.0000] $K33_1 $K11_1 $K44_1 1;  
element ModElasticBeam2d 606100 613 711  134.0000 $E [expr ($n+1)/$n*7190.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 606200 623 721  129.0000 $E [expr ($n+1)/$n*31000.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 606300 633 731  129.0000 $E [expr ($n+1)/$n*31000.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 606400 643 741  134.0000 $E [expr ($n+1)/$n*7190.0000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 605102 105170 611 134.0000 $E [expr ($n+1)/$n*7190.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 605202 105270 621 129.0000 $E [expr ($n+1)/$n*31000.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 605302 105370 631 129.0000 $E [expr ($n+1)/$n*31000.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 605402 105470 641 134.0000 $E [expr ($n+1)/$n*7190.0000] $K33_1 $K11_1 $K44_1 1;  
element ModElasticBeam2d 605101 513 105170 134.0000 $E [expr ($n+1)/$n*7190.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 605201 523 105270 143.0000 $E [expr ($n+1)/$n*36000.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 605301 533 105370 143.0000 $E [expr ($n+1)/$n*36000.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 605401 543 105470 134.0000 $E [expr ($n+1)/$n*7190.0000] $K33_1 $K11_1 $K44_1 1;  
element ModElasticBeam2d 604100 413 511  134.0000 $E [expr ($n+1)/$n*7190.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 604200 423 521  143.0000 $E [expr ($n+1)/$n*36000.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 604300 433 531  143.0000 $E [expr ($n+1)/$n*36000.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 604400 443 541  134.0000 $E [expr ($n+1)/$n*7190.0000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 603102 103170 411 134.0000 $E [expr ($n+1)/$n*7190.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 603202 103270 421 143.0000 $E [expr ($n+1)/$n*36000.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 603302 103370 431 143.0000 $E [expr ($n+1)/$n*36000.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 603402 103470 441 134.0000 $E [expr ($n+1)/$n*7190.0000] $K33_1 $K11_1 $K44_1 1;  
element ModElasticBeam2d 603101 313 103170 147.0000 $E [expr ($n+1)/$n*8210.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 603201 323 103270 155.0000 $E [expr ($n+1)/$n*38300.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 603301 333 103370 155.0000 $E [expr ($n+1)/$n*38300.0000] $K33_1 $K11_1 $K44_1 1;  element ModElasticBeam2d 603401 343 103470 147.0000 $E [expr ($n+1)/$n*8210.0000] $K33_1 $K11_1 $K44_1 1;  
element ModElasticBeam2d 602100 213 311  147.0000 $E [expr ($n+1)/$n*8210.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 602200 223 321  155.0000 $E [expr ($n+1)/$n*38300.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 602300 233 331  155.0000 $E [expr ($n+1)/$n*38300.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 602400 243 341  147.0000 $E [expr ($n+1)/$n*8210.0000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 601100 113 211  147.0000 $E [expr ($n+1)/$n*8210.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 601200 123 221  155.0000 $E [expr ($n+1)/$n*38300.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 601300 133 231  155.0000 $E [expr ($n+1)/$n*38300.0000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 601400 143 241  147.0000 $E [expr ($n+1)/$n*8210.0000] $K11_2 $K33_2 $K44_2 1; 

# BEAMS
element ModElasticBeam2d 521100 2114 2122  22.400 $E [expr ($n+1)/$n*0.90*$Comp_I*2100.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 521200 2124 2132  22.400 $E [expr ($n+1)/$n*0.90*$Comp_I*2100.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 521300 2134 2142  22.400 $E [expr ($n+1)/$n*0.90*$Comp_I*2100.000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 520100 2014 2022  22.400 $E [expr ($n+1)/$n*0.90*$Comp_I*2100.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 520200 2024 2032  22.400 $E [expr ($n+1)/$n*0.90*$Comp_I*2100.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 520300 2034 2042  22.400 $E [expr ($n+1)/$n*0.90*$Comp_I*2100.000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 519100 1914 1922  60.700 $E [expr ($n+1)/$n*0.90*$Comp_I*6820.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 519200 1924 1932  60.700 $E [expr ($n+1)/$n*0.90*$Comp_I*6820.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 519300 1934 1942  60.700 $E [expr ($n+1)/$n*0.90*$Comp_I*6820.000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 518100 1814 1822  60.700 $E [expr ($n+1)/$n*0.90*$Comp_I*6820.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 518200 1824 1832  60.700 $E [expr ($n+1)/$n*0.90*$Comp_I*6820.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 518300 1834 1842  60.700 $E [expr ($n+1)/$n*0.90*$Comp_I*6820.000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 517100 1714 1722  60.700 $E [expr ($n+1)/$n*0.90*$Comp_I*6820.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 517200 1724 1732  60.700 $E [expr ($n+1)/$n*0.90*$Comp_I*6820.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 517300 1734 1742  60.700 $E [expr ($n+1)/$n*0.90*$Comp_I*6820.000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 516100 1614 1622  44.800 $E [expr ($n+1)/$n*0.90*$Comp_I*8160.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 516200 1624 1632  44.800 $E [expr ($n+1)/$n*0.90*$Comp_I*8160.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 516300 1634 1642  44.800 $E [expr ($n+1)/$n*0.90*$Comp_I*8160.000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 515100 1514 1522  44.800 $E [expr ($n+1)/$n*0.90*$Comp_I*8160.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 515200 1524 1532  44.800 $E [expr ($n+1)/$n*0.90*$Comp_I*8160.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 515300 1534 1542  44.800 $E [expr ($n+1)/$n*0.90*$Comp_I*8160.000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 514100 1414 1422  44.800 $E [expr ($n+1)/$n*0.90*$Comp_I*8160.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 514200 1424 1432  44.800 $E [expr ($n+1)/$n*0.90*$Comp_I*8160.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 514300 1434 1442  44.800 $E [expr ($n+1)/$n*0.90*$Comp_I*8160.000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 513100 1314 1322  49.500 $E [expr ($n+1)/$n*0.90*$Comp_I*9290.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 513200 1324 1332  49.500 $E [expr ($n+1)/$n*0.90*$Comp_I*9290.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 513300 1334 1342  49.500 $E [expr ($n+1)/$n*0.90*$Comp_I*9290.000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 512100 1214 1222  49.500 $E [expr ($n+1)/$n*0.90*$Comp_I*9290.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 512200 1224 1232  49.500 $E [expr ($n+1)/$n*0.90*$Comp_I*9290.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 512300 1234 1242  49.500 $E [expr ($n+1)/$n*0.90*$Comp_I*9290.000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 511100 1114 1122  49.500 $E [expr ($n+1)/$n*0.90*$Comp_I*9290.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 511200 1124 1132  49.500 $E [expr ($n+1)/$n*0.90*$Comp_I*9290.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 511300 1134 1142  49.500 $E [expr ($n+1)/$n*0.90*$Comp_I*9290.000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 510100 1014 1022  49.500 $E [expr ($n+1)/$n*0.90*$Comp_I*9290.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 510200 1024 1032  49.500 $E [expr ($n+1)/$n*0.90*$Comp_I*9290.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 510300 1034 1042  49.500 $E [expr ($n+1)/$n*0.90*$Comp_I*9290.000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 509100 914 922  49.500 $E [expr ($n+1)/$n*0.90*$Comp_I*9290.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 509200 924 932  49.500 $E [expr ($n+1)/$n*0.90*$Comp_I*9290.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 509300 934 942  49.500 $E [expr ($n+1)/$n*0.90*$Comp_I*9290.000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 508100 814 822  49.500 $E [expr ($n+1)/$n*0.90*$Comp_I*9290.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 508200 824 832  49.500 $E [expr ($n+1)/$n*0.90*$Comp_I*9290.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 508300 834 842  49.500 $E [expr ($n+1)/$n*0.90*$Comp_I*9290.000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 507100 714 722  49.500 $E [expr ($n+1)/$n*0.90*$Comp_I*9290.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 507200 724 732  49.500 $E [expr ($n+1)/$n*0.90*$Comp_I*9290.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 507300 734 742  49.500 $E [expr ($n+1)/$n*0.90*$Comp_I*9290.000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 506100 614 622  49.500 $E [expr ($n+1)/$n*0.90*$Comp_I*9290.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 506200 624 632  49.500 $E [expr ($n+1)/$n*0.90*$Comp_I*9290.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 506300 634 642  49.500 $E [expr ($n+1)/$n*0.90*$Comp_I*9290.000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 505100 514 522  49.500 $E [expr ($n+1)/$n*0.90*$Comp_I*9290.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 505200 524 532  49.500 $E [expr ($n+1)/$n*0.90*$Comp_I*9290.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 505300 534 542  49.500 $E [expr ($n+1)/$n*0.90*$Comp_I*9290.000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 504100 414 422  44.800 $E [expr ($n+1)/$n*0.90*$Comp_I*8160.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 504200 424 432  44.800 $E [expr ($n+1)/$n*0.90*$Comp_I*8160.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 504300 434 442  44.800 $E [expr ($n+1)/$n*0.90*$Comp_I*8160.000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 503100 314 322  44.800 $E [expr ($n+1)/$n*0.90*$Comp_I*8160.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 503200 324 332  44.800 $E [expr ($n+1)/$n*0.90*$Comp_I*8160.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 503300 334 342  44.800 $E [expr ($n+1)/$n*0.90*$Comp_I*8160.000] $K11_2 $K33_2 $K44_2 1; 
element ModElasticBeam2d 502100 214 222  44.800 $E [expr ($n+1)/$n*0.90*$Comp_I*8160.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 502200 224 232  44.800 $E [expr ($n+1)/$n*0.90*$Comp_I*8160.000] $K11_2 $K33_2 $K44_2 1; element ModElasticBeam2d 502300 234 242  44.800 $E [expr ($n+1)/$n*0.90*$Comp_I*8160.000] $K11_2 $K33_2 $K44_2 1; 

####################################################################################################
#                                      ELASTIC RBS ELEMENTS                                        #
####################################################################################################

element elasticBeamColumn 521104 421104 21140 19.343 $E [expr 1.0*1687.877] 1; element elasticBeamColumn 521202 421202 21220 19.343 $E [expr 1.0*1687.877] 1; element elasticBeamColumn 521204 421204 21240 19.343 $E [expr 1.0*1687.877] 1; element elasticBeamColumn 521302 421302 21320 19.343 $E [expr 1.0*1687.877] 1; element elasticBeamColumn 521304 421304 21340 19.343 $E [expr 1.0*1687.877] 1; element elasticBeamColumn 521402 421402 21420 19.343 $E [expr 1.0*1687.877] 1; 
element elasticBeamColumn 520104 420104 20140 19.343 $E [expr 1.0*1687.877] 1; element elasticBeamColumn 520202 420202 20220 19.343 $E [expr 1.0*1687.877] 1; element elasticBeamColumn 520204 420204 20240 19.343 $E [expr 1.0*1687.877] 1; element elasticBeamColumn 520302 420302 20320 19.343 $E [expr 1.0*1687.877] 1; element elasticBeamColumn 520304 420304 20340 19.343 $E [expr 1.0*1687.877] 1; element elasticBeamColumn 520402 420402 20420 19.343 $E [expr 1.0*1687.877] 1; 
element elasticBeamColumn 519104 419104 19140 50.495 $E [expr 1.0*5332.421] 1; element elasticBeamColumn 519202 419202 19220 50.495 $E [expr 1.0*5332.421] 1; element elasticBeamColumn 519204 419204 19240 50.495 $E [expr 1.0*5332.421] 1; element elasticBeamColumn 519302 419302 19320 50.495 $E [expr 1.0*5332.421] 1; element elasticBeamColumn 519304 419304 19340 50.495 $E [expr 1.0*5332.421] 1; element elasticBeamColumn 519402 419402 19420 50.495 $E [expr 1.0*5332.421] 1; 
element elasticBeamColumn 518104 418104 18140 50.495 $E [expr 1.0*5332.421] 1; element elasticBeamColumn 518202 418202 18220 50.495 $E [expr 1.0*5332.421] 1; element elasticBeamColumn 518204 418204 18240 50.495 $E [expr 1.0*5332.421] 1; element elasticBeamColumn 518302 418302 18320 50.495 $E [expr 1.0*5332.421] 1; element elasticBeamColumn 518304 418304 18340 50.495 $E [expr 1.0*5332.421] 1; element elasticBeamColumn 518402 418402 18420 50.495 $E [expr 1.0*5332.421] 1; 
element elasticBeamColumn 517104 417104 17140 50.495 $E [expr 1.0*5332.421] 1; element elasticBeamColumn 517202 417202 17220 50.495 $E [expr 1.0*5332.421] 1; element elasticBeamColumn 517204 417204 17240 50.495 $E [expr 1.0*5332.421] 1; element elasticBeamColumn 517302 417302 17320 50.495 $E [expr 1.0*5332.421] 1; element elasticBeamColumn 517304 417304 17340 50.495 $E [expr 1.0*5332.421] 1; element elasticBeamColumn 517402 417402 17420 50.495 $E [expr 1.0*5332.421] 1; 
element elasticBeamColumn 516104 416104 16140 38.652 $E [expr 1.0*6541.957] 1; element elasticBeamColumn 516202 416202 16220 38.652 $E [expr 1.0*6541.957] 1; element elasticBeamColumn 516204 416204 16240 38.652 $E [expr 1.0*6541.957] 1; element elasticBeamColumn 516302 416302 16320 38.652 $E [expr 1.0*6541.957] 1; element elasticBeamColumn 516304 416304 16340 38.652 $E [expr 1.0*6541.957] 1; element elasticBeamColumn 516402 416402 16420 38.652 $E [expr 1.0*6541.957] 1; 
element elasticBeamColumn 515104 415104 15140 38.652 $E [expr 1.0*6541.957] 1; element elasticBeamColumn 515202 415202 15220 38.652 $E [expr 1.0*6541.957] 1; element elasticBeamColumn 515204 415204 15240 38.652 $E [expr 1.0*6541.957] 1; element elasticBeamColumn 515302 415302 15320 38.652 $E [expr 1.0*6541.957] 1; element elasticBeamColumn 515304 415304 15340 38.652 $E [expr 1.0*6541.957] 1; element elasticBeamColumn 515402 415402 15420 38.652 $E [expr 1.0*6541.957] 1; 
element elasticBeamColumn 514104 414104 14140 38.652 $E [expr 1.0*6541.957] 1; element elasticBeamColumn 514202 414202 14220 38.652 $E [expr 1.0*6541.957] 1; element elasticBeamColumn 514204 414204 14240 38.652 $E [expr 1.0*6541.957] 1; element elasticBeamColumn 514302 414302 14320 38.652 $E [expr 1.0*6541.957] 1; element elasticBeamColumn 514304 414304 14340 38.652 $E [expr 1.0*6541.957] 1; element elasticBeamColumn 514402 414402 14420 38.652 $E [expr 1.0*6541.957] 1; 
element elasticBeamColumn 513104 413104 13140 42.485 $E [expr 1.0*7427.601] 1; element elasticBeamColumn 513202 413202 13220 42.485 $E [expr 1.0*7427.601] 1; element elasticBeamColumn 513204 413204 13240 42.485 $E [expr 1.0*7427.601] 1; element elasticBeamColumn 513302 413302 13320 42.485 $E [expr 1.0*7427.601] 1; element elasticBeamColumn 513304 413304 13340 42.485 $E [expr 1.0*7427.601] 1; element elasticBeamColumn 513402 413402 13420 42.485 $E [expr 1.0*7427.601] 1; 
element elasticBeamColumn 512104 412104 12140 42.485 $E [expr 1.0*7427.601] 1; element elasticBeamColumn 512202 412202 12220 42.485 $E [expr 1.0*7427.601] 1; element elasticBeamColumn 512204 412204 12240 42.485 $E [expr 1.0*7427.601] 1; element elasticBeamColumn 512302 412302 12320 42.485 $E [expr 1.0*7427.601] 1; element elasticBeamColumn 512304 412304 12340 42.485 $E [expr 1.0*7427.601] 1; element elasticBeamColumn 512402 412402 12420 42.485 $E [expr 1.0*7427.601] 1; 
element elasticBeamColumn 511104 411104 11140 42.485 $E [expr 1.0*7427.601] 1; element elasticBeamColumn 511202 411202 11220 42.485 $E [expr 1.0*7427.601] 1; element elasticBeamColumn 511204 411204 11240 42.485 $E [expr 1.0*7427.601] 1; element elasticBeamColumn 511302 411302 11320 42.485 $E [expr 1.0*7427.601] 1; element elasticBeamColumn 511304 411304 11340 42.485 $E [expr 1.0*7427.601] 1; element elasticBeamColumn 511402 411402 11420 42.485 $E [expr 1.0*7427.601] 1; 
element elasticBeamColumn 510104 410104 10140 42.485 $E [expr 1.0*7427.601] 1; element elasticBeamColumn 510202 410202 10220 42.485 $E [expr 1.0*7427.601] 1; element elasticBeamColumn 510204 410204 10240 42.485 $E [expr 1.0*7427.601] 1; element elasticBeamColumn 510302 410302 10320 42.485 $E [expr 1.0*7427.601] 1; element elasticBeamColumn 510304 410304 10340 42.485 $E [expr 1.0*7427.601] 1; element elasticBeamColumn 510402 410402 10420 42.485 $E [expr 1.0*7427.601] 1; 
element elasticBeamColumn 509104 409104 9140 42.485 $E [expr 1.0*7427.601] 1; element elasticBeamColumn 509202 409202 9220 42.485 $E [expr 1.0*7427.601] 1; element elasticBeamColumn 509204 409204 9240 42.485 $E [expr 1.0*7427.601] 1; element elasticBeamColumn 509302 409302 9320 42.485 $E [expr 1.0*7427.601] 1; element elasticBeamColumn 509304 409304 9340 42.485 $E [expr 1.0*7427.601] 1; element elasticBeamColumn 509402 409402 9420 42.485 $E [expr 1.0*7427.601] 1; 
element elasticBeamColumn 508104 408104 8140 42.485 $E [expr 1.0*7427.601] 1; element elasticBeamColumn 508202 408202 8220 42.485 $E [expr 1.0*7427.601] 1; element elasticBeamColumn 508204 408204 8240 42.485 $E [expr 1.0*7427.601] 1; element elasticBeamColumn 508302 408302 8320 42.485 $E [expr 1.0*7427.601] 1; element elasticBeamColumn 508304 408304 8340 42.485 $E [expr 1.0*7427.601] 1; element elasticBeamColumn 508402 408402 8420 42.485 $E [expr 1.0*7427.601] 1; 
element elasticBeamColumn 507104 407104 7140 42.485 $E [expr 1.0*7427.601] 1; element elasticBeamColumn 507202 407202 7220 42.485 $E [expr 1.0*7427.601] 1; element elasticBeamColumn 507204 407204 7240 42.485 $E [expr 1.0*7427.601] 1; element elasticBeamColumn 507302 407302 7320 42.485 $E [expr 1.0*7427.601] 1; element elasticBeamColumn 507304 407304 7340 42.485 $E [expr 1.0*7427.601] 1; element elasticBeamColumn 507402 407402 7420 42.485 $E [expr 1.0*7427.601] 1; 
element elasticBeamColumn 506104 406104 6140 42.485 $E [expr 1.0*7427.601] 1; element elasticBeamColumn 506202 406202 6220 42.485 $E [expr 1.0*7427.601] 1; element elasticBeamColumn 506204 406204 6240 42.485 $E [expr 1.0*7427.601] 1; element elasticBeamColumn 506302 406302 6320 42.485 $E [expr 1.0*7427.601] 1; element elasticBeamColumn 506304 406304 6340 42.485 $E [expr 1.0*7427.601] 1; element elasticBeamColumn 506402 406402 6420 42.485 $E [expr 1.0*7427.601] 1; 
element elasticBeamColumn 505104 405104 5140 42.485 $E [expr 1.0*7427.601] 1; element elasticBeamColumn 505202 405202 5220 42.485 $E [expr 1.0*7427.601] 1; element elasticBeamColumn 505204 405204 5240 42.485 $E [expr 1.0*7427.601] 1; element elasticBeamColumn 505302 405302 5320 42.485 $E [expr 1.0*7427.601] 1; element elasticBeamColumn 505304 405304 5340 42.485 $E [expr 1.0*7427.601] 1; element elasticBeamColumn 505402 405402 5420 42.485 $E [expr 1.0*7427.601] 1; 
element elasticBeamColumn 504104 404104 4140 38.652 $E [expr 1.0*6541.957] 1; element elasticBeamColumn 504202 404202 4220 38.652 $E [expr 1.0*6541.957] 1; element elasticBeamColumn 504204 404204 4240 38.652 $E [expr 1.0*6541.957] 1; element elasticBeamColumn 504302 404302 4320 38.652 $E [expr 1.0*6541.957] 1; element elasticBeamColumn 504304 404304 4340 38.652 $E [expr 1.0*6541.957] 1; element elasticBeamColumn 504402 404402 4420 38.652 $E [expr 1.0*6541.957] 1; 
element elasticBeamColumn 503104 403104 3140 38.652 $E [expr 1.0*6541.957] 1; element elasticBeamColumn 503202 403202 3220 38.652 $E [expr 1.0*6541.957] 1; element elasticBeamColumn 503204 403204 3240 38.652 $E [expr 1.0*6541.957] 1; element elasticBeamColumn 503302 403302 3320 38.652 $E [expr 1.0*6541.957] 1; element elasticBeamColumn 503304 403304 3340 38.652 $E [expr 1.0*6541.957] 1; element elasticBeamColumn 503402 403402 3420 38.652 $E [expr 1.0*6541.957] 1; 
element elasticBeamColumn 502104 402104 2140 38.652 $E [expr 1.0*6541.957] 1; element elasticBeamColumn 502202 402202 2220 38.652 $E [expr 1.0*6541.957] 1; element elasticBeamColumn 502204 402204 2240 38.652 $E [expr 1.0*6541.957] 1; element elasticBeamColumn 502302 402302 2320 38.652 $E [expr 1.0*6541.957] 1; element elasticBeamColumn 502304 402304 2340 38.652 $E [expr 1.0*6541.957] 1; element elasticBeamColumn 502402 402402 2420 38.652 $E [expr 1.0*6541.957] 1; 

###################################################################################################
#                                 COLUMN AND BEAM PLASTIC SPRINGS                                 #
###################################################################################################

# Command Syntax; 
# Spring_IMK SpringID iNode jNode E Fy Ix d tw bf tf htw bftf ry L Ls Lb My PgPye CompositeFLAG MRFconnection Units; 

# BEAM SPRINGS
Spring_IMK 921104 2114  21140 $E $Fy [expr $Comp_I*1275.753] 23.900 0.440 8.990 0.680 49.000 6.610 1.920 185.538 107.350 92.769 9821.997 0.0 $Composite 0 2; Spring_IMK 921202 21220 2122  $E $Fy [expr $Comp_I*1275.753] 23.900 0.440 8.990 0.680 49.000 6.610 1.920 185.538 107.350 92.769 9821.997 0.0 $Composite 0 2; Spring_IMK 921204 2124  21240 $E $Fy [expr $Comp_I*1275.753] 23.900 0.440 8.990 0.680 49.000 6.610 1.920 185.538 107.350 92.769 9821.997 0.0 $Composite 0 2; Spring_IMK 921302 21320 2132  $E $Fy [expr $Comp_I*1275.753] 23.900 0.440 8.990 0.680 49.000 6.610 1.920 174.938 102.050 87.469 9821.997 0.0 $Composite 0 2; Spring_IMK 921304 2134  21340 $E $Fy [expr $Comp_I*1275.753] 23.900 0.440 8.990 0.680 49.000 6.610 1.920 174.938 102.050 87.469 9821.997 0.0 $Composite 0 2; Spring_IMK 921402 21420 2142  $E $Fy [expr $Comp_I*1275.753] 23.900 0.440 8.990 0.680 49.000 6.610 1.920 185.538 107.350 92.769 9821.997 0.0 $Composite 0 2; 
Spring_IMK 920104 2014  20140 $E $Fy [expr $Comp_I*1275.753] 23.900 0.440 8.990 0.680 49.000 6.610 1.920 184.838 107.000 92.419 9821.997 0.0 $Composite 0 2; Spring_IMK 920202 20220 2022  $E $Fy [expr $Comp_I*1275.753] 23.900 0.440 8.990 0.680 49.000 6.610 1.920 184.838 107.000 92.419 9821.997 0.0 $Composite 0 2; Spring_IMK 920204 2024  20240 $E $Fy [expr $Comp_I*1275.753] 23.900 0.440 8.990 0.680 49.000 6.610 1.920 184.838 107.000 92.419 9821.997 0.0 $Composite 0 2; Spring_IMK 920302 20320 2032  $E $Fy [expr $Comp_I*1275.753] 23.900 0.440 8.990 0.680 49.000 6.610 1.920 174.338 101.750 87.169 9821.997 0.0 $Composite 0 2; Spring_IMK 920304 2034  20340 $E $Fy [expr $Comp_I*1275.753] 23.900 0.440 8.990 0.680 49.000 6.610 1.920 174.338 101.750 87.169 9821.997 0.0 $Composite 0 2; Spring_IMK 920402 20420 2042  $E $Fy [expr $Comp_I*1275.753] 23.900 0.440 8.990 0.680 49.000 6.610 1.920 184.838 107.000 92.419 9821.997 0.0 $Composite 0 2; 
Spring_IMK 919104 1914  19140 $E $Fy [expr $Comp_I*3844.842] 25.700 0.870 13.000 1.570 24.800 4.140 3.080 178.475 107.000 89.237 29044.077 0.0 $Composite 0 2; Spring_IMK 919202 19220 1922  $E $Fy [expr $Comp_I*3844.842] 25.700 0.870 13.000 1.570 24.800 4.140 3.080 178.475 107.000 89.237 29044.077 0.0 $Composite 0 2; Spring_IMK 919204 1924  19240 $E $Fy [expr $Comp_I*3844.842] 25.700 0.870 13.000 1.570 24.800 4.140 3.080 178.475 107.000 89.237 29044.077 0.0 $Composite 0 2; Spring_IMK 919302 19320 1932  $E $Fy [expr $Comp_I*3844.842] 25.700 0.870 13.000 1.570 24.800 4.140 3.080 167.975 101.750 83.987 29044.077 0.0 $Composite 0 2; Spring_IMK 919304 1934  19340 $E $Fy [expr $Comp_I*3844.842] 25.700 0.870 13.000 1.570 24.800 4.140 3.080 167.975 101.750 83.987 29044.077 0.0 $Composite 0 2; Spring_IMK 919402 19420 1942  $E $Fy [expr $Comp_I*3844.842] 25.700 0.870 13.000 1.570 24.800 4.140 3.080 178.475 107.000 89.237 29044.077 0.0 $Composite 0 2; 
Spring_IMK 918104 1814  18140 $E $Fy [expr $Comp_I*3844.842] 25.700 0.870 13.000 1.570 24.800 4.140 3.080 177.925 106.725 88.962 29044.077 0.0 $Composite 0 2; Spring_IMK 918202 18220 1822  $E $Fy [expr $Comp_I*3844.842] 25.700 0.870 13.000 1.570 24.800 4.140 3.080 177.925 106.725 88.962 29044.077 0.0 $Composite 0 2; Spring_IMK 918204 1824  18240 $E $Fy [expr $Comp_I*3844.842] 25.700 0.870 13.000 1.570 24.800 4.140 3.080 177.925 106.725 88.962 29044.077 0.0 $Composite 0 2; Spring_IMK 918302 18320 1832  $E $Fy [expr $Comp_I*3844.842] 25.700 0.870 13.000 1.570 24.800 4.140 3.080 167.375 101.450 83.687 29044.077 0.0 $Composite 0 2; Spring_IMK 918304 1834  18340 $E $Fy [expr $Comp_I*3844.842] 25.700 0.870 13.000 1.570 24.800 4.140 3.080 167.375 101.450 83.687 29044.077 0.0 $Composite 0 2; Spring_IMK 918402 18420 1842  $E $Fy [expr $Comp_I*3844.842] 25.700 0.870 13.000 1.570 24.800 4.140 3.080 177.925 106.725 88.962 29044.077 0.0 $Composite 0 2; 
Spring_IMK 917104 1714  17140 $E $Fy [expr $Comp_I*3844.842] 25.700 0.870 13.000 1.570 24.800 4.140 3.080 177.925 106.725 88.962 29044.077 0.0 $Composite 0 2; Spring_IMK 917202 17220 1722  $E $Fy [expr $Comp_I*3844.842] 25.700 0.870 13.000 1.570 24.800 4.140 3.080 177.925 106.725 88.962 29044.077 0.0 $Composite 0 2; Spring_IMK 917204 1724  17240 $E $Fy [expr $Comp_I*3844.842] 25.700 0.870 13.000 1.570 24.800 4.140 3.080 177.925 106.725 88.962 29044.077 0.0 $Composite 0 2; Spring_IMK 917302 17320 1732  $E $Fy [expr $Comp_I*3844.842] 25.700 0.870 13.000 1.570 24.800 4.140 3.080 167.375 101.450 83.687 29044.077 0.0 $Composite 0 2; Spring_IMK 917304 1734  17340 $E $Fy [expr $Comp_I*3844.842] 25.700 0.870 13.000 1.570 24.800 4.140 3.080 167.375 101.450 83.687 29044.077 0.0 $Composite 0 2; Spring_IMK 917402 17420 1742  $E $Fy [expr $Comp_I*3844.842] 25.700 0.870 13.000 1.570 24.800 4.140 3.080 177.925 106.725 88.962 29044.077 0.0 $Composite 0 2; 
Spring_IMK 916104 1614  16140 $E $Fy [expr $Comp_I*4923.914] 33.500 0.635 11.600 1.060 47.200 5.480 2.470 173.875 106.750 86.938 27556.752 0.0 $Composite 0 2; Spring_IMK 916202 16220 1622  $E $Fy [expr $Comp_I*4923.914] 33.500 0.635 11.600 1.060 47.200 5.480 2.470 173.875 106.750 86.938 27556.752 0.0 $Composite 0 2; Spring_IMK 916204 1624  16240 $E $Fy [expr $Comp_I*4923.914] 33.500 0.635 11.600 1.060 47.200 5.480 2.470 173.875 106.750 86.938 27556.752 0.0 $Composite 0 2; Spring_IMK 916302 16320 1632  $E $Fy [expr $Comp_I*4923.914] 33.500 0.635 11.600 1.060 47.200 5.480 2.470 164.075 101.850 82.037 27556.752 0.0 $Composite 0 2; Spring_IMK 916304 1634  16340 $E $Fy [expr $Comp_I*4923.914] 33.500 0.635 11.600 1.060 47.200 5.480 2.470 164.075 101.850 82.037 27556.752 0.0 $Composite 0 2; Spring_IMK 916402 16420 1642  $E $Fy [expr $Comp_I*4923.914] 33.500 0.635 11.600 1.060 47.200 5.480 2.470 173.875 106.750 86.938 27556.752 0.0 $Composite 0 2; 
Spring_IMK 915104 1514  15140 $E $Fy [expr $Comp_I*4923.914] 33.500 0.635 11.600 1.060 47.200 5.480 2.470 173.875 106.750 86.938 27556.752 0.0 $Composite 0 2; Spring_IMK 915202 15220 1522  $E $Fy [expr $Comp_I*4923.914] 33.500 0.635 11.600 1.060 47.200 5.480 2.470 173.875 106.750 86.938 27556.752 0.0 $Composite 0 2; Spring_IMK 915204 1524  15240 $E $Fy [expr $Comp_I*4923.914] 33.500 0.635 11.600 1.060 47.200 5.480 2.470 173.875 106.750 86.938 27556.752 0.0 $Composite 0 2; Spring_IMK 915302 15320 1532  $E $Fy [expr $Comp_I*4923.914] 33.500 0.635 11.600 1.060 47.200 5.480 2.470 164.075 101.850 82.037 27556.752 0.0 $Composite 0 2; Spring_IMK 915304 1534  15340 $E $Fy [expr $Comp_I*4923.914] 33.500 0.635 11.600 1.060 47.200 5.480 2.470 164.075 101.850 82.037 27556.752 0.0 $Composite 0 2; Spring_IMK 915402 15420 1542  $E $Fy [expr $Comp_I*4923.914] 33.500 0.635 11.600 1.060 47.200 5.480 2.470 173.875 106.750 86.938 27556.752 0.0 $Composite 0 2; 
Spring_IMK 914104 1414  14140 $E $Fy [expr $Comp_I*4923.914] 33.500 0.635 11.600 1.060 47.200 5.480 2.470 173.275 106.450 86.637 27556.752 0.0 $Composite 0 2; Spring_IMK 914202 14220 1422  $E $Fy [expr $Comp_I*4923.914] 33.500 0.635 11.600 1.060 47.200 5.480 2.470 173.275 106.450 86.637 27556.752 0.0 $Composite 0 2; Spring_IMK 914204 1424  14240 $E $Fy [expr $Comp_I*4923.914] 33.500 0.635 11.600 1.060 47.200 5.480 2.470 173.275 106.450 86.637 27556.752 0.0 $Composite 0 2; Spring_IMK 914302 14320 1432  $E $Fy [expr $Comp_I*4923.914] 33.500 0.635 11.600 1.060 47.200 5.480 2.470 163.275 101.450 81.637 27556.752 0.0 $Composite 0 2; Spring_IMK 914304 1434  14340 $E $Fy [expr $Comp_I*4923.914] 33.500 0.635 11.600 1.060 47.200 5.480 2.470 163.275 101.450 81.637 27556.752 0.0 $Composite 0 2; Spring_IMK 914402 14420 1442  $E $Fy [expr $Comp_I*4923.914] 33.500 0.635 11.600 1.060 47.200 5.480 2.470 173.275 106.450 86.637 27556.752 0.0 $Composite 0 2; 
Spring_IMK 913104 1314  13140 $E $Fy [expr $Comp_I*5565.201] 33.800 0.670 11.500 1.220 44.700 4.710 2.500 173.175 106.450 86.587 30706.827 0.0 $Composite 0 2; Spring_IMK 913202 13220 1322  $E $Fy [expr $Comp_I*5565.201] 33.800 0.670 11.500 1.220 44.700 4.710 2.500 173.175 106.450 86.587 30706.827 0.0 $Composite 0 2; Spring_IMK 913204 1324  13240 $E $Fy [expr $Comp_I*5565.201] 33.800 0.670 11.500 1.220 44.700 4.710 2.500 173.175 106.450 86.587 30706.827 0.0 $Composite 0 2; Spring_IMK 913302 13320 1332  $E $Fy [expr $Comp_I*5565.201] 33.800 0.670 11.500 1.220 44.700 4.710 2.500 163.175 101.450 81.587 30706.827 0.0 $Composite 0 2; Spring_IMK 913304 1334  13340 $E $Fy [expr $Comp_I*5565.201] 33.800 0.670 11.500 1.220 44.700 4.710 2.500 163.175 101.450 81.587 30706.827 0.0 $Composite 0 2; Spring_IMK 913402 13420 1342  $E $Fy [expr $Comp_I*5565.201] 33.800 0.670 11.500 1.220 44.700 4.710 2.500 173.175 106.450 86.587 30706.827 0.0 $Composite 0 2; 
Spring_IMK 912104 1214  12140 $E $Fy [expr $Comp_I*5565.201] 33.800 0.670 11.500 1.220 44.700 4.710 2.500 172.625 106.175 86.313 30706.827 0.0 $Composite 0 2; Spring_IMK 912202 12220 1222  $E $Fy [expr $Comp_I*5565.201] 33.800 0.670 11.500 1.220 44.700 4.710 2.500 172.625 106.175 86.313 30706.827 0.0 $Composite 0 2; Spring_IMK 912204 1224  12240 $E $Fy [expr $Comp_I*5565.201] 33.800 0.670 11.500 1.220 44.700 4.710 2.500 172.625 106.175 86.313 30706.827 0.0 $Composite 0 2; Spring_IMK 912302 12320 1232  $E $Fy [expr $Comp_I*5565.201] 33.800 0.670 11.500 1.220 44.700 4.710 2.500 162.875 101.300 81.438 30706.827 0.0 $Composite 0 2; Spring_IMK 912304 1234  12340 $E $Fy [expr $Comp_I*5565.201] 33.800 0.670 11.500 1.220 44.700 4.710 2.500 162.875 101.300 81.438 30706.827 0.0 $Composite 0 2; Spring_IMK 912402 12420 1242  $E $Fy [expr $Comp_I*5565.201] 33.800 0.670 11.500 1.220 44.700 4.710 2.500 172.625 106.175 86.313 30706.827 0.0 $Composite 0 2; 
Spring_IMK 911104 1114  11140 $E $Fy [expr $Comp_I*5565.201] 33.800 0.670 11.500 1.220 44.700 4.710 2.500 172.625 106.175 86.313 30706.827 0.0 $Composite 0 2; Spring_IMK 911202 11220 1122  $E $Fy [expr $Comp_I*5565.201] 33.800 0.670 11.500 1.220 44.700 4.710 2.500 172.625 106.175 86.313 30706.827 0.0 $Composite 0 2; Spring_IMK 911204 1124  11240 $E $Fy [expr $Comp_I*5565.201] 33.800 0.670 11.500 1.220 44.700 4.710 2.500 172.625 106.175 86.313 30706.827 0.0 $Composite 0 2; Spring_IMK 911302 11320 1132  $E $Fy [expr $Comp_I*5565.201] 33.800 0.670 11.500 1.220 44.700 4.710 2.500 162.875 101.300 81.438 30706.827 0.0 $Composite 0 2; Spring_IMK 911304 1134  11340 $E $Fy [expr $Comp_I*5565.201] 33.800 0.670 11.500 1.220 44.700 4.710 2.500 162.875 101.300 81.438 30706.827 0.0 $Composite 0 2; Spring_IMK 911402 11420 1142  $E $Fy [expr $Comp_I*5565.201] 33.800 0.670 11.500 1.220 44.700 4.710 2.500 172.625 106.175 86.313 30706.827 0.0 $Composite 0 2; 
Spring_IMK 910104 1014  10140 $E $Fy [expr $Comp_I*5565.201] 33.800 0.670 11.500 1.220 44.700 4.710 2.500 172.425 106.075 86.213 30706.827 0.0 $Composite 0 2; Spring_IMK 910202 10220 1022  $E $Fy [expr $Comp_I*5565.201] 33.800 0.670 11.500 1.220 44.700 4.710 2.500 172.425 106.075 86.213 30706.827 0.0 $Composite 0 2; Spring_IMK 910204 1024  10240 $E $Fy [expr $Comp_I*5565.201] 33.800 0.670 11.500 1.220 44.700 4.710 2.500 172.425 106.075 86.213 30706.827 0.0 $Composite 0 2; Spring_IMK 910302 10320 1032  $E $Fy [expr $Comp_I*5565.201] 33.800 0.670 11.500 1.220 44.700 4.710 2.500 162.475 101.100 81.237 30706.827 0.0 $Composite 0 2; Spring_IMK 910304 1034  10340 $E $Fy [expr $Comp_I*5565.201] 33.800 0.670 11.500 1.220 44.700 4.710 2.500 162.475 101.100 81.237 30706.827 0.0 $Composite 0 2; Spring_IMK 910402 10420 1042  $E $Fy [expr $Comp_I*5565.201] 33.800 0.670 11.500 1.220 44.700 4.710 2.500 172.425 106.075 86.213 30706.827 0.0 $Composite 0 2; 
Spring_IMK 909104 914  9140 $E $Fy [expr $Comp_I*5565.201] 33.800 0.670 11.500 1.220 44.700 4.710 2.500 172.425 106.075 86.213 30706.827 0.0 $Composite 0 2; Spring_IMK 909202 9220 922  $E $Fy [expr $Comp_I*5565.201] 33.800 0.670 11.500 1.220 44.700 4.710 2.500 172.425 106.075 86.213 30706.827 0.0 $Composite 0 2; Spring_IMK 909204 924  9240 $E $Fy [expr $Comp_I*5565.201] 33.800 0.670 11.500 1.220 44.700 4.710 2.500 172.425 106.075 86.213 30706.827 0.0 $Composite 0 2; Spring_IMK 909302 9320 932  $E $Fy [expr $Comp_I*5565.201] 33.800 0.670 11.500 1.220 44.700 4.710 2.500 162.475 101.100 81.237 30706.827 0.0 $Composite 0 2; Spring_IMK 909304 934  9340 $E $Fy [expr $Comp_I*5565.201] 33.800 0.670 11.500 1.220 44.700 4.710 2.500 162.475 101.100 81.237 30706.827 0.0 $Composite 0 2; Spring_IMK 909402 9420 942  $E $Fy [expr $Comp_I*5565.201] 33.800 0.670 11.500 1.220 44.700 4.710 2.500 172.425 106.075 86.213 30706.827 0.0 $Composite 0 2; 
Spring_IMK 908104 814  8140 $E $Fy [expr $Comp_I*5565.201] 33.800 0.670 11.500 1.220 44.700 4.710 2.500 171.625 105.675 85.813 30706.827 0.0 $Composite 0 2; Spring_IMK 908202 8220 822  $E $Fy [expr $Comp_I*5565.201] 33.800 0.670 11.500 1.220 44.700 4.710 2.500 171.625 105.675 85.813 30706.827 0.0 $Composite 0 2; Spring_IMK 908204 824  8240 $E $Fy [expr $Comp_I*5565.201] 33.800 0.670 11.500 1.220 44.700 4.710 2.500 171.625 105.675 85.813 30706.827 0.0 $Composite 0 2; Spring_IMK 908302 8320 832  $E $Fy [expr $Comp_I*5565.201] 33.800 0.670 11.500 1.220 44.700 4.710 2.500 161.975 100.850 80.987 30706.827 0.0 $Composite 0 2; Spring_IMK 908304 834  8340 $E $Fy [expr $Comp_I*5565.201] 33.800 0.670 11.500 1.220 44.700 4.710 2.500 161.975 100.850 80.987 30706.827 0.0 $Composite 0 2; Spring_IMK 908402 8420 842  $E $Fy [expr $Comp_I*5565.201] 33.800 0.670 11.500 1.220 44.700 4.710 2.500 171.625 105.675 85.813 30706.827 0.0 $Composite 0 2; 
Spring_IMK 907104 714  7140 $E $Fy [expr $Comp_I*5565.201] 33.800 0.670 11.500 1.220 44.700 4.710 2.500 171.625 105.675 85.813 30706.827 0.0 $Composite 0 2; Spring_IMK 907202 7220 722  $E $Fy [expr $Comp_I*5565.201] 33.800 0.670 11.500 1.220 44.700 4.710 2.500 171.625 105.675 85.813 30706.827 0.0 $Composite 0 2; Spring_IMK 907204 724  7240 $E $Fy [expr $Comp_I*5565.201] 33.800 0.670 11.500 1.220 44.700 4.710 2.500 171.625 105.675 85.813 30706.827 0.0 $Composite 0 2; Spring_IMK 907302 7320 732  $E $Fy [expr $Comp_I*5565.201] 33.800 0.670 11.500 1.220 44.700 4.710 2.500 161.975 100.850 80.987 30706.827 0.0 $Composite 0 2; Spring_IMK 907304 734  7340 $E $Fy [expr $Comp_I*5565.201] 33.800 0.670 11.500 1.220 44.700 4.710 2.500 161.975 100.850 80.987 30706.827 0.0 $Composite 0 2; Spring_IMK 907402 7420 742  $E $Fy [expr $Comp_I*5565.201] 33.800 0.670 11.500 1.220 44.700 4.710 2.500 171.625 105.675 85.813 30706.827 0.0 $Composite 0 2; 
Spring_IMK 906104 614  6140 $E $Fy [expr $Comp_I*5565.201] 33.800 0.670 11.500 1.220 44.700 4.710 2.500 171.125 105.425 85.563 30706.827 0.0 $Composite 0 2; Spring_IMK 906202 6220 622  $E $Fy [expr $Comp_I*5565.201] 33.800 0.670 11.500 1.220 44.700 4.710 2.500 171.125 105.425 85.563 30706.827 0.0 $Composite 0 2; Spring_IMK 906204 624  6240 $E $Fy [expr $Comp_I*5565.201] 33.800 0.670 11.500 1.220 44.700 4.710 2.500 171.125 105.425 85.563 30706.827 0.0 $Composite 0 2; Spring_IMK 906302 6320 632  $E $Fy [expr $Comp_I*5565.201] 33.800 0.670 11.500 1.220 44.700 4.710 2.500 160.975 100.350 80.487 30706.827 0.0 $Composite 0 2; Spring_IMK 906304 634  6340 $E $Fy [expr $Comp_I*5565.201] 33.800 0.670 11.500 1.220 44.700 4.710 2.500 160.975 100.350 80.487 30706.827 0.0 $Composite 0 2; Spring_IMK 906402 6420 642  $E $Fy [expr $Comp_I*5565.201] 33.800 0.670 11.500 1.220 44.700 4.710 2.500 171.125 105.425 85.563 30706.827 0.0 $Composite 0 2; 
Spring_IMK 905104 514  5140 $E $Fy [expr $Comp_I*5565.201] 33.800 0.670 11.500 1.220 44.700 4.710 2.500 171.125 105.425 85.563 30706.827 0.0 $Composite 0 2; Spring_IMK 905202 5220 522  $E $Fy [expr $Comp_I*5565.201] 33.800 0.670 11.500 1.220 44.700 4.710 2.500 171.125 105.425 85.563 30706.827 0.0 $Composite 0 2; Spring_IMK 905204 524  5240 $E $Fy [expr $Comp_I*5565.201] 33.800 0.670 11.500 1.220 44.700 4.710 2.500 171.125 105.425 85.563 30706.827 0.0 $Composite 0 2; Spring_IMK 905302 5320 532  $E $Fy [expr $Comp_I*5565.201] 33.800 0.670 11.500 1.220 44.700 4.710 2.500 160.975 100.350 80.487 30706.827 0.0 $Composite 0 2; Spring_IMK 905304 534  5340 $E $Fy [expr $Comp_I*5565.201] 33.800 0.670 11.500 1.220 44.700 4.710 2.500 160.975 100.350 80.487 30706.827 0.0 $Composite 0 2; Spring_IMK 905402 5420 542  $E $Fy [expr $Comp_I*5565.201] 33.800 0.670 11.500 1.220 44.700 4.710 2.500 171.125 105.425 85.563 30706.827 0.0 $Composite 0 2; 
Spring_IMK 904104 414  4140 $E $Fy [expr $Comp_I*4923.914] 33.500 0.635 11.600 1.060 47.200 5.480 2.470 170.975 105.300 85.487 27556.752 0.0 $Composite 0 2; Spring_IMK 904202 4220 422  $E $Fy [expr $Comp_I*4923.914] 33.500 0.635 11.600 1.060 47.200 5.480 2.470 170.975 105.300 85.487 27556.752 0.0 $Composite 0 2; Spring_IMK 904204 424  4240 $E $Fy [expr $Comp_I*4923.914] 33.500 0.635 11.600 1.060 47.200 5.480 2.470 170.975 105.300 85.487 27556.752 0.0 $Composite 0 2; Spring_IMK 904302 4320 432  $E $Fy [expr $Comp_I*4923.914] 33.500 0.635 11.600 1.060 47.200 5.480 2.470 161.175 100.400 80.588 27556.752 0.0 $Composite 0 2; Spring_IMK 904304 434  4340 $E $Fy [expr $Comp_I*4923.914] 33.500 0.635 11.600 1.060 47.200 5.480 2.470 161.175 100.400 80.588 27556.752 0.0 $Composite 0 2; Spring_IMK 904402 4420 442  $E $Fy [expr $Comp_I*4923.914] 33.500 0.635 11.600 1.060 47.200 5.480 2.470 170.975 105.300 85.487 27556.752 0.0 $Composite 0 2; 
Spring_IMK 903104 314  3140 $E $Fy [expr $Comp_I*4923.914] 33.500 0.635 11.600 1.060 47.200 5.480 2.470 170.975 105.300 85.487 27556.752 0.0 $Composite 0 2; Spring_IMK 903202 3220 322  $E $Fy [expr $Comp_I*4923.914] 33.500 0.635 11.600 1.060 47.200 5.480 2.470 170.975 105.300 85.487 27556.752 0.0 $Composite 0 2; Spring_IMK 903204 324  3240 $E $Fy [expr $Comp_I*4923.914] 33.500 0.635 11.600 1.060 47.200 5.480 2.470 170.975 105.300 85.487 27556.752 0.0 $Composite 0 2; Spring_IMK 903302 3320 332  $E $Fy [expr $Comp_I*4923.914] 33.500 0.635 11.600 1.060 47.200 5.480 2.470 161.175 100.400 80.588 27556.752 0.0 $Composite 0 2; Spring_IMK 903304 334  3340 $E $Fy [expr $Comp_I*4923.914] 33.500 0.635 11.600 1.060 47.200 5.480 2.470 161.175 100.400 80.588 27556.752 0.0 $Composite 0 2; Spring_IMK 903402 3420 342  $E $Fy [expr $Comp_I*4923.914] 33.500 0.635 11.600 1.060 47.200 5.480 2.470 170.975 105.300 85.487 27556.752 0.0 $Composite 0 2; 
Spring_IMK 902104 214  2140 $E $Fy [expr $Comp_I*4923.914] 33.500 0.635 11.600 1.060 47.200 5.480 2.470 170.975 105.300 85.487 27556.752 0.0 $Composite 0 2; Spring_IMK 902202 2220 222  $E $Fy [expr $Comp_I*4923.914] 33.500 0.635 11.600 1.060 47.200 5.480 2.470 170.975 105.300 85.487 27556.752 0.0 $Composite 0 2; Spring_IMK 902204 224  2240 $E $Fy [expr $Comp_I*4923.914] 33.500 0.635 11.600 1.060 47.200 5.480 2.470 170.975 105.300 85.487 27556.752 0.0 $Composite 0 2; Spring_IMK 902302 2320 232  $E $Fy [expr $Comp_I*4923.914] 33.500 0.635 11.600 1.060 47.200 5.480 2.470 161.175 100.400 80.588 27556.752 0.0 $Composite 0 2; Spring_IMK 902304 234  2340 $E $Fy [expr $Comp_I*4923.914] 33.500 0.635 11.600 1.060 47.200 5.480 2.470 161.175 100.400 80.588 27556.752 0.0 $Composite 0 2; Spring_IMK 902402 2420 242  $E $Fy [expr $Comp_I*4923.914] 33.500 0.635 11.600 1.060 47.200 5.480 2.470 170.975 105.300 85.487 27556.752 0.0 $Composite 0 2; 

# Column Springs
Spring_IMK 921101 2111 421101 $E $Fy 1530.000 14.700 0.645 14.700 1.030 17.700 7.150 3.760 132.100 66.050 132.100 14157.000 0.016 0 2 2; Spring_IMK 921201 2121 421201 $E $Fy 9040.000 35.900 0.625 12.000 0.940 51.900 6.370 2.470 132.100 66.050 132.100 35150.500 0.010 0 2 2; Spring_IMK 921301 2131 421301 $E $Fy 9040.000 35.900 0.625 12.000 0.940 51.900 6.370 2.470 132.100 66.050 132.100 35150.500 0.010 0 2 2; Spring_IMK 921401 2141 421401 $E $Fy 1530.000 14.700 0.645 14.700 1.030 17.700 7.150 3.760 132.100 66.050 132.100 14157.000 0.016 0 2 2; 
Spring_IMK 920103 2013 420103 $E $Fy 1530.000 14.700 0.645 14.700 1.030 17.700 7.150 3.760 132.100 66.050 132.100 14157.000 0.016 0 2 2; Spring_IMK 920203 2023 420203 $E $Fy 9040.000 35.900 0.625 12.000 0.940 51.900 6.370 2.470 132.100 66.050 132.100 35150.500 0.010 0 2 2; Spring_IMK 920303 2033 420303 $E $Fy 9040.000 35.900 0.625 12.000 0.940 51.900 6.370 2.470 132.100 66.050 132.100 35150.500 0.010 0 2 2; Spring_IMK 920403 2043 420403 $E $Fy 1530.000 14.700 0.645 14.700 1.030 17.700 7.150 3.760 132.100 66.050 132.100 14157.000 0.016 0 2 2; 
Spring_IMK 920101 2011 420101 $E $Fy 1530.000 14.700 0.645 14.700 1.030 17.700 7.150 3.760 132.100 66.050 132.100 14157.000 0.016 0 2 2; Spring_IMK 920201 2021 420201 $E $Fy 9040.000 35.900 0.625 12.000 0.940 51.900 6.370 2.470 132.100 66.050 132.100 35150.500 0.010 0 2 2; Spring_IMK 920301 2031 420301 $E $Fy 9040.000 35.900 0.625 12.000 0.940 51.900 6.370 2.470 132.100 66.050 132.100 35150.500 0.010 0 2 2; Spring_IMK 920401 2041 420401 $E $Fy 1530.000 14.700 0.645 14.700 1.030 17.700 7.150 3.760 132.100 66.050 132.100 14157.000 0.016 0 2 2; 
Spring_IMK 919103 1913 419103 $E $Fy 2400.000 15.500 0.890 15.700 1.440 12.800 5.450 4.050 131.200 65.600 131.200 21477.500 0.025 0 2 2; Spring_IMK 919203 1923 419203 $E $Fy 12100.000 36.500 0.765 12.100 1.260 42.400 4.810 2.560 131.200 65.600 131.200 46403.500 0.016 0 2 2; Spring_IMK 919303 1933 419303 $E $Fy 12100.000 36.500 0.765 12.100 1.260 42.400 4.810 2.560 131.200 65.600 131.200 46403.500 0.016 0 2 2; Spring_IMK 919403 1943 419403 $E $Fy 2400.000 15.500 0.890 15.700 1.440 12.800 5.450 4.050 131.200 65.600 131.200 21477.500 0.025 0 2 2; 
Spring_IMK 919101 1911 419101 $E $Fy 2400.000 15.500 0.890 15.700 1.440 12.800 5.450 4.050 130.300 65.150 130.300 21477.500 0.025 0 2 2; Spring_IMK 919201 1921 419201 $E $Fy 12100.000 36.500 0.765 12.100 1.260 42.400 4.810 2.560 130.300 65.150 130.300 46403.500 0.016 0 2 2; Spring_IMK 919301 1931 419301 $E $Fy 12100.000 36.500 0.765 12.100 1.260 42.400 4.810 2.560 130.300 65.150 130.300 46403.500 0.016 0 2 2; Spring_IMK 919401 1941 419401 $E $Fy 2400.000 15.500 0.890 15.700 1.440 12.800 5.450 4.050 130.300 65.150 130.300 21477.500 0.025 0 2 2; 
Spring_IMK 918103 1813 418103 $E $Fy 2400.000 15.500 0.890 15.700 1.440 12.800 5.450 4.050 130.300 65.150 130.300 21477.500 0.038 0 2 2; Spring_IMK 918203 1823 418203 $E $Fy 12100.000 36.500 0.765 12.100 1.260 42.400 4.810 2.560 130.300 65.150 130.300 46403.500 0.025 0 2 2; Spring_IMK 918303 1833 418303 $E $Fy 12100.000 36.500 0.765 12.100 1.260 42.400 4.810 2.560 130.300 65.150 130.300 46403.500 0.025 0 2 2; Spring_IMK 918403 1843 418403 $E $Fy 2400.000 15.500 0.890 15.700 1.440 12.800 5.450 4.050 130.300 65.150 130.300 21477.500 0.038 0 2 2; 
Spring_IMK 918101 1811 418101 $E $Fy 2400.000 15.500 0.890 15.700 1.440 12.800 5.450 4.050 130.300 65.150 130.300 21477.500 0.038 0 2 2; Spring_IMK 918201 1821 418201 $E $Fy 12100.000 36.500 0.765 12.100 1.260 42.400 4.810 2.560 130.300 65.150 130.300 46403.500 0.025 0 2 2; Spring_IMK 918301 1831 418301 $E $Fy 12100.000 36.500 0.765 12.100 1.260 42.400 4.810 2.560 130.300 65.150 130.300 46403.500 0.025 0 2 2; Spring_IMK 918401 1841 418401 $E $Fy 2400.000 15.500 0.890 15.700 1.440 12.800 5.450 4.050 130.300 65.150 130.300 21477.500 0.038 0 2 2; 
Spring_IMK 917103 1713 417103 $E $Fy 3010.000 16.000 1.070 15.900 1.720 10.700 4.620 4.100 130.300 65.150 130.300 26378.000 0.043 0 2 2; Spring_IMK 917203 1723 417203 $E $Fy 15000.000 37.100 0.870 12.100 1.570 37.300 3.860 2.620 130.300 65.150 130.300 56628.000 0.029 0 2 2; Spring_IMK 917303 1733 417303 $E $Fy 15000.000 37.100 0.870 12.100 1.570 37.300 3.860 2.620 130.300 65.150 130.300 56628.000 0.029 0 2 2; Spring_IMK 917403 1743 417403 $E $Fy 3010.000 16.000 1.070 15.900 1.720 10.700 4.620 4.100 130.300 65.150 130.300 26378.000 0.043 0 2 2; 
Spring_IMK 917101 1711 417101 $E $Fy 3010.000 16.000 1.070 15.900 1.720 10.700 4.620 4.100 130.300 65.150 130.300 26378.000 0.043 0 2 2; Spring_IMK 917201 1721 417201 $E $Fy 15000.000 37.100 0.870 12.100 1.570 37.300 3.860 2.620 130.300 65.150 130.300 56628.000 0.029 0 2 2; Spring_IMK 917301 1731 417301 $E $Fy 15000.000 37.100 0.870 12.100 1.570 37.300 3.860 2.620 130.300 65.150 130.300 56628.000 0.029 0 2 2; Spring_IMK 917401 1741 417401 $E $Fy 3010.000 16.000 1.070 15.900 1.720 10.700 4.620 4.100 130.300 65.150 130.300 26378.000 0.043 0 2 2; 
Spring_IMK 916103 1613 416103 $E $Fy 3010.000 16.000 1.070 15.900 1.720 10.700 4.620 4.100 126.400 63.200 126.400 26378.000 0.054 0 2 2; Spring_IMK 916203 1623 416203 $E $Fy 15000.000 37.100 0.870 12.100 1.570 37.300 3.860 2.620 126.400 63.200 126.400 56628.000 0.036 0 2 2; Spring_IMK 916303 1633 416303 $E $Fy 15000.000 37.100 0.870 12.100 1.570 37.300 3.860 2.620 126.400 63.200 126.400 56628.000 0.036 0 2 2; Spring_IMK 916403 1643 416403 $E $Fy 3010.000 16.000 1.070 15.900 1.720 10.700 4.620 4.100 126.400 63.200 126.400 26378.000 0.054 0 2 2; 
Spring_IMK 916101 1611 416101 $E $Fy 3010.000 16.000 1.070 15.900 1.720 10.700 4.620 4.100 122.500 61.250 122.500 26378.000 0.054 0 2 2; Spring_IMK 916201 1621 416201 $E $Fy 15000.000 37.100 0.870 12.100 1.570 37.300 3.860 2.620 122.500 61.250 122.500 56628.000 0.036 0 2 2; Spring_IMK 916301 1631 416301 $E $Fy 15000.000 37.100 0.870 12.100 1.570 37.300 3.860 2.620 122.500 61.250 122.500 56628.000 0.036 0 2 2; Spring_IMK 916401 1641 416401 $E $Fy 3010.000 16.000 1.070 15.900 1.720 10.700 4.620 4.100 122.500 61.250 122.500 26378.000 0.054 0 2 2; 
Spring_IMK 915103 1513 415103 $E $Fy 3840.000 16.700 1.290 16.100 2.070 8.840 3.890 4.170 122.500 61.250 122.500 32791.000 0.054 0 2 2; Spring_IMK 915203 1523 415203 $E $Fy 17300.000 36.300 0.840 16.600 1.440 37.500 5.750 3.780 122.500 61.250 122.500 65340.000 0.039 0 2 2; Spring_IMK 915303 1533 415303 $E $Fy 17300.000 36.300 0.840 16.600 1.440 37.500 5.750 3.780 122.500 61.250 122.500 65340.000 0.039 0 2 2; Spring_IMK 915403 1543 415403 $E $Fy 3840.000 16.700 1.290 16.100 2.070 8.840 3.890 4.170 122.500 61.250 122.500 32791.000 0.054 0 2 2; 
Spring_IMK 915101 1511 415101 $E $Fy 3840.000 16.700 1.290 16.100 2.070 8.840 3.890 4.170 122.500 61.250 122.500 32791.000 0.054 0 2 2; Spring_IMK 915201 1521 415201 $E $Fy 17300.000 36.300 0.840 16.600 1.440 37.500 5.750 3.780 122.500 61.250 122.500 65340.000 0.039 0 2 2; Spring_IMK 915301 1531 415301 $E $Fy 17300.000 36.300 0.840 16.600 1.440 37.500 5.750 3.780 122.500 61.250 122.500 65340.000 0.039 0 2 2; Spring_IMK 915401 1541 415401 $E $Fy 3840.000 16.700 1.290 16.100 2.070 8.840 3.890 4.170 122.500 61.250 122.500 32791.000 0.054 0 2 2; 
Spring_IMK 914103 1413 414103 $E $Fy 3840.000 16.700 1.290 16.100 2.070 8.840 3.890 4.170 122.500 61.250 122.500 32791.000 0.063 0 2 2; Spring_IMK 914203 1423 414203 $E $Fy 17300.000 36.300 0.840 16.600 1.440 37.500 5.750 3.780 122.500 61.250 122.500 65340.000 0.046 0 2 2; Spring_IMK 914303 1433 414303 $E $Fy 17300.000 36.300 0.840 16.600 1.440 37.500 5.750 3.780 122.500 61.250 122.500 65340.000 0.046 0 2 2; Spring_IMK 914403 1443 414403 $E $Fy 3840.000 16.700 1.290 16.100 2.070 8.840 3.890 4.170 122.500 61.250 122.500 32791.000 0.063 0 2 2; 
Spring_IMK 914101 1411 414101 $E $Fy 3840.000 16.700 1.290 16.100 2.070 8.840 3.890 4.170 122.500 61.250 122.500 32791.000 0.063 0 2 2; Spring_IMK 914201 1421 414201 $E $Fy 17300.000 36.300 0.840 16.600 1.440 37.500 5.750 3.780 122.500 61.250 122.500 65340.000 0.046 0 2 2; Spring_IMK 914301 1431 414301 $E $Fy 17300.000 36.300 0.840 16.600 1.440 37.500 5.750 3.780 122.500 61.250 122.500 65340.000 0.046 0 2 2; Spring_IMK 914401 1441 414401 $E $Fy 3840.000 16.700 1.290 16.100 2.070 8.840 3.890 4.170 122.500 61.250 122.500 32791.000 0.063 0 2 2; 
Spring_IMK 913103 1313 413103 $E $Fy 4330.000 17.100 1.410 16.200 2.260 8.090 3.590 4.200 122.350 61.175 122.350 36481.500 0.066 0 2 2; Spring_IMK 913203 1323 413203 $E $Fy 22500.000 37.100 1.020 16.600 1.850 30.900 4.490 3.840 122.350 61.175 122.350 83490.000 0.042 0 2 2; Spring_IMK 913303 1333 413303 $E $Fy 22500.000 37.100 1.020 16.600 1.850 30.900 4.490 3.840 122.350 61.175 122.350 83490.000 0.042 0 2 2; Spring_IMK 913403 1343 413403 $E $Fy 4330.000 17.100 1.410 16.200 2.260 8.090 3.590 4.200 122.350 61.175 122.350 36481.500 0.066 0 2 2; 
Spring_IMK 913101 1311 413101 $E $Fy 4330.000 17.100 1.410 16.200 2.260 8.090 3.590 4.200 122.200 61.100 122.200 36481.500 0.066 0 2 2; Spring_IMK 913201 1321 413201 $E $Fy 22500.000 37.100 1.020 16.600 1.850 30.900 4.490 3.840 122.200 61.100 122.200 83490.000 0.042 0 2 2; Spring_IMK 913301 1331 413301 $E $Fy 22500.000 37.100 1.020 16.600 1.850 30.900 4.490 3.840 122.200 61.100 122.200 83490.000 0.042 0 2 2; Spring_IMK 913401 1341 413401 $E $Fy 4330.000 17.100 1.410 16.200 2.260 8.090 3.590 4.200 122.200 61.100 122.200 36481.500 0.066 0 2 2; 
Spring_IMK 912103 1213 412103 $E $Fy 4330.000 17.100 1.410 16.200 2.260 8.090 3.590 4.200 122.200 61.100 122.200 36481.500 0.074 0 2 2; Spring_IMK 912203 1223 412203 $E $Fy 22500.000 37.100 1.020 16.600 1.850 30.900 4.490 3.840 122.200 61.100 122.200 83490.000 0.047 0 2 2; Spring_IMK 912303 1233 412303 $E $Fy 22500.000 37.100 1.020 16.600 1.850 30.900 4.490 3.840 122.200 61.100 122.200 83490.000 0.047 0 2 2; Spring_IMK 912403 1243 412403 $E $Fy 4330.000 17.100 1.410 16.200 2.260 8.090 3.590 4.200 122.200 61.100 122.200 36481.500 0.074 0 2 2; 
Spring_IMK 912101 1211 412101 $E $Fy 4330.000 17.100 1.410 16.200 2.260 8.090 3.590 4.200 122.200 61.100 122.200 36481.500 0.074 0 2 2; Spring_IMK 912201 1221 412201 $E $Fy 22500.000 37.100 1.020 16.600 1.850 30.900 4.490 3.840 122.200 61.100 122.200 83490.000 0.047 0 2 2; Spring_IMK 912301 1231 412301 $E $Fy 22500.000 37.100 1.020 16.600 1.850 30.900 4.490 3.840 122.200 61.100 122.200 83490.000 0.047 0 2 2; Spring_IMK 912401 1241 412401 $E $Fy 4330.000 17.100 1.410 16.200 2.260 8.090 3.590 4.200 122.200 61.100 122.200 36481.500 0.074 0 2 2; 
Spring_IMK 911103 1113 411103 $E $Fy 5440.000 17.900 1.660 16.500 2.660 6.890 3.100 4.270 122.200 61.100 122.200 44528.000 0.069 0 2 2; Spring_IMK 911203 1123 411203 $E $Fy 24800.000 37.400 1.120 16.700 2.010 28.100 4.160 3.860 122.200 61.100 122.200 91355.000 0.048 0 2 2; Spring_IMK 911303 1133 411303 $E $Fy 24800.000 37.400 1.120 16.700 2.010 28.100 4.160 3.860 122.200 61.100 122.200 91355.000 0.048 0 2 2; Spring_IMK 911403 1143 411403 $E $Fy 5440.000 17.900 1.660 16.500 2.660 6.890 3.100 4.270 122.200 61.100 122.200 44528.000 0.069 0 2 2; 
Spring_IMK 911101 1111 411101 $E $Fy 5440.000 17.900 1.660 16.500 2.660 6.890 3.100 4.270 122.200 61.100 122.200 44528.000 0.069 0 2 2; Spring_IMK 911201 1121 411201 $E $Fy 24800.000 37.400 1.120 16.700 2.010 28.100 4.160 3.860 122.200 61.100 122.200 91355.000 0.048 0 2 2; Spring_IMK 911301 1131 411301 $E $Fy 24800.000 37.400 1.120 16.700 2.010 28.100 4.160 3.860 122.200 61.100 122.200 91355.000 0.048 0 2 2; Spring_IMK 911401 1141 411401 $E $Fy 5440.000 17.900 1.660 16.500 2.660 6.890 3.100 4.270 122.200 61.100 122.200 44528.000 0.069 0 2 2; 
Spring_IMK 910103 1013 410103 $E $Fy 5440.000 17.900 1.660 16.500 2.660 6.890 3.100 4.270 122.200 61.100 122.200 44528.000 0.076 0 2 2; Spring_IMK 910203 1023 410203 $E $Fy 24800.000 37.400 1.120 16.700 2.010 28.100 4.160 3.860 122.200 61.100 122.200 91355.000 0.053 0 2 2; Spring_IMK 910303 1033 410303 $E $Fy 24800.000 37.400 1.120 16.700 2.010 28.100 4.160 3.860 122.200 61.100 122.200 91355.000 0.053 0 2 2; Spring_IMK 910403 1043 410403 $E $Fy 5440.000 17.900 1.660 16.500 2.660 6.890 3.100 4.270 122.200 61.100 122.200 44528.000 0.076 0 2 2; 
Spring_IMK 910101 1011 410101 $E $Fy 5440.000 17.900 1.660 16.500 2.660 6.890 3.100 4.270 122.200 61.100 122.200 44528.000 0.076 0 2 2; Spring_IMK 910201 1021 410201 $E $Fy 24800.000 37.400 1.120 16.700 2.010 28.100 4.160 3.860 122.200 61.100 122.200 91355.000 0.053 0 2 2; Spring_IMK 910301 1031 410301 $E $Fy 24800.000 37.400 1.120 16.700 2.010 28.100 4.160 3.860 122.200 61.100 122.200 91355.000 0.053 0 2 2; Spring_IMK 910401 1041 410401 $E $Fy 5440.000 17.900 1.660 16.500 2.660 6.890 3.100 4.270 122.200 61.100 122.200 44528.000 0.076 0 2 2; 
Spring_IMK 909103 913 409103 $E $Fy 5440.000 17.900 1.660 16.500 2.660 6.890 3.100 4.270 122.200 61.100 122.200 44528.000 0.084 0 2 2; Spring_IMK 909203 923 409203 $E $Fy 27500.000 37.800 1.220 16.800 2.200 25.800 3.820 3.900 122.200 61.100 122.200 101035.000 0.052 0 2 2; Spring_IMK 909303 933 409303 $E $Fy 27500.000 37.800 1.220 16.800 2.200 25.800 3.820 3.900 122.200 61.100 122.200 101035.000 0.052 0 2 2; Spring_IMK 909403 943 409403 $E $Fy 5440.000 17.900 1.660 16.500 2.660 6.890 3.100 4.270 122.200 61.100 122.200 44528.000 0.084 0 2 2; 
Spring_IMK 909101 911 409101 $E $Fy 5440.000 17.900 1.660 16.500 2.660 6.890 3.100 4.270 122.200 61.100 122.200 44528.000 0.084 0 2 2; Spring_IMK 909201 921 409201 $E $Fy 27500.000 37.800 1.220 16.800 2.200 25.800 3.820 3.900 122.200 61.100 122.200 101035.000 0.052 0 2 2; Spring_IMK 909301 931 409301 $E $Fy 27500.000 37.800 1.220 16.800 2.200 25.800 3.820 3.900 122.200 61.100 122.200 101035.000 0.052 0 2 2; Spring_IMK 909401 941 409401 $E $Fy 5440.000 17.900 1.660 16.500 2.660 6.890 3.100 4.270 122.200 61.100 122.200 44528.000 0.084 0 2 2; 
Spring_IMK 908103 813 408103 $E $Fy 5440.000 17.900 1.660 16.500 2.660 6.890 3.100 4.270 122.200 61.100 122.200 44528.000 0.091 0 2 2; Spring_IMK 908203 823 408203 $E $Fy 27500.000 37.800 1.220 16.800 2.200 25.800 3.820 3.900 122.200 61.100 122.200 101035.000 0.057 0 2 2; Spring_IMK 908303 833 408303 $E $Fy 27500.000 37.800 1.220 16.800 2.200 25.800 3.820 3.900 122.200 61.100 122.200 101035.000 0.057 0 2 2; Spring_IMK 908403 843 408403 $E $Fy 5440.000 17.900 1.660 16.500 2.660 6.890 3.100 4.270 122.200 61.100 122.200 44528.000 0.091 0 2 2; 
Spring_IMK 908101 811 408101 $E $Fy 5440.000 17.900 1.660 16.500 2.660 6.890 3.100 4.270 122.200 61.100 122.200 44528.000 0.091 0 2 2; Spring_IMK 908201 821 408201 $E $Fy 27500.000 37.800 1.220 16.800 2.200 25.800 3.820 3.900 122.200 61.100 122.200 101035.000 0.057 0 2 2; Spring_IMK 908301 831 408301 $E $Fy 27500.000 37.800 1.220 16.800 2.200 25.800 3.820 3.900 122.200 61.100 122.200 101035.000 0.057 0 2 2; Spring_IMK 908401 841 408401 $E $Fy 5440.000 17.900 1.660 16.500 2.660 6.890 3.100 4.270 122.200 61.100 122.200 44528.000 0.091 0 2 2; 
Spring_IMK 907103 713 407103 $E $Fy 7190.000 19.000 2.020 16.800 3.210 5.660 2.620 4.380 122.200 61.100 122.200 56628.000 0.079 0 2 2; Spring_IMK 907203 723 407203 $E $Fy 31000.000 38.300 1.360 17.000 2.440 23.100 3.480 3.930 122.200 61.100 122.200 113135.000 0.055 0 2 2; Spring_IMK 907303 733 407303 $E $Fy 31000.000 38.300 1.360 17.000 2.440 23.100 3.480 3.930 122.200 61.100 122.200 113135.000 0.055 0 2 2; Spring_IMK 907403 743 407403 $E $Fy 7190.000 19.000 2.020 16.800 3.210 5.660 2.620 4.380 122.200 61.100 122.200 56628.000 0.079 0 2 2; 
Spring_IMK 907101 711 407101 $E $Fy 7190.000 19.000 2.020 16.800 3.210 5.660 2.620 4.380 122.200 61.100 122.200 56628.000 0.079 0 2 2; Spring_IMK 907201 721 407201 $E $Fy 31000.000 38.300 1.360 17.000 2.440 23.100 3.480 3.930 122.200 61.100 122.200 113135.000 0.055 0 2 2; Spring_IMK 907301 731 407301 $E $Fy 31000.000 38.300 1.360 17.000 2.440 23.100 3.480 3.930 122.200 61.100 122.200 113135.000 0.055 0 2 2; Spring_IMK 907401 741 407401 $E $Fy 7190.000 19.000 2.020 16.800 3.210 5.660 2.620 4.380 122.200 61.100 122.200 56628.000 0.079 0 2 2; 
Spring_IMK 906103 613 406103 $E $Fy 7190.000 19.000 2.020 16.800 3.210 5.660 2.620 4.380 122.200 61.100 122.200 56628.000 0.085 0 2 2; Spring_IMK 906203 623 406203 $E $Fy 31000.000 38.300 1.360 17.000 2.440 23.100 3.480 3.930 122.200 61.100 122.200 113135.000 0.059 0 2 2; Spring_IMK 906303 633 406303 $E $Fy 31000.000 38.300 1.360 17.000 2.440 23.100 3.480 3.930 122.200 61.100 122.200 113135.000 0.059 0 2 2; Spring_IMK 906403 643 406403 $E $Fy 7190.000 19.000 2.020 16.800 3.210 5.660 2.620 4.380 122.200 61.100 122.200 56628.000 0.085 0 2 2; 
Spring_IMK 906101 611 406101 $E $Fy 7190.000 19.000 2.020 16.800 3.210 5.660 2.620 4.380 122.200 61.100 122.200 56628.000 0.085 0 2 2; Spring_IMK 906201 621 406201 $E $Fy 31000.000 38.300 1.360 17.000 2.440 23.100 3.480 3.930 122.200 61.100 122.200 113135.000 0.059 0 2 2; Spring_IMK 906301 631 406301 $E $Fy 31000.000 38.300 1.360 17.000 2.440 23.100 3.480 3.930 122.200 61.100 122.200 113135.000 0.059 0 2 2; Spring_IMK 906401 641 406401 $E $Fy 7190.000 19.000 2.020 16.800 3.210 5.660 2.620 4.380 122.200 61.100 122.200 56628.000 0.085 0 2 2; 
Spring_IMK 905103 513 405103 $E $Fy 7190.000 19.000 2.020 16.800 3.210 5.660 2.620 4.380 122.200 61.100 122.200 56628.000 0.091 0 2 2; Spring_IMK 905203 523 405203 $E $Fy 36000.000 39.300 1.500 17.100 2.680 21.400 3.190 3.960 122.200 61.100 122.200 128865.000 0.057 0 2 2; Spring_IMK 905303 533 405303 $E $Fy 36000.000 39.300 1.500 17.100 2.680 21.400 3.190 3.960 122.200 61.100 122.200 128865.000 0.057 0 2 2; Spring_IMK 905403 543 405403 $E $Fy 7190.000 19.000 2.020 16.800 3.210 5.660 2.620 4.380 122.200 61.100 122.200 56628.000 0.091 0 2 2; 
Spring_IMK 905101 511 405101 $E $Fy 7190.000 19.000 2.020 16.800 3.210 5.660 2.620 4.380 122.200 61.100 122.200 56628.000 0.091 0 2 2; Spring_IMK 905201 521 405201 $E $Fy 36000.000 39.300 1.500 17.100 2.680 21.400 3.190 3.960 122.200 61.100 122.200 128865.000 0.057 0 2 2; Spring_IMK 905301 531 405301 $E $Fy 36000.000 39.300 1.500 17.100 2.680 21.400 3.190 3.960 122.200 61.100 122.200 128865.000 0.057 0 2 2; Spring_IMK 905401 541 405401 $E $Fy 7190.000 19.000 2.020 16.800 3.210 5.660 2.620 4.380 122.200 61.100 122.200 56628.000 0.091 0 2 2; 
Spring_IMK 904103 413 404103 $E $Fy 7190.000 19.000 2.020 16.800 3.210 5.660 2.620 4.380 122.350 61.175 122.350 56628.000 0.097 0 2 2; Spring_IMK 904203 423 404203 $E $Fy 36000.000 39.300 1.500 17.100 2.680 21.400 3.190 3.960 122.350 61.175 122.350 128865.000 0.060 0 2 2; Spring_IMK 904303 433 404303 $E $Fy 36000.000 39.300 1.500 17.100 2.680 21.400 3.190 3.960 122.350 61.175 122.350 128865.000 0.060 0 2 2; Spring_IMK 904403 443 404403 $E $Fy 7190.000 19.000 2.020 16.800 3.210 5.660 2.620 4.380 122.350 61.175 122.350 56628.000 0.097 0 2 2; 
Spring_IMK 904101 411 404101 $E $Fy 7190.000 19.000 2.020 16.800 3.210 5.660 2.620 4.380 122.500 61.250 122.500 56628.000 0.097 0 2 2; Spring_IMK 904201 421 404201 $E $Fy 36000.000 39.300 1.500 17.100 2.680 21.400 3.190 3.960 122.500 61.250 122.500 128865.000 0.060 0 2 2; Spring_IMK 904301 431 404301 $E $Fy 36000.000 39.300 1.500 17.100 2.680 21.400 3.190 3.960 122.500 61.250 122.500 128865.000 0.060 0 2 2; Spring_IMK 904401 441 404401 $E $Fy 7190.000 19.000 2.020 16.800 3.210 5.660 2.620 4.380 122.500 61.250 122.500 56628.000 0.097 0 2 2; 
Spring_IMK 903103 313 403103 $E $Fy 8210.000 19.600 2.190 17.000 3.500 5.210 2.430 4.430 122.500 61.250 122.500 63525.000 0.093 0 2 2; Spring_IMK 903203 323 403203 $E $Fy 38300.000 39.200 1.610 17.200 2.910 19.600 2.960 4.010 122.500 61.250 122.500 137940.000 0.059 0 2 2; Spring_IMK 903303 333 403303 $E $Fy 38300.000 39.200 1.610 17.200 2.910 19.600 2.960 4.010 122.500 61.250 122.500 137940.000 0.059 0 2 2; Spring_IMK 903403 343 403403 $E $Fy 8210.000 19.600 2.190 17.000 3.500 5.210 2.430 4.430 122.500 61.250 122.500 63525.000 0.093 0 2 2; 
Spring_IMK 903101 311 403101 $E $Fy 8210.000 19.600 2.190 17.000 3.500 5.210 2.430 4.430 122.500 61.250 122.500 63525.000 0.093 0 2 2; Spring_IMK 903201 321 403201 $E $Fy 38300.000 39.200 1.610 17.200 2.910 19.600 2.960 4.010 122.500 61.250 122.500 137940.000 0.059 0 2 2; Spring_IMK 903301 331 403301 $E $Fy 38300.000 39.200 1.610 17.200 2.910 19.600 2.960 4.010 122.500 61.250 122.500 137940.000 0.059 0 2 2; Spring_IMK 903401 341 403401 $E $Fy 8210.000 19.600 2.190 17.000 3.500 5.210 2.430 4.430 122.500 61.250 122.500 63525.000 0.093 0 2 2; 
Spring_IMK 902103 213 402103 $E $Fy 8210.000 19.600 2.190 17.000 3.500 5.210 2.430 4.430 146.500 73.250 146.500 63525.000 0.099 0 2 2; Spring_IMK 902203 223 402203 $E $Fy 38300.000 39.200 1.610 17.200 2.910 19.600 2.960 4.010 146.500 73.250 146.500 137940.000 0.062 0 2 2; Spring_IMK 902303 233 402303 $E $Fy 38300.000 39.200 1.610 17.200 2.910 19.600 2.960 4.010 146.500 73.250 146.500 137940.000 0.062 0 2 2; Spring_IMK 902403 243 402403 $E $Fy 8210.000 19.600 2.190 17.000 3.500 5.210 2.430 4.430 146.500 73.250 146.500 63525.000 0.099 0 2 2; 
Spring_IMK 902101 211 402101 $E $Fy 8210.000 19.600 2.190 17.000 3.500 5.210 2.430 4.430 146.500 73.250 146.500 63525.000 0.099 0 2 2; Spring_IMK 902201 221 402201 $E $Fy 38300.000 39.200 1.610 17.200 2.910 19.600 2.960 4.010 146.500 73.250 146.500 137940.000 0.062 0 2 2; Spring_IMK 902301 231 402301 $E $Fy 38300.000 39.200 1.610 17.200 2.910 19.600 2.960 4.010 146.500 73.250 146.500 137940.000 0.062 0 2 2; Spring_IMK 902401 241 402401 $E $Fy 8210.000 19.600 2.190 17.000 3.500 5.210 2.430 4.430 146.500 73.250 146.500 63525.000 0.099 0 2 2; 
Spring_IMK 901103 11 113 $E $Fy 8210.000 19.600 2.190 17.000 3.500 5.210 2.430 4.430 163.250 81.625 163.250 63525.000 0.104 0 2 2; Spring_IMK 901203 12 123 $E $Fy 38300.000 39.200 1.610 17.200 2.910 19.600 2.960 4.010 163.250 81.625 163.250 137940.000 0.066 0 2 2; Spring_IMK 901303 13 133 $E $Fy 38300.000 39.200 1.610 17.200 2.910 19.600 2.960 4.010 163.250 81.625 163.250 137940.000 0.066 0 2 2; Spring_IMK 901403 14 143 $E $Fy 8210.000 19.600 2.190 17.000 3.500 5.210 2.430 4.430 163.250 81.625 163.250 63525.000 0.104 0 2 2; 

####################################################################################################
#                                          RIGID FLOOR LINKS                                       #
####################################################################################################

# COMMAND SYNTAX 
# element truss $ElementID $iNode $jNode $Area $matID
element truss 1021 421404 215 $A_Stiff 99;
element truss 1020 420404 205 $A_Stiff 99;
element truss 1019 419404 195 $A_Stiff 99;
element truss 1018 418404 185 $A_Stiff 99;
element truss 1017 417404 175 $A_Stiff 99;
element truss 1016 416404 165 $A_Stiff 99;
element truss 1015 415404 155 $A_Stiff 99;
element truss 1014 414404 145 $A_Stiff 99;
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
element elasticBeamColumn  620500  2053  2151  [expr 100000.000 / 2] $E [expr (100000000.000  + 1636.000) / 2] 1; element elasticBeamColumn  620600  2063  2161  [expr 100000.000 / 2] $E [expr (100000000.000  + 1636.000) / 2] 1; 
element elasticBeamColumn 619502 119570 2051  [expr 100000.000 / 2] $E [expr (100000000.000  + 1636.000) / 2] 1;  element elasticBeamColumn 619602 119670 2061  [expr 100000.000 / 2] $E [expr (100000000.000  + 1636.000) / 2] 1;  
element elasticBeamColumn 619501 1953 119570  [expr 100000.000 / 2] $E [expr (100000000.000  + 2612.000) / 2] 1;  element elasticBeamColumn 619601 1963 119670  [expr 100000.000 / 2] $E [expr (100000000.000  + 2612.000) / 2] 1;  
element elasticBeamColumn  618500  1853  1951  [expr 100000.000 / 2] $E [expr (100000000.000  + 2612.000) / 2] 1; element elasticBeamColumn  618600  1863  1961  [expr 100000.000 / 2] $E [expr (100000000.000  + 2612.000) / 2] 1; 
element elasticBeamColumn 617502 117570 1851  [expr 100000.000 / 2] $E [expr (100000000.000  + 2612.000) / 2] 1;  element elasticBeamColumn 617602 117670 1861  [expr 100000.000 / 2] $E [expr (100000000.000  + 2612.000) / 2] 1;  
element elasticBeamColumn 617501 1753 117570  [expr 100000.000 / 2] $E [expr (100000000.000  + 3236.000) / 2] 1;  element elasticBeamColumn 617601 1763 117670  [expr 100000.000 / 2] $E [expr (100000000.000  + 3236.000) / 2] 1;  
element elasticBeamColumn  616500  1653  1751  [expr 100000.000 / 2] $E [expr (100000000.000  + 3236.000) / 2] 1; element elasticBeamColumn  616600  1663  1761  [expr 100000.000 / 2] $E [expr (100000000.000  + 3236.000) / 2] 1; 
element elasticBeamColumn 615502 115570 1651  [expr 100000.000 / 2] $E [expr (100000000.000  + 3236.000) / 2] 1;  element elasticBeamColumn 615602 115670 1661  [expr 100000.000 / 2] $E [expr (100000000.000  + 3236.000) / 2] 1;  
element elasticBeamColumn 615501 1553 115570  [expr 100000.000 / 2] $E [expr (100000000.000  + 5060.000) / 2] 1;  element elasticBeamColumn 615601 1563 115670  [expr 100000.000 / 2] $E [expr (100000000.000  + 5060.000) / 2] 1;  
element elasticBeamColumn  614500  1453  1551  [expr 100000.000 / 2] $E [expr (100000000.000  + 5060.000) / 2] 1; element elasticBeamColumn  614600  1463  1561  [expr 100000.000 / 2] $E [expr (100000000.000  + 5060.000) / 2] 1; 
element elasticBeamColumn 613502 113570 1451  [expr 100000.000 / 2] $E [expr (100000000.000  + 5060.000) / 2] 1;  element elasticBeamColumn 613602 113670 1461  [expr 100000.000 / 2] $E [expr (100000000.000  + 5060.000) / 2] 1;  
element elasticBeamColumn 613501 1353 113570  [expr 100000.000 / 2] $E [expr (100000000.000  + 6060.000) / 2] 1;  element elasticBeamColumn 613601 1363 113670  [expr 100000.000 / 2] $E [expr (100000000.000  + 6060.000) / 2] 1;  
element elasticBeamColumn  612500  1253  1351  [expr 100000.000 / 2] $E [expr (100000000.000  + 6060.000) / 2] 1; element elasticBeamColumn  612600  1263  1361  [expr 100000.000 / 2] $E [expr (100000000.000  + 6060.000) / 2] 1; 
element elasticBeamColumn 611502 111570 1251  [expr 100000.000 / 2] $E [expr (100000000.000  + 6060.000) / 2] 1;  element elasticBeamColumn 611602 111670 1261  [expr 100000.000 / 2] $E [expr (100000000.000  + 6060.000) / 2] 1;  
element elasticBeamColumn 611501 1153 111570  [expr 100000.000 / 2] $E [expr (100000000.000  + 7120.000) / 2] 1;  element elasticBeamColumn 611601 1163 111670  [expr 100000.000 / 2] $E [expr (100000000.000  + 7120.000) / 2] 1;  
element elasticBeamColumn  610500  1053  1151  [expr 100000.000 / 2] $E [expr (100000000.000  + 7120.000) / 2] 1; element elasticBeamColumn  610600  1063  1161  [expr 100000.000 / 2] $E [expr (100000000.000  + 7120.000) / 2] 1; 
element elasticBeamColumn 609502 109570 1051  [expr 100000.000 / 2] $E [expr (100000000.000  + 7120.000) / 2] 1;  element elasticBeamColumn 609602 109670 1061  [expr 100000.000 / 2] $E [expr (100000000.000  + 7120.000) / 2] 1;  
element elasticBeamColumn 609501 953 109570  [expr 100000.000 / 2] $E [expr (100000000.000  + 7480.000) / 2] 1;  element elasticBeamColumn 609601 963 109670  [expr 100000.000 / 2] $E [expr (100000000.000  + 7480.000) / 2] 1;  
element elasticBeamColumn  608500  853  951  [expr 100000.000 / 2] $E [expr (100000000.000  + 7480.000) / 2] 1; element elasticBeamColumn  608600  863  961  [expr 100000.000 / 2] $E [expr (100000000.000  + 7480.000) / 2] 1; 
element elasticBeamColumn 607502 107570 851  [expr 100000.000 / 2] $E [expr (100000000.000  + 7480.000) / 2] 1;  element elasticBeamColumn 607602 107670 861  [expr 100000.000 / 2] $E [expr (100000000.000  + 7480.000) / 2] 1;  
element elasticBeamColumn 607501 753 107570  [expr 100000.000 / 2] $E [expr (100000000.000  + 9100.000) / 2] 1;  element elasticBeamColumn 607601 763 107670  [expr 100000.000 / 2] $E [expr (100000000.000  + 9100.000) / 2] 1;  
element elasticBeamColumn  606500  653  751  [expr 100000.000 / 2] $E [expr (100000000.000  + 9100.000) / 2] 1; element elasticBeamColumn  606600  663  761  [expr 100000.000 / 2] $E [expr (100000000.000  + 9100.000) / 2] 1; 
element elasticBeamColumn 605502 105570 651  [expr 100000.000 / 2] $E [expr (100000000.000  + 9100.000) / 2] 1;  element elasticBeamColumn 605602 105670 661  [expr 100000.000 / 2] $E [expr (100000000.000  + 9100.000) / 2] 1;  
element elasticBeamColumn 605501 553 105570  [expr 100000.000 / 2] $E [expr (100000000.000  + 9620.000) / 2] 1;  element elasticBeamColumn 605601 563 105670  [expr 100000.000 / 2] $E [expr (100000000.000  + 9620.000) / 2] 1;  
element elasticBeamColumn  604500  453  551  [expr 100000.000 / 2] $E [expr (100000000.000  + 9620.000) / 2] 1; element elasticBeamColumn  604600  463  561  [expr 100000.000 / 2] $E [expr (100000000.000  + 9620.000) / 2] 1; 
element elasticBeamColumn 603502 103570 451  [expr 100000.000 / 2] $E [expr (100000000.000  + 9620.000) / 2] 1;  element elasticBeamColumn 603602 103670 461  [expr 100000.000 / 2] $E [expr (100000000.000  + 9620.000) / 2] 1;  
element elasticBeamColumn 603501 353 103570  [expr 100000.000 / 2] $E [expr (100000000.000  + 10740.000) / 2] 1;  element elasticBeamColumn 603601 363 103670  [expr 100000.000 / 2] $E [expr (100000000.000  + 10740.000) / 2] 1;  
element elasticBeamColumn  602500  253  351  [expr 100000.000 / 2] $E [expr (100000000.000  + 10740.000) / 2] 1; element elasticBeamColumn  602600  263  361  [expr 100000.000 / 2] $E [expr (100000000.000  + 10740.000) / 2] 1; 
element elasticBeamColumn  601500  153  251  [expr 100000.000 / 2] $E [expr (100000000.000  + 10740.000) / 2] 1; element elasticBeamColumn  601600  163  261  [expr 100000.000 / 2] $E [expr (100000000.000  + 10740.000) / 2] 1; 

# Gravity Beams
element elasticBeamColumn  521400 2154  2162  100000.000  $E [expr $Comp_I_GC * 100000000.000] 1;
element elasticBeamColumn  520400 2054  2062  100000.000  $E [expr $Comp_I_GC * 100000000.000] 1;
element elasticBeamColumn  519400 1954  1962  100000.000  $E [expr $Comp_I_GC * 100000000.000] 1;
element elasticBeamColumn  518400 1854  1862  100000.000  $E [expr $Comp_I_GC * 100000000.000] 1;
element elasticBeamColumn  517400 1754  1762  100000.000  $E [expr $Comp_I_GC * 100000000.000] 1;
element elasticBeamColumn  516400 1654  1662  100000.000  $E [expr $Comp_I_GC * 100000000.000] 1;
element elasticBeamColumn  515400 1554  1562  100000.000  $E [expr $Comp_I_GC * 100000000.000] 1;
element elasticBeamColumn  514400 1454  1462  100000.000  $E [expr $Comp_I_GC * 100000000.000] 1;
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
Spring_Zero 921501 215 2151; Spring_Zero 921601 216 2161; 
Spring_Zero 920503 205 2053; Spring_Zero 920603 206 2063; 
Spring_Zero 920501 205 2051; Spring_Zero 920601 206 2061; 
Spring_Zero 919503 195 1953; Spring_Zero 919603 196 1963; 
Spring_Zero 919501 195 1951; Spring_Zero 919601 196 1961; 
Spring_Zero 918503 185 1853; Spring_Zero 918603 186 1863; 
Spring_Zero 918501 185 1851; Spring_Zero 918601 186 1861; 
Spring_Zero 917503 175 1753; Spring_Zero 917603 176 1763; 
Spring_Zero 917501 175 1751; Spring_Zero 917601 176 1761; 
Spring_Zero 916503 165 1653; Spring_Zero 916603 166 1663; 
Spring_Zero 916501 165 1651; Spring_Zero 916601 166 1661; 
Spring_Zero 915503 155 1553; Spring_Zero 915603 156 1563; 
Spring_Zero 915501 155 1551; Spring_Zero 915601 156 1561; 
Spring_Zero 914503 145 1453; Spring_Zero 914603 146 1463; 
Spring_Zero 914501 145 1451; Spring_Zero 914601 146 1461; 
Spring_Zero 913503 135 1353; Spring_Zero 913603 136 1363; 
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
Spring_Pinching  921504  215   2154 40837.500 $gap 0; Spring_Pinching  921602  2162  216  40837.500 $gap 0; 
Spring_Pinching  920504  205   2054 40837.500 $gap 0; Spring_Pinching  920602  2062  206  40837.500 $gap 0; 
Spring_Pinching  919504  195   1954 40837.500 $gap 0; Spring_Pinching  919602  1962  196  40837.500 $gap 0; 
Spring_Pinching  918504  185   1854 40837.500 $gap 0; Spring_Pinching  918602  1862  186  40837.500 $gap 0; 
Spring_Pinching  917504  175   1754 40837.500 $gap 0; Spring_Pinching  917602  1762  176  40837.500 $gap 0; 
Spring_Pinching  916504  165   1654 40837.500 $gap 0; Spring_Pinching  916602  1662  166  40837.500 $gap 0; 
Spring_Pinching  915504  155   1554 40837.500 $gap 0; Spring_Pinching  915602  1562  156  40837.500 $gap 0; 
Spring_Pinching  914504  145   1454 40837.500 $gap 0; Spring_Pinching  914602  1462  146  40837.500 $gap 0; 
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
equalDOF 421104  421204  1; equalDOF 421104  421304  1; equalDOF 421104  421404  1; 
equalDOF 420104  420204  1; equalDOF 420104  420304  1; equalDOF 420104  420404  1; 
equalDOF 419104  419204  1; equalDOF 419104  419304  1; equalDOF 419104  419404  1; 
equalDOF 418104  418204  1; equalDOF 418104  418304  1; equalDOF 418104  418404  1; 
equalDOF 417104  417204  1; equalDOF 417104  417304  1; equalDOF 417104  417404  1; 
equalDOF 416104  416204  1; equalDOF 416104  416304  1; equalDOF 416104  416404  1; 
equalDOF 415104  415204  1; equalDOF 415104  415304  1; equalDOF 415104  415404  1; 
equalDOF 414104  414204  1; equalDOF 414104  414304  1; equalDOF 414104  414404  1; 
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
equalDOF  421101 	2111 1 2; equalDOF  421201 	2121 1 2; equalDOF  421301 	2131 1 2; equalDOF  421401 	2141 1 2; 
equalDOF  420103 	2013 1 2; equalDOF  420203 	2023 1 2; equalDOF  420303 	2033 1 2; equalDOF  420403 	2043 1 2; 
equalDOF  419103 	1913 1 2; equalDOF  419203 	1923 1 2; equalDOF  419303 	1933 1 2; equalDOF  419403 	1943 1 2; 
equalDOF  418103 	1813 1 2; equalDOF  418203 	1823 1 2; equalDOF  418303 	1833 1 2; equalDOF  418403 	1843 1 2; 
equalDOF  417103 	1713 1 2; equalDOF  417203 	1723 1 2; equalDOF  417303 	1733 1 2; equalDOF  417403 	1743 1 2; 
equalDOF  416103 	1613 1 2; equalDOF  416203 	1623 1 2; equalDOF  416303 	1633 1 2; equalDOF  416403 	1643 1 2; 
equalDOF  415103 	1513 1 2; equalDOF  415203 	1523 1 2; equalDOF  415303 	1533 1 2; equalDOF  415403 	1543 1 2; 
equalDOF  414103 	1413 1 2; equalDOF  414203 	1423 1 2; equalDOF  414303 	1433 1 2; equalDOF  414403 	1443 1 2; 
equalDOF  413103 	1313 1 2; equalDOF  413203 	1323 1 2; equalDOF  413303 	1333 1 2; equalDOF  413403 	1343 1 2; 
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
equalDOF  420101 	2011 1 2; equalDOF  420201 	2021 1 2; equalDOF  420301 	2031 1 2; equalDOF  420401 	2041 1 2; 
equalDOF  419101 	1911 1 2; equalDOF  419201 	1921 1 2; equalDOF  419301 	1931 1 2; equalDOF  419401 	1941 1 2; 
equalDOF  418101 	1811 1 2; equalDOF  418201 	1821 1 2; equalDOF  418301 	1831 1 2; equalDOF  418401 	1841 1 2; 
equalDOF  417101 	1711 1 2; equalDOF  417201 	1721 1 2; equalDOF  417301 	1731 1 2; equalDOF  417401 	1741 1 2; 
equalDOF  416101 	1611 1 2; equalDOF  416201 	1621 1 2; equalDOF  416301 	1631 1 2; equalDOF  416401 	1641 1 2; 
equalDOF  415101 	1511 1 2; equalDOF  415201 	1521 1 2; equalDOF  415301 	1531 1 2; equalDOF  415401 	1541 1 2; 
equalDOF  414101 	1411 1 2; equalDOF  414201 	1421 1 2; equalDOF  414301 	1431 1 2; equalDOF  414401 	1441 1 2; 
equalDOF  413101 	1311 1 2; equalDOF  413201 	1321 1 2; equalDOF  413301 	1331 1 2; equalDOF  413401 	1341 1 2; 
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
equalDOF  21140 	2114 1 2; equalDOF  21220 	2122 1 2; equalDOF  21240 	2124 1 2; equalDOF  21320 	2132 1 2; equalDOF  21340 	2134 1 2; equalDOF  21420 	2142 1 2; 
equalDOF  20140 	2014 1 2; equalDOF  20220 	2022 1 2; equalDOF  20240 	2024 1 2; equalDOF  20320 	2032 1 2; equalDOF  20340 	2034 1 2; equalDOF  20420 	2042 1 2; 
equalDOF  19140 	1914 1 2; equalDOF  19220 	1922 1 2; equalDOF  19240 	1924 1 2; equalDOF  19320 	1932 1 2; equalDOF  19340 	1934 1 2; equalDOF  19420 	1942 1 2; 
equalDOF  18140 	1814 1 2; equalDOF  18220 	1822 1 2; equalDOF  18240 	1824 1 2; equalDOF  18320 	1832 1 2; equalDOF  18340 	1834 1 2; equalDOF  18420 	1842 1 2; 
equalDOF  17140 	1714 1 2; equalDOF  17220 	1722 1 2; equalDOF  17240 	1724 1 2; equalDOF  17320 	1732 1 2; equalDOF  17340 	1734 1 2; equalDOF  17420 	1742 1 2; 
equalDOF  16140 	1614 1 2; equalDOF  16220 	1622 1 2; equalDOF  16240 	1624 1 2; equalDOF  16320 	1632 1 2; equalDOF  16340 	1634 1 2; equalDOF  16420 	1642 1 2; 
equalDOF  15140 	1514 1 2; equalDOF  15220 	1522 1 2; equalDOF  15240 	1524 1 2; equalDOF  15320 	1532 1 2; equalDOF  15340 	1534 1 2; equalDOF  15420 	1542 1 2; 
equalDOF  14140 	1414 1 2; equalDOF  14220 	1422 1 2; equalDOF  14240 	1424 1 2; equalDOF  14320 	1432 1 2; equalDOF  14340 	1434 1 2; equalDOF  14420 	1442 1 2; 
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
equalDOF  215 	2154 1 2; equalDOF  216 	2162 1 2; 
equalDOF  205 	2054 1 2; equalDOF  206 	2062 1 2; 
equalDOF  195 	1954 1 2; equalDOF  196 	1962 1 2; 
equalDOF  185 	1854 1 2; equalDOF  186 	1862 1 2; 
equalDOF  175 	1754 1 2; equalDOF  176 	1762 1 2; 
equalDOF  165 	1654 1 2; equalDOF  166 	1662 1 2; 
equalDOF  155 	1554 1 2; equalDOF  156 	1562 1 2; 
equalDOF  145 	1454 1 2; equalDOF  146 	1462 1 2; 
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
equalDOF  215 	2151 1 2; equalDOF  216 	2161 1 2; 
equalDOF  205 	2053 1 2; equalDOF  206 	2063 1 2; 
equalDOF  195 	1953 1 2; equalDOF  196 	1963 1 2; 
equalDOF  185 	1853 1 2; equalDOF  186 	1863 1 2; 
equalDOF  175 	1753 1 2; equalDOF  176 	1763 1 2; 
equalDOF  165 	1653 1 2; equalDOF  166 	1663 1 2; 
equalDOF  155 	1553 1 2; equalDOF  156 	1563 1 2; 
equalDOF  145 	1453 1 2; equalDOF  146 	1463 1 2; 
equalDOF  135 	1353 1 2; equalDOF  136 	1363 1 2; 
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
equalDOF  205 	2051 1 2; equalDOF  206 	2061 1 2; 
equalDOF  195 	1951 1 2; equalDOF  196 	1961 1 2; 
equalDOF  185 	1851 1 2; equalDOF  186 	1861 1 2; 
equalDOF  175 	1751 1 2; equalDOF  176 	1761 1 2; 
equalDOF  165 	1651 1 2; equalDOF  166 	1661 1 2; 
equalDOF  155 	1551 1 2; equalDOF  156 	1561 1 2; 
equalDOF  145 	1451 1 2; equalDOF  146 	1461 1 2; 
equalDOF  135 	1351 1 2; equalDOF  136 	1361 1 2; 
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
recorder Drift -file $MainFolder/$SubFolder/SDR_MRF20.out  -iNode 420104 -jNode 421104 -dof 1 -perpDirn 2; 
recorder Drift -file $MainFolder/$SubFolder/SDR_MRF19.out  -iNode 419104 -jNode 420104 -dof 1 -perpDirn 2; 
recorder Drift -file $MainFolder/$SubFolder/SDR_MRF18.out  -iNode 418104 -jNode 419104 -dof 1 -perpDirn 2; 
recorder Drift -file $MainFolder/$SubFolder/SDR_MRF17.out  -iNode 417104 -jNode 418104 -dof 1 -perpDirn 2; 
recorder Drift -file $MainFolder/$SubFolder/SDR_MRF16.out  -iNode 416104 -jNode 417104 -dof 1 -perpDirn 2; 
recorder Drift -file $MainFolder/$SubFolder/SDR_MRF15.out  -iNode 415104 -jNode 416104 -dof 1 -perpDirn 2; 
recorder Drift -file $MainFolder/$SubFolder/SDR_MRF14.out  -iNode 414104 -jNode 415104 -dof 1 -perpDirn 2; 
recorder Drift -file $MainFolder/$SubFolder/SDR_MRF13.out  -iNode 413104 -jNode 414104 -dof 1 -perpDirn 2; 
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
recorder Node -file $MainFolder/$SubFolder/RFA_MRF21.out  -node 421103 -dof 1 accel;
recorder Node -file $MainFolder/$SubFolder/RFA_MRF20.out  -node 420103 -dof 1 accel;
recorder Node -file $MainFolder/$SubFolder/RFA_MRF19.out  -node 419103 -dof 1 accel;
recorder Node -file $MainFolder/$SubFolder/RFA_MRF18.out  -node 418103 -dof 1 accel;
recorder Node -file $MainFolder/$SubFolder/RFA_MRF17.out  -node 417103 -dof 1 accel;
recorder Node -file $MainFolder/$SubFolder/RFA_MRF16.out  -node 416103 -dof 1 accel;
recorder Node -file $MainFolder/$SubFolder/RFA_MRF15.out  -node 415103 -dof 1 accel;
recorder Node -file $MainFolder/$SubFolder/RFA_MRF14.out  -node 414103 -dof 1 accel;
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
mass 421103 0.2888  1.e-9 1.e-9; mass 421203 0.2888  1.e-9 1.e-9; mass 421303 0.2888  1.e-9 1.e-9; mass 421403 0.2888  1.e-9 1.e-9; mass 215 0.2888  1.e-9 1.e-9; mass 216 0.2888  1.e-9 1.e-9; 
mass 420103 0.3056  1.e-9 1.e-9; mass 420203 0.3056  1.e-9 1.e-9; mass 420303 0.3056  1.e-9 1.e-9; mass 420403 0.3056  1.e-9 1.e-9; mass 205 0.3056  1.e-9 1.e-9; mass 206 0.3056  1.e-9 1.e-9; 
mass 419103 0.3056  1.e-9 1.e-9; mass 419203 0.3056  1.e-9 1.e-9; mass 419303 0.3056  1.e-9 1.e-9; mass 419403 0.3056  1.e-9 1.e-9; mass 195 0.3056  1.e-9 1.e-9; mass 196 0.3056  1.e-9 1.e-9; 
mass 418103 0.3056  1.e-9 1.e-9; mass 418203 0.3056  1.e-9 1.e-9; mass 418303 0.3056  1.e-9 1.e-9; mass 418403 0.3056  1.e-9 1.e-9; mass 185 0.3056  1.e-9 1.e-9; mass 186 0.3056  1.e-9 1.e-9; 
mass 417103 0.3056  1.e-9 1.e-9; mass 417203 0.3056  1.e-9 1.e-9; mass 417303 0.3056  1.e-9 1.e-9; mass 417403 0.3056  1.e-9 1.e-9; mass 175 0.3056  1.e-9 1.e-9; mass 176 0.3056  1.e-9 1.e-9; 
mass 416103 0.3056  1.e-9 1.e-9; mass 416203 0.3056  1.e-9 1.e-9; mass 416303 0.3056  1.e-9 1.e-9; mass 416403 0.3056  1.e-9 1.e-9; mass 165 0.3056  1.e-9 1.e-9; mass 166 0.3056  1.e-9 1.e-9; 
mass 415103 0.3056  1.e-9 1.e-9; mass 415203 0.3056  1.e-9 1.e-9; mass 415303 0.3056  1.e-9 1.e-9; mass 415403 0.3056  1.e-9 1.e-9; mass 155 0.3056  1.e-9 1.e-9; mass 156 0.3056  1.e-9 1.e-9; 
mass 414103 0.3056  1.e-9 1.e-9; mass 414203 0.3056  1.e-9 1.e-9; mass 414303 0.3056  1.e-9 1.e-9; mass 414403 0.3056  1.e-9 1.e-9; mass 145 0.3056  1.e-9 1.e-9; mass 146 0.3056  1.e-9 1.e-9; 
mass 413103 0.3056  1.e-9 1.e-9; mass 413203 0.3056  1.e-9 1.e-9; mass 413303 0.3056  1.e-9 1.e-9; mass 413403 0.3056  1.e-9 1.e-9; mass 135 0.3056  1.e-9 1.e-9; mass 136 0.3056  1.e-9 1.e-9; 
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
set T13 [expr 2.0*$pi/$w13];
set T14 [expr 2.0*$pi/$w14];
set T15 [expr 2.0*$pi/$w15];
set T16 [expr 2.0*$pi/$w16];
set T17 [expr 2.0*$pi/$w17];
set T18 [expr 2.0*$pi/$w18];
set T19 [expr 2.0*$pi/$w19];
set T20 [expr 2.0*$pi/$w20];
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
load 421103 0. -34.969 0.; load 421203 0. -23.312 0.; load 421303 0. -23.312 0.; load 421403 0. -34.969 0.; 
load 420103 0. -42.337 0.; load 420203 0. -28.225 0.; load 420303 0. -28.225 0.; load 420403 0. -42.337 0.; 
load 419103 0. -42.337 0.; load 419203 0. -28.225 0.; load 419303 0. -28.225 0.; load 419403 0. -42.337 0.; 
load 418103 0. -42.337 0.; load 418203 0. -28.225 0.; load 418303 0. -28.225 0.; load 418403 0. -42.337 0.; 
load 417103 0. -42.337 0.; load 417203 0. -28.225 0.; load 417303 0. -28.225 0.; load 417403 0. -42.337 0.; 
load 416103 0. -42.337 0.; load 416203 0. -28.225 0.; load 416303 0. -28.225 0.; load 416403 0. -42.337 0.; 
load 415103 0. -42.337 0.; load 415203 0. -28.225 0.; load 415303 0. -28.225 0.; load 415403 0. -42.337 0.; 
load 414103 0. -42.337 0.; load 414203 0. -28.225 0.; load 414303 0. -28.225 0.; load 414403 0. -42.337 0.; 
load 413103 0. -42.337 0.; load 413203 0. -28.225 0.; load 413303 0. -28.225 0.; load 413403 0. -42.337 0.; 
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
load 215 0. -310.443794 0.; load 216 0. -310.443794 0.; 
load 205 0. -344.887107 0.; load 206 0. -344.887107 0.; 
load 195 0. -344.887107 0.; load 196 0. -344.887107 0.; 
load 185 0. -344.887107 0.; load 186 0. -344.887107 0.; 
load 175 0. -344.887107 0.; load 176 0. -344.887107 0.; 
load 165 0. -344.887107 0.; load 166 0. -344.887107 0.; 
load 155 0. -344.887107 0.; load 156 0. -344.887107 0.; 
load 145 0. -344.887107 0.; load 146 0. -344.887107 0.; 
load 135 0. -344.887107 0.; load 136 0. -344.887107 0.; 
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

puts "Seismic Weight = 16530.8 kip";
puts "Seismic Mass = 36.6 kip.sec2/in";

if {$Animation == 1} {
	DisplayModel3D DeformedShape 5 50 50  2000 1500
}

###################################################################################################
#                                        Pushover Analysis                       		          #
###################################################################################################

if {$PO==1} {

	# Create Load Pattern
	pattern Plain 222 Linear {
	load 421103 0.26921 0.0 0.0
	load 420103 0.25890 0.0 0.0
	load 419103 0.24785 0.0 0.0
	load 418103 0.23663 0.0 0.0
	load 417103 0.22410 0.0 0.0
	load 416103 0.21096 0.0 0.0
	load 415103 0.19732 0.0 0.0
	load 414103 0.18313 0.0 0.0
	load 413103 0.16859 0.0 0.0
	load 412103 0.15399 0.0 0.0
	load 411103 0.13907 0.0 0.0
	load 410103 0.12402 0.0 0.0
	load 409103 0.10870 0.0 0.0
	load 408103 0.09345 0.0 0.0
	load 407103 0.07836 0.0 0.0
	load 406103 0.06366 0.0 0.0
	load 405103 0.04920 0.0 0.0
	load 404103 0.03497 0.0 0.0
	load 403103 0.02113 0.0 0.0
	load 402103 0.00882 0.0 0.0
	}

	# Displacement Control Parameters
	set CtrlNode 421104;
	set CtrlDOF 1;
	set Dmax [expr 0.100*$Floor21];
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
	region 1 -eleRange  502100  620400 -rayleigh 0.0 0.0 $a1_mod 0.0;
	region 2 -node  402103 402203 402303 402403 102500 102600 403103 403203 403303 403403 103500 103600 404103 404203 404303 404403 104500 104600 405103 405203 405303 405403 105500 105600 406103 406203 406303 406403 106500 106600 407103 407203 407303 407403 107500 107600 408103 408203 408303 408403 108500 108600 409103 409203 409303 409403 109500 109600 410103 410203 410303 410403 110500 110600 411103 411203 411303 411403 111500 111600 412103 412203 412303 412403 112500 112600 413103 413203 413303 413403 113500 113600 414103 414203 414303 414403 114500 114600 415103 415203 415303 415403 115500 115600 416103 416203 416303 416403 116500 116600 417103 417203 417303 417403 117500 117600 418103 418203 418303 418403 118500 118600 419103 419203 419303 419403 119500 119600 420103 420203 420303 420403 120500 120600 421103 421203 421303 421403 121500 121600  -rayleigh $a0 0.0 0.0 0.0;

	# GROUND MOTION ACCELERATION FILE INPUT
	set AccelSeries "Series -dt $dt -filePath $GMfile -factor  [expr $EqScale* $g]"
	pattern UniformExcitation  200 1 -accel $AccelSeries

	set SMFFloorNodes [list  402104 403104 404104 405104 406104 407104 408104 409104 410104 411104 412104 413104 414104 415104 416104 417104 418104 419104 420104 421104 ];
	DynamicAnalysisCollapseSolver   $dt	$dtAnalysis	$totTime $NStory	0.15   $SMFFloorNodes	180.00 156.00;

	puts "Ground Motion Done. End Time: [getTime]"
}

wipe all;
