%% GNAT Demo 4
% This demo shows how to construct an N-linked glycosylation pathway using inferGlyForwPath.  The
% inputs are one glycan structure and six enzymes.

%% Enzyme definition 
%  MGAT 1,2,3,4,5, MANII, and GalT enzymes
%   are defined. 

%% Definition and visualization of MGAT2 enzyme 
mgat2                                    = GTEnz([2;4;1;143]);
residueMap                          = load('residueTypes.mat');
mgat2.resfuncgroup                = residueMap.allresidues('GlcNAc');
glcnacbond     = GlycanBond('2','1');
mgat2.linkFG   = struct('anomer','b','bond',glcnacbond);
manResType                        = residueMap.allresidues('Man');
manBond                             = GlycanBond('6','1');
mgat2.resAtt2FG = manResType;
mgat2.linkresAtt2FG = struct('bond', manBond,'anomer','a');
m3gngn           = glycanMLread('m3gn.glycoct_xml');
mgat2.isTerminalTarget = true;
mgat2.substMinStruct  = m3gngn;
% mgat2.targetBranch     = glycanMLread('mgat2actingbranch.glycoct_xml');
mgat2.substNABranch = CellArrayList;
mgat2.substNABranch.add(glycanMLread('NGlycanBisectGlcNAc.glycoct_xml'));
mgat2.substNABranch.add(glycanMLread('mgat2substrateNAbranch.glycoct_xml'));
mgat2.substNAResidue = residueMap.allresidues('Gal');
enzViewer(mgat2)

%% Definition and visualization of MANII enzyme 
manii                            = GHEnz([3;2;1;114]);
manii.resfuncgroup   = manResType;
manii.linkFG.anomer = 'a';
manBond(1,1)            = GlycanBond('3','1');
manBond(2,1)            = GlycanBond('6','1');
manii.linkFG.bond     = manBond;
manii.resAtt2FG = manResType;
manii.prodMinStruct  = glycanMLread('m3gn.glycoct_xml'); % mannosidase I can not work on M5 glycan
manii.substNABranch = glycanMLread('NGlycanBisectGlcNAc.glycoct_xml');
manii.substNAResidue = residueMap.allresidues('Gal');
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
m3gngn           = glycanMLread('m3gn.glycoct_xml');
mgat3.substMinStruct   = m3gngn;
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
m3gngn           = glycanMLread('m3gngn.glycoct_xml');
mgat4.substMinStruct  = m3gngn;
mgat4.targetBranch      =  glycanMLread('mgat4targetbranch.glycoct_xml');
mgat4.substNABranch  = CellArrayList;
mgat4.substNABranch.add(glycanMLread('NGlycanBisectGlcNAc.glycoct_xml'));
mgat4.substNABranch.add(glycanMLread('mgat4subsNAbranch.glycoct_xml'));
mgat4.substNAResidue = residueMap.allresidues('Gal');
enzViewer(mgat4)


%% Definition and visualization of MGAT5 enzyme 
mgat5                                    = GTEnz([2;4;1;155]);
mgat5.resfuncgroup                = residueMap.allresidues('GlcNAc');
manResType                        = residueMap.allresidues('Man');
manBond                             = GlycanBond('6','1');
mgat5.resAtt2FG = manResType;
mgat5.linkresAtt2FG = struct('bond', manBond,'anomer','a');
glcnacbond = GlycanBond('6','1');
mgat5.linkFG   = struct('anomer','b','bond',glcnacbond);
m3gngn           = glycanMLread('m3gngn.glycoct_xml');
%mgat5.substMinStruct  = m3gn;
mgat5.targetBranch      = glycanMLread('mgat5targetbranch.glycoct_xml');
mgat5.substMinStruct  = glycanMLread('mgat5substMinStruct.glycoct_xml');
mgat5.substNABranch = CellArrayList;
mgat5.substNABranch.add(glycanMLread('NGlycanBisectGlcNAc.glycoct_xml'));
mgat5.substNABranch.add(glycanMLread('mgat5substrateNAbranch.glycoct_xml'));
mgat5.substNAResidue = residueMap.allresidues('Gal');
enzViewer(mgat5)
 
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
galt.targetBranch          = glycanMLread('galttargetbranch.glycoct_xml');
enzViewer(galt)


%% Definition of Starting Substrate
% Initial glycan is defined as M5Gn structure. 
% 
m5gnspecies    = GlycanSpecies(glycanMLread('M5gn.glycoct_xml')) ;
fprintf(1,'display initial substrate structure\n');
glycanViewer(m5gnspecies.glycanStruct);

%% Store enzymes and glycan in CellArrayList variables
% substrateArray and enzArray are created to store initial substrate
%   and enzymes which might act  on substrate.
substrateArray = CellArrayList;
enzArray = CellArrayList;
substrateArray.add(m5gnspecies);
enzArray.add(manii);
enzArray.add(mgat2);
enzArray.add(mgat3);
enzArray.add(mgat4);
enzArray.add(mgat5);
% enzArray.add(galt);

%% Theoretical prediction of pathway using forward construction
%  inferGlyForwPath command is used to construct a theoretical
%    pathway and the pathway can be visualized using glycanPathViewer 
%    command. 
%  
[isPath,nglycanpath]=inferGlyForwPath(substrateArray, enzArray);

if(isPath)
    glycanPathViewer(nglycanpath);
end

%% Removal of isomer structures in the network
%  removing isomer structures in the network leads to a similar netowrk
%    proposed by Umana et al 1995 starting from M3Gn. 
%  
nlinkedpath2 = removeLinkageIsomerStruct(nglycanpath);
glycanPathViewer(nlinkedpath2);          
             
             
          