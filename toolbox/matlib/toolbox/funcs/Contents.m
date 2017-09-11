% Glycosylation Network Analysis Toolbox (GNAT)
%
% The "funcs" directory contains eight subfolders 
%   
%  funcs/db directory 
%    This directory contains the functions that interact with local and
%    online Glycomics Databases, as listed below. 
% 
%     1. dbLocalConnect  - connect to local database
%     2. dbExactStructSearch - search glycan structure on  local database
%     3. queryGlycomeDB  - query glycan structure using database ID over GLYCOMEDB
%     4. queryCFGDB  - query glycan structure  using databaseID over CFGDB
%     5. webGlycomicsDB - query glycan structure and open a default web browser
%     6. queryIUBMBDB - query enzyme information using enzyme EC number over IUBMBDB
%    
%  funcs/io directory
%    This directory contains the functions that handles reading/writing 
%     local files or strings.
% 
%      1 glycanMLread - read glycan structure XML file
%      2 glycanNetSBMLread - read glycosylation network  SBML file
%      3 glycanMLwrite - write glycan structure  XML file
%      4 glycanNetSBMLwrite - write glycosylation network SBML file
%      5 glycanStrread - read glycan structure string 
%      6 glycanStrwrite - write glycan structure string
%    
%  funcs/sbmlfunc directory 
%    This directory contains the function that handles SBML structure
%      
%      1 addGlycanAnnotation - add glycan sequence annotation to SBML  
%
%  funcs/sim directory
%    This directory contains the functions that simulate glycosylation
%    reactio networks
%       
%      1 glycanSSim - simulate glycosylation reaction network under steady states
%      2 glycanDSim - simulate glycosylation network at a series of time points
%  
%  funcs/transform directory
%    This directory contains the functions that convert one format of glycan sequence to another
%      
%      1 glycoctcond2Glyde - convert from GlycoCT condensed form to Glyde format
%      2 glycoctcond2Linucs - convert from GlycoCT condensed form to LINUCS format
%      3 glycoctcond2Glycoct - convert from GlycoCT condensed form to GlycoCT format
%      4 glycoct2GlycoctCond - convert from GlycoCT to GlycoCT condensed format
%      5 glycoct2Linucs - convert from GlycoCT to Linucs format 
%      6 glycoct2Glyde - convert from GlycoCT condensed form to Glyde format
%      7 linucs2Glyde - convert from LINUCS to Glyde format
%      8 linucs2Glycoct - convert from LINUCS to GlycoCT format
%      9 linucs2Glycoctcond - convert from LINUCS to GlycoCT condensed format  
% 
%  funcs/util directory
%    This directory contains the program files used internally for function 
% 
%  funcs/viz directory
%    This directory contains the function that display glycan structure and
%    glycosylation reaction networks
%     
%      1 glycanFileViewer  - display glycan structure  using glycan file
%      2 glycanViewer  - display glycan structure  using Matlab GlycanStruct object
%      3 glycanNetFileViewer - display glycosylation network  using SBML file
%      4 glycanNetViewer - display glycosylation network  using Matlab GlycanNetSBML object
%      5 displayset - set display options.
%      6 displayget - get display options
%      7 glycanPathViewer - display glycosylation network using Pathway object
%      8 enzViewer - display enzyme information in a custom-designed GUI
% 
%  funcs/demos directory
%    This directory contains the demos file 
%      1 gnatdemo1 - short introduction
%      2 gnatdemo2 - simulate bailey model 1997
%      3 gnatdemo3 - O-linked glycosylation network reconstruction
%      4 gnatdemo4 - N-linked glycosylation network reconstruction
%   
%  funcs/ms directory
%    This directory contains the functions that process mass spectra data 
%      1 readMS    - read MS data 
%      2 msprocess - process MS data 
% 
%  funcs/netinfer directory
%    This directory contains the functions that infer glycan and network
%      1 inferGlyConnPath - infer pathway using connection construction
%      2 inferGlyForwPath - infer pathway using forward construction
%      3 inferGlyRevrPath - infer pathway using reverse construction
%      4 inferGlyProd - infer glycan product based on substrate and enzyme
%      5 inferGlySubstr - infer glyan substrate based on product and enzyme
%  
%  funcs/graphoper directory
%    This directory contains the functions that infer glycan and network
%      1 detectIsolatedSpecies - detect isolated species
%      2 pathfinding - find the pathway between two species 
%      3 removeIsolatedSpecies - detect and remove isolated species from the pathway 
%      4 subnetgenbynumdel - generate subset network by removing specified number of species
%      5 subnetgenbyspecdel - generate subset network by removing specified species
%      6 subsetgenbyspeckeep - generate subset network by keeping specified species


%   Authorr Gang Liu
%   Lastly updated 5/30/13


