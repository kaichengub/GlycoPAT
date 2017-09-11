function [tSpan,speciesConc,speciesName]=glycanDSim(glycanNMObj,ODEmfileName, endTime,nSteps,varargin)
%glycanDSim simulate the glycosylation reaction network at various time points
%   
% [tSpan,speciesConc,speciesName]=glycanDSim(glycanNMObj,ODEmfileName,
%  endTime,nSteps,options) simulates the dynamics of glycosylation
%  reaction networks using MATLAB build-in ode15s algorithm. The input glycanNMObj is 
%  the model to simulate, ODEmfileName is the ODE file that need to be generated 
%  using SBML toolbox function WriteODEFunction, endTime and nSteps are the ending time 
%  and the number of time points for the simulation. Options can be provided using the odeset 
%  command. See optimset and ode15s for details. 
%
% [tSpan,speciesConc,speciesName]=glycanDSim(glycanNMObj,ODEmfileName,
%  endTime,nSteps)  use default options. See odeset for default options.
%    
% Example:  
%  testGlycanNetSBMLfileName ='gnat_test_wtannot.xml';
%  testGlycanNetModel= glycanNetSBMLread(testGlycanNetSBMLfileName);
%  % write out ODE function for simulation
%  if(isempty(testGlycanNetModel.glycanNet_sbmlmodel.name))
%   exampleODEFileName = testGlycanNetModel.glycanNet_sbmlmodel.id ;
%  else
%   exampleODEFileName = testGlycanNetModel.glycanNet_sbmlmodel.name ;
%  end
%  if(exist(strcat(exampleODEFileName,'.m'),'file')==2) 
%    WriteODEFunction(testGlycanNetModel.glycanNet_sbmlmodel,exampleODEFileName);
%  end
%  endTime =10;
%  tsteps =100;
%  rehash toolboxcache;
%  [tSpan, speciesconc, speciesname] = glycanDSim(testGlycanNetModel,exampleODEFileName,endTime,tsteps);
%  plot(tSpan, speciesconc); legend(speciesname);
%  xlabel('Time','fontsize',11,'fontweight','b');
%  ylabel('Concentration','fontsize',11,'fontweight','b');
%
% See also GlycanNetModel,glycanSSim.

% Author: Gang Liu
% Copyright 2012 Neelamegham Lab

% input number check
if(~verLessThan('matlab','7.13'))
    narginchk(3,5);
else
    error(nargchk(3,5,nargin));
end

glycanNet_SBMLStruct = glycanNMObj.glycanNet_sbmlmodel;
if(isempty(glycanNet_SBMLStruct))
    glycanNet_SBMLStruct = glycanNMObj.GlycanNetModel2SBMLStruct;
end

% retrieve species name for the list
nSpecies =  length(glycanNet_SBMLStruct.species);
speciesName = cell(nSpecies,1);
for i=1: nSpecies
    if(~isempty( glycanNet_SBMLStruct.species(1,i).name))
       speciesName{i,1} = glycanNet_SBMLStruct.species(1,i).name;
    else
       speciesName{i,1} = glycanNet_SBMLStruct.species(1,i).id; 
    end
end



% write M file for ODE simulation
% ODEmfileName = [ODEmfileName '.m'];
if(exist(ODEmfileName,'file')~=2)
    WriteODEFunction(glycanNet_SBMLStruct,ODEmfileName);
end

ODEmfileHandle = str2func(strrep(ODEmfileName,'.m',''));

interval = endTime/nSteps;
tspan = [0:interval:endTime];

if(length(varargin)==1)
    options = varargin{1};
    [tSpan,speciesConc]= ode15s(ODEmfileHandle,tspan,ODEmfileHandle(),options);
else
    [tSpan,speciesConc]= ode15s(ODEmfileHandle,tspan,ODEmfileHandle());    
end






