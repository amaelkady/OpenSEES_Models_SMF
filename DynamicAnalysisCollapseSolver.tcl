
# DynamicAnalysisCollapseSolver #########################################################
#
# This Solver is used to solve convergence issues by alternatinf between solvers and time 
# increments
#
# Written by Dimitrios G. Lignos, Ph.D
# Modified by Ahmed Elkady, Ph.D
#
# First Created: 04/20/2010
# Last Modified: 08/23/2011
#
# Input Arguments:
#   dt            : Ground Motion step
#   dt_anal_Step  : Analysis time step
#   GMtime        : Ground motion total time
#   numStories    : Number of stories
#   DriftLimit    : Drift limit for collapse
#   FloorNodes    : List of floor nodes 
#   h1    		  : First-story height
#   htyp    	  : Typical story height
# 
#########################################################################################

proc DynamicAnalysisCollapseSolver {dt dt_anal_Step GMtime numStories DriftLimit FloorNodes h1 htyp} {

global CollapseFlag;                        # global variable to monitor collapse
global nIterationsFlag;                     # global variable to monitor number of iterations
global IterationCounter;
set IterationCounter 1;
set CollapseFlag "NO"
set nIterationsFlag "NO"
source MaxDriftTester.tcl;

wipeAnalysis

constraints Plain
numberer RCM
system UmfPack
test EnergyIncr 1.0e-3 100
algorithm KrylovNewton
integrator Newmark 0.50 0.25
analysis Transient

set NumSteps [expr round($GMtime/$dt_anal_Step)];	# number of steps in analysis
set ok [analyze $NumSteps $dt_anal_Step];

# Check Max Drifts for Collapse by Monitoring the CollapseFlag Variable
MaxDriftTester $numStories $DriftLimit $FloorNodes $h1 $htyp

if  {$nIterationsFlag == "YES"} {
	puts "----> Too many iterations. Stoping Analysis!";
}


if  {$CollapseFlag == "YES"} {
	set ok 0
	puts "----> Collapse Occured";
}

# If analysis failed
if {$ok != 0} {
	puts "----> Analysis did not converge..."
	# The analysis will be time-controlled and is done for the remaining time
	set ok 0;
	set controlTime [getTime];
	
	# While the GM did not finish OR while analysis is failing
	while {$controlTime < $GMtime || $ok !=0 } {
		MaxDriftTester $numStories $DriftLimit $FloorNodes $h1 $htyp
		if  {$CollapseFlag == "YES"} {
			set ok 0; break;
		} else {
			set ok 1
		}		
	    # Get Control Time inside the loop
		set controlTime [getTime]
		puts "----> Currently at time $controlTime out of $GMtime"

		if {$ok != 0} {
			puts "----> Run Newton 100 steps with 1/2 of step.."
			set controlTime [getTime]
			set remainTime [expr $GMtime - $controlTime]
			set NewRemainSteps [expr round(($remainTime)/($dt_anal_Step/2.0))]

			test EnergyIncr 1.0e-3 100   0
			algorithm KrylovNewton
			integrator Newmark 0.50 0.25
			set ok [analyze 10 [expr $dt_anal_Step/2.0]]
			MaxDriftTester $numStories $DriftLimit $FloorNodes $h1 $htyp
			if  {$CollapseFlag == "YES"} {
				set ok 0
			}
		}
		if {$ok != 0 } {		
			puts "----> Go Back to KrylovNewton with tangent Tangent and original step.."
			test EnergyIncr 1.0e-2 100   0
			set controlTime [getTime]
			set remainTime [expr $GMtime - $controlTime]
			set NewRemainSteps [expr round(($remainTime)/($dt_anal_Step))]
			
			algorithm KrylovNewton
			integrator Newmark 0.50 0.25
			set ok [analyze $NewRemainSteps [expr $dt_anal_Step]]
			MaxDriftTester $numStories $DriftLimit $FloorNodes  $h1 $htyp
			if  {$CollapseFlag == "YES"} {
				set ok 0
			}
		}
		if {$ok != 0 } {
			puts "----> Run 10 steps KrylovNewton with Initial Tangent with 1/2 of original step.."
			test EnergyIncr 1.0e-2 200 0			
			set controlTime [getTime]
			set remainTime [expr $GMtime - $controlTime]
			set NewRemainSteps [expr round(($remainTime)/($dt_anal_Step/2.0))]
			algorithm KrylovNewton -initial
			set ok [analyze 10 [expr $dt_anal_Step/2.0]]
			MaxDriftTester $numStories $DriftLimit $FloorNodes  $h1 $htyp
			if  {$CollapseFlag == "YES"} {
				set ok 0
			}
		}
		if {$ok != 0 } {			
			puts "----> Go Back to KrylovNewton with tangent Tangent and original step.."
			test EnergyIncr 1.0e-2 100   0
			set controlTime [getTime]
			set remainTime [expr $GMtime - $controlTime]
			set NewRemainSteps [expr round(($remainTime)/($dt_anal_Step))]
			algorithm KrylovNewton
			integrator Newmark 0.50 0.25
			set ok [analyze $NewRemainSteps [expr $dt_anal_Step]]
			MaxDriftTester $numStories $DriftLimit $FloorNodes  $h1 $htyp
			if  {$CollapseFlag == "YES"} {
				set ok 0
			}
		}				

		if {$ok != 0 } {			
			puts "Go Back to KrylovNewton with tangent Tangent and 0.001 step.."
			test EnergyIncr 1.0e-1 20   0
			set controlTime [getTime]
			set remainTime [expr $GMtime - $controlTime]
			set NewRemainSteps [expr round(($remainTime)/(0.001))]
			algorithm KrylovNewton
			integrator Newmark 0.50 0.25
			set ok [analyze $NewRemainSteps [expr 0.001]]
			MaxDriftTester $numStories $DriftLimit $FloorNodes  $h1 $htyp
			if  {$CollapseFlag == "YES"} {
				set ok 0
			}
		}				
		if {$ok != 0 } {
			puts "----> KrylovNewton Initial with 1/2 of step and Displacement Control Convergence.."
			test EnergyIncr 1.0e-1 50  0
			algorithm KrylovNewton -initial
			set ok [analyze 10 [expr $dt_anal_Step/2.0]]
			MaxDriftTester $numStories $DriftLimit $FloorNodes  $h1 $htyp
			if  {$CollapseFlag == "YES"} {
				set ok 0
			}
		}
		if {$ok != 0 } {			
			puts "----> Go Back to KrylovNewton with tangent Tangent and 0.0001 step.."
			test EnergyIncr 1.0e-2 100   0
			set controlTime [getTime]
			set remainTime [expr $GMtime - $controlTime]
			set NewRemainSteps [expr round(($remainTime)/(0.0001))]
			algorithm KrylovNewton
			integrator Newmark 0.50 0.25
			set ok [analyze 5 [expr 0.0001]]
			MaxDriftTester $numStories $DriftLimit $FloorNodes  $h1 $htyp
			if  {$CollapseFlag == "YES"} {
				set ok 0
			}
		}		

		if {$ok != 0 } {			
			puts "----> Go Back to KrylovNewton with tangent Tangent and original step.."
			test EnergyIncr 1.0e-2 100   0
			set controlTime [getTime]
			set remainTime [expr $GMtime - $controlTime]
			set NewRemainSteps [expr round(($remainTime)/($dt_anal_Step))]
			algorithm KrylovNewton
			integrator Newmark 0.50 0.25
			set ok [analyze $NewRemainSteps [expr $dt_anal_Step]]
			MaxDriftTester $numStories $DriftLimit $FloorNodes $h1 $htyp
			if  {$CollapseFlag == "YES"} {
				set ok 0
			}
		}		
		if {$ok != 0 } {
			puts "----> Newton with Fixed Number of Iteratios else continue"
			set controlTime [getTime]
			set remainTime [expr $GMtime - $controlTime]
			set NewRemainSteps [expr round(($remainTime)/(0.0001))]
			puts $NewRemainSteps
			test FixedNumIter 50
			integrator NewmarkHSFixedNumIter 0.5 0.25

			algorithm Newton

			set ok [analyze 10 [expr 0.0001]]
			MaxDriftTester $numStories $DriftLimit $FloorNodes $h1 $htyp
			if  {$CollapseFlag == "YES"} {
				set ok 0
			}			
		}
		
		set controlTime [getTime]		
	}
 }
}