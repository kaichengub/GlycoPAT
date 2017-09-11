%% Enzyme definition 
%  MANI, II, MGAT 1,2,3,4,5, GalT,IGNT,FucT,SiaT enzymes
%   are defined. 
residueMap                          = load('residueTypes.mat');
manResType                        = residueMap.allresidues('Man');
m3gn                                    = glycanMLread('m3gn.glycoct_xml');


%% define sia T
siaT                                            = GTEnz([2;4;99;6]);
siaT.isTerminalTarget           = true;
siaT.resfuncgroup                 = residueMap.allresidues('NeuAc');
siaTbond                                = GlycanBond('3','2');
siaT.linkFG                             = struct('anomer','a','bond',siaTbond);
galResType                            = residueMap.allresidues('Gal');
galBond                                  = GlycanBond('4','1');
siaT.resAtt2FG                        = galResType;
siaT.linkresAtt2FG                  = struct('bond', galBond,'anomer','b');
siaT.substNABranch              = glycanMLread('NGlycanBisectGlcNAc.glycoct_xml');
siaT.targetbranchcontain      = glycanMLread('gntetargetbranch.glycoct_xml');
enzViewer(siaT);

%% Define Fuc T
fucT8                                    = GTEnz([2;4;1;68]);
fucT8.isTerminalTarget      = false;
fucT8.resfuncgroup            = residueMap.allresidues('Fuc');
fuctbond                              = GlycanBond('6','1');
fucT8.linkFG                        = struct('anomer','a','bond',fuctbond);
glcnacResType                    = residueMap.allresidues('GlcNAc');
glcnacBond                         = GlycanBond('?','?');
fucT8.resAtt2FG                  = glcnacResType;
fucT8.linkresAtt2FG            = struct('bond', glcnacBond,'anomer','?');
fucT8.targetNABranch       = glycanMLread('NGlycanBisectGlcNAc.glycoct_xml');
fucT8.substNAResidue      = residueMap.allresidues('Gal');
fucT8.substMinStruct        = m3gn;
%fucT8.targetBranch       = glycanMLread('fuctTargetbranch.glycoct_xml');
enzViewer(fucT8);

%% Define MGAT1 
mgat1                                            = GTEnz([2;4;1;101]);
mgat1.resfuncgroup                   = residueMap.allresidues('GlcNAc');
glcnacbond                                  = GlycanBond('2','1');
mgat1.linkFG                                = struct('anomer','b','bond',glcnacbond);
manBond                                      =  GlycanBond('3','1');
mgat1.resAtt2FG                          = manResType;
mgat1.linkresAtt2FG                   = struct('bond', manBond,'anomer','a');
mgat1.substMinStruct                = glycanMLread('M5.glycoct_xml');
mgat1.substMaxStruct                = glycanMLread('M5.glycoct_xml');
mgat1.targetBranch                    = glycanMLread('M5_lowerbranch.glycoct_xml');
enzViewer(mgat1);

%% Define IGNT 
gnte                                               = GTEnz([2;4;1;149]);
gnte.isTerminalTarget                = true;
gnte.resfuncgroup                           = residueMap.allresidues('GlcNAc');
galtbond                                       = GlycanBond('3','1');
gnte.linkFG                                  = struct('anomer','b','bond',galtbond);
galResType                                  = residueMap.allresidues('Gal');
galBond                                       = GlycanBond('4','1');
gnte.resAtt2FG                           = galResType;
gnte.linkresAtt2FG                     = struct('bond', galBond,'anomer','b');
gnte.targetNABranch              = glycanMLread('NGlycanBisectGlcNAc.glycoct_xml');
% galt.substNABranch=glycanMLread('NGlycanBisectGlcNAc.glycoct_xml');
%gnte.targetbranchcontain      = glycanMLread('gntetargetbranch.glycoct_xml');
enzViewer(gnte);

