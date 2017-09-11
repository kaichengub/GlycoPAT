clc;clear;
residueMap                          = load('residueTypes.mat');

%% define mgat2 enzyme
mgat2                                    = GTEnz([2;4;1;143]);
mgat2.resfuncgroup           = residueMap.allresidues('GlcNAc');
manResType                         = residueMap.allresidues('Man');
manBond                              = GlycanBond('6','1');
mgat2.resAtt2FG                  = manResType;
mgat2.linkresAtt2FG                = struct('bond', manBond,'anomer','a');
glcnacbond                         = GlycanBond('2','1');
mgat2.linkFG                      = struct('anomer','b','bond',glcnacbond);
m3gn                        = glycanMLread('m3gn.glycoct_xml');
mgat2.isTerminalTarget = true;
mgat2.substMinStruct  = m3gn;
mgat2.targetBranch     = glycanMLread('mgat2actingbranch.glycoct_xml');
mgat2.substNABranch = CellArrayList;
mgat2.substNABranch.add(glycanMLread('NGlycanBisectGlcNAc.glycoct_xml'));
mgat2.substNABranch.add(glycanMLread('mgat2substrateNAbranch.glycoct_xml'));
%mgat2.substNAResidue= residueMap.allresidues('Gal');

%% define mgat3 enzyme
mgat3                                    = GTEnz([2;4;1;143]);
mgat3.resfuncgroup           = residueMap.allresidues('GlcNAc');
glcnacbond                          = GlycanBond('4','1');
mgat3.linkFG                        = struct('anomer','b','bond',glcnacbond);
manResType                         = residueMap.allresidues('Man');
manBond                              = GlycanBond('4','1');
mgat3.resAtt2FG                  =  manResType;
mgat3.linkresAtt2FG           = struct('bond', manBond,'anomer','b');
m3gn                                    = glycanMLread('m3gn.glycoct_xml');
mgat3.substMinStruct       = m3gn;
mgat3.substNABranch      = glycanMLread('NGlycanBisectGlcNAc.glycoct_xml');
mgat3.targetBranch           = glycanMLread('mgat3targetbranch.glycoct_xml');
mgat3.substNAResidue     = residueMap.allresidues('Gal');

%% define mgat4 enzyme
mgat4                                    = GTEnz([2;4;1;14]);
mgat4.resfuncgroup           = residueMap.allresidues('GlcNAc');
manResType                        = residueMap.allresidues('Man');
manBond                             = GlycanBond('3','1');
glcnacbond                         = GlycanBond('4','1');
mgat4.linkFG                       = struct('anomer','b','bond',glcnacbond);
mgat4.resAtt2FG                 = manResType;
mgat4.linkresAtt2FG               = struct('bond', manBond,'anomer','a');

mgat4.substMinStruct = m3gn;
mgat4.targetBranch     =  glycanMLread('mgat4targetbranch.glycoct_xml');
mgat4.substNABranch = CellArrayList;
mgat4.substNABranch.add(glycanMLread('NGlycanBisectGlcNAc.glycoct_xml'));
mgat4.substNABranch.add(glycanMLread('mgat4subsNAbranch.glycoct_xml'));
mgat4.substNAResidue = residueMap.allresidues('Gal');

%% define mgat5 enzyme
mgat5                                   = GTEnz([2;4;1;155]);
mgat5.resfuncgroup          = residueMap.allresidues('GlcNAc');
glcnacbond                       = GlycanBond('6','1');
mgat5.linkFG   = struct('anomer','b','bond',glcnacbond);
manResType                       = residueMap.allresidues('Man');
manBond                            = GlycanBond('6','1');
mgat5.resAtt2FG               = manResType;
mgat5.linkresAtt2FG              = struct('bond', manBond,'anomer','a');
m3gn                                  = glycanMLread('m3gn.glycoct_xml');
%mgat5.substMinStruct  = m3gn;
mgat5.targetBranch        = glycanMLread('mgat5targetBranch.glycoct_xml');
mgat5.substMinStruct     = glycanMLread('mgat5substMinStruct.glycoct_xml');
mgat5.substNABranch = CellArrayList;
mgat5.substNABranch.add(glycanMLread('NGlycanBisectGlcNAc.glycoct_xml'));
mgat5.substNABranch.add(glycanMLread('mgat5substrateNAbranch.glycoct_xml'));
 
%% define GalT enzyme
galt                                     = GTEnz([2;4;1;38]);
galt.isTerminalTarget      = true;
galt.resfuncgroup            = residueMap.allresidues('Gal');
galtbond                           = GlycanBond('4','1');
galt.linkFG                             = struct('anomer','b','bond',galtbond);

glcnacResType                = residueMap.allresidues('GlcNAc');
glcnacBond                     = GlycanBond('?','1');
galt.resAtt2FG                = glcnacResType;
galt.linkresAtt2FG               = struct('bond', glcnacBond,'anomer','b');

% galt.substNABranch=glycanMLread('NGlycanBisectGlcNAc.glycoct_xml');
galt.targetNABranch=glycanMLread('NGlycanBisectGlcNAc.glycoct_xml');

%% define input 
tetreprimglycan    = GlycanSpecies(glycanMLread('tetriprime_gal_nlinkedglycan.glycoct_xml')) ;
fprintf(1,'Input of glycan product structure is \n');
glycanViewer(tetreprimglycan.glycanStruct);
prodArray = CellArrayList; 
enzArray = CellArrayList; 
prodArray.add(tetreprimglycan); 
enzArray.add(mgat2);
enzArray.add(mgat3);
enzArray.add(mgat4);
enzArray.add(mgat5); 
enzArray.add(galt);

%% reverse inference
[isPath,nlinkedpath]=inferGlyRevrPath(prodArray, enzArray);
fprintf(1,'Inferred network is shown below:\n');
glycanPathViewer(nlinkedpath);


