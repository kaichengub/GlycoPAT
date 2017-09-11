clc;clear;

%% load example path
pathexample = Pathway.loadpathway('nlinkedpath.mat');
disp('An example pathway is shown below:');
glycanPathViewer(pathexample);

%% generate a list of subset pathway by deleting specified number (say 2) of species from the network
subpathlist = subnetgenbynumdel(pathexample,2);
disp('One example from the list of subset model is shown below:');
glycanPathViewer(subpathlist.get(2));