%% Define MGAT2 
mgat2                                    = GTEnz([2;4;1;143]);
residueMap                          = load('residueTypes.mat');
mgat2.resfuncgroup                = residueMap.allresidues('GlcNAc');
glcnacbond     = GlycanBond('2','1');
mgat2.linkFG   = struct('anomer','b','bond',glcnacbond);
manResType                        = residueMap.allresidues('Man');
manBond                             = GlycanBond('6','1');
mgat2.resAtt2FG = manResType;
mgat2.linkresAtt2FG = struct('bond', manBond,'anomer','a');
m3gn           = glycanMLread('m3gn.glycoct_xml');
mgat2.isTerminalTarget = true;
mgat2.substMinStruct  = m3gn;
mgat2.targetBranch     = glycanMLread('mgat2actingbranch.glycoct_xml');
mgat2.substNABranch = CellArrayList;
mgat2.substNABranch.add(glycanMLread('NGlycanBisectGlcNAc.glycoct_xml'));
mgat2.substNABranch.add(glycanMLread('mgat2substrateNAbranch.glycoct_xml'));
mgat2.substNAResidue = residueMap.allresidues('Gal');
enzViewer(mgat2)

%% Define MANI 
mani = GHEnz([3;2;1;113]);
mani.resfuncgroup = manResType;
mani.linkFG.anomer ='a';
manBond  = GlycanBond('2','1');
mani.linkFG.bond     = manBond;
mani.resAtt2FG         = manResType;
manAttachBond      = GlycanBond('?','?');
mani.linkresAtt2FG = struct('bond', manAttachBond,'anomer','?');
mani.prodMinStruct    = glycanMLread('M5.glycoct_xml'); 
mani.substMaxStruct   = glycanMLread('M9.glycoct_xml');
mani.substNAResidue = residueMap.allresidues('Gal');
enzViewer(mani);

%% Define MANII
manii                            = GHEnz([3;2;1;114]);
manii.resfuncgroup   = manResType;
manii.linkFG.anomer = 'a';
manBond(1,1)            = GlycanBond('3','1');
manBond(2,1)            = GlycanBond('6','1');
manii.linkFG.bond     = manBond;
manii.resAtt2FG          = manResType;
manii.prodMinStruct  = glycanMLread('m3gn.glycoct_xml'); % mannosidase II can not work on M3 glycan
manii.substNABranch  = glycanMLread('NGlycanBisectGlcNAc.glycoct_xml');
manii.substMaxStruct   = glycanMLread('m5gn.glycoct_xml');
enzViewer(manii)

%% Definition and visualization of MGAT3 enzyme 
mgat3                                    = GTEnz([2;4;1;143]);
mgat3.resfuncgroup           = residueMap.allresidues('GlcNAc');
manResType                        = residueMap.allresidues('Man');
manBond                             = GlycanBond('4','1');
mgat3.resAtt2FG = manResType;
mgat3.linkresAtt2FG= struct('bond', manBond,'anomer','b');
glcnacbond     = GlycanBond('4','1');
mgat3.linkFG   = struct('anomer','b','bond',glcnacbond);
m3gn           = glycanMLread('m3gn.glycoct_xml');
mgat3.substMinStruct   = m3gn;
mgat3.substNABranch  = glycanMLread('NGlycanBisectGlcNAc.glycoct_xml');
mgat3.targetBranch       = glycanMLread('mgat3targetbranch.glycoct_xml');
mgat3.substNAResidue = residueMap.allresidues('Gal');
enzViewer(mgat3)

%% Definition and visualization of MGAT4 enzyme 
mgat4                                    = GTEnz([2;4;1;145]);
mgat4.resfuncgroup                = residueMap.allresidues('GlcNAc');
manResType                        = residueMap.allresidues('Man');
manBond                             = GlycanBond('3','1');
mgat4.resAtt2FG = manResType;
mgat4.linkresAtt2FG = struct('bond', manBond,'anomer','a');
glcnacbond = GlycanBond('4','1');
mgat4.linkFG   = struct('anomer','b','bond',glcnacbond);
m3gn           = glycanMLread('m3gn.glycoct_xml');
mgat4.substMinStruct  = m3gn;
mgat4.targetBranch      =  glycanMLread('mgat4targetbranch.glycoct_xml');
mgat4.substNABranch  = CellArrayList;
mgat4.substNABranch.add(glycanMLread('NGlycanBisectGlcNAc.glycoct_xml'));
mgat4.substNABranch.add(glycanMLread('mgat4subsNAbranch.glycoct_xml'));
mgat4.substNAResidue = residueMap.allresidues('Gal');
%enzViewer(mgat4)

