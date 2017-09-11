%% GNAT Demo 1 
% This short demo contains four parts as below. 
% 1.  Network Simulation
% 2.  Database Connection
% 3.  Glycan Visualization
% 4.  Network Visualization

%% Dynamic Simulation of Glycosylation Reaction Network
% Simulation of glycosylation reaction network model can be implemented using   
%  glycanDSim function. 

glycanNetExampleFileName = 'gnat_test_wtannot.xml';
glycanNetModelObj = glycanNetSBMLread(glycanNetExampleFileName);

% write out ODE function for simulation
if(isempty(glycanNetModelObj.glycanNet_sbmlmodel.name))
    exampleODEFileName = glycanNetModelObj.glycanNet_sbmlmodel.id ;
else
    exampleODEFileName = glycanNetModelObj.glycanNet_sbmlmodel.name ;
end

if(exist(exampleODEFileName,'file')~=2)    
  WriteODEFunction(glycanNetModelObj.glycanNet_sbmlmodel,exampleODEFileName);
end


% simulation
endTime =10;
tsteps =100;
rehash toolboxcache;
[tspan, speciesConc, speciesnames] = glycanDSim(glycanNetModelObj,exampleODEFileName,endTime, tsteps);

figure;
for i=1:length(speciesnames);
    plot(tspan,speciesConc);
end  
xlabel('Time');
ylabel('Concentration');
legend(speciesnames);


%% Database Connection
% Query of GlycomeDB database will return the information about species reference, species information, 
% the  NCBI ID and its reference information: the database IDs reported in other databases
% and the glycan sequence information.
% queryCFGDB returns information about the database IDs reported in two other databases, 
% summary of the glycan including family, mole weight, composition,
% the glycan sequence information and the reference

queryResult = queryGlycomeDB('244'); 
fn_structdisp(queryResult);

queryResult = queryCFGDB('carbOlink_48280_D000');
fn_structdisp(queryResult);

%% Visualize Glycan Structure
% Glycan structure can be visualized using glycanFileViewer function.
glycanFileViewer('highmannose.glycoct_xml');
gDispOption1 = displayset('showmass',true,'showLinkage',true,'showRedEnd',true);
glycanFileViewer('highmannose.glycoct_xml','glycoct_xml',gDispOption1);

%% Visualize Network
% Glycosylation reaction network can be viewed using
% glycanNetFileViewer. 
glycanNetFileViewer('gnat_test_wtannot.xml');
