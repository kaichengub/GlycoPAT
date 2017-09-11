clc;clear;
mgat1                    = GTEnz([2;4;1;101]);
residueMap               = load('residueTypes.mat');
mgat1.resfuncgroup       = residueMap.allresidues('GlcNAc');
residueMap               = load('residueTypes.mat');
manResType               = residueMap.allresidues('Man');
manBond                  = GlycanBond('3','1');
mgat1.resAtt2FG          = manResType;
mgat1.linkresAtt2FG      = struct('bond', manBond,'anomer','a');
glcnacbond               = GlycanBond('2','1');
mgat1.linkFG             = struct('anomer','b','bond',glcnacbond);
mgat1.substMinStruct     = glycanMLread('M5.glycoct_xml');
mgat1.substMaxStruct     = glycanMLread('M5.glycoct_xml');
enzViewer(mgat1);


