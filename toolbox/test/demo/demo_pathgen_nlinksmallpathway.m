clc;clear;
substrateArray = CellArrayList;
s1species = GlycanSpecies(glycanMLread('Man9.glycoct_xml'));
s2species = GlycanSpecies(glycanMLread('tri_SSS.glycoct_xml'));
substrateArray.add(s1species);
substrateArray.add(s2species);

residueMap                      = load('residueTypes.mat');
manResType                      = residueMap.allresidues('Man');
m3gn                            = glycanMLread('m3gn.glycoct_xml');

%% define sia T
siaT                            = GTEnz([2;4;99;6]);
siaT.isTerminalTarget           = true;
siaT.resfuncgroup               = residueMap.allresidues('NeuAc');
siaTbond                        = GlycanBond('3','2');
siaT.linkFG                     = struct('anomer','a','bond',siaTbond);
galResType                      = residueMap.allresidues('Gal');
galBond                         = GlycanBond('4','1');
siaT.resAtt2FG                  = galResType;
siaT.linkresAtt2FG              = struct('bond', galBond,'anomer','b');
siaT.substNABranch              = glycanMLread('NGlycanBisectGlcNAc.glycoct_xml');
siaT.targetbranchcontain        = glycanMLread('gntetargetbranch.glycoct_xml');

%% Define Fuc T
fucT8                           = GTEnz([2;4;1;68]);
fucT8.isTerminalTarget          = false;
fucT8.resfuncgroup              = residueMap.allresidues('Fuc');
fuctbond                        = GlycanBond('6','1');
fucT8.linkFG                    = struct('anomer','a','bond',fuctbond);
glcnacResType                   = residueMap.allresidues('GlcNAc');
glcnacBond                      = GlycanBond('?','?');
fucT8.resAtt2FG                 = glcnacResType;
fucT8.linkresAtt2FG             = struct('bond', glcnacBond,'anomer','?');
fucT8.targetNABranch            = glycanMLread('NGlycanBisectGlcNAc.glycoct_xml');
fucT8.substNAResidue            = residueMap.allresidues('Gal');
fucT8.substMinStruct            = m3gn;

%% Define MGAT1
mgat1                            = GTEnz([2;4;1;101]);
mgat1.resfuncgroup               = residueMap.allresidues('GlcNAc');
glcnacbond                       = GlycanBond('2','1');
mgat1.linkFG                     = struct('anomer','b','bond',glcnacbond);
manBond                          = GlycanBond('3','1');
mgat1.resAtt2FG                  = manResType;
mgat1.linkresAtt2FG              = struct('bond', manBond,'anomer','a');
mgat1.substMinStruct             = glycanMLread('M5.glycoct_xml');
mgat1.substMaxStruct             = glycanMLread('M5.glycoct_xml');

%% Define MGAT2
mgat2                             = GTEnz([2;4;1;143]);
residueMap                        = load('residueTypes.mat');
mgat2.resfuncgroup                = residueMap.allresidues('GlcNAc');
glcnacbond                        = GlycanBond('2','1');
mgat2.linkFG                      = struct('anomer','b','bond',glcnacbond);
manResType                        = residueMap.allresidues('Man');
manBond                           = GlycanBond('6','1');
mgat2.resAtt2FG                   = manResType;
mgat2.linkresAtt2FG               = struct('bond', manBond,'anomer','a');
mgat2.isTerminalTarget            = true;
mgat2.substMinStruct              = m3gn;
mgat2.targetBranch                = glycanMLread('mgat2actingbranch.glycoct_xml');
mgat2.substNABranch               = CellArrayList;
mgat2.substNABranch.add(glycanMLread('NGlycanBisectGlcNAc.glycoct_xml'));
mgat2.substNABranch.add(glycanMLread('mgat2substrateNAbranch.glycoct_xml'));

%% Define MANI
man1b1                              = GHEnz([3;2;1;113]);
man1b1.resfuncgroup                 = manResType;
man1b1.linkFG.anomer                ='a';
manBond                           = GlycanBond('2','1');
man1b1.linkFG.bond                  = manBond;
man1b1.resAtt2FG                    = manResType;
man1b1AttachBond                     = GlycanBond('3','1');
man1b1.linkresAtt2FG                = struct('bond', man1b1AttachBond,'anomer','a');
man1b1.substMaxStruct              = glycanMLread('M9.glycoct_xml');
man1b1.substMinStruct                 = glycanMLread('M9.glycoct_xml');
man1b1.substNAResidue               = residueMap.allresidues('Gal');

man1a1                              = GHEnz([3;2;1;113]);
man1a1.resfuncgroup                 = manResType;
man1a1.linkFG.anomer                ='a';
manBond                           = GlycanBond('2','1');
man1a1.linkFG.bond                  = manBond;
man1a1.resAtt2FG                    = manResType;
man1a1AttachBond                     = GlycanBond('2','1');
man1a1.linkresAtt2FG                = struct('bond', man1a1AttachBond,'anomer','a');
man1a1.substMinStruct                = glycanMLread('M8K.glycoct_xml');
man1a1.substMaxStruct               = glycanMLread('M8K.glycoct_xml');
man1a1.substNAResidue               = residueMap.allresidues('Gal');

