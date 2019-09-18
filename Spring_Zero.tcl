########################################################################################################
# Spring_Zero.tcl 
#                                    
# SubRoutine to model a rotational spring with zero stiffness
#
# Input  Arguments
# 	SpringID		Spring ID
# 	Node_i			Node i ID
# 	Node_j			Node j ID
#
# Written by: Ahmed Elkady 
#
########################################################################################################

proc Spring_Zero {SpringID Node_i Node_j} {

element zeroLength $SpringID  $Node_i $Node_j -mat 9 -dir 6;

}