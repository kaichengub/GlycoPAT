function [exitflag, speciesConc,speciesName,funceval]=glycanSSim(glycanNMObj,ODEmfileName, varargin)
%glycanSSim simulate glycosylation reaction network model under steady state 
%
% [exitflag, speciesConc,speciesName,funceval]=glycanSSim(glycanNMObj,ODEmfileName,options) 
%  takes GlycanNetModel object, ODEFunction file to simulate the system under steady states using 
%  fsolve function provided by MATLAB. Options can be provided using the optimset command. See 
%  optimset and fsolve for details. 
%
% glycanSSim(glycanNMObj,ODEmfileName) uses default options. The iterative steps will show in the 
%  command windows,and the algorithm used to solve equations is levenberg-marquardt methods. 
%  See optimset for other default options. 
%
% Example : 
%  testGlycanNetSBMLfileName ='gnat_test_ssim.xml';
%  testGlycanNetModel= glycanNetSBMLread(testGlycanNetSBMLfileName);
%  % write out ODE function for simulation
%  if(isempty(testGlycanNetModel.glycanNet_sbmlmodel.name))
%   exampleODEFileName = testGlycanNetModel.glycanNet_sbmlmodel.id ;
%  else
%   exampleODEFileName = testGlycanNetModel.glycanNet_sbmlmodel.name ;
%  end 
%  if(~(exist(strcat(exampleODEFileName,'.m'),'file')==2))
%   WriteODEFunction(testGlycanNetModel.glycanNet_sbmlmodel,exampleODEFileName);
%  end
%  [exitflag, speciesconc, speciesnames,funceval] = glycanSSim(testGlycanNetModel,exampleODEFileName);
%    %To see simulation result in plot, type:
%  bar(speciesconc);
%  set(gca,'Xtick',1:4,'XTickLabel',speciesnames); 
%
% See also GlycanNetModel,glycanDSim.

% Author: Gang Liu
% Copyright 2012 Neelamegham Lab

glycanNet_SBMLStruct = glycanNMObj.glycanNet_sbmlmodel;
if(isempty(glycanNet_SBMLStruct))
    glycanNet_SBMLStruct = glycanNMObj.GlycanNetModel2SBMLStruct;
end

% retrieve species name for the list
nSpecies =  length(glycanNet_SBMLStruct.species);
speciesName = cell(nSpecies,1);
for i=1: nSpecies
    if(~isempty(glycanNet_SBMLStruct.species(1,i).name))
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

% create an anoymous function for fsolve 
ODEmfileHandle = str2func(strrep(ODEmfileName,'.m',''));
fsolvefun = @(x) ODEmfileHandle(1,x);
x0 = ODEmfileHandle();

if(length(varargin)==1)
    options = varargin{1};
    [speciesConc funceval exitflag]= fsolve(fsolvefun,x0,options);
else
    options=optimset('Display','iter','Algorithm',{'levenberg-marquardt',0.01}); 
     [speciesConc funceval exitflag]=fsolve(fsolvefun,x0,options);
end
% if(length(nargout)==4)
%     varargout(1)=funceval;
% end







