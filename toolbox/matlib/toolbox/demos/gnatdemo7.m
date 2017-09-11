%% GNAT Demo 5
% This demo shows how to construct an N-linked glycosylation pathway using glycans annoated from 
%   mass spectra data.  The inputs are glycan structures annoated from 24 peaks and 11 enzymes.

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
%enzViewer(mgat5)
 
%% Definition and visualization of GALT enzyme 
galt                                   = GTEnz([2;4;1;38]);
galt.isTerminalTarget    = true;
galt.resfuncgroup          = residueMap.allresidues('Gal');
glcnacResType               = residueMap.allresidues('GlcNAc');
glcnacBond                    = GlycanBond('?','1');
galt.resAtt2FG                = glcnacResType;
galt.linkresAtt2FG          = struct('bond', glcnacBond,'anomer','b');
galtbond                         = GlycanBond('4','1');
galt.linkFG                      = struct('anomer','b','bond',galtbond);
% galt.targetBranch        = glycanMLread('galttargetbranch.glycoct_xml');
enzViewer(galt)

%% Definition of Glycan Structures
% Initial glycans are defined based on 24 peaks and stored in substrateArray variable.  

gDispOption1    = displayset('showmass',true,'showLinkage',true,...
'showRedEnd',true);
s1species    = GlycanSpecies(glycanMLread('s1_1579.glycoct_xml')) ;
glycanViewer(s1species.glycanStruct,gDispOption1);
s2species    = GlycanSpecies(glycanMLread('s2_1590.glycoct_xml')) ;
glycanViewer(s2species.glycanStruct,gDispOption1);

s3v1species    = GlycanSpecies(glycanMLread('s3v1_1620.glycoct_xml')) ;
glycanViewer(s3v1species.glycanStruct,gDispOption1);
s3v2species    = GlycanSpecies(glycanMLread('s3v2_1620.glycoct_xml')) ;
glycanViewer(s3v2species.glycanStruct,gDispOption1);
s4species    = GlycanSpecies(glycanMLread('s4_1783.glycoct_xml')) ;
glycanViewer(s4species.glycanStruct,gDispOption1);
s5species    = GlycanSpecies(glycanMLread('s5_1835.glycoct_xml')) ;
glycanViewer(s5species.glycanStruct,gDispOption1);
s6species    = GlycanSpecies(glycanMLread('s6_1865.glycoct_xml')) ;
glycanViewer(s6species.glycanStruct,gDispOption1);
s7species    = GlycanSpecies(glycanMLread('s7_1988.glycoct_xml')) ;
glycanViewer(s7species.glycanStruct,gDispOption1);
s8v1species    = GlycanSpecies(glycanMLread('s8v1_2040.glycoct_xml')) ;
glycanViewer(s8v1species.glycanStruct,gDispOption1);
s8v2species    = GlycanSpecies(glycanMLread('s8v2_2040.glycoct_xml')) ;
glycanViewer(s8v2species.glycanStruct,gDispOption1);
s9species    = GlycanSpecies(glycanMLread('s9_2070.glycoct_xml')) ;
glycanViewer(s9species.glycanStruct,gDispOption1);
s10species    = GlycanSpecies(glycanMLread('s10_2081.glycoct_xml'));
glycanViewer(s10species.glycanStruct,gDispOption1);
s11species   = GlycanSpecies(glycanMLread('s11_2192.glycoct_xml')) ;
glycanViewer(s11species.glycanStruct,gDispOption1);
s12species   = GlycanSpecies(glycanMLread('s12_2244.glycoct_xml')) ;
glycanViewer(s12species.glycanStruct,gDispOption1);
s13species    = GlycanSpecies(glycanMLread('s13_2396.glycoct_xml')) ;
glycanViewer(s13species.glycanStruct,gDispOption1);
s14species    = GlycanSpecies(glycanMLread('s14_2431.glycoct_xml')) ;
glycanViewer(s14species.glycanStruct,gDispOption1);
s15species    = GlycanSpecies(glycanMLread('s15_2489.glycoct_xml')) ;
glycanViewer(s15species.glycanStruct,gDispOption1);
s16v1species    = GlycanSpecies(glycanMLread('s16v1_2519.glycoct_xml')) ;
glycanViewer(s16v1species.glycanStruct,gDispOption1);
s16v2species    = GlycanSpecies(glycanMLread('s16v2_2519.glycoct_xml')) ;
glycanViewer(s16v2species.glycanStruct,gDispOption1);
s17species    = GlycanSpecies(glycanMLread('s17_2605.glycoct_xml')) ;
glycanViewer(s17species.glycanStruct,gDispOption1);
s18v1species        = GlycanSpecies(glycanMLread('s18v1_2693.glycoct_xml')) ;
glycanViewer(s18v1species.glycanStruct,gDispOption1);
s18v2species        = GlycanSpecies(glycanMLread('s18v2_2693.glycoct_xml')) ;
glycanViewer(s18v2species.glycanStruct,gDispOption1);
s19v1species    = GlycanSpecies(glycanMLread('s19v1_2880.glycoct_xml')) ;
glycanViewer(s19v1species.glycanStruct,gDispOption1);
s19v2species    = GlycanSpecies(glycanMLread('s19v2_2880.glycoct_xml')) ;
glycanViewer(s19v2species.glycanStruct,gDispOption1);
s19v3species    = GlycanSpecies(glycanMLread('s19v3_2880.glycoct_xml')) ;
glycanViewer(s19v3species.glycanStruct,gDispOption1);
s20species        = GlycanSpecies(glycanMLread('s20v1_2938.glycoct_xml')) ;
glycanViewer(s20species.glycanStruct,gDispOption1);
s21species        = GlycanSpecies(glycanMLread('s21v1_2968.glycoct_xml')) ;
glycanViewer(s21species.glycanStruct,gDispOption1);
s22v1species    = GlycanSpecies(glycanMLread('s22v1_3054.glycoct_xml')) ;
glycanViewer(s22v1species.glycanStruct,gDispOption1);
s22v2species    = GlycanSpecies(glycanMLread('s22v2_3054.glycoct_xml')) ;
glycanViewer(s22v2species.glycanStruct,gDispOption1);
s22v3species    = GlycanSpecies(glycanMLread('s22v3_3054.glycoct_xml')) ;
glycanViewer(s22v3species.glycanStruct,gDispOption1);
s23species       = GlycanSpecies(glycanMLread('s23_3142.glycoct_xml')) ;
glycanViewer(s23species.glycanStruct,gDispOption1);
s24v1species   = GlycanSpecies(glycanMLread('s24v1_3241.glycoct_xml')) ;
glycanViewer(s24v1species.glycanStruct,gDispOption1);
s24v2species   = GlycanSpecies(glycanMLread('s24v2_3241.glycoct_xml')) ;
glycanViewer(s24v2species.glycanStruct,gDispOption1);
s24v3species   = GlycanSpecies(glycanMLread('s24v3_3241.glycoct_xml')) ;
glycanViewer(s24v3species.glycanStruct,gDispOption1);

