clc;clear;
residueMap = load('residueTypes.mat');
manResType=residueMap.allresidues('Man');
mani = GHlEnz([3;2;1;113]);
mani.resfuncgroup = manResType;
manBond       = GlycanBond('2','1');
mani.linkFG  = struct('anomer','a','bond',manBond); 
mani.substMinStruct = glycanMLread('M6.glycoct_xml'); % mannosidase I can not work on M5 glycan 
mani.substMaxStruct = glycanMLread('M9.glycoct_xml');
enzViewer(mani);


