function [status,tspan,speciesconc]=cstrdsim(stoichi,rate,speciesInFlowRate,speciesOutFlowRate,speciesInitC)
% cstrdsim simulate the CSTR reaction under non-steady states
%
%  [status,tspan,speciesconc]=cstrdsim(stoichi,rate,speciesInFlowRate,speciesOutFlowRate,speciesInitC)
%
%
%

% Author: Gang Liu
% Date:  6/7 /2012
% CopyRight: 2012 Neelamegham Lab
  



end

function dcdt=dcdtcstr(t,x)
    dcdt = stoichi*rate-speciesInFlowRate+speciesOutFlowRate;
end



