function xdot = ssimModelExample(time, x_values)
% function ssimModelExample takes
%
% either	1) no arguments
%       	    and returns a vector of the initial values
%
% or    	2) time - the elapsed time since the beginning of the reactions
%       	   x_values    - vector of the current values of the variables
%       	    and returns a vector of the rate of change of value of each of the variables
%
% ssimModelExample can be used with MATLABs odeN functions as 
%
%	[t,x] = ode23(@ssimModelExample, [0, t_end], ssimModelExample)
%
%			where  t_end is the end time of the simulation
%
%The variables in this model are related to the output vectors with the following indices
%	Index	Variable name
%	  1  	  M9
%	  2  	  M8
%	  3  	  M7
%	  4  	  M6
%
%--------------------------------------------------------
% output vector

xdot = zeros(4, 1);

%--------------------------------------------------------
% compartment values

compartmentOne = 1;

%--------------------------------------------------------
% parameter values

k1_reaction_1 = 2;
k2_reaction_2 = 3;
k3_reaction_3 = 4;
k4_reaction_4 = 2.5;
k5_reaction_5 = 10;

%--------------------------------------------------------
% initial values of variables - these may be overridden by assignment rules
% NOTE: any use of initialAssignments has been considered in calculating the initial values

if (nargin == 0)

	% initial time
	time = 0;

	% initial values
	M9 = 0;
	M8 = 0;
	M7 = 0;
	M6 = 0;

else
	% floating variable values
	M9 = x_values(1);
	M8 = x_values(2);
	M7 = x_values(3);
	M6 = x_values(4);

end;

%--------------------------------------------------------
% assignment rules

%--------------------------------------------------------
% algebraic rules

%--------------------------------------------------------
% calculate concentration values

if (nargin == 0)

	% initial values
	xdot(1) = 0;
	xdot(2) = 0;
	xdot(3) = 0;
	xdot(4) = 0;

else

	% rate equations
	xdot(1) = ( - (k1_reaction_1*M9) + (k5_reaction_5))/compartmentOne;
	xdot(2) = ( + (k1_reaction_1*M9) - (k2_reaction_2*M8))/compartmentOne;
	xdot(3) = ( + (k2_reaction_2*M8) - (k3_reaction_3*M7))/compartmentOne;
	xdot(4) = ( + (k3_reaction_3*M7) - (k4_reaction_4*M6))/compartmentOne;

end;
