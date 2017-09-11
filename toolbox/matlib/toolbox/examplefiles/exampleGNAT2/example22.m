clc;clear;

%% load example path
pathexample = Pathway.loadpathway('nlinkedpath.mat');
disp('An example pathway is shown below:');
glycanPathViewer(pathexample);

%% define two nodes
tetreprimglycan  = GlycanSpecies(...
    glycanMLread('tetriprime_gal_nlinkedglycan.glycoct_xml')) ;
m3gngnlowerglycan = GlycanSpecies(...
    glycanMLread('m3gngnlowerglycan.glycoct_xml'));
pair.react=m3gngnlowerglycan;
pair.prod= tetreprimglycan;
disp('two species(nodes) to search in the pathway are');
glycanViewer(tetreprimglycan.glycanStruct);
glycanViewer(m3gngnlowerglycan.glycanStruct);

%% find path between two species in the network
pathfound=pathfinding(pathexample,pair);
disp('a path found to link two nodes is');
glycanPathViewer(pathfound);