substrateArray = CellArrayList;
substrateArray.add(s1species);
substrateArray.add(s2species);
substrateArray.add(s3v1species);
substrateArray.add(s3v2species);
substrateArray.add(s4species);
substrateArray.add(s9species);
substrateArray.add(s5species);
substrateArray.add(s6species);
substrateArray.add(s7species);
substrateArray.add(s8v1species);
substrateArray.add(s8v2species);
substrateArray.add(s10species);
substrateArray.add(s11species);
substrateArray.add(s12species);
substrateArray.add(s13species);
substrateArray.add(s14species);
substrateArray.add(s15species);
substrateArray.add(s16v1species);
substrateArray.add(s16v2species);
substrateArray.add(s17species);
substrateArray.add(s18v1species);
substrateArray.add(s18v2species);
substrateArray.add(s19v1species);
substrateArray.add(s19v2species);
substrateArray.add(s19v3species);
substrateArray.add(s20species);
substrateArray.add(s21species);
substrateArray.add(s22v1species);
substrateArray.add(s22v2species);
substrateArray.add(s22v3species);
substrateArray.add(s23species);
substrateArray.add(s24v1species);
substrateArray.add(s24v2species);
substrateArray.add(s24v3species);


%% Store enzymes and glycan in CellArrayList variables
% enzArray are created to store  enzymes which might act on substrates.
enzArray = CellArrayList;
enzArray.add(manii);
enzArray.add(mgat1);
enzArray.add(mgat2);
enzArray.add(mgat3);
enzArray.add(mgat4);
enzArray.add(mgat5);
enzArray.add(galt);
enzArray.add(fucT8);
enzArray.add(mani);
enzArray.add(gnte);
enzArray.add(siaT);

%% Pathway reconstruction using connection inferrence
%  inferGlyGlyConnPath command is used to construct a 
%    pathway and the pathway can be visualized using glycanPathViewer 
%    command.  The reconstructed network has 288 reactions and 151 species.
%    This construction takes about 5 mins to finish on Core 7 computer. 
%    
[isPath,nglycanpath]=inferGlyConnPath(substrateArray, enzArray);

if(isPath)
    glycanPathViewer(nglycanpath);
    fprintf(1,'the generated network has: \n');
    fprintf(1,'    %i  reactions\n',nglycanpath.getNReactions);
    fprintf(1,'    %i  species\n',   nglycanpath.getNSpecies);    
else
    fprintf(1,'no path is found\n');
end            
             
          