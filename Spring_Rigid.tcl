########################################################################################################
# Spring_Zero.tcl 
#                                    
# SubRoutine to model a rigid springs between 2 nodes
#
# Input Arguments
# 	SpringID		Spring ID
# 	Node_i			Node i ID
# 	Node_j			Node j ID
#
# Written by: Ahmed Elkady 
#
########################################################################################################

proc Spring_Rigid {SpringID Node_i Node_j} {

element zeroLength $SpringID  $Node_i $Node_j -mat 99 99 99 -dir 1 2 6;

}