man1a2                               = GHEnz([3;2;1;113]);
man1a2.resfuncgroup                  = manResType;
man1a2.linkFG.anomer                 ='a';
manBond                              = GlycanBond('2','1');
man1a2.linkFG.bond                   = manBond;
man1a2.resAtt2FG                     = manResType;
man1a2AttachBond                     = GlycanBond('6','1');
man1a2.linkresAtt2FG                 = struct('bond', man1a2AttachBond,'anomer','a');
man1a2.substMinStruct                = glycanMLread('M7K.glycoct_xml');
man1a2.substMaxStruct                = glycanMLread('M7K.glycoct_xml');
man1a2.substNAResidue                = residueMap.allresidues('Gal');

man1c1                               = GHEnz([3;2;1;113]);
man1c1.resfuncgroup                 = manResType;
man1c1.linkFG.anomer                ='a';
manBond                           = GlycanBond('2','1');
man1c1.linkFG.bond                  = manBond;
man1c1.resAtt2FG                    = manResType;
man1c1AttachBond                     = GlycanBond('3','1');
man1c1.linkresAtt2FG                = struct('bond', man1c1AttachBond,'anomer','a');
man1c1.substMaxStruct               = glycanMLread('M6K.glycoct_xml');
man1c1.substMinStruct               = glycanMLread('M6K.glycoct_xml');
man1c1.substNAResidue               = residueMap.allresidues('Gal');

%% Define MANII
manResType               = residueMap.allresidues('Man');
manii                    = GHEnz([3;2;1;114]);
manii.resfuncgroup       = manResType;
manBond(1,1)             = GlycanBond('3','1');
manBond(2,1)             = GlycanBond('6','1');
manii.linkFG             = struct('bond',manBond ,'anomer','a');
manii.resAtt2FG          = manResType;
resbond                  = GlycanBond('6','1');
manii.linkresAtt2FG      = struct('bond', resbond,'anomer','a');
manii.substNABranch      = glycanMLread('1008.51.glycoct_xml');
manii.substMaxStruct     = glycanMLread('1824.91.glycoct_xml');

%% Definition and visualization of MGAT4 enzyme
mgat4                             = GTEnz([2;4;1;145]);
mgat4.resfuncgroup                = residueMap.allresidues('GlcNAc');
manResType                        = residueMap.allresidues('Man');
manBond                           = GlycanBond('3','1');
mgat4.resAtt2FG                   = manResType;
mgat4.linkresAtt2FG               = struct('bond', manBond,'anomer','a');
glcnacbond                        = GlycanBond('4','1');
mgat4.linkFG                      = struct('anomer','b','bond',glcnacbond);
mgat4.substMinStruct              = glycanMLread('mgat4_5substMinStruct_K.glycoct_xml');
mgat4.substNABranch               = CellArrayList;
mgat4.substNABranch.add(glycanMLread('NGlycanBisectGlcNAc.glycoct_xml'));
mgat4.substNABranch.add(glycanMLread('mgat4subsNAbranch.glycoct_xml'));
mgat4.substNAResidue              = residueMap.allresidues('Gal');

%% Definition and visualization of MGAT5 enzyme
mgat5                             = GTEnz([2;4;1;155]);
mgat5.resfuncgroup                = residueMap.allresidues('GlcNAc');
manResType                        = residueMap.allresidues('Man');
manBond                           = GlycanBond('6','1');
mgat5.resAtt2FG                   = manResType;
mgat5.linkresAtt2FG               = struct('bond', manBond,'anomer','a');
glcnacbond                        = GlycanBond('6','1');
mgat5.linkFG                      = struct('anomer','b','bond',glcnacbond);
mgat5.substMinStruct              = glycanMLread('mgat4_5substMinStruct_K.glycoct_xml');
mgat5.substNABranch               = CellArrayList;
mgat5.substNABranch.add(glycanMLread('NGlycanBisectGlcNAc.glycoct_xml'));
mgat5.substNABranch.add(glycanMLread('mgat5substrateNAbranch.glycoct_xml'));
mgat5.substNAResidue              = residueMap.allresidues('Gal');

beta4galt                              = GTEnz([2;4;1;38]);
beta4galt.isTerminalTarget             = true;
beta4galt.resfuncgroup                 = residueMap.allresidues('Gal');
glcnacResType                     = residueMap.allresidues('GlcNAc');
glcnacBond                        = GlycanBond('?','1');
beta4galt.resAtt2FG                    = glcnacResType;
beta4galt.linkresAtt2FG                = struct('bond', glcnacBond,'anomer','b');
galtbond                          = GlycanBond('4','1');
beta4galt.linkFG                       = struct('anomer','b','bond',galtbond);

enzArray = CellArrayList;
enzArray.add(man1b1);
enzArray.add(man1a1);
enzArray.add(man1a2);
enzArray.add(man1c1);
enzArray.add(manii);
enzArray.add(mgat1);
enzArray.add(mgat2);
enzArray.add(mgat4);
enzArray.add(mgat5);
enzArray.add(beta4galt);
enzArray.add(siaT);
enzArray.add(fucT8);


[isPath,nglycanpath]=inferGlyConnPath(substrateArray, enzArray);
nglycanpath2 = removeLinkageIsomerStruct(nglycanpath);
if(isPath)
    glycanPathViewer(nglycanpath2);
    fprintf(1,'After removing the linkage isomer, the final network has: \n');
    fprintf(1,'    %i  reactions\n',nglycanpath2.getNReactions);
    fprintf(1,'    %i  species\n',   nglycanpath2.getNSpecies);
    glycluster = clusterglycans(nglycanpath2);
end