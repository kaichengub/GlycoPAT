clc;clear;
mani = GHEnz([3;2;1;113]);
residueMap                          = load('residueTypes.mat');
manResType                         = residueMap.allresidues('Man');
mani.resfuncgroup = manResType;
manBond  = GlycanBond('2','1');
mani.resAtt2FG = manResType;
mani.linkFG =  struct('anomer','a','bond',manBond);
manunknownbond = GlycanBond('?','?');
mani.linkresAtt2FG =  struct('bond', manunknownbond,'anomer','?');
mani.prodMinStruct = glycanMLread('M5.glycoct_xml'); % mannosidase I can not work on M5 glycan
mani.substMaxStruct = glycanMLread('M9.glycoct_xml');
mani.substNAResidue = residueMap.allresidues('Gal');

enzArray       = CellArrayList;
enzArray.add(mani);
m9species    = GlycanSpecies(glycanMLread('M9.glycoct_xml')) ;
substrateArray = CellArrayList;
substrateArray.add(m9species);
fprintf(1,'Initial substrate structure is shown as below:');
glycanViewer(m9species.glycanStruct); 
[isPath,man1path]=inferGlyForwPath(substrateArray, enzArray);
fprintf(1,'Network inferred from M9 substrate catalyzed by ManI is shown as below:\n'); 
glycanPathViewer(man1path);


