clc;clear;

%% load example path
pathexample = Pathway.loadpathway('nlinkedpath.mat');
disp('An example pathway is shown below:');
glycanPathViewer(pathexample);

%% set a species "isolated"
m3gngnlowerglycanStruct =  glycanMLread('m3gngnlowerglycan.glycoct_xml');
pathexample.setSpeciesIsolated(m3gngnlowerglycanStruct);
disp('After setting a species "isolated", the pathway is as below:');
glycanPathViewer(pathexample);

%% find path between two species in the network
removeIsolatedSpecies(pathexample);
disp('A new pathway after removing isolated species is:');
glycanPathViewer(pathexample);