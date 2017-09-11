%% GNAT Demo 2
% This demo shows how to import, visualize and simulate the N-glycosylation reaction
% network proposed by Umana et al. (Biotech Bioeng, 55:890, 1997). 
% This is a bottom-up modeling and visualization example simulated using GNAT. 

%% Read Bailey Model from SBML 
% We start this demo by reading the relevant SBML file using glycanNetSBMLread.
% UB1997Model is the resulting GlycanNetModel object. This command will
% take a few moments. Please wait.
baileyModelSBMLfileName = 'ub1997.xml';
UB1997Model = glycanNetSBMLread(baileyModelSBMLfileName);

%% Display Model Summary
% Below we show how to display the summary of the model using get methods
% including the number of species, the number of reactions, and the 
% number of compartments.

fprintf(1,'Model summary: \n');
fprintf(1,'Name of the model is  %s\n',UB1997Model.getName);
fprintf(1,'The number of reactions    is %i \n',UB1997Model.getGlycanPathway.getNReactions);
fprintf(1,'The number of species      is %i \n',UB1997Model.getGlycanPathway.getNSpecies);
fprintf(1,'The number of compartments is %i\n',UB1997Model.getCompartment.length);

%% Structure Visualization
% Next, we show two ways to display the structure of the 32nd glycan in the species list  
ithNum = 32;
ithSpeciesStruct = UB1997Model.getGlycanPathway.getGlycanStruct(ithNum);
glycanViewer(ithSpeciesStruct);
gDispOption1 = displayset('showmass',true,'showLinkage',true,'showRedEnd',true);
glycanJavaObj =  ithSpeciesStruct.structMat2Java;
glycanViewer(glycanJavaObj,gDispOption1);

%% Network Visualization
% We show how to display the glycosylation reaction network using glycanNetFileViewer.
% Only the first compartment is shown first for the sake of simplicity. This
% takes a few moments. Then, visualization of
% glycosylation networks in multiple compartments is also shown below. 
options = displayset('showRedEnd',false,'showLinkage',false,'NetLayout','hierarchical');
glycanNetViewer(UB1997Model,options,0);
options=displayset('NetFitToFrame',true,'NetLayout','CompactTree'); 
options=displayset(options,'NetFrameHeight',800,'NetFrameWidth',600); 
glycanNetViewer(UB1997Model,options); 

%% Simulation 
% Below, we show how to simulate the glycosylation reaction network using glycanDSim  
% Note that the current version of glycanDSim uses ode15s to simulate
% the reaction network. This function does not support multicompartment model yet.
% Thus, we write a custom function to convert the model to a single
% compartment including the transport events. 
UB1997Model.glycanNet_sbmlmodel = convertToSingleCompt(UB1997Model.glycanNet_sbmlmodel);
ubODEFileName = regexprep(UB1997Model.glycanNet_sbmlmodel.name,'.m','');  
ubODEFileName = [ubODEFileName '.m'];
if(exist(ubODEFileName,'file')~=2)
   WriteODEFunction(UB1997Model.glycanNet_sbmlmodel,ubODEFileName);
end

% set up inputs
endTime = 100;
tsteps=100;
options = odeset('RelTol',1e-12,'AbsTol',1e-6);

% run a simulation test based on the parameter value defined in SBML 
rehash toolboxcache;
[tspan, speciesConc, speciesnames] = glycanDSim(UB1997Model,ubODEFileName,endTime, tsteps);

binames={'M3Gn2_tgn';'M3Gn2G_tgn';'M3Gn2Gnb_tgn';'M3Gn2GnbG_tgn'}; %,'M3GnGnb_TGN','M3GnGnbG_TGN'};
biindex = findbyname(speciesnames,binames);
    
triprimenames={'M3Gn3prime_tgn';'M3Gn3primeG_tgn';'M3Gn3primeGnb_tgn';'M3Gn3primeGnbG_tgn'}; 
triindex =  findbyname(speciesnames,triprimenames);

 [sumbiconc sumtriconc]=getBiTriConc(speciesConc,biindex, triindex);
 fprintf(1,' the mole fraction of biantennary glycan structures is %f\n',sumbiconc);
 fprintf(1,' the mole fraction of tri-prime-anntenary glycan structures is %f\n',sumtriconc);
 
 %% Display Results From Published Paper
 %  Lastly, we run a series of dynamic simulations with different values of
 %  parameter q (productivity rate). The simulation results are the same 
 %  as Fig. 4 in Umana et al 1997. These examples show how simple MATLAB
 %  scripts can be used to augment the functionality available in GNAT!
  
 qpname = 'qp';
 qpArray=[0:100:2000];
 qpArray(1,1)=1;
 plotBi = zeros(1,length(qpArray));
 plotTri =zeros(1,length(qpArray)); 

for i=1:length(qpArray);
    qp = qpArray(i);
     % adjust m file
     adjustMFile(ubODEFileName, qpname, qp); 
     options = odeset('RelTol',1e-12,'AbsTol',1e-6);
     [tspan, speciesConc, speciesnames] = glycanDSim(UB1997Model,ubODEFileName,endTime, tsteps,options);
     [sumbiconc sumtriconc]=getBiTriConc(speciesConc,biindex, triindex);
     plotBi(i) =sumbiconc;
     plotTri(i)=sumtriconc;
     rehash toolboxcache;
end

adjustMFile(ubODEFileName, qpname, 1); 

figure
plot(qpArray,plotBi,'r',qpArray,plotTri,'b','Linewidth',2);
axis([0 2000 0 1]);
set(gca,'YTick',0:0.25:1);
set(gca,'YTickLabel',{'0','0.25','0.5','0.75','1'});
xlabel('Glycoprotein productivity','fontweight','b','fontsize',12);
ylabel('Mole fraction','fontweight','b','fontsize',12);
legend('Biantennary','Triantennary'); 

%% Reference
%  1. Umana, P. and J.E. Bailey, A mathematical model of N-linked 
%  glycoform biosynthesis. Biotechnol Bioeng, 1997. 55(6): p. 890-908.