%% Definition and visualization of MGAT5 enzyme 
mgat5                                    = GTEnz([2;4;1;155]);
mgat5.resfuncgroup                = residueMap.allresidues('GlcNAc');
manResType                        = residueMap.allresidues('Man');
manBond                             = GlycanBond('6','1');
mgat5.resAtt2FG = manResType;
mgat5.linkresAtt2FG = struct('bond', manBond,'anomer','a');
glcnacbond = GlycanBond('6','1');
mgat5.linkFG   = struct('anomer','b','bond',glcnacbond);
m3gn           = glycanMLread('m3gn.glycoct_xml');
%mgat5.substMinStruct  = m3gn;
mgat5.targetBranch      = glycanMLread('mgat5targetbranch.glycoct_xml');
mgat5.substMinStruct  = glycanMLread('mgat5substMinStruct.glycoct_xml');
mgat5.substNABranch = CellArrayList;
mgat5.substNABranch.add(glycanMLread('NGlycanBisectGlcNAc.glycoct_xml'));
mgat5.substNABranch.add(glycanMLread('mgat5substrateNAbranch.glycoct_xml'));
mgat5.substNAResidue = residueMap.allresidues('Gal');

galt                                   = GTEnz([2;4;1;38]);
galt.isTerminalTarget    = true;
galt.resfuncgroup          = residueMap.allresidues('Gal');
glcnacResType               = residueMap.allresidues('GlcNAc');
glcnacBond                    = GlycanBond('?','1');
galt.resAtt2FG                = glcnacResType;
galt.linkresAtt2FG          = struct('bond', glcnacBond,'anomer','b');
galtbond                         = GlycanBond('4','1');
galt.linkFG                      = struct('anomer','b','bond',galtbond);

ignt                                        = GTEnz([2;4;1;149]);
ignt.isTerminalTarget          = true;
ignt.resfuncgroup                = residueMap.allresidues('GlcNAc');
galResType                           = residueMap.allresidues('Gal');
galBond                                = GlycanBond('4','1');
ignt.resAtt2FG                = galResType;
ignt.linkresAtt2FG  = struct(...
    'bond', galBond,'anomer','b');
glcnacbond = GlycanBond('3','1');
ignt.linkFG   = struct('anomer','b','bond',glcnacbond);

st3galI                                      = GTEnz([2;4;99;4]);
st3galI.isTerminalTarget        = true;
st3galI.resfuncgroup              = residueMap.allresidues('NeuAc');
galResType                              = residueMap.allresidues('Gal');
galBond                                   = GlycanBond('3','1');
st3galI.resAtt2FG               =  galResType;
st3galI.linkresAtt2FG               = struct( 'bond', galBond,'anomer','b');
st3bond                                    = GlycanBond('3','2');
st3galI.linkFG                           = struct('anomer','a','bond',st3bond);

st3galIV                                     = GTEnz([2;4;99;6]);
st3galIV.isTerminalTarget      = true;
st3galIV.resfuncgroup            = residueMap.allresidues('NeuAc');
galResType                               = residueMap.allresidues('Gal');
galBond                                    = GlycanBond('4','1');
st3bond                                    = GlycanBond('3','2');
st3galIV.linkFG                         = struct('anomer','a','bond',st3bond);
st3galIV.resAtt2FG                  = galResType;
st3galIV.linkresAtt2FG            = struct('bond', galBond,'anomer','b');

fucT7                                         = GTEnz([2;4;1;152]);
fucT7.isTerminalTarget           = false;
fucT7.resfuncgroup                 = residueMap.allresidues('Fuc');
fuctbond                                   = GlycanBond('4','1');
fucT7.linkFG                              = struct('anomer','a','bond',fuctbond);

glcnacResType                          = residueMap.allresidues('GlcNAc');
glcnacBond                               = GlycanBond('3','1');
fucT7.resAtt2FG                        =  glcnacResType;
fucT7.linkresAtt2FG                  =  struct('bond', glcnacBond,'anomer','?');
fucT7.substNAResidue             = residueMap.allresidues('Fuc');
fucT7.substMinStruct               =  glycanMLread('fucT7substmin.glycoct_xml');
% enzViewer(fucT7);

enzDB= containers.Map;
enzDB('mgat5')=mgat5;
enzDB('mgat4')=mgat4;
enzDB('mgat3')=mgat3;
enzDB('mgat2')=mgat2;
enzDB('mgat1')=mgat1;
enzDB('manii') =manii;
enzDB('mani')  =mani;
enzDB('fucT8')=fucT8;
enzDB('siaT')=siaT;
enzDB('gnte')=gnte;
enzDB('galt')=galt;
enzDB('st3galI')=st3galI;
enzDB('st3galIV')=st3galIV;
enzDB('fucT7')=fucT7;

save('glyenzDB.mat','enzDB');



