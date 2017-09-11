clc;clear;

workspace = org.eurocarbdb.application.glycanbuilder.BuilderWorkspace;
residueDict = org.eurocarbdb.application.glycanbuilder.ResidueDictionary.allResidues;

allresidues = containers.Map();
for i=1: residueDict.size
       residueType =ResidueType(residueDict.elementAt(i-1));
       allresidues(residueType.name)=residueType;
end

save('residueTypes.mat','allresidues');

% % create residue dictionary
% residueDict = containers.Map();
% 
% % add Mannose alpha1,3 to dictionary
% a=glycanMLread('highmannose.xml');


disp('end');