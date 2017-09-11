function xdot = LinearNLINKMODEL(time, x_values)
% function LinearNLINKMODEL takes
%
% either	1) no arguments
%       	    and returns a vector of the initial values
%
% or    	2) time - the elapsed time since the beginning of the reactions
%       	   x_values    - vector of the current values of the variables
%       	    and returns a vector of the rate of change of value of each of the variables
%
% LinearNLINKMODEL can be used with MATLABs odeN functions as 
%
%	[t,x] = ode23(@LinearNLINKMODEL, [0, t_end], LinearNLINKMODEL)
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

k1_reaction_1 = 0.3;
k2_reaction_2 = 0.2;
k3_reaction_3 = 0.2;

%--------------------------------------------------------
% initial values of variables - these may be overridden by assignment rules
% NOTE: any use of initialAssignments has been considered in calculating the initial values

if (nargin == 0)

	% initial time
	time = 0;

	% initial values
	M9 = 20;
	M8 = 10;
	M7 = 5;
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
	xdot(1) = 20;
	xdot(2) = 10;
	xdot(3) = 5;
	xdot(4) = 0;

else

	% rate equations
	xdot(1) = ( - (k1_reaction_1*M9))/compartmentOne;
	xdot(2) = ( + (k1_reaction_1*M9) - (k2_reaction_2*M8))/compartmentOne;
	xdot(3) = ( + (k2_reaction_2*M8) - (k3_reaction_3*M7))/compartmentOne;
	xdot(4) = ( + (k3_reaction_3*M7))/compartmentOne;

end;
